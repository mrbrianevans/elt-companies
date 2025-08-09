-- Select all remote partition filenames for the first day of the current month using DuckDB
-- Run with duckdb -noheader -quote -f list_filenames.sql

SELECT
  'zip://https://download.companieshouse.gov.uk/' ||
  'BasicCompanyData-' || strftime('%Y-%m-01', date_trunc('month', current_date)) || '-part' || part || '_7.zip/' ||
  'BasicCompanyData-' || strftime('%Y-%m-01', date_trunc('month', current_date)) || '-part' || part || '_7.csv' AS filename
FROM generate_series(1, 7) AS t(part)
ORDER BY part;