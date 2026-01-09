INSTALL httpfs;
LOAD httpfs;
INSTALL zipfs
FROM
  community;
LOAD zipfs;

CREATE SCHEMA IF NOT EXISTS charity_raw;
USE charity_raw;

.timer on

CREATE OR REPLACE TABLE charity_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity.zip/publicextract.charity.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_raw"

CREATE OR REPLACE TABLE charity_annual_return_history_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_annual_return_history.zip/publicextract.charity_annual_return_history.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_annual_return_history_raw"

CREATE OR REPLACE TABLE charity_annual_return_parta_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_annual_return_parta.zip/publicextract.charity_annual_return_parta.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_annual_return_parta_raw"

CREATE OR REPLACE TABLE charity_annual_return_partb_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_annual_return_partb.zip/publicextract.charity_annual_return_partb.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_annual_return_partb_raw"

CREATE OR REPLACE TABLE charity_area_of_operation_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_area_of_operation.zip/publicextract.charity_area_of_operation.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_area_of_operation_raw"

CREATE OR REPLACE TABLE charity_classification_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_classification.zip/publicextract.charity_classification.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_classification_raw"

CREATE OR REPLACE TABLE charity_event_history_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_event_history.zip/publicextract.charity_event_history.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_event_history_raw"

CREATE OR REPLACE TABLE charity_governing_document_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_governing_document.zip/publicextract.charity_governing_document.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_governing_document_raw"

CREATE OR REPLACE TABLE charity_other_names_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_other_names.zip/publicextract.charity_other_names.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_other_names_raw"

CREATE OR REPLACE TABLE charity_other_regulators_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_other_regulators.zip/publicextract.charity_other_regulators.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_other_regulators_raw"

CREATE OR REPLACE TABLE charity_policy_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_policy.zip/publicextract.charity_policy.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_policy_raw"

CREATE OR REPLACE TABLE charity_published_report_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_published_report.zip/publicextract.charity_published_report.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_published_report_raw"

CREATE OR REPLACE TABLE charity_trustee_raw AS (
    SELECT * FROM read_json(
        'zip://https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_trustee.zip/publicextract.charity_trustee.json',
        format = 'array', maximum_object_size = 4294967295
    )
);
.print "Loaded charity_trustee_raw"

.print "All charity raw tables loaded successfully"

-- this improves query performance during the transformation phase since everything references this
ALTER TABLE charity_raw ADD PRIMARY KEY(organisation_number);
.print "Created primary key on charity_raw table"
