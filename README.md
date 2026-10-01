# Olist Sales & Delivery Analysis

I examined historical Olist order data to understand marketplace activity and identify delivery and cancellation patterns worth investigating. The project uses a simulated marketplace operations manager as its audience.

Purchase period: **4 September 2016 to 17 October 2018**.

The SQL analysis and written case study are available. The Power BI report is planned; this repository does not yet contain a completed dashboard.

## 📚 Table of Contents

- [Business need](#business-need)
- [Business questions](#business-questions)
- [Findings](#findings)
- [Recommendations](#recommendations)
- [Data and methods](#data-and-methods)
- [Power BI](#power-bi)
- [Project files](#project-files)
- [Limitations](#limitations)

## Business need

A marketplace operations manager wants to understand commercial activity and decide which delivery exceptions need closer examination. Category value, order volume, and late-order counts help select investigation priorities without assuming what caused the delays.

## Business questions

| Question | Measures | Decision supported |
| --- | --- | --- |
| How do monthly orders and delivered value change? | Orders placed, delivered orders, delivered merchandise value | Select purchase cohorts for commercial or operational review. |
| Which categories contribute most to delivered value? | Category value, share, and item volume | Choose commercially material categories for deeper analysis. |
| Where are delivery exceptions concentrated? | Late-order counts, eligible volume, on-time rate | Prioritize customer-state/month cohorts for investigation. |
| Which material sellers are associated with late orders? | Seller item value and containing-order delivery outcomes | Review order milestones before attributing responsibility. |
| Which months have material recorded cancellations? | Cancellation counts and rates with cohort sizes | Investigate larger cancellation cohorts. |

## Findings

- Health and beauty, watches and gifts, and bed, bath and table contributed **25.89%** of delivered merchandise value. Their commercial contribution makes them useful starting points for review; it does not establish profitability.
- **93.23%** of eligible delivered orders arrived on or before the estimate. There were **6,534** late orders among **96,470** eligible delivered orders; eight delivered orders lacked the dates needed for this calculation.
- In the August 2018 purchase cohort, São Paulo accounted for **285 of 393** late orders. This identifies a cohort for reviewing order milestones, without establishing that location caused the delays.
- Recorded cancellations were **625 of 99,441 orders**, or **0.63%**. August and February 2018 had the largest cancellation counts. Extreme rates in the final two months came from only 20 orders and require caution.

These figures come from the existing [written case study](report/case_study.md). Preparing this repository did not rerun the analysis.

## Recommendations

Begin with the August 2018 São Paulo cohort and orders associated with commercially material sellers. Examine order milestones before proposing a process change. Review the leading categories alongside service outcomes, and investigate cancellation records in larger cohorts if reasons or status histories become available.

## Data and methods

Orders, items, and payments retain their separate grains. Merchandise value sums delivered item prices and excludes freight. Monthly comparisons use purchase month. Delivery rates require actual and estimated delivery dates and compare calendar dates, so same-day delivery counts as on time.

The [data notes](data/README.md) describe the source and table grains. The [SQL folder](sql/README.md) links the five analytical queries and combined script.

## Power BI

The [Power BI folder](powerbi/README.md) contains the planned reporting structure and metric definitions. Dashboard link:

## Project files

| Folder | Contents |
| --- | --- |
| [data/](data/) | Source notes and data dictionary; no raw transaction extract. |
| [sql/](sql/) | Existing analytical SQL queries. |
| [powerbi/](powerbi/) | Reporting plan and metric definitions. |
| [report/](report/) | Written case study. |

## Limitations

The extract is historical and its date boundaries do not establish complete market coverage. Merchandise value is not revenue, margin, or profit. Whole-order delivery outcomes cannot identify which seller caused a delay. Missing dates and small cohorts limit comparisons. No operational intervention or resulting business impact has been measured.

Data attribution: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). AI assisted with drafting and code review; numerical claims refer to the saved analytical evidence.

[Back to portfolio](https://github.com/Mt-H-Anh/data-powerbi-portfolio)
