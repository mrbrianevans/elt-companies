WITH source_data AS (
    SELECT *
                     FROM
    read_csv('BasicCompanyData-2026-01-01-part1_7.csv', HEADER = true,
        -- the types of PreviousName_x.CONDATE are explicitly set to DATE since sniffing doesn't always get the right types (values are sparse in these columns)
        -- TODO: specify all the input columns with types here for completeness and consistency
            types = { 'PreviousName_1.CONDATE' : 'DATE',
            'PreviousName_2.CONDATE' : 'DATE',
            'PreviousName_3.CONDATE' : 'DATE',
            'PreviousName_4.CONDATE' : 'DATE',
            'PreviousName_5.CONDATE' : 'DATE',
            'PreviousName_6.CONDATE' : 'DATE',
            'PreviousName_7.CONDATE' : 'DATE',
            'PreviousName_8.CONDATE' : 'DATE',
            'PreviousName_9.CONDATE' : 'DATE',
            'PreviousName_10.CONDATE' : 'DATE' })
),
renamed AS (
    SELECT
        CompanyName as company_name, CompanyNumber as company_number, "RegAddress.CareOf" as address_care_of,
        "RegAddress.POBox" as address_po_box,
        "RegAddress.AddressLine1" as address_line_1, "RegAddress.AddressLine2" as address_line_2, "RegAddress.PostTown" as address_post_town,
        "RegAddress.County" as address_county, "RegAddress.Country" as address_country, "RegAddress.PostCode" as address_post_code,
        CompanyCategory as company_category, CompanyStatus as company_status, CountryOfOrigin as country_of_origin,
        DissolutionDate as dissolution_date, IncorporationDate as incorporation_date, "Accounts.AccountRefDay" as accounts_ref_day,
        "Accounts.AccountRefMonth" as accounts_ref_month, "Accounts.NextDueDate" as accounts_next_due_date, "Accounts.LastMadeUpDate" as accounts_last_made_up_date,
        "Accounts.AccountCategory" as accounts_last_category,
        "Returns.NextDueDate" as returns_next_due_date,
        "Returns.LastMadeUpDate" as returns_last_made_up_date,
        "Mortgages.NumMortCharges" as mortgages_number_of_charges, "Mortgages.NumMortOutstanding" as mortgages_number_outstanding,
        "Mortgages.NumMortPartSatisfied" as mortgages_number_part_satisfied,
        "Mortgages.NumMortSatisfied" as mortgages_number_satisfied,
        "SICCode.SicText_1" as sic_text_1, "SICCode.SicText_2" as sic_text_2, "SICCode.SicText_3" as sic_text_3, "SICCode.SicText_4" as sic_text_4,
        "LimitedPartnerships.NumGenPartners" as limited_partnerships_number_general_partners,
        "LimitedPartnerships.NumLimPartners" as limited_partnerships_number_limited_partners, URI as uri,
        "PreviousName_1.CONDATE" as previous_name_1_ceased_on_date, "PreviousName_1.CompanyName" as previous_name_1,
        "PreviousName_2.CONDATE" as previous_name_2_ceased_on_date, "PreviousName_2.CompanyName" as previous_name_2,
        "PreviousName_3.CONDATE" as previous_name_3_ceased_on_date, "PreviousName_3.CompanyName" as previous_name_3,
        "PreviousName_4.CONDATE" as previous_name_4_ceased_on_date, "PreviousName_4.CompanyName" as previous_name_4,
        "PreviousName_5.CONDATE" as previous_name_5_ceased_on_date, "PreviousName_5.CompanyName" as previous_name_5,
        "PreviousName_6.CONDATE" as previous_name_6_ceased_on_date, "PreviousName_6.CompanyName" as previous_name_6,
        "PreviousName_7.CONDATE" as previous_name_7_ceased_on_date, "PreviousName_7.CompanyName" as previous_name_7,
        "PreviousName_8.CONDATE" as previous_name_8_ceased_on_date, "PreviousName_8.CompanyName" as previous_name_8,
        "PreviousName_9.CONDATE" as previous_name_9_ceased_on_date, "PreviousName_9.CompanyName" as previous_name_9,
        "PreviousName_10.CONDATE" as previous_name_10_ceased_on_date, "PreviousName_10.CompanyName" as previous_name_10,
        ConfStmtNextDueDate as confirmation_statement_next_due_date,
        ConfStmtLastMadeUpDate as confirmation_statement_last_made_up_date
    FROM source_data
),
    cleaned AS (
        SELECT
            trim(company_name),
            lpad(upper(company_number), 9, '0'),
            address_care_of,address_po_box,address_line_1,address_line_2,address_post_town,address_county,address_country,
            address_post_code,
            lower(company_category),
            lower(company_status),
            country_of_origin,dissolution_date,incorporation_date,
            accounts_ref_day,accounts_ref_month,accounts_next_due_date,accounts_last_made_up_date,
            lower(accounts_last_category) as accounts_last_category,
            returns_next_due_date,returns_last_made_up_date,mortgages_number_of_charges,mortgages_number_outstanding,
            mortgages_number_part_satisfied,mortgages_number_satisfied,sic_text_1,sic_text_2,sic_text_3,sic_text_4,
            limited_partnerships_number_general_partners,limited_partnerships_number_limited_partners,uri,
            previous_name_1_ceased_on_date,previous_name_1,previous_name_2_ceased_on_date,previous_name_2,
            previous_name_3_ceased_on_date,previous_name_3,previous_name_4_ceased_on_date,previous_name_4,
            previous_name_5_ceased_on_date,previous_name_5,previous_name_6_ceased_on_date,previous_name_6,
            previous_name_7_ceased_on_date,previous_name_7,previous_name_8_ceased_on_date,previous_name_8,
            previous_name_9_ceased_on_date,previous_name_9,previous_name_10_ceased_on_date,previous_name_10,
            confirmation_statement_next_due_date,confirmation_statement_last_made_up_date
        FROM renamed
    ),
