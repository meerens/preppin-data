-- turn milliseconds into minutes and seconds
-- extract year from timestamp

WITH  step_1 as (
  SELECT *,
  ROUND((ms_played / 60000),2) AS minutes_played,
  EXTRACT(year FROM ts) AS year
  FROM preppindata.`2022w26_spotify`
),


-- aggregating the total minutes played by artist
-- sorting artists descending by total minutes played

step_2 as (
  SELECT 
  Artist_Name,
  SUM(minutes_played) AS total_minutes_played,
  FROM step_1
  GROUP BY Artist_Name
  ORDER BY total_minutes_played DESC
),

-- adding a rownumber to every artist creating the overall ranking for artists based on the total minutes played

step_3 as (
  SELECT
  Artist_Name,
  ROW_NUMBER() OVER () AS rank
  FROM step_2
),

 -- create a table that aggregates the total minutes played by year and then artist name

step_4 as (
  SELECT 
  year, 
  Artist_Name, 
  SUM(minutes_played) AS total_year_artist
  FROM step_1
  GROUP BY year, Artist_Name
  ORDER BY year,total_year_artist DESC 
),

-- for every year find the ranking of the artists by total minutes played

step_5 as (
  SELECT
  year,
  Artist_Name,
  ROW_NUMBER () OVER (PARTITION 
  BY year ORDER BY year, total_year_artist DESC) AS ranking,
  FROM step_4
),


-- reshape the table to show the years as columns
step_6 as (

  SELECT * FROM 
  (SELECT 
  CAST(year AS string) AS year,
  Artist_Name,
  ranking 
  FROM step_5)
  PIVOT 
  (MIN(ranking) AS rank
  FOR year IN ("2015","2016","2017","2018","2019","2020","2021","2022"))
)


-- bringing it all together

SELECT 
step_3.rank AS overall_rank,
step_3.artist_name,
step_6.rank_2015,
step_6.rank_2016,
step_6.rank_2017,
step_6.rank_2018,
step_6.rank_2019,
step_6.rank_2020,
step_6.rank_2021,
step_6.rank_2022
FROM step_3
  JOIN step_6
    ON step_3.Artist_Name = step_6.Artist_Name
ORDER BY overall_rank ASC
LIMIT 100;