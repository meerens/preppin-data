-- check my count canvas for more details
-- https://count.co/report/QaHHzaFd5ME?frame=vVEIw4gDoJm

WITH
  union_tables AS (
    -- bringing all the tables together
    SELECT
      *,
      'mock_data' AS file_name
    FROM
      preppindata.`2023w8_mock_data`
    UNION ALL
    SELECT
      *,
      'mock_data_2'
    FROM
      preppindata.`2023w8_mock_data_2`
    UNION ALL
    SELECT
      *,
      'mock_data_3'
    FROM
      preppindata.`2023w8_mock_data_3`
    UNION ALL
    SELECT
      *,
      'mock_data_4'
    FROM
      preppindata.`2023w8_mock_data_4`
    UNION ALL
    SELECT
      *,
      'mock_data_5'
    FROM
      preppindata.`2023w8_mock_data_5`
    UNION ALL
    SELECT
      *,
      'mock_data_6'
    FROM
      preppindata.`2023w8_mock_data_6`
    UNION ALL
    SELECT
      *,
      'mock_data_7'
    FROM
      preppindata.`2023w8_mock_data_7`
    UNION ALL
    SELECT
      *,
      'mock_data_8'
    FROM
      preppindata.`2023w8_mock_data_8`
    UNION ALL
    SELECT
      *,
      'mock_data_9'
    FROM
      preppindata.`2023w8_mock_data_9`
    UNION ALL
    SELECT
      *,
      'mock_data_10'
    FROM
      preppindata.`2023w8_mock_data_10`
    UNION ALL
    SELECT
      *,
      'mock_data_11'
    FROM
      preppindata.`2023w8_mock_data_11`
    UNION ALL
    SELECT
      *,
      'mock_data_12'
    FROM
      preppindata.`2023w8_mock_data_12`
  ),
  creating_file_month AS (
    -- splitting off the month value from the file name so we can create the file date in the next step
    SELECT
      *,
      IF (
        SPLIT(file_name, '_') [SAFE_ORDINAL(3)] IS NULL,
        '1',
        SPLIT(file_name, '_') [SAFE_ORDINAL(3)]
      ) AS file_month
    FROM
      union_tables
  ),
  creating_file_date AS (
    -- creating file date string and converting it to an actual date
    SELECT
      *,
      CASE
        WHEN CAST(file_month AS INT) > 9 THEN PARSE_DATE('%d/%m/%Y', CONCAT('01/', file_month, '/2023'))
        ELSE PARSE_DATE('%d/%m/%Y', CONCAT('01/0', file_month, '/2023'))
      END AS file_date
    FROM
      creating_file_month
  ),
  cleaning_up_market_cap AS (
    -- removing the records where the market cap value is n/a
    -- converting strings so we can create the groups in the next step
    SELECT
      id,
      first_name,
      last_name,
      Ticker,
      Sector,
      Market,
      Stock_Name,
      Market_Cap,
      CASE
        WHEN RIGHT(Market_Cap, 1) = 'M' THEN CAST(RTRIM(LTRIM(Market_Cap, '$'), 'M') AS DECIMAL) * 1000000
        WHEN RIGHT(Market_Cap, 1) = 'B' THEN CAST(RTRIM(LTRIM(Market_Cap, '$'), 'B') AS DECIMAL) * 1000000000
        ELSE CAST(LTRIM(Market_Cap, '$') AS DECIMAL)
      END AS Market_Cap_New,
      CAST(Purchase_Price AS DECIMAL) AS Purchase_Price,
      file_date
    FROM
      creating_file_date
    WHERE
      Market_Cap != "n/a"
  ),
  creating_categories AS (
    -- creating groups for market cap & purchase price ↑ 
    SELECT
      *,
      CASE
        WHEN Market_Cap_New < 100000000 THEN "Small"
        WHEN Market_Cap_New BETWEEN 100000000 AND 1000000000 THEN "Medium"
        WHEN Market_Cap_New BETWEEN 1000000000 AND 100000000000 THEN "Large"
        WHEN Market_Cap_New >= 100000000000 THEN "Huge"
        ELSE "Woops"
      END AS Market_Cap_Category,
      CASE
        WHEN Purchase_Price BETWEEN 0 AND 24999.99 THEN "Low"
        WHEN Purchase_Price BETWEEN 25000 AND 49999.99 THEN "Medium"
        WHEN Purchase_Price BETWEEN 50000 AND 74999.99 THEN "High"
        WHEN Purchase_Price BETWEEN 75000 AND 100000 THEN "Very High"
        ELSE "Woops"
      END AS Purchase_Price_Category
    FROM
      cleaning_up_market_cap
  ),
  ranking_purchases AS (
    -- add ranking
    -- rank the highest 5 purchases per combination of: file date, purchase price category and market capitalisation category
    SELECT
      *,
      RANK () OVER (
        PARTITION BY
          file_date,
          Market_Cap_Category,
          Purchase_Price_Category
        ORDER BY
          Purchase_Price DESC
      ) AS ranking
    FROM
      creating_categories
  )
SELECT
  Market_Cap_Category,
  Purchase_Price_Category,
  file_date AS File_Date,
  Ticker,
  Sector,
  Market,
  Stock_Name,
  Market_Cap_New AS Market_Capitalisation,
  Purchase_Price,
  Ranking
FROM
  ranking_purchases
WHERE
  ranking < 6