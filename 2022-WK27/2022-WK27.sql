-- output 'Liquid'

-- split the product name column to create 2 new columns Product Type and Quantity

WITH  step_1 as (

  SELECT
  *,
  TRIM(SPLIT(Product_Name,"-")[ORDINAL(1)]) AS Product_Type,
  --^^ take the first value (ordinal position = 1) from the array created by the SPLIT function, trim the leading and trailing spaces and rename the column as Product_Type
  TRIM(SPLIT(Product_Name,"-")[ORDINAL(2)]) AS Quantity
  FROM preppindata.`2022w27_cbsco`
),

-- create a seperate table for 'Liquid'

step_2 as (

  SELECT *
  FROM step_1 
  WHERE Product_Type = "Liquid"
),

-- trim the quantity string to only how the numbers

step_3 as (

  SELECT 
  *,
  CASE 
    WHEN CONTAINS_SUBSTR(Quantity,"ml") THEN REPLACE(Quantity,"ml","")
    ELSE REPLACE(Quantity,"L","000")
  END AS Quantity_String
  FROM step_2
)

-- final output for 'Liquid'
-- aggregate sales and count the number of orders

SELECT 
CAST(Quantity_String AS INTEGER) AS Quantity,
Store_Name,
Region,
SUM(Sale_Value) AS Sales_Value,
COUNT(DISTINCT Order_Id) AS Present_In_N_Orders
FROM step_3
GROUP BY Quantity, Store_Name, Region
ORDER BY Store_Name, Quantity ASC

-- output 'Bar'
-- split the product name column to create 2 new columns Product Type and Quantity

WITH  step_1 as (

  SELECT
  *,
  TRIM(SPLIT(Product_Name,"-")[ORDINAL(1)]) AS Product_Type,
  --^^ take the first value (ordinal position = 1) from the array created by the SPLIT function, trim the leading and trailing spaces and rename the column as Product_Type
  TRIM(SPLIT(Product_Name,"-")[ORDINAL(2)]) AS Quantity
  FROM preppindata.`2022w27_cbsco`
),

-- create a seperate table for 'Bar'

step_4 as (

  SELECT *
  FROM step_1 
  WHERE Product_Type = "Bar"
),

step_5 as (
  SELECT 
  *,
  LENGTH(Quantity) AS length,
  RTRIM(Quantity,"x") AS Quantity_String_Bar
  FROM step_4
)

-- final output for 'Bar'
-- aggregate sales and count the number of orders

SELECT 
CAST(Quantity_String_Bar AS INTEGER) AS Quantity,
Store_Name,
Region,
SUM(Sale_Value) AS Sales_Value,
COUNT(DISTINCT Order_Id) AS Present_In_N_Orders
FROM step_5
GROUP BY Quantity, Store_Name, Region
ORDER BY Store_Name, Quantity ASC