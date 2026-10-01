# SQL analysis

The five analytical queries use SQL Server syntax and the existing `olist_dataset` reporting model. They answer the questions below using a consistent purchase period.

| Business question | Query |
| --- | --- |
| How do monthly orders and delivered merchandise value change? | [Monthly activity](01_monthly_value_and_orders.sql) |
| Which categories contribute most to delivered value? | [Category ranking](02_category_ranking.sql) |
| Where are customer-state delivery exceptions concentrated? | [State/month delivery](03_customer_state_on_time.sql) |
| Which commercially material sellers are associated with late orders? | [Seller value and delivery](04_seller_value_and_delivery.sql) |
| Which months have material recorded cancellations? | [Monthly cancellations](05_monthly_cancellations.sql) |

[Combined five-query script](five_analytical_queries.sql) · [Written case study](../report/case_study.md)

These scripts depend on the existing `rpt` model and are published as analytical source. This repository does not contain a SQL Server database or a complete source-import pipeline.
