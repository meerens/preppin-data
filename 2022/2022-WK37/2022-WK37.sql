-- create damage stats table 
-- and flip measure values from columns to rows
WITH step_1 AS (
  SELECT 
  Name,
  Category,
  Values,
  Measure 
  FROM preppindata.`2022w37_elden_ring_combat`
  UNPIVOT (Values FOR Measure IN (Phy, Mag, Fire, Ligh, Holy))),

-- create level requirements table 
-- and flip measure values from columns to rows
step_2 AS (
  SELECT 
  Name,
  Category,
  Values,
  Measure 
  FROM preppindata.`2022w37_elden_ring_combat`
  UNPIVOT (Values FOR Measure IN (Str, Dex, Int, Fai, Arc))),

-- split values in damage stats table to create new columns
step_3 AS (
  SELECT
  Name,
  Category,
  SPLIT(Values, " ") [ORDINAL(1)] AS Attack_Damage,
  SPLIT(Values, " ") [ORDINAL(2)] AS Damage_Resistance,
  Measure
  FROM step_1),

-- split values in level requirements table to create new columns
step_4 AS (
  SELECT
  Name,
  Category,
  SPLIT(Values, " ") [ORDINAL(1)] AS Required_Level,
  SPLIT(Values, " ") [ORDINAL(2)] AS Attribute_Scaling,
  Measure
  FROM step_2),

-- cleaning up values in the damage stats table ---------------------------------------------
step_5 AS (
  SELECT
  Name,
  Category,
  CAST(REPLACE(Attack_Damage,"-","0") AS INT) AS Attack_Damage,
  CAST(REPLACE(Damage_Resistance,"-","0") AS INT) AS Damage_Resistance,
  Measure
  FROM step_3),

-- cleaning up values in the level requirements table 
step_6 AS (
  SELECT 
  Name,
  Category,
  CAST(REPLACE(Required_Level,"-","0") AS INT) AS Required_Level,
  Measure
  FROM step_4),

-- calculating the total damage by weapon (name)
step_7 AS (
  SELECT
  Name,
  Category,
  SUM(Attack_Damage) AS Total_Damage
  FROM step_5
  GROUP BY Name, Category),

-- calculating the total required by weapon (name)
step_8 AS (
  SELECT 
  Name,
  Category,
  SUM(Required_Level) AS Total_Required
  FROM step_6
  GROUP BY Name, Category),

-- bringing the aggregates together
step_9 AS (
  SELECT
  d.Name,
  d.Category,
  d.Total_Damage,
  l.Total_Required
  FROM step_7 AS d -- damage stats
    JOIN step_8 AS l -- level requirements
    ON d.name = l.name),

-- ranking the weapons by total damage grouped by total required
step_10 AS (
  SELECT
  Name,
  Category, 
  Total_Damage,
  Total_Required,
  DENSE_RANK() OVER(PARTITION BY Total_Required ORDER BY Total_Damage DESC) AS Damage_Ranking
  FROM step_9)

-- filter for records where the ranking is 1
SELECT
Name,
Category,
Total_Required AS Required_Level,
Total_Damage AS Attack_Damage
FROM step_10
WHERE Damage_Ranking = 1;











