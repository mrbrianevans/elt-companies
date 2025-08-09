

# Commands

**Get latest filenames**

```bash
duckdb -noheader -quote -f list_filenames.sql
```

**Extract and load raw data**

```bash
duckdb -f load.sql companies.ddb
```


**Transform**

```bash
duckdb -f transform.sql companies.ddb
```