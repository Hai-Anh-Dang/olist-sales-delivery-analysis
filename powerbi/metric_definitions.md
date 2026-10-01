# Metric definitions

| Measure | Definition and population |
| --- | --- |
| Orders placed | Distinct recorded orders in the selected purchase period, including all statuses. |
| Delivered orders | Distinct orders recorded as delivered in that purchase period. |
| Delivered merchandise value | Sum item prices on delivered orders, excluding freight. |
| On-time delivery rate | Eligible delivered orders arriving on or before the estimated calendar date, divided by eligible delivered orders with both dates. |
| Late orders | Eligible delivered orders arriving after the estimated calendar date. |
| Recorded cancellation rate | Orders recorded as cancelled divided by all orders in the same purchase period. |
| Category value share | Delivered category item value divided by all eligible delivered merchandise value. |
| Seller-associated orders | Distinct orders containing items from a seller. These counts can overlap across sellers. |

The SQL outputs express percentage fields in 0–100 units. Power BI percentage formatting requires a compatible numeric scale. Undefined rates remain unavailable; missing dates are not classified as late.
