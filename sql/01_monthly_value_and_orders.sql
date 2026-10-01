-- QUERY 1: Monthly value and order activity
-- Question: Which purchase months warrant commercial investigation?
-- Grain: purchase month. All statuses for orders; delivered item prices for value.
-- Technique: bounded calendar, conditional aggregation and LAG.

USE [olist_dataset];
SET NOCOUNT ON;
DECLARE @StartDate date = '20160904';
DECLARE @EndDateExclusive date = '20181018';
IF @StartDate IS NULL OR @EndDateExclusive IS NULL OR @StartDate >= @EndDateExclusive
    THROW 50000, 'StartDate must be earlier than EndDateExclusive.', 1;

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
