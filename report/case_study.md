# Olist Sales and Delivery Analysis

**Historical marketplace analysis | Purchase period: 4 September 2016 to 17 October 2018**

*Prepared as a portfolio analysis for a simulated marketplace operations scenario.*

## Executive summary

The analysis covers 99,441 orders, of which 96,478 were recorded as delivered. Delivered merchandise value totalled 13,221,498.11, excluding freight. Health and beauty, watches and gifts, and bed, bath and table products together contributed 25.89% of that value. These categories provide a commercially material starting point for further investigation.

Delivery performance varied across the examined groups. Overall, 93.23% of eligible delivered orders arrived on or before their estimated delivery date, leaving 6,534 late orders. In the August 2018 purchase cohort, São Paulo accounted for 285 of the 393 late orders across all states. The seller with the highest delivered merchandise value also illustrates the limitations of an average delivery measure: its associated orders arrived 11.10 days early on average, while 118 orders were late.

Recorded cancellations represented 0.63% of all orders. August and February 2018 had the largest cancellation counts, making them useful cohorts for investigation. The much higher percentages in the final two months of the extract came from only 20 orders in total and require cautious interpretation. The findings support targeted examination of delivery exceptions and cancellation records; they do not establish the causes of those outcomes.

| Measure | Result | Population |
|---|---:|---|
| Orders placed | 99,441 | All recorded statuses in the selected purchase period |
| Delivered orders | 96,478 | Orders recorded as delivered |
| Delivered merchandise value | 13,221,498.11 | Item prices on delivered orders, excluding freight |
| On-time delivery rate | 93.23% | 89,936 on-time orders out of 96,470 eligible delivered orders |
| Late delivered orders | 6,534 | Eligible delivered orders arriving after their estimate |
| Recorded cancellation rate | 0.63% | 625 canceled orders out of 99,441 orders |

All monetary figures are expressed in source monetary units. A currency symbol has not been applied because the currency label has not been confirmed in the project documentation.

## Purpose, scope and analytical approach

I examined the dataset to identify where commercial importance and order outcomes provide a useful basis for operational investigation. I focused on five areas: monthly sales activity, category contribution, delivery performance by customer state, seller contribution and associated delivery outcomes, and recorded cancellations. The objective was to establish a reproducible basis for deciding which groups should be examined more closely.

I used purchase date consistently across the five queries. The selected period starts on 4 September 2016 and includes purchases through 17 October 2018. This means that a monthly delivery result describes orders purchased in that month, even when delivery occurred later. The extract is historical, and its first and last transaction dates do not establish complete coverage for every calendar month.

I kept order counts and item values at their appropriate levels of detail. Orders placed includes every recorded status, while delivered merchandise value includes only item prices attached to delivered orders. Freight, marketplace fees, costs and profit are outside that value measure. For seller analysis, I first grouped items into one record per seller and order, ensuring that multiple items did not repeatedly weight the same order's delivery time.

Missing timestamps were preserved. An order entered the on-time delivery calculation only when it was recorded as delivered and both actual customer-delivery and estimated-delivery dates were available. The comparison used calendar dates, so delivery later in the day of the estimate still counted as on time. For monthly growth, I retained calendar gaps and excluded comparisons involving empty months, unusable prior values, partial selected months or the first and last observed months.

## Findings and interpretation

### 1. Monthly activity identifies a clear peak, with important limits on growth comparisons

November 2017 had the highest delivered merchandise value in the selected extract, at 987,765.37. The purchase cohort contained 7,544 orders, including 7,289 recorded as delivered. Compared with October, delivered merchandise value increased by 52.37% and orders placed increased by 62.90%. Both measures then fell in December: delivered value decreased by 26.50%, while orders placed decreased by 24.80%.

This pattern identifies November 2017 as a useful case for examining how order processing and fulfilment responded to higher activity. The available results do not explain the increase, and a single observed peak is insufficient evidence of recurring annual seasonality. Promotion, traffic or operational records would be needed to investigate the drivers.

I compared each eligible month with its preceding calendar month rather than its preceding available record. This matters because November 2016 contains no recorded orders. Keeping that gap prevents December 2016 from being compared directly with October. The calendar also stops at the observed purchase-date boundary, so extending a filter to 2024 does not create years of apparent zero activity.

