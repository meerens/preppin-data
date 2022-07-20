-- clean guests table, replace N/A will null

WITH  step_1 as (

  SELECT 
  Party,
  Adults,
  Children,
  Double_Twin,
  Requires_Accessible_Room,
  IF(Additional_Requests = "N/A", NULL, Additional_Requests) AS Additional_Requests
  FROM preppindata.`2022w25_guests`
),

-- counting the number of additional requests by guest

step_2 as (

  SELECT 
  Party,
  Adults AS Adults_In_Party,
  Children AS Children_In_Party,
  Double_Twin,
  Requires_Accessible_Room,
  Additional_Requests,
  IF(ARRAY_LENGTH(SPLIT(Additional_Requests,",")) IS NULL, 0, ARRAY_LENGTH(SPLIT(Additional_Requests,","))) AS Nr_Requests
  FROM step_1
),

-- cleaning hotelrooms table

step_3 as (

  SELECT 
  Room, 
  Adults, 
  IF (Children IS NULL, 0, Children) AS Children, 
  Features
  FROM preppindata.`2022w25_hotelrooms`
),

-- bringing it all together
-- matching guests to the rooms which have capacity for their entire party

step_4 as (

  SELECT *
  FROM step_2 -- guests
  LEFT JOIN step_3 -- hotelrooms
  ON Children_In_Party <= Children AND Adults_In_Party <= Adults
  ORDER BY Party, Room ASC
),

-- filtering so that double/twin bed preferences are adhered to

step_5 as (

  SELECT *
  FROM step_4
  WHERE Features LIKE '%'|| Double_Twin ||'%'
),

-- making sure guests who have accessibility requirements are matched to accessible rooms only

step_6 as (

  SELECT *
  FROM step_5
  WHERE 
    (CASE 
      WHEN Requires_Accessible_Room = TRUE 
       AND CONTAINS_SUBSTR (Features,"Accessible") THEN 'Keep'
      WHEN Requires_Accessible_Room = TRUE 
       AND NOT CONTAINS_SUBSTR (Features,"Accessible") THEN 'Remove'
     ELSE "Keep"
     END) = 'Keep'
),

-- calculate score for how additional requests match up to features, 1 for match, 0 for no match

step_7 as (

  SELECT *,
  IF (CONTAINS_SUBSTR(Additional_Requests,"Bath") AND CONTAINS_SUBSTR(Features,"Bath"),1,0) AS Bath,
  IF (CONTAINS_SUBSTR(Additional_Requests,"High Floor") AND CONTAINS_SUBSTR(Features,"High Floor"),1,0) AS Floor,
  IF (NOT(CONTAINS_SUBSTR(Features,"Near to lift")) AND CONTAINS_SUBSTR(Additional_Requests,"NOT Near to lift"),1,0) AS Lift
  FROM step_6
),

-- calculate success request satisfaction % for each room

step_8 as (

  SELECT 
  *,
  IF (Nr_Requests= 0, 100 , ROUND(((Bath + Floor + Lift) / Nr_Requests)*100)) AS Satisfaction_Score
  FROM step_7
  ORDER BY Party ASC
),

-- calculate the max satisfaction score by party

step_9 as (

  SELECT *,
  MAX(Satisfaction_Score) OVER (PARTITION BY Party) AS Suitable_Score,
  FROM step_8
),

-- filter so that guests are only left with rooms with the highest request (MAX) satisfaction score (read: rooms that are most suitable for them)

step_10 as (

  SELECT * 
  FROM step_9 
  WHERE Suitable_Score = Satisfaction_Score
),

-- for every room calculate the max of adults in the guest party (for rooms with with the largest capacity we want to make sure guests with larger parties are prioritised)

step_11 as (

  SELECT *,
  MAX(Adults_In_Party) OVER (PARTITION BY Room) AS Most_Adults_For_Room
  FROM step_10
)

-- filtering the data to make sure guests with larger parties are prioritised

SELECT 
Party,
Adults_In_Party,
Children_In_Party,
Double_Twin,
Requires_Accessible_Room,
Additional_Requests,
Satisfaction_Score AS Request_Satisfaction_Score,
Room,
Adults,
Children,
Features
FROM step_11
WHERE Adults < 3 OR Most_Adults_For_Room = Adults_In_Party;