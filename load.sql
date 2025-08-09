INSTALL httpfs;
LOAD httpfs;
INSTALL zipfs FROM community;
LOAD zipfs;

CREATE OR REPLACE TABLE companies_raw AS
SELECT *
FROM read_csv_auto(
    -- get file names from list_filenames.sql by running `duckdb -noheader -quote -f list_filenames.sql`
    ['zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part1_7.zip/BasicCompanyData-2025-08-01-part1_7.csv', 'zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part2_7.zip/BasicCompanyData-2025-08-01-part2_7.csv', 'zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part3_7.zip/BasicCompanyData-2025-08-01-part3_7.csv', 'zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part4_7.zip/BasicCompanyData-2025-08-01-part4_7.csv', 'zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part5_7.zip/BasicCompanyData-2025-08-01-part5_7.csv', 'zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part6_7.zip/BasicCompanyData-2025-08-01-part6_7.csv', 'zip://https://download.companieshouse.gov.uk/BasicCompanyData-2025-08-01-part7_7.zip/BasicCompanyData-2025-08-01-part7_7.csv']
    , HEADER = true,
types = {'PreviousName_1.CONDATE': 'DATE','PreviousName_2.CONDATE': 'DATE','PreviousName_3.CONDATE': 'DATE','PreviousName_4.CONDATE': 'DATE',
'PreviousName_5.CONDATE': 'DATE','PreviousName_6.CONDATE': 'DATE','PreviousName_7.CONDATE': 'DATE','PreviousName_8.CONDATE': 'DATE','PreviousName_9.CONDATE': 'DATE',
'PreviousName_10.CONDATE': 'DATE'});
