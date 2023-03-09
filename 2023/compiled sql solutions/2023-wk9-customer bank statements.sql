-- solution prepared by Marian Eerens
-- coded in BigQuery SQL syntax
-- challenge: https://preppindata.blogspot.com/2023/03/2023-week-9-customer-bank-statements.html
-- check my count canvas for my full SQL workflow: https://count.co/report/SugHO9FhrGw

WITH
  filtering_cancelled_transactions AS (
    SELECT
      *
    FROM
      preppindata.`2023w9_transaction_detail`
    WHERE
      Cancelled_ != TRUE
  ),
  building_transactions_table AS (
    -- joining in the to/from account for each transaction
    SELECT
      t.Transaction_ID,
      t.Transaction_Date,
      t.Value,
      p.Account_To,
      p.Account_From
    FROM
      filtering_cancelled_transactions AS t
      LEFT JOIN preppindata.`2023w9_transaction_path` AS p ON t.Transaction_ID = p.Transaction_ID
  ),
  incoming_transactions AS (
    -- incoming = money is coming into the account
    -- account = account_to
    SELECT
      o.Transaction_ID,
      o.Transaction_Date AS DATE,
      o.Value,
      'Incoming' AS Transaction_Type,
      a.Account_Number,
      a.Account_Type,
      a.Account_Holder_ID
    FROM
      building_transactions_table AS o
      LEFT JOIN preppindata.`2023w9_account_information` AS a ON o.Account_To = a.Account_Number
  ),
  outgoing_transactions AS (
    -- outgoing = money is leaving the account
    -- account = account_from
    SELECT
      o.Transaction_ID,
      o.Transaction_Date AS DATE,
      o.Value,
      'Outgoing' AS Transaction_Type,
      a.Account_Number,
      a.Account_Type,
      a.Account_Holder_ID
    FROM
      building_transactions_table AS o
      LEFT JOIN preppindata.`2023w9_account_information` AS a ON o.Account_From = a.Account_Number
  ),
  union_transactions AS (
    SELECT
      *
    FROM
      outgoing_transactions
    UNION ALL
    SELECT
      *
    FROM
      incoming_transactions
  ),
  renaming_account_details AS (
    -- adding an additional column so we can union with the transactions
    SELECT
      Account_Number,
      Account_Type,
      Account_Holder_ID,
      Balance_Date AS DATE,
      Balance AS Amount,
      'Balance' AS Identifier
    FROM
      preppindata.`2023w9_account_information`
  ),
  cleaning_up_transactions AS (
    -- keeping the columns we need
    -- for outgoing transactions make the amount negative
    SELECT
      Account_Number,
      Account_Type,
      Account_Holder_ID,
      DATE,
      IF (Transaction_Type = "Outgoing", - Value, Value) AS Amount,
      Transaction_Type AS Identifier
    FROM
      union_transactions
    ORDER BY
      Account_Number,
      DATE ASC
  ),
  combining_transactions_balance AS (
    SELECT
      *
    FROM
      cleaning_up_transactions
    UNION ALL
    SELECT
      *
    FROM
      renaming_account_details
  ),
  create_ledger AS (
    SELECT
      *,
      RANK() OVER (
        PARTITION BY
          Account_Number
        ORDER BY
          DATE ASC
      ) AS RANK
    FROM
      combining_transactions_balance
    ORDER BY
      Account_Number,
      DATE ASC
  ),
  reorder_ledger AS (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY
          Account_Number
        ORDER BY
          RANK,
          Amount DESC
      ) AS Row_Nr
    FROM
      create_ledger
    ORDER BY
      Account_Number,
      row_nr ASC
  ),
  seperate_value_balance AS (
    SELECT
      Account_Number,
      DATE,
      IF (Identifier = 'Balance', NULL, Amount) AS Transaction_Value,
      Amount,
      Row_Nr
    FROM
      reorder_ledger
    ORDER BY
      Account_Number,
      DATE ASC
  )
SELECT
  Account_Number,
  DATE,
  Transaction_Value,
  SUM(Amount) OVER (
    PARTITION BY
      Account_Number
    ORDER BY
      Row_Nr
  ) AS Balance
FROM
  seperate_value_balance
GROUP BY
  Account_Number,
  row_nr,
  DATE,
  Transaction_Value,
  Amount
ORDER BY
  Account_Number,
  DATE