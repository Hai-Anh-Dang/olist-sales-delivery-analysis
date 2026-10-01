-- QUERY 4: Seller value and delivery
-- Question: Which material sellers have associated orders that merit review?
-- Grain: seller, built from one seller/order row so item quantity cannot weight delivery timing.
-- Delivery is a whole-order outcome; a negative signed difference means early delivery.

USE [olist_dataset];
SET NOCOUNT ON;
DECLARE @StartDate date = '20160904';
DECLARE @EndDateExclusive date = '20181018';
IF @StartDate IS NULL OR @EndDateExclusive IS NULL OR @StartDate >= @EndDateExclusive
    THROW 50000, 'StartDate must be earlier than EndDateExclusive.', 1;

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
