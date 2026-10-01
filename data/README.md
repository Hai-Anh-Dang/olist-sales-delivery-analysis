# Data

Source: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

The analysis uses the historical purchase period from 4 September 2016 to 17 October 2018. Monthly delivery results describe the purchase cohort, even if delivery occurred later.

This folder contains source documentation rather than the raw extract. Refer to the publisher for source access and dataset terms.

| Input | Role | Grain |
| --- | --- | --- |
| Orders | Purchase dates, recorded status, estimated and actual delivery dates | One order |
| Order items | Product, seller, price, and freight | One order/item sequence |
| Payments | Payment type and amount | One order/payment sequence |
| Customers | Link orders to customer state and stable customer identity | One customer record used by an order |
| Products | Product and category attributes | One product |
| Sellers | Seller attributes | One seller |
| Category translation | English category labels | One category mapping |

[Data dictionary](data_dictionary.md) · [Project overview](../README.md)
