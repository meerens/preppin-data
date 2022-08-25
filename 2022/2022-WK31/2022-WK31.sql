-- split productname into type and size
-- only keep rows for liquid
-- total up sales by size  & scent combo for each store
WITH step_1 as (
  SELECT
  Store_Name,
  CONCAT(TRIM(SPLIT(Product_Name, "-") [ORDINAL(2)]), "-", Scent_Name) AS Size_Scent,
  SUM(Sale_Value) AS Total_Sales
  FROM preppindata.`2022w27_cbsco`
  WHERE TRIM(SPLIT(Product_Name, "-") [ORDINAL(1)]) = "Liquid"
  GROUP BY Store_Name, Size_Scent
),

-- rank size & scent combo for each store
step_2 as (
  SELECT
  *, 
  RANK() OVER(PARTITION BY Store_Name ORDER BY Total_Sales DESC) AS Sales_Ranking
  FROM step_1
) 

-- only keep the top 10
-- round sales value to the nearest '10' value (1913 to 1910)
-- no parameter but table can be filtered on store_name via the notebook 
-- https://count.co/notebook/ZVkjh4yRKot
SELECT
Store_Name,
Sales_Ranking,
SPLIT(Size_Scent, "-") [ORDINAL(2)] AS Scent_Name,
SPLIT(Size_Scent, "-") [ORDINAL(1)] AS Size,
ROUND(Total_Sales, -1) AS Sales_Value
FROM step_2
WHERE Sales_Ranking <= 10;