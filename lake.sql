INSTALL ducklake;
LOAD ducklake;

ATTACH 'ducklake:metadata.ducklake' AS company_lake (DATA_PATH 'ducklake_files');

.timer on

CREATE TABLE company_lake.companies AS (SELECT * FROM companies);

