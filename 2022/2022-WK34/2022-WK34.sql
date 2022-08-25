-- cleaning up values and units
-- splitting up the spin_class column
-- capitalize music type
WITH step_1 AS (
  SELECT
  Date,
  Value,
  CASE WHEN Units = "km" THEN "min" ELSE "min" END AS Mins,
  Type,
  TRIM(SPLIT(Spin_Class,"-") [ORDINAL(1)]) AS Coach,
  TRIM(SPLIT(Spin_Class,"-") [ORDINAL(2)]) AS Calories,
  INITCAP(TRIM(SPLIT(Spin_Class,"-") [ORDINAL(3)])) AS Music_Type,
  FROM preppindata.`2022w34_cycling`
),

-- rank coaches & music types by calories
step_2 AS (
  SELECT *,
  DENSE_RANK() OVER (PARTITION BY Coach ORDER BY Calories DESC) AS Calorie_Rank,
  DENSE_RANK() OVER (PARTITION BY Music_Type ORDER BY Calories DESC) AS Music_Type_Rank
  FROM step_1
)

-- the top n tables run off the same cell (step_2) in the count sql notebook
-- when running the compiled sql in the IDE you need run step 1, 2 to for every table seperately
-- table for top n coach
SELECT 
Calorie_Rank,
Coach,
Calories,
Music_Type,
Date,
Mins
FROM step_2;

-- table for top n music type
SELECT 
Music_Type_Rank,
Coach,
Calories,
Music_Type,
Date,
Mins
FROM step_2;
