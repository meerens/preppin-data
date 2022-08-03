# Preppin Data in SQL
 
This repository contains all my documentation for the '[Preppin Data](https://preppindata.blogspot.com/)' challenges I completed so far. <br>Keep watching 👀 this space as I add on more solutions.<br>

### `My Process`
Solutions were coded in [Google BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax) SQL syntax using a [Count](https://count.co/) SQL notebook.<br>

Each challenge folder contains the following files including the csv files for the input and final output
- **.md**: markdown from SQL notebook
- **.sql**: compiled sql for creating the final output

### `Completed Challenges` 
Check the overview below for all the documentation (challenge and sql notebook) for the challenges I completed so far. I also added a shortlist of the main functions and operators I used (including links to the BigQuery documentation) when solving each challenge. (🤓: below the summary table you'll find an index of the additional materials I reviewewed as I'm learning and that could be useful for your own learning journey).

| 📆        | 🗂                           | 🧮                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 🧠                                                                                                 | 📒                                                                                                   | 📝                                                                                                                                                    |
| --------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2022-WK23 | Salesforce Opportunities     | [UNPIVOT](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#unpivot_operator) - [CASE ](https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions#case_expr)-  [IF](https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions#if) - [UNION DISTINCT](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#union)                                                                                                                                                                                                                                                                                                                                                                                                                | [Challenge](https://preppindata.blogspot.com/2022/06/2022-week-23-pd-x-wow-salesforce.html)        | [Solution Notebook](https://count.co/notebook/ALLYdShxAnd)                                           | Unpivoting a wide table (2 columns to rows), unioning tables without duplicating records, chained if functions                                        |
| 2022-WK24 | Longest Flights              | [TRIM](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#trim) - [SPLIT](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#split) - [REPLACE](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#replace) - [ORDINAL](https://cloud.google.com/bigquery/docs/reference/standard-sql/operators#array_subscript_operator) - [CONCAT](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#concat) - [CAST](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions#cast) - [PARSE_DATE](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#parse_date) - [DENSE_RANK](https://cloud.google.com/bigquery/docs/reference/standard-sql/numbering_functions#dense_rank) | [Challenge](https://preppindata.blogspot.com/2022/06/2022-week-24-longest-flights.html)            | [Solution Notebook](https://count.co/notebook/egsKBXWNQqW)                                           | Complex chained string manipulations (arrays, multiple chained functions), dual join (same table on different columns), parsing a date from a string  |
| 2022-WK25 | Housing Happy Hotel Guests   | [ARRAY_LENGTH](https://cloud.google.com/bigquery/docs/reference/standard-sql/arrays#finding_lengths) - [SPLIT](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#split) - [CASE](https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions#case_expr) - [CONTAINS_SUBSTR ](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#contains_substr)- [MAX() OVER (PARTITION BY)](https://cloud.google.com/bigquery/docs/reference/standard-sql/window-function-calls)                                                                                                                                                                                                                                                                                  | [Challenge](https://preppindata.blogspot.com/2022/06/2022-week-25-housing-happy-hotel-guests.html) | [Solution Notebook](https://count.co/notebook/QLP6USadahs)                                           | Complex filtering in WHERE using CASE & LIKE, window functions (aggregation)                                                                          |
| 2022-WK26 | Making Spotify Data Spotless | [ROUND](https://cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions#round) - [EXTRACT](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#extract) - [CAST](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions#cast) - [PIVOT](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#pivot_operator) - [ROW_NUMBER](https://cloud.google.com/bigquery/docs/reference/standard-sql/numbering_functions#row_number)                                                                                                                                                                                                                                                                                                              | [Challenge](https://preppindata.blogspot.com/2022/06/2022-week-26-making-spotify-data.html)        | [Solution Notebook](https://count.co/notebook/QNeQy4t45lN)                                           | Pivoting (rows to columns), window functions (ranking)                                                                                                |
| 2022-WK27 | C&BSCo Clean and Aggregate   | [SPLIT](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#split) - [ORDINAL](https://cloud.google.com/bigquery/docs/reference/standard-sql/operators#array_subscript_operator) - [TRIM](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#trim) - [RTRIM](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#rtrim) - [LENGTH](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#length) - [CONTAINS_SUBSTR](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#contains_substr) - [REPLACE](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#replace) - [CAST](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions#cast)  | [Challenge](https://preppindata.blogspot.com/2022/07/2022-week-27-c-clean-and-aggregate.html)      | [Solution Notebook](https://count.co/notebook/bSXqSaQ9Zdo)                                           | String manipulation by creating an array from a string and accessing specific elements                                                                |
| 2022-WK28 | C&BSCo No Sales Today        | [EXTRACT](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#extract) - [CAST](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions#cast) - [GENERATE_DATE_ARRAY](https://cloud.google.com/bigquery/docs/reference/standard-sql/array_functions#generate_date_array) - [UNNEST ](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#unnest_operator)- [FORMAT_DATE](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#format_date)                                                                                                                                                                                                                                                                                          | [Challenge](https://preppindata.blogspot.com/2022/07/2022-week-28-c-no-sales-today.html)           | [Solution Notebook](https://count.co/notebook/UvSghK0UsVz)                                           | Create an array of dates, converting elements in an array to individual rows                                                                          |
| 2022-WK29 | C&BSco Meeting Targets?      | [TRIM](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#trim) - [SPLIT](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#split) - [UNPIVOT](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#unpivot_operator) - [INITCAP ](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#initcap)- [STRUCT](https://cloud.google.com/spanner/docs/reference/standard-sql/data-types#constructing_a_struct) - [UNNEST](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#unnest_operator)                                                                                                                                                                                                              | [Challenge](https://preppindata.blogspot.com/2022/07/2022-week-29-c-meeting-targets.html)          | [Solution Notebook](https://count.co/notebook/Kj16wzIOrPs)                                           | Unpivoting (columns to rows), using proper case                                                                                                       |
| 2022-WK30 | C&BSCo Actual Sales Values   | [UNION ALL](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#union) - [ROUND](https://cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions#round) - [CAST](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions#cast)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [Challenge](https://preppindata.blogspot.com/2022/07/2022-week-30-c-actual-sales-values.html)      | [Solution Notebook](https://count.co/notebook/wTDx086J1yp)                                           | Unioning 2 files and adding a column to identify the file (read: region), simple joins and aggregations                                               |
| 2022-WK31 | C&BSCo Preppin' Parameters   | [SPLIT](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#split) - [ORDINAL](https://cloud.google.com/bigquery/docs/reference/standard-sql/operators#array_subscript_operator) - [TRIM](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#trim) - [ROUND ](https://cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions#round)- [RANK](https://cloud.google.com/bigquery/docs/reference/standard-sql/numbering_functions#rank)                                                                                                                                                                                                                                                                                                                       | [Challenge](https://count.co/notebook/ZVkjh4yRKot)                                                 | [Solution Notebook](https://preppindata.blogspot.com/2022/08/2022-week-31-c-preppin-parameters.html) | Practicing basics (string manipulations using arrays and ordinal position, aggregations, filtering), TOP N using CTE’s, rounding before decimal point |


### `Documentation Index` 

### `A`

**ARRAYS**

- [Arrays explained](https://count.co/sql-resources/bigquery-standard-sql/arrays-explained) (via count.co)
- [Working with ARRAYS](https://cloud.google.com/bigquery/docs/reference/standard-sql/arrays) (via cloud.google.com)
- [BigQuery Arrays](https://www.youtube.com/watch?v=3WIMdDe7G7Y) (via youtube.com)
- [Explore Arrays and Structs for Better Query Performance in Google BigQuery](https://towardsdatascience.com/explore-arrays-and-structs-for-better-performance-in-google-bigquery-8978fb00a5bc#:~:text=An%20array%20is%20a%20data,records%20are%20arrays%20of%20structs.) ( via towardsdatascience.com)
- [How to ‘Unpivot’ a table in Google BigQuery using Arrays & Structs](https://yuhuisdatascienceblog.blogspot.com/2018/06/how-to-unpivot-table-in-bigquery.html) (via yuhuisdatascienceblog.blogspot.com)

### `C`

**CASE**

- [SQL Resources / BigQuery / CASE](https://count.co/sql-resources/bigquery-standard-sql/case) (via count.co)

### `D`

**DENSE_RANK**

- [Window Functions & Ranking](https://dev.to/meerens/lessons-learnt-from-the-8-week-sql-challenge-window-functions-ranking-1c54) (via dev.to)

### `F`

**FORMAT_DATE**

- [Formatting Date Cheat Sheet](https://sql-snippets.count.co/t/formatting-date-cheat-sheet/246) (via count.co)
- [Format elements for date and time parts](https://cloud.google.com/bigquery/docs/reference/standard-sql/format-elements#format_elements_date_time) (via cloud.google.com)

### `I`

**IF**

- [SQL Resources / BigQuery / IF](SQL IF Function | BigQuery Syntax and Examples | Count https://count.co/sql-resources/bigquery-standard-sql/if) (via count.co)

### `P`

**PARSE_DATE**

- [Format elements for date and time parts](https://cloud.google.com/bigquery/docs/reference/standard-sql/format-elements#format_elements_date_time) (via cloud.google.com)
- [PARSE_DATE() function examples](https://www.sumified.com/data-studio-parse-date-function-examples) (via sumified.com)

**PIVOT**

- [Pivot in BigQuery](https://towardsdatascience.com/pivot-in-bigquery-4eefde28b3be) (via towardsdatascience.com)
- [How to use the Google BigQuery PIVOT operator](https://hevodata.com/learn/bigquery-columns-to-rows/#pivot) (via hevodata.com)

### `R`

**ROW_NUMBER**

- [Window Functions & Ranking](https://dev.to/meerens/lessons-learnt-from-the-8-week-sql-challenge-window-functions-ranking-1c54) (via dev.to)

### `S`

**STRUCTS**

- [Explore Arrays and Structs for Better Query Performance in Google BigQuery](https://towardsdatascience.com/explore-arrays-and-structs-for-better-performance-in-google-bigquery-8978fb00a5bc#:~:text=An%20array%20is%20a%20data,records%20are%20arrays%20of%20structs.) ( via towardsdatascience.com)
- [How to ‘Unpivot’ a table in Google BigQuery using Arrays & Structs](https://yuhuisdatascienceblog.blogspot.com/2018/06/how-to-unpivot-table-in-bigquery.html) (via yuhuisdatascienceblog.blogspot.com)

### `U`

**UNION**

- [BigQuery Union: syntax and examples](https://blog.coupler.io/bigquery-union-syntax-and-usage-examples/) (via blog.coupler.io)

**UNPIVOT**

- [Using UNPIVOT in BigQuery](https://sql-snippets.count.co/t/unpivot-melt/55) (via count.co)
- [How to use the Google BigQuery Unpivot operator](https://hevodata.com/learn/bigquery-columns-to-rows/#unpivot) (via hevodata.com)

**UNNEST**

- [Using UNNEST in BigQuery](https://sql-snippets.count.co/t/unpivot-melt/55) (via count.co)

### `W`

**WITH** (contains CTE’s or Common Table Expressions)

- [Take your SQL from Good to Great Part 1: CTE’s](https://blog.count.co/take-your-sql-from-good-to-great-part-1/) (via blog.count.co)
- [BigQuery WITH & CTE Statements: Syntax & Usage Simplified 101](https://hevodata.com/learn/bigquery-with/) (via hevodata.com)
