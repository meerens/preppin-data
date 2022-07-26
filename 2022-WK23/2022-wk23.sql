-- reshape the opportunities table
-- create rows from createddate and closeddate columns -> UNPIVOT

WITH  step_1 as (

  SELECT
  *,
  FROM preppindata.`2022w23_opportunity` 
  UNPIVOT(Date FOR Stage IN (CreatedDate, CloseDate))
),

-- relabel values in the stage column
-- only keep relevant columns

step_2 as (

  SELECT 
  Id, 
  Date, 
  StageName,
  CASE WHEN Stage = "CreatedDate" THEN "Opened" 
     WHEN Stage = "CloseDate" THEN "ExpectedCloseDate" 
     ELSE "Woop" END AS Stage
  FROM step_1
),

-- updating the stagefield
-- if opportunity closed (see stagename) then expectedclosedate in the stage column is updated with the value from the stagename column

step_3 as (

  SELECT 
  Id,
  Date,
  IF(CONTAINS_SUBSTR(StageName, "Close") AND Stage = "ExpectedCloseDate", StageName, Stage) AS Stage
  FROM step_2
),

-- creating a small table with the stagename and matching sortorder

step_5 as (

  SELECT 
  StageName,
  SortOrder,
  COUNT(*) AS aggregation
  FROM preppindata.`2022w23_opportunity_history`
  GROUP BY StageName, SortOrder
),
 step_4 as (-- bringing in the opportunity history

  SELECT * FROM step_3
  UNION DISTINCT
  SELECT OppID, CreatedDate, StageName FROM preppindata.`2022w23_opportunity_history`
  ORDER BY Id, Date
),

-- bringing it all together

step_6 as (

  SELECT
  t.Id,
  t.Date,
  t.Stage,
  s.SortOrder
  FROM step_4 AS t -- datatable
    LEFT JOIN step_5 AS s -- sortorders
    ON t.Stage = s.StageName
  ORDER BY Id, SortOrder
)

-- updating the null values in sortorder

SELECT
Id,
Date, 
Stage,
IF (Stage = "Opened",0, IF(Stage = "ExpectedCloseDate",11,SortOrder)) AS SortOrder
FROM step_6
-- GROUP BY Id, Date, Stage, SortOrder > not needed, union distinct took care of removing duplicates
ORDER BY Id, SortOrder