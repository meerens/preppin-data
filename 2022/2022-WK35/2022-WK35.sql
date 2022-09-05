-- cleaning up values and units, splitting up the spin_class column, convert date to year
WITH step_1 AS (
  SELECT
  EXTRACT (year FROM date) AS Years,
  Value,
  CASE WHEN Units = "km" THEN "min" ELSE "min" END AS Mins,
  Type,
  TRIM(SPLIT(Spin_Class,"-") [ORDINAL(1)]) AS Coach,
  CAST(TRIM(SPLIT(Spin_Class,"-") [ORDINAL(2)]) AS INT) AS Calories,
  INITCAP(TRIM(SPLIT(Spin_Class,"-") [ORDINAL(3)])) AS Music_Type,
  FROM preppindata.`2022w34_cycling`
  WHERE EXTRACT (year FROM date) IN (2021,2022)
),

-- top level aggregations, converting all columns to strings for unpivot/pivot
step_2 AS (
  SELECT 
  Years,
  CAST(SUM(Value) AS STRING) AS Total_Mins,
  CAST(SUM(Calories) AS STRING) AS Total_Calories,
  CAST(COUNT(*) AS STRING) AS Total_Rides,
  CAST((SUM(Value) / 60) * 30 AS STRING)  AS Total_Distance, -- 30 = 'parameter' value
  CAST(ROUND(SUM(Calories) / COUNT(*),1) AS STRING) AS Avg_Calories_Per_Ride,
  CAST(ROUND(AVG(Calories / Value),1) AS STRING) AS Avg_Calories_Per_Minute
  FROM step_1
GROUP BY years),

-- top level aggregations: columns to rows
step_3 AS (
  SELECT
  Years,
  Values,
  Measure
  FROM step_2
  UNPIVOT(Values FOR Measure IN (Total_Mins, Total_Calories, Total_Rides, Total_Distance, Avg_Calories_Per_Ride, Avg_Calories_Per_Minute))),

-- aggregations at the coach level
step_4 AS (
  SELECT 
  Years,
  Coach,
  SUM(Value) AS Total_Mins,
  SUM(Calories) AS Total_Cals,
  ROUND(AVG(Calories/Value),1) AS Cals_Mins,
  ROW_NUMBER() OVER (PARTITION BY Years ORDER BY SUM(Value) DESC) AS Ranking_Cals,
  ROW_NUMBER() OVER (PARTITION BY Years ORDER BY AVG(Calories/Value) DESC) AS Ranking_Cals_Mins
  FROM step_1
  GROUP BY Years, Coach),

-- best coach by number of calories per minute
step_5 AS (
  SELECT
  Years,
  CONCAT(Coach," (", Cals_Mins, ")") AS Values,
  "Best_Coach_Cals_Mins" AS Measure
  FROM step_4
  WHERE ranking_cals_mins = 1),
 
-- best coach by number of minutes
step_6 AS ( 
  SELECT
  Years,
  CONCAT(Coach," (", Total_Mins, ")") AS Values,
  "Best_Coach_Mins" AS Measure
  FROM step_4
  WHERE ranking_cals = 1),

-- bringing together all the measures
step_7 AS (
  SELECT * FROM step_3
  UNION ALL
  SELECT * FROM step_5
  UNION ALL
  SELECT * FROM step_6)

-- final output
-- years: rows to columns
SELECT * FROM step_7
PIVOT (MIN(Values) FOR Years IN (2022,2021));