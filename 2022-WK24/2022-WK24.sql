-- cleaning up flying_from & to
-- extracting km & mi number from distance column

WITH  step_1 as (
    
  SELECT 
  TRIM(SPLIT(REPLACE(REPLACE(Flying_From,"-","/"),"–","/"),"/")[ORDINAL(1)]) AS Flying_From,
    -- ^^
    -- wrapping multiple 'replaces' so they all have the same format using the /
    -- then split the string into an array (/ being the delimiter) and keep the first value
    -- adding a trim to remove and potential leading/trailing spaces
  TRIM(SPLIT(REPLACE(REPLACE(Flying_To,"-","/"),"–","/"),"/")[ORDINAL(1)]) AS Flying_To, 
  Airline,
  Flight_Number,
  REPLACE(REPLACE(REPLACE(Distance,"(",""),")",""),";","") AS Distance_Clean,
  SPLIT(REPLACE(REPLACE(REPLACE(Distance,"(",""),")",""),";","")," ")[ORDINAL(1)]AS Distance_Km,
    -- ^^
    -- wrapping multiple 'replaces' so we are left with a string containing 6 values seperated by a space
    -- then split the string into an array (the space being the delimiter)
    -- keep the first value which is the string number for km
  SPLIT(REPLACE(REPLACE(REPLACE(Distance,"(",""),")",""),";","")," ")[ORDINAL(3)]AS Distance_Mi,
  Distance,
  Scheduled_Duration,
  Aircraft,
  First_Flight
  FROM preppindata.`2022w24_flights`
),

-- create the route column (flying from - flying to)
-- convert distances from string to number
-- update the first flight field to be a date
-- scheduled duration loaded as a string so nothing to do there

step_2 as (

  SELECT
  Flying_From,
  Flying_To,
  CONCAT(Flying_From," - ",Flying_To) AS Route,
  Airline,
  Flight_Number,
  CAST(REPLACE(Distance_Km,",","") AS INTEGER) AS Distance_Km,
  CAST(REPLACE(Distance_Mi,",","") AS INTEGER) AS Distance_Mi,
  Scheduled_Duration,
  Aircraft,
  PARSE_DATE('%b %d, %Y', First_Flight) AS First_Flight,
  FROM step_1
),

-- rank flights based on distance

step_3 as (

  SELECT 
  *,
  DENSE_RANK() OVER (ORDER BY Distance_Km DESC) AS Ranking
  -- the entire table is the partition
  FROM step_2
)

-- bring it all together

SELECT
f.Ranking AS Rank,
f.Flying_From,
f.Flying_To,
f.Route,
f.Airline,
f.Flight_Number,
f.Distance_Mi,
f.Distance_Km,
f.Scheduled_Duration,
f.Aircraft,
f.First_Flight,
cf.Lat AS From_Lat,
cf.Lng AS From_Lng,
ct.Lat AS To_Lat,
ct.Lng AS To_Lng
FROM step_3 AS f -- flights
LEFT JOIN preppindata.`2022w24_cities` AS cf ON f.Flying_From = cf.City
LEFT JOIN preppindata.`2022w24_cities` AS ct ON f.Flying_To = ct.City;