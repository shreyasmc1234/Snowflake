=======================================
Data Sharing to Other Snowflake Users 
=======================================

CREATE DATABASE CUST_DB_Sample;


CREATE SCHEMA CUST_TBLS;
CREATE SCHEMA CUST_VIEWS;

CREATE TABLE CUST_DB_Sample.CUST_TBLS.CUSTOMER1
AS SELECT * FROM snowflake_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

CREATE TABLE CUST_DB_Sample.CUST_TBLS.ORDERS1
AS SELECT * FROM snowflake_SAMPLE_DATA.TPCH_SF1.ORDERS;


create or replace view normal_view
as select * from snowflake_SAMPLE_DATA.TPCH_SF1.ORDERS;

// Create a secure view in views schema
CREATE OR REPLACE SECURE VIEW CUST_VIEWS.SEC_VW_CUST
AS
SELECT CST.C_CUSTKEY, C_NAME,C_ADDRESS, C_PHONE 
FROM CUST_DB.CUST_TBLS.CUSTOMER1 CST;

// Create a  mat view in views schema
CREATE or replace MATERIALIZED VIEW CUST_DB.CUST_VIEWS.MAT_VW_ORDERS
AS
SELECT * FROM CUST_DB.CUST_TBLS.CUSTOMER1;

// Create a secure mat view in views schema
CREATE or replace SECURE MATERIALIZED VIEW CUST_DB.CUST_VIEWS.SEC_MAT_VW_ORDERS
AS
SELECT * FROM CUST_DB.CUST_TBLS.CUSTOMER1;

===============================

// Create a share 
// by using webui and by using sql statements


CREATE OR REPLACE SHARE CUST_DATA_SHARE_SAMPLE1;

// Grant access to share object
GRANT USAGE ON DATABASE CUST_DB_Sample TO SHARE CUST_DATA_SHARE_SAMPLE1; 

GRANT USAGE ON SCHEMA CUST_DB_Sample.CUST_TBLS TO SHARE CUST_DATA_SHARE_SAMPLE1; 
GRANT SELECT ON TABLE CUST_DB_Sample.CUST_TBLS.CUSTOMER1 TO SHARE CUST_DATA_SHARE_SAMPLE1; 
GRANT SELECT ON TABLE CUST_DB_Sample.CUST_TBLS.ORDERS1 TO SHARE CUST_DATA_SHARE_SAMPLE1;

GRANT USAGE ON SCHEMA CUST_DB_Sample.CUST_VIEWS TO SHARE CUST_DATA_SHARE_SAMPLE1; 
GRANT SELECT ON TABLE CUST_DB_Sample.CUST_VIEWS.NORMAL_VIEW TO SHARE CUST_DATA_SHARE_SAMPLE1; 
GRANT SELECT ON TABLE CUST_DB_Sample.CUST_VIEWS.SEC_VW_CUST TO SHARE CUST_DATA_SHARE_SAMPLE1;
GRANT SELECT ON TABLE CUST_DB_Sample.CUST_VIEWS.MAT_VW_ORDERS TO SHARE CUST_DATA_SHARE_SAMPLE1;
GRANT SELECT ON TABLE CUST_DB_Sample.CUST_VIEWS.SEC_MAT_VW_ORDERS TO SHARE CUST_DATA_SHARE_SAMPLE1;


// How to see share objects
SHOW SHARES; -- or we can use shares tab

// How to see the grants of a share object
SHOW GRANTS TO SHARE CUST_DATA_SHARE_SAMPLE1;

// Add the consumer account to share the data
ALTER SHARE CUST_DATA_SHARE ADD ACCOUNT =CRYVQTM.HC02067;


// How to share complete schema
GRANT SELECT ON ALL TABLES IN SCHEMA CUST_DB.CUST_TBLS TO SHARE CUST_DATA_SHARE;

// How to share complete database
GRANT SELECT ON ALL TABLES IN DATABASE CUST_DB TO SHARE CUST_DATA_SHARE;

=============================
Consumer side database setup
=============================

SHOW SHARES;

DESC SHARE share-name;

// Create a database to consume the shared data
CREATE DATABASE CUST_DB_SHARED FROM SHARE share-name;

SELECT * FROM CUST_DB_SHARED.CUST_TBLS.CUSTOMER;


====================================
Data Sharing to Non-Snowflake Users 
====================================

// Create a reader account

CREATE MANAGED ACCOUNT analyst
ADMIN_NAME = cust_analyst12,
ADMIN_PASSWORD = 'ramgowdas87392',
TYPE = READER;

{"accountName":"CUSTOMER_ANALYST","accountLocator":"SB46799","url":"https://tltpsug-customer_analyst.snowflakecomputing.com","accountLocatorUrl":"https://sb46799.central-india.azure.snowflakecomputing.com"}


// How to see reader accounts
SHOW MANAGED ACCOUNTS;

// Add reader account to share object
ALTER SHARE CUST_DATA_SHARE  ADD ACCOUNT = GP27367;

ALTER SHARE CUST_DATA_SHARE  ADD ACCOUNT =  reader-account-id
SHARE_RESTRICTIONS=false;


=============================
Reader side database setup
=============================

SHOW SHARES;

DESC SHARE share-name;

// Get url of reader account and login to that reader account

// Get inbound share details
SHOW SHARES;

// Create a database to consume the shared data
CREATE DATABASE CUST_DB_SHARED FROM SHARE share-name;

// Query the shared tables
SELECT * FROM CUST_DB_SHARED.CUST_TBLS.CUSTOMER;

// Create a virtual warehouse
CREATE WAREHOUSE READER_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE;


SELECT * FROM CUST_DB_SHARED.CUST_TBLS.CUSTOMER;

