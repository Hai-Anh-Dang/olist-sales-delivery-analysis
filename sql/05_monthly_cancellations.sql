-- QUERY 5: Monthly cancellation rate
-- Question: Which purchase cohorts have cancellation patterns to investigate?
-- Grain: calendar month within observed dates. All statuses form the denominator.
-- Technique: one conditional aggregation and a calendar LEFT JOIN; zero orders gives a NULL rate.

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
