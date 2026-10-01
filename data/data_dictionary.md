# Data dictionary

| Field | Meaning in this analysis |
| --- | --- |
| order_id | Order identifier used for distinct order counts. |
| order_item_id | Item sequence within an order; multiple items are valid. |
| payment_sequential | Payment sequence within an order; multiple payments are valid. |
| order_purchase_timestamp | Purchase timing; calendar month is the reporting basis. |
| order_status | Recorded order status; delivered and cancelled measures use their documented status rules. |
| order_delivered_customer_date | Actual whole-order customer delivery timestamp. |
| order_estimated_delivery_date | Estimated delivery date used in the on-time comparison. |
| price | Item price used in delivered merchandise value. |
| freight_value | Freight amount; excluded from delivered merchandise value. |
| customer_id | Customer-record link for the order. |
| customer_unique_id | Stable customer identifier across observed orders. |
| customer_state | Customer state used for geographic comparisons. |
| product_id | Product key on the item. |
| seller_id | Seller key on the item. Delivery outcomes still describe the whole order. |
| product_category_name | Product category; translation is used when available. |

Order counts at seller or category scope can overlap and must not be summed as a marketplace total. Item and payment facts must not be joined before aggregation in a way that repeats either amount.
