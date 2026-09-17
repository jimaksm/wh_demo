```
# wh_demo — A Four-Layer Data Warehouse with dbt + DuckDB

A complete ELT demo that builds a production-style analytics warehouse
(ODS → DWD → DWS → ADS) using **dbt Core** and **DuckDB**. It simulates a
realistic e-commerce scenario: 6 raw tables, 13 models, and 10 automated
data tests, including common dirty-data cases you meet in real life.

## Tech Stack

- dbt Core 1.12.5
- dbt-duckdb 1.11.0
- DuckDB (embedded, zero server setup)
- Python 3.12 (venv: `dbt-duckdb-env`)

## Project Structure
```

wh_demo/ ├── seeds/            # raw data (6 CSV files) │   ├── customers.csv │   ├── products.csv │   ├── orders.csv │   ├── order_items.csv │   ├── payments.csv │   └── shipping.csv ├── models/ │   ├── ods/          # Operational Data Store — near-lineage copy (6 views) │   ├── dwd/          # Detail layer — cleaned dims & fact (3 tables) │   ├── dws/          # Summary layer — aggregated topics (2 tables) │   └── ads/          # Application layer — final reports (2 tables) └── dbt_project.yml

```
## Data Flow
```

6 seed tables → ODS (6 views) → DWD (3 tables) → DWS (2 tables) → ADS (2 tables)

```
| Layer | Models | Purpose |
| --- | --- | --- |
| ODS | `ods_customers`, `ods_products`, `ods_orders`, `ods_order_items`, `ods_payments`, `ods_shipping` | 1:1 copy of source, minimal transformation |
| DWD | `dim_customer`, `dim_product`, `fact_order_detail` | Cleaning, standardization, 4-table join |
| DWS | `dws_customer_stats`, `dws_category_stats` | Customer & category aggregated topics |
| ADS | `ads_daily_gmv_report`, `ads_top_customers` | Final reports for business users |

## Data Cleansing Highlights

- Order status normalized: `Completed` / `PENDING` / `cancelled` → 已完成 / 待支付 / 已取消
- Gender standardized: lowercase `f` → 女
- Missing age handled → bucketed as 未知
- Delivery days computed from `ship_date` to `delivery_date`
- Gross margin calculated with a price-vs-cost sanity check

## How to Run

```bash
# 1. setup (once)
python -m venv dbt-duckdb-env
dbt-duckdb-env\Scripts\activate
pip install dbt-duckdb

# 2. load raw data
dbt seed

# 3. build all models and run tests
dbt build

# 4. generate and view docs (lineage graph)
dbt docs generate
dbt docs serve --port 8081
# open [http://localhost:8081](http://localhost:8081) → Overview → View lineage
```

## Tests

10 data tests defined in `schema.yml` files (`unique` / `not_null` on key columns), all passing with `dbt build`.

## Sample Output

`ads_top_customers`:

| customer | city | completed_orders | gmv  |
| -------- | ---- | ---------------- | ---- |
| Eve      | 深圳 | 1                | 957  |
| Alice    | 长沙 | 3                | 885  |
| Henry    | 北京 | 1                | 658  |



