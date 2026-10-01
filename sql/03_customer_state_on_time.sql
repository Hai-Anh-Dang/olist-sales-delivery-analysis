-- QUERY 3: Customer-state delivery
-- Question: Which customer state/month groups warrant delivery investigation?
-- Grain: state and purchase month, delivered orders only.
-- Technique: LEFT JOIN and conditional counts; missing dates stay outside the rate denominator.

USE [olist_dataset];
SET NOCOUNT ON;
DECLARE @StartDate date = '20160904';
DECLARE @EndDateExclusive date = '20181018';
IF @StartDate IS NULL OR @EndDateExclusive IS NULL OR @StartDate >= @EndDateExclusive
    THROW 50000, 'StartDate must be earlier than EndDateExclusive.', 1;

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
