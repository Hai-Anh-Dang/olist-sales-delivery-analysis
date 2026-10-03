# Olist Sales & Delivery Analysis

Historical e-commerce analysis using **SQL Server and Power BI** to understand marketplace activity, delivery performance, seller/category contribution, and cancellation patterns.

**Purchase period:** 4 September 2016 to 17 October 2018  
**Live dashboard:** [Open the interactive Power BI report](https://app.powerbi.com/view?r=eyJrIjoiMzE1OWZlYzctMzA5NC00YTljLWExYTItNWIzNjJlZWJjM2M4IiwidCI6Ijc1ZGIzZDY4LTExMGYtNDI1NS05MTE5LWFhNjMxOGMyMDY2YyJ9)

## Business question

Where are the most commercially material sales and delivery patterns, and which customer-state, seller, category, or cancellation cohorts should be investigated first?

## Key findings

- **99,441 orders** were recorded; **96,478** were delivered.
- Delivered merchandise value totalled **13.22M** in source monetary units, excluding freight.
- Health and beauty, watches and gifts, and bed, bath and table generated **25.89%** of delivered merchandise value.
- **93.23%** of eligible delivered orders were on time; **6,534** were late.
- In the August 2018 purchase cohort, São Paulo accounted for **285 of 393** late orders.
- Recorded cancellations were **625 of 99,441 orders (0.63%)**; August and February 2018 had the largest cancellation counts.

## Recommendations

- Review the August 2018 São Paulo cohort and orders linked to commercially material sellers before proposing operational changes.
- Combine category contribution with service outcomes rather than using value alone for prioritisation.
- Investigate cancellation records in larger cohorts first, especially August and February 2018.
- Keep order-level delivery outcomes separate from item-level value and show eligible denominators beside rates.

## Power BI dashboard

The published Power BI report provides three recruiter-friendly views:

| View | Purpose |
| --- | --- |
| Performance Overview | Review monthly orders, delivered value, and overall marketplace activity. |
| Categories and Sellers | Compare commercial contribution with seller-associated delivery outcomes. |
| Delivery and Cancellations | Identify delivery exceptions and material cancellation cohorts. |

**[Open the live Power BI dashboard](https://app.powerbi.com/view?r=eyJrIjoiMzE1OWZlYzctMzA5NC00YTljLWExYTItNWIzNjJlZWJjM2M4IiwidCI6Ijc1ZGIzZDY4LTExMGYtNDI1NS05MTE5LWFhNjMxOGMyMDY2YyJ9)**

For metric logic and report review guidance, see [powerbi/README.md](powerbi/README.md).

## Data and methods

The analysis uses five SQL Server queries covering monthly activity, category ranking, state/month delivery performance, seller value and delivery outcomes, and monthly cancellations.

Orders, items, and payments remain at their correct grains. Delivered merchandise value is the sum of item prices on delivered orders and excludes freight. Monthly analysis uses purchase month. On-time delivery requires both actual and estimated delivery dates and compares calendar dates, so same-day delivery counts as on time.

See the [SQL analysis](sql/README.md), [metric definitions](powerbi/metric_definitions.md), and [written case study](report/case_study.md).

## Recruiter review path

1. Open the [Power BI dashboard](https://app.powerbi.com/view?r=eyJrIjoiMzE1OWZlYzctMzA5NC00YTljLWExYTItNWIzNjJlZWJjM2M4IiwidCI6Ijc1ZGIzZDY4LTExMGYtNDI1NS05MTE5LWFhNjMxOGMyMDY2YyJ9) and scan the overview KPIs and trends.
2. Review category, seller, delivery, and cancellation views for the exception patterns above.
3. Check the [SQL queries](sql/README.md) for reproducible logic and the [case study](report/case_study.md) for interpretation and caveats.

## Project files

| Folder | Contents |
| --- | --- |
| [data/](data/) | Source notes and data dictionary; no raw transaction extract. |
| [sql/](sql/) | Reproducible analytical SQL queries. |
| [powerbi/](powerbi/) | Live dashboard link, report structure, and metric definitions. |
| [report/](report/) | Detailed written case study. |

## Limitations

The dataset is historical and does not establish complete market coverage or current Olist performance. Merchandise value is not revenue, margin, or profit. Delivery outcomes belong to whole orders, so seller-level results do not prove responsibility for delays. Missing timestamps and very small end-of-extract cohorts limit comparisons. No operational intervention or resulting business impact was measured.

Data source: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

[Back to portfolio](https://github.com/Hai-Anh-Dang/data-powerbi-portfolio)
