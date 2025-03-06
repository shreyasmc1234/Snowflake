select current_role();

CURRENT_ROLE()
SECURITYADMIN

--I don't have access to create databases or tables or schema in this security admin role. so swithing to account admin and granting the access

use role accountadmin;


GRANT CREATE DATABASE ON ACCOUNT TO ROLE SECURITYADMIN;

GRANT CREATE SCHEMA ON DATABASE <database_name> TO ROLE <your_role>;
GRANT CREATE TABLE ON SCHEMA <schema_name> TO ROLE <your_role>;

GRANT IMPORTED PRIVILEGES ON D=================
Masking Policies 
=================

--we cannot apply masking policy to shared data

// Try to clone from sample data -- we can't clone tables from shared databases
CREATE TABLE mask.samp.CUSTOMER
CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

// Create a sample table
CREATE TABLE mask.samp.CUSTOMER
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

SELECT * FROM PUBLIC.CUSTOMER;

// Grant access to other roles
GRANT USAGE ON DATABASE mask TO ROLE useradmin;
GRANT USAGE ON SCHEMA mask.samp TO ROLE useradmin;
GRANT SELECT ON TABLE mask.samp.CUSTOMER TO ROLE useradmin;

GRANT USAGE ON DATABASE mask TO ROLE sysadmin;
GRANT USAGE ON SCHEMA mask.samp TO ROLE sysadmin;
GRANT SELECT ON TABLE mask.samp.CUSTOMER TO ROLE sysadmin;

GRANT USAGE ON DATABASE mask TO ROLE pc_dbt_role;
GRANT USAGE ON SCHEMA mask.samp TO ROLE pc_dbt_role;
GRANT SELECT ON TABLE mask.samp.CUSTOMER TO ROLE pc_dbt_role;

GRANT USAGE ON DATABASE mask TO ROLE orgadmin;
GRANT USAGE ON SCHEMA mask.samp TO ROLE orgadmin;
GRANT SELECT ON TABLE mask.samp.CUSTOMER TO ROLE orgadmin;

======================

// Want to Hide Phone and Account Balance
CREATE OR REPLACE MASKING POLICY customer_phone 
    as (val string) returns string->
CASE WHEN CURRENT_ROLE() in ('useradmin') THEN val
    ELSE '##-###-###-'||SUBSTRING(val,12,4) 
    END;

select top 10 * from mask.samp.CUSTOMER
    
CREATE OR REPLACE MASKING POLICY customer_accbal 
    as (val number) returns number->
CASE WHEN CURRENT_ROLE() in ('orgadmin') THEN val
    ELSE '####' 
    END;
    
    
CREATE OR REPLACE MASKING POLICY customer_accbal2
    as (val number) returns number->
CASE WHEN CURRENT_ROLE() in ('sysadmin') THEN val
    ELSE 0 
    END;
    

// Apply masking policies on columns of CUSTOMER table
ALTER TABLE mask.samp.CUSTOMER MODIFY COLUMN C_PHONE
    SET MASKING POLICY customer_phone;
    
ALTER TABLE mask.samp.CUSTOMER MODIFY COLUMN C_ACCTBAL
    SET MASKING POLICY customer_accbal2;
    
// switch to sales_users and see the data
USE ROLE useradmin;

SELECT * FROM mask.samp.CUSTOMER;

GRANT USAGE ON WAREHOUSE copyinto_warehouse TO ROLE orgadmin;


// Unset policy customer_accbal and set to customer_accbal2
ALTER TABLE mask.samp.CUSTOMER MODIFY COLUMN C_ACCTBAL
    UNSET MASKING POLICY;

ALTER TABLE mask.samp.CUSTOMER MODIFY COLUMN C_ACCTBAL
    SET MASKING POLICY customer_accbal2;
    
    
// switch to sales_admin and see the data
USE ROLE useradmin;

SELECT * FROM mask.samp.CUSTOMER;

USE ROLE sysadmin;


// Altering policies
ALTER MASKING POLICY customer_phone SET body ->
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##########' 
    END;

// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM PUBLIC.CUSTOMER;

// To see masking policies
USE ROLE SYSADMIN;

SHOW MASKING POLICIES;

DESC MASKING POLICY CUSTOMER_PHONE;

// To see wherever you applied the policy
SELECT * FROM table(information_schema.policy_references(policy_name=>'CUSTOMER_PHONE'));


