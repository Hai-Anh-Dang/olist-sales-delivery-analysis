# Power BI dashboard

**[Open the live interactive Power BI dashboard](https://app.powerbi.com/view?r=eyJrIjoiMzE1OWZlYzctMzA5NC00YTljLWExYTItNWIzNjJlZWJjM2M4IiwidCI6Ijc1ZGIzZDY4LTExMGYtNDI1NS05MTE5LWFhNjMxOGMyMDY2YyJ9)**

The published report turns the SQL analysis into three business-facing views:

| Dashboard view | Business purpose |
| --- | --- |
| Performance Overview | Compare purchase-month order activity and delivered merchandise value. |
| Categories and Sellers | Review commercially material categories and seller-associated delivery outcomes together. |
| Delivery and Cancellations | Identify state/month delivery exceptions and material cancellation cohorts for follow-up. |

## Metric logic

The report uses the same definitions as the SQL analysis. Orders, items, and payments remain at their appropriate grains; delivered merchandise value excludes freight; and on-time delivery requires both actual and estimated delivery dates. Missing delivery dates are excluded from the on-time-rate denominator rather than treated as late.

See the full [metric definitions](metric_definitions.md) and the reproducible [SQL analysis](../sql/README.md).

## Suggested review order

1. Open the live dashboard and scan the overview KPIs and trends.
2. Review category, seller, delivery, and cancellation views for the exception patterns highlighted in the project README.
3. Use the SQL queries and written case study to verify definitions, calculations, and analytical limitations.

[Project overview](../README.md) · [Written case study](../report/case_study.md)
