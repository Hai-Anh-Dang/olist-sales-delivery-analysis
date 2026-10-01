-- Five Olist analytical queries. SELECT-only; dates use purchase timestamp.
-- Amounts exclude freight. Percentage outputs use 0-100 units.
USE [olist_dataset];
SET NOCOUNT ON;
DECLARE @StartDate date = '20160904';
DECLARE @EndDateExclusive date = '20181018';
IF @StartDate IS NULL OR @EndDateExclusive IS NULL OR @StartDate >= @EndDateExclusive
    THROW 50000, 'StartDate must be earlier than EndDateExclusive.', 1;
DECLARE @TopCategories int = 15;
IF @TopCategories IS NULL OR @TopCategories < 1
    THROW 50000, 'TopCategories must be positive.', 1;

-- Limit the calendar to observed dates; keep the requested order filters.
DECLARE @FirstPurchase date, @LastPurchase date;
SELECT @FirstPurchase = CONVERT(date, MIN(order_purchase_timestamp)),
       @LastPurchase = CONVERT(date, MAX(order_purchase_timestamp))
FROM rpt.fact_orders;
DECLARE @CalendarStart date = CASE WHEN @StartDate > @FirstPurchase
    THEN @StartDate ELSE @FirstPurchase END;
DECLARE @CalendarEnd date = CASE WHEN @EndDateExclusive < DATEADD(day, 1, @LastPurchase)
    THEN @EndDateExclusive ELSE DATEADD(day, 1, @LastPurchase) END;
DECLARE @FirstMonth date = DATEFROMPARTS(YEAR(@FirstPurchase), MONTH(@FirstPurchase), 1);
DECLARE @LastMonth date = DATEFROMPARTS(YEAR(@LastPurchase), MONTH(@LastPurchase), 1);

-- QUERY 1: Monthly value and order activity
-- Question: Which purchase months warrant commercial investigation?
-- Grain: purchase month. All statuses for orders; delivered item prices for value.
-- Technique: bounded calendar, conditional aggregation and LAG.
;WITH months AS (
    SELECT DATEFROMPARTS(YEAR(@CalendarStart), MONTH(@CalendarStart), 1) AS order_month
    WHERE @CalendarStart < @CalendarEnd
    UNION ALL
    SELECT DATEADD(month, 1, order_month) FROM months
    WHERE DATEADD(month, 1, order_month) < @CalendarEnd
), monthly AS (
    SELECT DATEFROMPARTS(YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), 1) AS order_month,
        COUNT_BIG(*) AS orders_placed,
        SUM(CONVERT(bigint, o.is_delivered)) AS delivered_orders,
        SUM(CASE WHEN o.is_delivered = 1 THEN f.merchandise_value ELSE 0 END) AS delivered_value,
        SUM(CASE WHEN o.is_delivered = 1 AND f.merchandise_value IS NULL
                 THEN CONVERT(bigint, 1) ELSE 0 END) AS missing_item_value_orders
    FROM rpt.fact_orders AS o
    LEFT JOIN rpt.order_financials AS f ON f.order_id = o.order_id
    WHERE o.order_purchase_timestamp >= @StartDate AND o.order_purchase_timestamp < @EndDateExclusive
    GROUP BY DATEFROMPARTS(YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), 1)
), calendar_values AS (
    SELECT m.order_month,
        COALESCE(a.orders_placed, 0) AS orders_placed,
        COALESCE(a.delivered_orders, 0) AS delivered_orders,
        CAST(CASE WHEN a.missing_item_value_orders > 0 THEN NULL
                  ELSE COALESCE(a.delivered_value, 0) END AS decimal(19, 2)) AS delivered_merchandise_value,
        COALESCE(a.missing_item_value_orders, 0) AS missing_item_value_orders,
        CASE WHEN a.orders_placed > 0
              AND m.order_month > @FirstMonth AND m.order_month < @LastMonth
              AND @StartDate <= m.order_month AND @EndDateExclusive >= DATEADD(month, 1, m.order_month)
             THEN 1 ELSE 0 END AS can_compare_month
    FROM months AS m
    LEFT JOIN monthly AS a ON a.order_month = m.order_month
), compared AS (
    SELECT *,
        LAG(orders_placed) OVER (ORDER BY order_month) AS previous_orders,
        LAG(delivered_merchandise_value) OVER (ORDER BY order_month) AS previous_value,
        LAG(can_compare_month) OVER (ORDER BY order_month) AS previous_can_compare
    FROM calendar_values
)
SELECT order_month, orders_placed, delivered_orders, delivered_merchandise_value,
    missing_item_value_orders,
    CASE WHEN orders_placed > 0 THEN 1 ELSE 0 END AS has_recorded_orders,
    CASE WHEN @StartDate > order_month OR @EndDateExclusive < DATEADD(month, 1, order_month)
         THEN 1 ELSE 0 END AS is_partial_selected_month,
    CASE WHEN order_month IN (@FirstMonth, @LastMonth) THEN 1 ELSE 0 END AS is_observed_boundary_month,
    CAST(CASE WHEN can_compare_month = 1 AND previous_can_compare = 1
              THEN 100.0 * (delivered_merchandise_value - previous_value) / NULLIF(previous_value, 0)
         END AS decimal(19, 2)) AS merchandise_value_mom_pct,
    CAST(CASE WHEN can_compare_month = 1 AND previous_can_compare = 1
              THEN 100.0 * (orders_placed - previous_orders) / NULLIF(previous_orders, 0)
         END AS decimal(19, 2)) AS orders_mom_pct