The January 2017 increase of 1,025,573.03% is mathematically correct but has limited value as a planning benchmark. December 2016 contained only one order and 10.90 in delivered merchandise value. Similarly, September and October 2018 contained just 16 and four orders respectively, with no delivered merchandise value. Those small end-of-extract cohorts cannot support a conclusion that marketplace sales ceased. Monthly growth therefore needs to be read alongside order counts and the coverage of the underlying extract.

### 2. Leading categories provide material review priorities, while value remains spread across the catalogue

Health and beauty generated the highest delivered merchandise value, at 1,233,131.72, representing 9.33% of the total. Watches and gifts followed at 1,166,176.98, and bed, bath and table products contributed 1,023,434.76. Together, these three categories generated 3,422,743.46, or 25.89% of delivered merchandise value.

| Value rank | Category | Delivered merchandise value | Delivered item rows | Share of total value |
|---|---|---:|---:|---:|
| 1 | Health and beauty | 1,233,131.72 | 9,465 | 9.33% |
| 2 | Watches and gifts | 1,166,176.98 | 5,859 | 8.82% |
| 3 | Bed, bath and table | 1,023,434.76 | 10,953 | 7.74% |
| 4 | Sports and leisure | 954,852.55 | 8,431 | 7.22% |
| 5 | Computers and accessories | 888,724.61 | 7,644 | 6.72% |

*The table shows the five highest-value categories from the 15-row ranked output. Display names have been expanded from the category codes for readability.*

I ranked categories by delivered item value and calculated each percentage against all eligible categories before selecting the displayed ranks. This preserves a consistent contribution measure. Categories tied on value receive the same rank, and the existing category fallback retains records without an English translation.

The category results distinguish commercial value from item volume. Bed, bath and table products had more delivered item rows than either of the two higher-value categories, yet ranked third by value. A value ranking and a volume ranking therefore answer different questions. The leading categories warrant attention because of their contribution, while the remaining categories still account for 74.11% of delivered value. Decisions about assortment or investment would also require information on costs, availability and returns; this analysis does not measure category profitability.

### 3. Delivery exceptions are concentrated in a material customer-state cohort

Across the full selected period, 89,936 of 96,470 eligible delivered orders were on time, producing an on-time rate of 93.23%. The remaining 6,534 eligible orders were late. Eight delivered orders lacked the required delivery-date evidence and were excluded from the rate without being removed from the delivered-order count.

I calculated the overall rate from the total on-time and eligible counts. This gives each eligible order equal weight and prevents small state/month groups from having the same influence as large groups. The state analysis also retains the group size and missing-date count beside each rate.

August 2018 provides a useful example of a material delivery pattern. São Paulo had 3,164 eligible orders and 285 late orders, giving an on-time rate of 90.99%. Across all states in the same purchase month, there were 6,351 eligible orders and 393 late orders. São Paulo therefore represented 49.82% of eligible orders and 72.52% of late orders in that cohort.

| Customer state | Eligible delivered orders | Late orders | On-time rate |
|---|---:|---:|---:|
| São Paulo (SP) | 3,164 | 285 | 90.99% |
| Rio de Janeiro (RJ) | 723 | 42 | 94.19% |
| Minas Gerais (MG) | 700 | 12 | 98.29% |
| Paraná (PR) | 327 | 10 | 96.94% |
| Rio Grande do Sul (RS) | 293 | 9 | 96.93% |

*August 2018 purchase cohort; the five states with the largest eligible-order counts are shown. These are monthly results, separate from the full-period rate of 93.23%.*

The concentration of late orders makes São Paulo a reasonable starting point for reviewing August delivery exceptions. It does not establish that location caused the delays. Differences in product mix, sellers, delivery promises and fulfilment conditions may affect the comparison and would require further analysis. No service target or statistically tested performance threshold has been established, so the results identify investigation candidates rather than confirmed failures against an agreed standard.

### 4. Seller averages need to be interpreted alongside late-order counts

The seller analysis covered 2,970 sellers and 110,197 delivered item rows. Seller item values reconcile to the full delivered merchandise value of 13,221,498.11. The leading seller by value contributed 226,987.93 across 1,124 containing orders, with all 1,124 eligible for delivery assessment.

That seller's orders arrived 11.10 days before the estimate on average. However, 118 orders were late and the on-time rate was 89.50%. The average therefore conceals a group of exceptions because early deliveries offset late deliveries in the signed mean.

