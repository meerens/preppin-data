WITH  all_data as (

  SELECT * FROM preppindata.`2022w27_cbsco`
),

-- clean data, convert timestamp to date
-- aggregate sales by date (multiple orders/lines per date)
-- narrow table and only keep relevant columns


step_1 as (
  SELECT 
  EXTRACT(Date FROM Sale_Date) AS Sale_Date,
  SUM(CAST(Sale_Value AS Integer)) AS Sum_Sales
  FROM all_data
  GROUP BY Sale_Date
),

-- create a table with all the dates for 2022

step_2 as (
  SELECT * 
  FROM UNNEST(GENERATE_DATE_ARRAY('2022-01-01', '2022-12-31' , INTERVAL 1 DAY)) AS all_dates_2022
),

-- join the sales data onto the calendar table 
-- filtering out dates without a sale (Sum_Sales is NULL)
-- only keep required columns
-- and format the date to show the day of the week

step_3 as (
  SELECT 
  all_dates_2022 AS Date,
  FORMAT_DATE("%A", all_dates_2022) AS Day_Of_Week
  FROM step_2
    LEFT JOIN step_1
    ON all_dates_2022 = Sale_Date
  WHERE Sum_Sales IS NULL
)

-- aggregate the dates by day of week

SELECT Day_Of_Week,
COUNT(DISTINCT Date) AS Nr_Of_Days
FROM step_3
GROUP BY Day_Of_Week;