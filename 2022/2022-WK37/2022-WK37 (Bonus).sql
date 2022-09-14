-- create the base table
-- flip measure values from columns to rows
WITH step_b1 AS (
  SELECT 
  Name,
  Category,
  Values,
  Measure 
  FROM preppindata.`2022w37_elden_ring_combat`
  UNPIVOT (Values FOR Measure IN (Phy, Mag, Fire, Ligh, Holy,Str, Dex, Int, Fai, Arc))),

-- create a new dimension to seperate the damage stats from the level requirement measures
step_b2 AS (
  SELECT
  Name,
  Category,
  Values,
  CASE 
    WHEN Measure IN ("Phy", "Mag", "Fire", "Ligh", "Holy") THEN "Damage"
    WHEN Measure IN ("Str", "Dex", "Int", "Fai", "Arc") THEN "Level"
  END AS Measure_Category
  FROM step_b1),

-- splitting the values, replace - by 0 and then convert strings to an integer
-- we only need the first value from the 'array' for both the damage and level measures
step_b3 AS (
  SELECT
  Name,
  Category,
  Measure_Category,
  CAST(REPLACE(SPLIT(Values, " ") [ORDINAL(1)],"-","0") AS INT) AS First_Value,
  FROM step_b2),

-- calculating the damage and level total scores per weapon (name)
step_b4 AS (
  SELECT
  Name,
  Category,
  SUM(CASE WHEN Measure_Category = "Damage" THEN First_Value END) AS Damage_Total,
  SUM(CASE WHEN Measure_Category = "Level" THEN First_Value END) AS Level_Total
  FROM step_b3
  GROUP BY Name, Category),

-- ranking the weapons by total damage grouped by total required
step_b5 AS (
  SELECT
  Name,
  Category, 
  Damage_Total,
  Level_Total,
  DENSE_RANK() OVER(PARTITION BY Level_Total ORDER BY Damage_Total DESC) AS Damage_Ranking
  FROM step_b4)

-- filter for records where the ranking is 1
SELECT
Name,
Category,
Level_Total AS Required_Level,
Damage_Total AS Attack_Damage
FROM step_b5
WHERE Damage_Ranking = 1;