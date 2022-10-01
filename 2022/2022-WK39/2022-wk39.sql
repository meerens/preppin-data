SELECT
Record_Id AS RecordId,
LAST_VALUE(Employee IGNORE NULLS) OVER (ORDER BY Record_Id ASC) AS EmployeeName,
LAST_VALUE(Work_Level IGNORE NULLS) OVER (ORDER BY Record_ID ASC) AS WorkLevel,
Stage,
Date
FROM preppindata.`2022w39_filling_in`;