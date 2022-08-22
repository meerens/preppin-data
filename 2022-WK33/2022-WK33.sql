-- combine the in-store and online sales datasources
WITH step_1 AS (
  SELECT Sales_Timestamp, "Online" AS Store, ID, Product 
  FROM preppindata.`2022w33_online_orders`
  UNION ALL
  SELECT * FROM preppindata.`2022w33_instore_orders`
),

-- bring in the product name
-- create the product type field by using the first word from the product name
step_2 AS (
  SELECT 
  t.id,
  t.Sales_Timestamp,
  t.Store, 
  TRIM(SPLIT(Product_Name,"-") [ORDINAL(1)]) AS Product_Type
  FROM step_1 AS t -- combined table
    LEFT JOIN preppindata.`2022w33_product_lookup` AS l
    ON t.Product = l.Product_ID
),

-- calculate the next purchase date for every record 
-- window = per store & product type, recorders ordered by id asc
step_3 AS (
  SELECT
  *,
  LEAD(Sales_Timestamp) OVER (PARTITION BY Store, Product_Type ORDER BY ID ASC) AS Next_Purchase
  FROM step_2
),

-- calculate the difference between timestamps in minutes
step_4 AS (
  SELECT 
  *,
  DATETIME_DIFF(Next_Purchase, Sales_Timestamp, Minute) AS difference_to_next
  FROM step_3
)

-- creating the final output, the avg minutes to next sale per store and product type
SELECT 
Store, 
Product_Type,
ROUND(AVG(difference_to_next),1) AS Average_Minutes_To_Next_Sale
FROM step_4
WHERE difference_to_next >= 0
GROUP BY Store, Product_Type;