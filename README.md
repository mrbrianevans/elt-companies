
# Company data lakehouse

An all SQL ELT pipeline using [DuckDB](https://duckdb.org/) as a staging area and [DuckLake](https://ducklake.select/) for a local "data lakehouse".
- runs in 2 minutes
- output is transformed company data in queryable parquet files with a metadata store


## Steps
**Extract and load raw data**
```bash
duckdb -f load.sql companies.ddb
```
- Takes ~2 minutes depending on network speed.
- Loads remote zipped CSV file directly into a SQL table `companies_raw`.
- staging DuckDB database to hold raw data in an optimised format

**Transform**

```bash
duckdb -f transform.sql companies.ddb
```
- creates a view based on the raw data with column transformations

**Data lakehouse using DuckLake**

```bash
duckdb -f lake.sql companies.ddb
```
 - creates a DuckLake based on the transformed view
 - parquet files stored in ducklake_files/main/companies/*.parquet
   - they could easily be put into remote object storage (S3)
 - entire companies dataset uses ~300MB (original CSV is ~2GB)
 - ready to be queried
