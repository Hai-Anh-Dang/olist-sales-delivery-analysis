-- QUERY 2: Category ranking
-- Question: Which categories contribute the most delivered merchandise value?
-- Grain: category. Delivered items only; freight excluded.
-- Technique: aggregate, RANK with boundary ties, and an all-category window total.

USE [olist_dataset];
SET NOCOUNT ON;
DECLARE @StartDate date = '20160904';
DECLARE @EndDateExclusive date = '20181018';
IF @StartDate IS NULL OR @EndDateExclusive IS NULL OR @StartDate >= @EndDateExclusive
    THROW 50000, 'StartDate must be earlier than EndDateExclusive.', 1;
DECLARE @TopCategories int = 15;
IF @TopCategories IS NULL OR @TopCategories < 1
    THROW 50000, 'TopCategories must be positive.', 1;

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
