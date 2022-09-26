-- compiled sql for creating the base table
-- step 1: adding usernames to opportunity table
WITH  opportunity_users AS (  
  SELECT
  o.Id AS OpportunityId,
  o.AccountId AS AccountId,
  o.Name AS OpportunityName,
  o.StageName,
  o.Amount,
  o.OwnerId,
  o.CreatedById,
  uc.Name AS CreatedByName,
  uo.Name AS OwnerName
  FROM preppindata.`2022w38_opportunity` AS o
    LEFT JOIN preppindata.`2022w38_account` AS a ON o.AccountId = a.Id
    INNER JOIN preppindata.`2022w38_user` AS uc ON o.CreatedById = uc.Id
    INNER JOIN preppindata.`2022w38_user` AS uo ON o.OwnerId = uo.Id),

-- step 2: adding usernames to the accounts table 
account_users AS (
  SELECT
  a.Id AS AccountId,
  a.Name AS AccountName,
  a.Type AS AccountType,
  uc.Name AS AccountCreatedByName,
  uo.Name AS AccountOwnerName
  FROM preppindata.`2022w38_account` AS a
    LEFT JOIN preppindata.`2022w38_user` AS uc ON a.CreatedById = uc.Id
    LEFT JOIN preppindata.`2022w38_user` AS uo ON a.OwnerId = uo.Id),
 
-- step 3: bringting it all together to create the basetable
SELECT
  OpportunityId,
  ou.AccountId,
  OpportunityName,
  StageName,
  Amount,
  OwnerId,
  CreatedById,
  CreatedByName,
  OwnerName,
  AccountName,
  AccountType,
  AccountCreatedByName,
  AccountOwnerName
FROM opportunity_users AS ou
  LEFT JOIN account_users AS au ON ou.AccountId = au.AccountId;

-- the questions
-- who is the opportunity owner with the hightest amount?
SELECT
OwnerName,
SUM(Amount) AS TotalAmount
FROM basetable
GROUP BY OwnerName
ORDER BY TotalAmount DESC;

-- who is the Account Owner with the Highest Amount? 
SELECT
AccountOwnerName,
SUM(Amount) AS TotalAmount
FROM basetable
GROUP BY AccountOwnerName;

-- which Account has the most Opportunities & Amount? 
SELECT
AccountName,
COUNT(DISTINCT OpportunityId) AS Total_Opportunities,
SUM(Amount) AS Total_Amount
FROM basetable;