FROM compared
ORDER BY order_month
OPTION (MAXRECURSION 0);

-- QUERY 2: Category ranking
-- Question: Which categories contribute the most delivered merchandise value?
-- Grain: category. Delivered items only; freight excluded.
-- Technique: aggregate, RANK with boundary ties, and an all-category window total.
;WITH category_totals AS (
    SELECT category_display,
        CAST(SUM(price) AS decimal(19, 2)) AS delivered_merchandise_value,
        COUNT_BIG(*) AS delivered_item_count,
        COUNT(DISTINCT order_id) AS distinct_containing_orders
    FROM rpt.fact_order_items
    WHERE order_status = N'delivered'
      AND order_purchase_timestamp >= @StartDate AND order_purchase_timestamp < @EndDateExclusive
    GROUP BY category_display
), ranked AS (
    SELECT *, RANK() OVER (ORDER BY delivered_merchandise_value DESC) AS value_rank,
        SUM(delivered_merchandise_value) OVER () AS all_category_value
    FROM category_totals
)
SELECT value_rank, category_display, delivered_merchandise_value,
    delivered_item_count, distinct_containing_orders,
    CAST(100.0 * delivered_merchandise_value / NULLIF(CAST(all_category_value AS decimal(19, 2)), 0)
         AS decimal(7, 2)) AS share_of_all_delivered_value_pct
FROM ranked
WHERE value_rank <= @TopCategories
ORDER BY value_rank, category_display;

-- QUERY 3: Customer-state delivery
-- Question: Which customer state/month groups warrant delivery investigation?
-- Grain: state and purchase month, delivered orders only.
-- Technique: LEFT JOIN and conditional counts; missing dates stay outside the rate denominator.
;WITH state_month AS (
    SELECT c.customer_state,
        DATEFROMPARTS(YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), 1) AS order_month,
        COUNT_BIG(*) AS delivered_orders,
        SUM(CONVERT(bigint, o.eligible_for_on_time)) AS eligible_orders,
        SUM(CASE WHEN o.eligible_for_on_time = 1 AND o.is_on_time = 1
                 THEN CONVERT(bigint, 1) ELSE 0 END) AS on_time_orders
    FROM rpt.fact_orders AS o
    LEFT JOIN rpt.customers AS c ON c.customer_id = o.customer_id
    WHERE o.is_delivered = 1
      AND o.order_purchase_timestamp >= @StartDate AND o.order_purchase_timestamp < @EndDateExclusive
    GROUP BY c.customer_state,
        DATEFROMPARTS(YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), 1)
)
SELECT order_month, COALESCE(customer_state, N'Unmapped') AS customer_state,
    delivered_orders, eligible_orders, on_time_orders,
    eligible_orders - on_time_orders AS late_orders,
    delivered_orders - eligible_orders AS excluded_missing_delivery_dates,
    CAST(100.0 * on_time_orders / NULLIF(eligible_orders, 0) AS decimal(7, 2)) AS on_time_pct,
    CAST(100.0 * eligible_orders / NULLIF(delivered_orders, 0) AS decimal(7, 2)) AS delivery_date_coverage_pct
FROM state_month
ORDER BY order_month, on_time_pct DESC, customer_state;

