-- destination schema of transformed data
CREATE SCHEMA charity_mart;


USE charity_raw;
-- TODO: add joins for other source tables to enrich this view


CREATE
OR REPLACE VIEW charity_mart.charities AS
SELECT date_of_extract::DATE AS date_of_extract,
    organisation_number::UINTEGER AS organisation_number,
    registered_charity_number::UINTEGER AS registered_charity_number,

    (SELECT COUNT(*)
     FROM charity_raw cr
     WHERE cr.registered_charity_number = charity_raw.registered_charity_number) AS number_of_linked_charities,
       charity_name,
       charity_type,
       CASE
           WHEN charity_registration_status = 'Removed' THEN TRUE
           ELSE FALSE
           END AS removed,
       date_of_registration::DATE AS date_of_registration,
    date_of_removal::DATE AS date_of_removal,
    charity_reporting_status AS reporting_status,
       latest_acc_fin_period_start_date::DATE AS latest_acc_fin_period_start_date,
    latest_acc_fin_period_end_date::DATE AS latest_acc_fin_period_end_date,
    latest_income::DECIMAL(18, 2) AS latest_income,
    latest_expenditure::DECIMAL(18, 2) AS latest_expenditure,
    CAST(ROW(charity_contact_address1, charity_contact_address2, charity_contact_address3, charity_contact_address4, charity_contact_address5, charity_contact_postcode) AS STRUCT (line1 VARCHAR, line2 VARCHAR, line3 VARCHAR, line4 VARCHAR, line5 VARCHAR, postcode VARCHAR)) AS address,
       charity_contact_phone AS contact_phone,
       charity_contact_email AS contact_email,
       charity_contact_web AS website_url,
       LPAD(charity_company_registration_number::VARCHAR, 8, '0') AS company_registration_number,
       charity_insolvent AS insolvent,
       charity_in_administration AS in_administration,
       charity_previously_excepted AS previously_excepted,
       charity_is_cdf_or_cif AS is_cdf_or_cif,
       charity_is_cio AS is_cio,
       cio_is_dissolved::BOOLEAN AS cio_is_dissolved,
    date_cio_dissolution_notice,
       charity_activities,
       charity_gift_aid,
       charity_has_land
FROM charity_raw
WHERE linked_charity_number = 0 ;