-- "build" the first and last date value for the date array
-- extract the year from the date, convert it to a string 
-- concat the other parts to create a string date
WITH step_1 AS (
  SELECT
  CONCAT(CAST(EXTRACT(year FROM MIN(scheduled_date)) AS STRING),"-","01","-","01") AS first_date,
  CONCAT(CAST(EXTRACT(year FROM MAX(scheduled_date)) AS STRING),"-","12","-","31") AS last_date,
  FROM preppindata.`2022w36_employee_calendar`),

-- parse the string dates and create the date array
step_2 AS (
  SELECT
  GENERATE_DATE_ARRAY(PARSE_DATE("%F",first_date), PARSE_DATE("%F", last_date), INTERVAL 1 DAY) AS Date_Array 
  FROM step_1),

-- flatten the date array
step_3 AS (
  SELECT 
  Dates
  FROM step_2 AS t 
  CROSS JOIN UNNEST(t.Date_Array) AS Dates),

-- create a unique list of the employees
step_4 AS (
  SELECT
  CONCAT(first_name," ", last_name) AS full_name,
  first_name,
  last_name,
  emp_id
  FROM preppindata.`2022w36_employee_calendar`
  GROUP BY full_name, first_name, last_name, emp_id),

-- create a new table where every employee has a record for all the dates from the date table
step_5 AS (
  SELECT * 
  FROM step_3 -- dates
  CROSS JOIN step_4 ), -- employees

-- bringing it all together
step_6 AS (
  SELECT 
  d.Dates AS date,
  c.scheduled_date,
  d.full_name,
  d.first_name, 
  d.last_name,
  d.emp_id
  FROM step_5 AS d -- date array table
    LEFT JOIN preppindata.`2022w36_employee_calendar` AS c -- employee calendar table
    ON d.emp_id = c.emp_id AND d.Dates = c.scheduled_date
  ORDER BY date ASC)

-- final output
SELECT
date AS schedule_date,
emp_id,
full_name,
first_name,
last_name,
IF(scheduled_date IS NULL, "false","true") AS scheduled
FROM step_6
ORDER BY date ASC;