-- QUERY 4: Seller value and delivery
-- Question: Which material sellers have associated orders that merit review?
-- Grain: seller, built from one seller/order row so item quantity cannot weight delivery timing.
-- Delivery is a whole-order outcome; a negative signed difference means early delivery.
;WITH seller_orders AS (
    SELECT seller_id, order_id, SUM(price) AS item_value, COUNT_BIG(*) AS item_count
    FROM rpt.fact_order_items
    WHERE order_status = N'delivered'
      AND order_purchase_timestamp >= @StartDate AND order_purchase_timestamp < @EndDateExclusive
    GROUP BY seller_id, order_id
), seller_totals AS (
    SELECT k.seller_id,
        CAST(SUM(k.item_value) AS decimal(19, 2)) AS delivered_merchandise_value,
        SUM(k.item_count) AS delivered_item_count,
        COUNT_BIG(*) AS distinct_containing_orders,
        SUM(CONVERT(bigint, o.eligible_for_on_time)) AS eligible_orders,
        SUM(CASE WHEN o.eligible_for_on_time = 1 AND o.is_on_time = 1
                 THEN CONVERT(bigint, 1) ELSE 0 END) AS on_time_orders,
        CAST(AVG(CASE WHEN o.eligible_for_on_time = 1 THEN CAST(o.delivery_delay_days AS decimal(10, 2)) END)
             AS decimal(10, 2)) AS mean_signed_delivery_difference_days
    FROM seller_orders AS k
    JOIN rpt.fact_orders AS o ON o.order_id = k.order_id
    GROUP BY k.seller_id
)
SELECT RANK() OVER (ORDER BY t.delivered_merchandise_value DESC) AS value_rank,
    t.seller_id, s.seller_city, s.seller_state,
    t.delivered_merchandise_value, t.delivered_item_count,
    t.distinct_containing_orders, t.eligible_orders,
    t.distinct_containing_orders - t.eligible_orders AS excluded_missing_delivery_dates,
    t.eligible_orders - t.on_time_orders AS late_orders,
    CAST(100.0 * t.on_time_orders / NULLIF(t.eligible_orders, 0) AS decimal(7, 2)) AS on_time_pct,
    t.mean_signed_delivery_difference_days
FROM seller_totals AS t
LEFT JOIN rpt.sellers AS s ON s.seller_id = t.seller_id
ORDER BY value_rank, t.seller_id;

-- QUERY 5: Monthly cancellation rate
-- Question: Which purchase cohorts have cancellation patterns to investigate?
-- Grain: calendar month within observed dates. All statuses form the denominator.
-- Technique: one conditional aggregation and a calendar LEFT JOIN; zero orders gives a NULL rate.
;WITH months AS (
    SELECT DATEFROMPARTS(YEAR(@CalendarStart), MONTH(@CalendarStart), 1) AS order_month
    WHERE @CalendarStart < @CalendarEnd
    UNION ALL
    SELECT DATEADD(month, 1, order_month) FROM months
    WHERE DATEADD(month, 1, order_month) < @CalendarEnd
), monthly AS (
    SELECT DATEFROMPARTS(YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), 1) AS order_month,
        COUNT_BIG(*) AS total_orders,
        SUM(CASE WHEN order_status = N'canceled' THEN CONVERT(bigint, 1) ELSE 0 END) AS canceled_orders
    FROM rpt.fact_orders
    WHERE order_purchase_timestamp >= @StartDate AND order_purchase_timestamp < @EndDateExclusive
    GROUP BY DATEFROMPARTS(YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), 1)
)
SELECT m.order_month,
    COALESCE(a.total_orders, 0) AS total_orders,
    COALESCE(a.canceled_orders, 0) AS canceled_orders,
    CAST(100.0 * a.canceled_orders / NULLIF(a.total_orders, 0) AS decimal(7, 2)) AS cancellation_rate_pct,
    CASE WHEN a.total_orders > 0 THEN 1 ELSE 0 END AS has_recorded_orders,
    CASE WHEN @StartDate > m.order_month OR @EndDateExclusive < DATEADD(month, 1, m.order_month)
         THEN 1 ELSE 0 END AS is_partial_selected_month,
    CASE WHEN m.order_month IN (@FirstMonth, @LastMonth) THEN 1 ELSE 0 END AS is_observed_boundary_month
FROM months AS m
LEFT JOIN monthly AS a ON a.order_month = m.order_month
ORDER BY m.order_month
OPTION (MAXRECURSION 0);
