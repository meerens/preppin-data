-- solution prepared by Marian Eerens
-- coded in BigQuery SQL syntax
-- challenge: https://preppindata.blogspot.com/2023/02/2023-week-6-dsb-customer-ratings.html
-- check my count canvas for my full SQL workflow: https://count.co/report/m6A2SxX8ya0?frame=vVEIw4gDoJm

WITH
  reshape_data_unpivot AS (
    -- reshape the data so we have 5 rows for each customer, with responses for the mobile app and online interface being in separate fields on the same row
    -- step 1: unpivot
    SELECT
      Customer_ID,
      Metric,
      Value
    FROM
      preppindata.`2023w6_dsb_customer_ratings` UNPIVOT(
        Value
        FOR
          Metric IN (
            Mobile_App___Navigation,
            Mobile_App___Ease_of_Use,
            Mobile_App___Ease_of_Access,
            Mobile_App___Overall_Rating,
            Mobile_App___Likelihood_to_Recommend,
            Online_Interface___Navigation,
            Online_Interface___Ease_of_Use,
            Online_Interface___Ease_of_Access,
            Online_Interface___Overall_Rating,
            Online_Interface___Likelihood_to_Recommend
          )
      )
    ORDER BY
      Metric,
      Value
  ),
  reshape_data_split AS (
    -- reshape the data so we have 5 rows for each customer, with responses for the mobile app and online interface being in separate fields on the same row
    -- step 2: split metric column
    SELECT
      Customer_ID,
      SPLIT(Metric, '___') [ORDINAL(1)] AS Category,
      SPLIT(Metric, '___') [ORDINAL(2)] AS Subcategory,
      Value AS Score
    FROM
      reshape_data_unpivot
  ),
  calculate_average_ratings AS (
    -- exclude the overall ratings, these were incorrectly calculated by the system
    -- calculate the avg ratings for each platform for each customer 
    SELECT
      Customer_ID,
      Category AS Platform,
      AVG(Score) AS Average_Rating,
    FROM
      reshape_data_split
    WHERE
      Subcategory != "Overall_Rating"
    GROUP BY
      Platform,
      Customer_ID
  ),
  reshape_for_calculating_difference AS (
    -- pivot table to be able to calculate the difference between both averages
    SELECT
      *
    FROM
      (
        SELECT
          *
        FROM
          calculate_average_ratings
      ) PIVOT(
        SUM(Average_Rating)
        FOR
          Platform IN("Mobile_App", "Online_Interface")
      )
  ),
  calculate_difference AS (
    -- calculating the difference between the avg ratings
    SELECT
      *,
      Mobile_App - Online_Interface AS difference,
    FROM
      reshape_for_calculating_difference
  ),
  categorize_customers AS (
    SELECT
      *,
      CASE
        -- when the difference is positive the mobile app gets a better avg rating
        WHEN difference >= 2 THEN "Mobile App Superfans"
        WHEN difference >= 1
        AND difference < 2 THEN "Mobile App Fans" -- when the difference is negative the online app gets a better avg rating
        WHEN difference < 0
        AND difference >= -1 THEN "Online Interface Fans"
        WHEN difference <= -2 THEN "Online Interface Superfans"
        ELSE "Neutral"
      END AS Preference
    FROM
      calculate_difference
  ),
  totals_by_prefence_category AS (
    SELECT
      Preference,
      COUNT(Customer_ID) AS Total
    FROM
      categorize_customers
    GROUP BY
      Preference
  )
SELECT
  Preference,
  CONCAT(
    CAST(ROUND((Total / SUM(Total) OVER ()) * 100, 2) AS STRING),
    '%'
  ) AS total_percent
FROM
  totals_by_prefence_category