structured_fields as (
    SELECT company_name,company_number,

        struct_pack(care_of := address_care_of, po_box := address_po_box, address_line_1 := address_line_1,
            address_line_2 := address_line_2, post_town := address_post_town, county := address_county,
            country := address_country, post_code := address_post_code
        ) as address,

        company_category,company_status,country_of_origin,dissolution_date,incorporation_date,

        struct_pack(ard := struct_pack(ref_day := accounts_ref_day, ref_month := accounts_ref_month),
        next_due_date := accounts_next_due_date, last_made_up_date := accounts_last_made_up_date,
        last_category := accounts_last_category) as accounts,

--         I think these fields are obsolete (Annual Return replaced by confirmation statement in 2016)
--         returns_next_due_date,returns_last_made_up_date,

        struct_pack(charges := mortgages_number_of_charges, outstanding := mortgages_number_outstanding,
        part_satisfied := mortgages_number_part_satisfied, satisfied := mortgages_number_satisfied) as mortgages,


        filter(list_value(sic_text_1,sic_text_2,sic_text_3,sic_text_4), lambda x : x IS NOT NULL) as sic_codes,
        struct_pack(general_partners := limited_partnerships_number_general_partners,
                    limited_partners := limited_partnerships_number_limited_partners) as limited_partnerships,
-- uri doesn't add any info. it's just company number after a standard url
        --         uri,

        filter([
            { 'name': previous_name_1, 'ceased_on': previous_name_1_ceased_on_date },
            { 'name': previous_name_2, 'ceased_on': previous_name_2_ceased_on_date },
            { 'name': previous_name_3, 'ceased_on': previous_name_3_ceased_on_date },
            { 'name': previous_name_4, 'ceased_on': previous_name_4_ceased_on_date },
            { 'name': previous_name_5, 'ceased_on': previous_name_5_ceased_on_date },
            { 'name': previous_name_6, 'ceased_on': previous_name_6_ceased_on_date },
            { 'name': previous_name_7, 'ceased_on': previous_name_7_ceased_on_date },
            { 'name': previous_name_8, 'ceased_on': previous_name_8_ceased_on_date },
            { 'name': previous_name_9, 'ceased_on': previous_name_9_ceased_on_date },
            { 'name': previous_name_10, 'ceased_on': previous_name_10_ceased_on_date },
        ], lambda x : x['name'] IS NOT NULL) as previous_names,

        struct_pack(next_due_date := confirmation_statement_next_due_date,
        last_made_up_date := confirmation_statement_last_made_up_date) as confirmation_statement
    FROM cleaned
)
SELECT *
FROM renamed LIMIT 1;

-- process:
 -- load source data "as-is" into duckdb table
 -- transform and insert into a ducklake
 -- have an orchestration file that duckdb can run which reads in the steps in the correct order