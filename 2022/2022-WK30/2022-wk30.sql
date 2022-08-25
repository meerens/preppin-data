-- combine top3 files and add in the region
WITH  step_1 as (
  SELECT *, "West" AS Region FROM preppindata.`2022w30_west_top3`
  UNION ALL
    -- technically you don't need an alias for 'region' column in the second select
    -- what put here will be replaced by the column headers in the first select
  SELECT *, "East" AS Whatever FROM preppindata.`2022w30_east_top3`
),

-- add in the store name
-- only keep relevant fields
step_2 as (
  SELECT 
  t.Store,
  s.Store_Name,
  t.Sales_Person,
  t.Percent_of_Store_Sales,
  t.Region
  FROM step_1 AS t -- top3union
    LEFT JOIN preppindata.`2022w30_store_lookup` AS s -- storelookup
    ON t.Store = s.StoreID
),

-- calculate the sales value for each store
step_3 as (
  SELECT 
  Store_Name,
  SUM(Sale_Value) AS Sales_by_Store
  FROM preppindata.`2022w27_cbsco`
  GROUP BY Store_Name
)

-- bringing together sales per store and top3 data
-- calculate sales value per sales person
-- only keep required columns
SELECT 
ROUND((t.Percent_of_Store_Sales * s.Sales_by_Store)/100,2) AS Sales_by_Sales_Person,
t.Store_Name,
t.Region,
t.Sales_Person,
CAST(t.Percent_of_Store_Sales AS string) || "%" AS Percent_of_Store_Sales,
s.Sales_by_Store
FROM step_2 AS t -- top3
  JOIN step_3 AS s -- salesvalue per store
  ON t.Store_Name = s.Store_Name
ORDER BY Store_Name, Sales_by_Sales_Person ASC;