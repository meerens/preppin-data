-- creating a date field for today (8th Aug 2022)
-- creating a field for monthly capital payments
-- creating a field for the # of months left before all the capital is paid off
WITH step_1 as (
  SELECT
  Store,
  Capital_Repayment_Remaining,
  (__of_Monthly_Repayment_going_to_Capital * Monthly_Payment) / 100 AS Monthly_Capital_Payment,
  CAST(ROUND(
    Capital_Repayment_Remaining / ((__of_Monthly_Repayment_going_to_Capital * Monthly_Payment) / 100) -1) AS INT64) 
    AS Months_To_Pay_Off, 
    -- ^^
    -- cast to INT64 to use as interval in date_add
    -- -1 because 'first' payment on start_date
  Capital_Repayment_Remaining - ((__of_Monthly_Repayment_going_to_Capital * Monthly_Payment) / 100) AS Starting_Balance,
  PARSE_DATE("%F", "2022-08-10") AS Start_Date,
  FROM preppindata.`2022w32_mortgage`
  ),

-- creating an array for the payment dates 
step_2 as (
  SELECT
  Store,
  GENERATE_DATE_ARRAY(Start_Date, DATE_ADD(Start_Date, INTERVAL Months_To_Pay_Off MONTH), INTERVAL 1 MONTH) AS Payment_Array,
  FROM step_1
  ),

-- flattening the array for the payment dates
-- adding a row index which to use when joining other tables
 step_3 as (
  SELECT *,
  ROW_NUMBER() OVER(PARTITION BY Store ORDER BY Payment_Dates ASC) AS Row_Index
  FROM step_2 AS t
  CROSS JOIN UNNEST(t.Payment_Array) AS Payment_Dates
  ),

-- creating array for capital balance values
step_4 as (
  SELECT
  Store,
  GENERATE_ARRAY(Starting_Balance, -200, - Monthly_Capital_Payment) Values_Array
  FROM step_1
  ),

-- flattening the array for the capital balance values
-- adding a row index which to use when joining other tables
step_5 as (
  SELECT *,
  ROW_NUMBER() OVER(PARTITION BY Store ORDER BY Values_Arr DESC ) AS Row_Index
  FROM step_4 AS t
  CROSS JOIN UNNEST(t.Values_Array) AS Values_Arr
  ),

-- creating a table for the total capital balance
step_6 as (
  SELECT
  Row_Index,
  SUM(Values_Arr) AS Total_Values
  FROM step_5
  GROUP BY Row_Index
  )

-- bringing it all together
SELECT
d.Payment_Dates AS Monthly_Payment_Date,
d.Store,
t.Total_Values AS Capital_Outstanding_Total,
b.Values_Arr AS Remaining_Capital_To_Pay
FROM step_3 AS d -- dates
  LEFT JOIN step_5 AS b -- balance/values
  ON d.Row_Index = b.Row_Index AND d.Store = b.Store
  LEFT JOIN step_6 AS t -- total balance
  ON d.Row_Index = t.Row_Index;