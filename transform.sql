
CREATE OR REPLACE VIEW companies AS
SELECT TRIM("CompanyName")                                               AS company_name,
       "CompanyNumber"                                                   AS company_number,
       TRIM("RegAddress.CareOf")                                         AS reg_address_care_of,
       TRIM("RegAddress.POBox")                                          AS reg_address_po_box,
       TRIM("RegAddress.AddressLine1")                                   AS reg_address_line1,
       TRIM("RegAddress.AddressLine2")                                   AS reg_address_line2,
       TRIM("RegAddress.PostTown")                                       AS reg_address_post_town,
       TRIM("RegAddress.County")                                         AS reg_address_county,
       TRIM("RegAddress.Country")                                        AS reg_address_country,
       TRIM("RegAddress.PostCode")                                       AS reg_address_post_code,
       CASE "CompanyCategory"
           WHEN 'Private Limited Company' THEN 'ltd'
           WHEN 'Public Limited Company' THEN 'plc'
           WHEN 'Limited Liability Partnership' THEN 'llp'
           WHEN 'Limited Partnership' THEN 'limited-partnership'
           WHEN 'Private Unlimited Company' THEN 'private-unlimited'
           WHEN 'Private Company Limited By Guarantee without Share Capital' THEN 'private-limited-guarant-nsc'
           WHEN 'PRI/LTD BY GUAR/NSC (Private, limited by guarantee, no share capital)' THEN 'private-limited-guarant-nsc'
           ELSE LOWER(REGEXP_REPLACE("CompanyCategory", '[^a-z0-9A-Z]+', '-', 'g')) END          AS company_category,
       CASE TRIM(SPLIT_PART("CompanyStatus", '-', 1))
           WHEN 'Active' THEN 'active'
           WHEN 'Dissolved' THEN 'dissolved'
           WHEN 'Liquidation' THEN 'liquidation'
           WHEN 'Receivership' THEN 'receivership'
           WHEN 'Administration' THEN 'administration'
           WHEN 'Voluntary Arrangement' THEN 'voluntary-arrangement'
           WHEN 'Insolvency Proceedings' THEN 'insolvency-proceedings'
           WHEN 'Converted / Closed' THEN 'converted-closed'
           ELSE LOWER(REPLACE(TRIM(SPLIT_PART("CompanyStatus", '-', 1)), ' ', '-')) END            AS company_status,
       NULLIF(LOWER(REPLACE(TRIM(SPLIT_PART("CompanyStatus", '-', 2)), ' ', '-')), '')            AS status_detail,
       TRIM("CountryOfOrigin")                                           AS country_of_origin,
       "DissolutionDate"                                                AS dissolution_date,
       "IncorporationDate"                                             AS incorporation_date,
       "Accounts.AccountRefDay"::INTEGER AS accounts_ref_day, "Accounts.AccountRefMonth"::INTEGER AS accounts_ref_month, "Accounts.NextDueDate" AS accounts_next_due_date,
       "Accounts.LastMadeUpDate"                                       AS accounts_last_made_up_date,
       CASE UPPER("Accounts.AccountCategory")
           WHEN 'TOTAL EXEMPTION FULL' THEN 'total-exemption-full'
           WHEN 'MICRO-ENTITY' THEN 'micro-entity'
           WHEN 'SMALL' THEN 'small'
           WHEN 'MEDIUM' THEN 'medium'
           WHEN 'GROUP' THEN 'group'
           WHEN 'DORMANT' THEN 'dormant'
           WHEN 'FULL' THEN 'full'
           WHEN 'AUDIT EXEMPTION SUBSIDIARY' THEN 'audit-exemption-subsidiary'
           WHEN 'UNAUDITED ABRIDGED' THEN 'unaudited-abridged'
           ELSE LOWER(REPLACE("Accounts.AccountCategory", ' ', '-')) END AS accounts_category,
       "Returns.NextDueDate"                                            AS returns_next_due_date,
       "Returns.LastMadeUpDate"                                         AS returns_last_made_up_date,
       "Mortgages.NumMortCharges"::INTEGER AS mortgages_num_charges,
       "Mortgages.NumMortOutstanding"::INTEGER AS mortgages_num_outstanding,
       "Mortgages.NumMortPartSatisfied"::INTEGER AS mortgages_num_part_satisfied,
       "Mortgages.NumMortSatisfied"::INTEGER AS mortgages_num_satisfied,

       list_filter(
         list_value(
           CASE WHEN "SICCode.SicText_1" IS NULL OR UPPER("SICCode.SicText_1") = 'NONE SUPPLIED' OR TRIM("SICCode.SicText_1") = '' THEN NULL ELSE
             struct_pack(code := LEFT("SICCode.SicText_1", 5)::INTEGER, description := NULLIF(TRIM(SUBSTR("SICCode.SicText_1", 9)), ''))
           END,
           CASE WHEN "SICCode.SicText_2" IS NULL OR UPPER("SICCode.SicText_2") = 'NONE SUPPLIED' OR TRIM("SICCode.SicText_2") = '' THEN NULL ELSE
             struct_pack(code := LEFT("SICCode.SicText_2", 5)::INTEGER, description := NULLIF(TRIM(SUBSTR("SICCode.SicText_2", 9)), ''))
           END,
           CASE WHEN "SICCode.SicText_3" IS NULL OR UPPER("SICCode.SicText_3") = 'NONE SUPPLIED' OR TRIM("SICCode.SicText_3") = '' THEN NULL ELSE
             struct_pack(code := LEFT("SICCode.SicText_3", 5)::INTEGER, description := NULLIF(TRIM(SUBSTR("SICCode.SicText_3", 9)), ''))
           END,
           CASE WHEN "SICCode.SicText_4" IS NULL OR UPPER("SICCode.SicText_4") = 'NONE SUPPLIED' OR TRIM("SICCode.SicText_4") = '' THEN NULL ELSE
             struct_pack(code := LEFT("SICCode.SicText_4", 5)::INTEGER, description := NULLIF(TRIM(SUBSTR("SICCode.SicText_4", 9)), ''))
           END
         ),
         x -> x IS NOT NULL AND x.description IS NOT NULL
       ) AS sic_codes,
  "LimitedPartnerships.NumGenPartners"::INTEGER AS limited_partnerships_num_gen_partners,
  "LimitedPartnerships.NumLimPartners"::INTEGER AS limited_partnerships_num_lim_partners,

  list_filter(
    list_value(
      struct_pack(company_name := NULLIF(TRIM("PreviousName_1.CompanyName"), ''), ceased_on_date := "PreviousName_1.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_2.CompanyName"), ''), ceased_on_date := "PreviousName_2.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_3.CompanyName"), ''), ceased_on_date := "PreviousName_3.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_4.CompanyName"), ''), ceased_on_date := "PreviousName_4.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_5.CompanyName"), ''), ceased_on_date := "PreviousName_5.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_6.CompanyName"), ''), ceased_on_date := "PreviousName_6.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_7.CompanyName"), ''), ceased_on_date := "PreviousName_7.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_8.CompanyName"), ''), ceased_on_date := "PreviousName_8.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_9.CompanyName"), ''), ceased_on_date := "PreviousName_9.CONDATE"::DATE),
      struct_pack(company_name := NULLIF(TRIM("PreviousName_10.CompanyName"), ''), ceased_on_date := "PreviousName_10.CONDATE"::DATE)
    ),
    x -> x.company_name IS NOT NULL
  ) AS previous_names,
  "ConfStmtNextDueDate" AS conf_stmt_next_due_date,
  "ConfStmtLastMadeUpDate" AS conf_stmt_last_made_up_date
FROM companies_raw;