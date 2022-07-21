-- clean products table and only keep the product type (liquid - bar) from product name

WITH  step_1 as (
  SELECT 
  *,
  TRIM(SPLIT(Product_Name,"-")[ORDINAL(1)]) AS Product_Type
  -- take the first value (ordinal position = 1) from the array created by the SPLIT function
  -- trim the leading and trailing spaces and rename the column as Product_Type
  FROM preppindata.`2022w27_cbsco`
),

-- adding up sales values per store and product type

step_2 as (
  SELECT 
  Store_Name,
  Product_Type,
  Region,
  SUM(Sale_Value) AS Total_Sales
  FROM step_1
  GROUP BY Store_Name, Product_Type, Region
)

-- reshaping the targets table

step_3 as (
  SELECT *
  FROM preppindata.`2022w29_targets`
  UNPIVOT (Target FOR Store IN (CHELSEA, DULWICH, LEWISHAM, NOTTING_HILL, SHOREDITCH, WIMBLEDON))
),

-- recalculating the target and fixing the spelling for product type and store

step_4 as (
  SELECT
  INITCAP(Product) as Product_Type,
  Target * 1000 AS Target,
  INITCAP(Store) AS Store
  FROM step_3
),

-- fixing the spelling for Notting Hill in the targets table so the join works correctly (can't match Notting Hill to Notting_Hill)

step_5 as (
  SELECT 
  Product_Type,
  CASE WHEN Store = "Notting_Hill" THEN "Notting Hill"
  ELSE Store END AS Store_Name,
  Target,
  FROM step_4
),

-- bringing it all together
-- showing which stores beat their targets

SELECT 
s.Store_Name,
s.Region,
s.Product_Type,
s.Total_Sales,
t.Target,
IF (s.Total_Sales > t.Target, "Yes","No") AS Beats_Target
FROM step_2 AS s -- short table stores
LEFT JOIN step_5 AS t -- targets
ON s.Product_Type = t.Product_Type AND s.Store_Name = t.Store_Name

--------
-- alternative solution for unpivot
--------

-- creating an array of structs
-- an array is a collection of variables of the same data type, individual variables within the array are accessed by their index number.
-- a struct is a collection of variables from different data types, variables are accessed by their names


WITH  alternative_for_unpivot_step_1 as (
  SELECT 
  Product,
  [
    STRUCT('CHELSEA' AS Store, Chelsea AS Target),
    STRUCT('DULWICH' AS Store, Dulwich AS Target),
    STRUCT('LEWISHAM' AS Store, Lewisham AS Target),
    STRUCT('NOTTING_HILL' AS Store, Notting_Hill AS Target),
    STRUCT('SHOREDITCH' AS Store, Shoreditch AS Target),
    STRUCT('WIMBLEDON' AS Store, Wimbledon AS Target)
  ] AS Target_Struct
  FROM preppindata.`2022w29_targets`
)

SELECT *
FROM alternative_for_unpivot_step_1 AS t CROSS JOIN
UNNEST(t.Target_Struct) AS s