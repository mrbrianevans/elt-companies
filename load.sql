INSTALL httpfs;
LOAD httpfs;
INSTALL zipfs
FROM
  community;
LOAD zipfs;

.timer on

-- directly loads remote zipped csv into a table with no data transformation yet.
CREATE
OR REPLACE TABLE companies_raw AS
SELECT
    *
FROM
    read_csv_auto(
        -- construct most recent filename based on current date (first day of month)
            'zip://https://download.companieshouse.gov.uk/BasicCompanyDataAsOneFile-' || strftime('%Y-%m-01',date_trunc('month', current_date))|| '.zip/BasicCompanyDataAsOneFile-' || strftime('%Y-%m-01',date_trunc('month', current_date))|| '.csv',
            HEADER = true,
        -- the types of PreviousName_x.CONDATE are explicitly set to DATE since sniffing doesn't always get the right types (values are sparse in these columns)
            types = { 'PreviousName_1.CONDATE' : 'DATE',
            'PreviousName_2.CONDATE' : 'DATE',
            'PreviousName_3.CONDATE' : 'DATE',
            'PreviousName_4.CONDATE' : 'DATE',
            'PreviousName_5.CONDATE' : 'DATE',
            'PreviousName_6.CONDATE' : 'DATE',
            'PreviousName_7.CONDATE' : 'DATE',
            'PreviousName_8.CONDATE' : 'DATE',
            'PreviousName_9.CONDATE' : 'DATE',
            'PreviousName_10.CONDATE' : 'DATE' }
  );
