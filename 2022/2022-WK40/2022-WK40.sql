-- step 1: creating an array to fill the numbers between 1 (minimum) and 9 (maximum)
WITH
  create_array AS (
    
    SELECT
      GENERATE_ARRAY(MIN(numbers), MAX(numbers), 1) AS number_array
    FROM
      preppindata.`2022w40_numbers`
  ),

-- step 2: flatten the array
  flatten_array AS (
    
    SELECT
      number
    FROM
      create_array AS t
      CROSS JOIN UNNEST(t.number_array) AS number
  ) 

-- step 3: create the 'times tables'
SELECT
  number,
  number * 1 AS _1,
  number * 2 AS _2,
  number * 3 AS _3,
  number * 4 AS _4,
  number * 5 AS _5,
  number * 6 AS _6,
  number * 7 AS _7,
  number * 8 AS _8,
  number * 9 AS _9
FROM
  flatten_array