// Applying on views
ALTER VIEW MYVIEWS.VW_CUSTOMER MODIFY COLUMN C_PHONE
    SET MASKING POLICY customer_phone;
    
// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM MYVIEWS.VW_CUSTOMER;


// Dropping masking policies
DROP MASKING POLICY customer_phone;

ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    UNSET MASKING POLICY;
    
DROP MASKING POLICY customer_accbal2;
ATABASE snowflake_sample_data TO ROLE securityadmin;

show grants;

use mask.samp;


=================
Masking Policies 
=================
USE DATABASE PUBLIC_DB;

// Create a schema for policies
CREATE SCHEMA MYPOLICIES ;

// Try to clone from sample data -- we can't clone tables from shared databases
CREATE TABLE PUBLIC.CUSTOMER
CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

// Create a sample table
CREATE TABLE PUBLIC.CUSTOMER
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

SELECT * FROM PUBLIC.CUSTOMER;

// Grant access to other roles
GRANT USAGE ON DATABASE PUBLIC_DB TO ROLE sales_users;
GRANT USAGE ON SCHEMA PUBLIC_DB.public TO ROLE sales_users;
GRANT SELECT ON TABLE PUBLIC_DB.public.CUSTOMER TO ROLE sales_users;

GRANT USAGE ON DATABASE PUBLIC_DB TO ROLE sales_admin;
GRANT USAGE ON SCHEMA PUBLIC_DB.public TO ROLE sales_admin;
GRANT SELECT ON TABLE PUBLIC_DB.public.CUSTOMER TO ROLE sales_admin;

GRANT USAGE ON DATABASE PUBLIC_DB TO ROLE market_users;
GRANT USAGE ON SCHEMA PUBLIC_DB.public TO ROLE market_users;
GRANT SELECT ON TABLE PUBLIC_DB.public.CUSTOMER TO ROLE market_users;

GRANT USAGE ON DATABASE PUBLIC_DB TO ROLE market_admin;
GRANT USAGE ON SCHEMA PUBLIC_DB.public TO ROLE market_admin;
GRANT SELECT ON TABLE PUBLIC_DB.public.CUSTOMER TO ROLE market_admin;

======================

// Want to Hide Phone and Account Balance
CREATE OR REPLACE MASKING POLICY customer_phone 
    as (val string) returns string->
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##-###-###-'||SUBSTRING(val,12,4) 
    END;
    
    
CREATE OR REPLACE MASKING POLICY customer_accbal 
    as (val number) returns number->
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '####' 
    END;
    
    
CREATE OR REPLACE MASKING POLICY customer_accbal2
    as (val number) returns number->
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE 0 
    END;
    

// Apply masking policies on columns of CUSTOMER table
ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_PHONE
    SET MASKING POLICY customer_phone;
    
ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    SET MASKING POLICY customer_accbal;
    
// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM PUBLIC.CUSTOMER;

// Unset policy customer_accbal and set to customer_accbal2
ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    UNSET MASKING POLICY;

ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    SET MASKING POLICY customer_accbal2;
    
    
// switch to sales_admin and see the data
USE ROLE sales_admin;

SELECT * FROM PUBLIC.CUSTOMER;


// Altering policies
ALTER MASKING POLICY customer_phone SET body ->
CASE WHEN CURRENT_ROLE() in ('SALES_ADMIN', 'MARKET_ADMIN') THEN val
    ELSE '##########' 
    END;

// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM PUBLIC.CUSTOMER;

// To see masking policies
USE ROLE SYSADMIN;

SHOW MASKING POLICIES;

DESC MASKING POLICY CUSTOMER_PHONE;

// To see wherever you applied the policy
SELECT * FROM table(information_schema.policy_references(policy_name=>'CUSTOMER_PHONE'));


// Applying on views
ALTER VIEW MYVIEWS.VW_CUSTOMER MODIFY COLUMN C_PHONE
    SET MASKING POLICY customer_phone;
    
// switch to sales_users and see the data
USE ROLE sales_users;

SELECT * FROM MYVIEWS.VW_CUSTOMER;


// Dropping masking policies
DROP MASKING POLICY customer_phone;

ALTER TABLE PUBLIC.CUSTOMER MODIFY COLUMN C_ACCTBAL
    UNSET MASKING POLICY;
    
DROP MASKING POLICY customer_accbal2;