| Value rank | Delivered merchandise value | Eligible containing orders | Late orders | On-time rate | Mean signed delivery difference, days |
|---|---:|---:|---:|---:|---:|
| 1 | 226,987.93 | 1,124 | 118 | 89.50% | -11.10 |
| 2 | 217,940.44 | 348 | 12 | 96.55% | -11.48 |
| 3 | 196,882.12 | 1,772 | 172 | 90.29% | -9.53 |
| 4 | 190,917.14 | 578 | 53 | 90.83% | -10.31 |
| 5 | 186,570.05 | 973 | 89 | 90.85% | -11.38 |

*The five highest-value sellers are shown. A negative signed difference indicates delivery before the estimate.*

I grouped item rows by seller and order before joining delivery measures. This retains every item's value while allowing the order's delivery outcome to enter a seller's average once. It also makes the value ranking and the delivery denominator easier to trace.

The results support reviewing the orders associated with commercially material sellers, using value, eligible volume and exceptions together. They do not identify responsibility for individual delays. Delivery timestamps describe whole orders, including orders containing items from several sellers. The output has 97,819 seller/order pairs, so summing seller order counts would count some orders more than once. Any investigation should examine the relevant order milestones before attributing a problem to a seller.

### 5. Cancellation counts provide more useful priorities than extreme percentages in tiny cohorts

There were 625 orders recorded as canceled, representing 0.63% of all 99,441 orders in the selected period. August 2018 had the largest cancellation count, with 84 cancellations among 6,512 orders, followed by February 2018 with 73 among 6,728. Their respective cancellation rates were 1.29% and 1.09%.

| Purchase month | Orders placed | Recorded cancellations | Cancellation rate |
|---|---:|---:|---:|
| February 2018 | 6,728 | 73 | 1.09% |
| July 2018 | 6,292 | 41 | 0.65% |
| August 2018 | 6,512 | 84 | 1.29% |
| September 2018 | 16 | 15 | 93.75% |
| October 2018 | 4 | 4 | 100.00% |

*The table includes the three purchase months with the largest cancellation counts and the final two months to show the effect of cohort size. The [monthly cancellation query](../sql/05_monthly_cancellations.sql) is available as analytical source.*

The final two percentages appear much larger, but they represent only 19 cancellations across 20 orders. August and February provide more material starting points for a review because their cancellation counts occur within substantially larger purchase cohorts. The recorded status alone cannot explain whether the cancellations arose from stock availability, payment issues, customer decisions or another cause.

I calculated total and canceled orders in the same monthly aggregation so that both use the same date filter. All statuses remain in the denominator, while only `canceled` contributes to the numerator. The calendar retains months without records, and the rate remains unavailable when no orders exist. This is a comparison of recorded cancellation status by purchase month; it does not measure when cancellations occurred.

## Recommendations

For this historical case, I would prioritise the following analytical follow-ups:

1. **Review material delivery exceptions.** Begin with São Paulo's August 2018 cohort and the orders associated with high-value sellers that have substantial late-order counts. Compare order milestones and relevant order characteristics before assigning responsibility or proposing a process change.
2. **Combine category contribution with service evidence.** Use the three leading categories as an initial commercial focus, then examine their delivery outcomes and operational context. Value contribution alone is insufficient to justify an assortment or investment decision.
3. **Investigate cancellation records in larger cohorts.** Examine August and February 2018, including cancellation reasons and status histories if those records become available. Keep the small end-of-extract cohorts visible as a coverage limitation rather than using their percentages as the main operational benchmark.
4. **Maintain consistent definitions in subsequent reporting.** Compare equivalent purchase periods, show eligible order counts beside delivery rates, preserve missing timestamps and keep order-level outcomes separate from item-level value. These practices are necessary for later SQL and Power BI results to remain comparable.

These are proposed follow-up analyses. No operational intervention has been implemented or its business impact measured as part of this report.

## Limitations

The dataset represents a historical extract with uneven activity at its boundaries and an internal month without recorded orders. Its transaction dates do not establish complete market coverage or current Olist performance. Monthly results also describe the statuses observed in the extract rather than the full sequence of status changes. Cancellation-event dates and causes are unavailable in the examined outputs.

Delivered merchandise value excludes freight and does not establish fees, margins or profit. Delivery outcomes belong to whole orders, which limits attribution to individual sellers. Geographic and seller comparisons are descriptive: order mix has not been controlled and differences have not been subjected to a statistical significance test. Missing required delivery dates are excluded from rates and remain visible through coverage counts.
