-- hierarchy --> photos
![image](https://github.com/shreyasmc1234/Snowflake/blob/main/photos/Screenshot%202025-03-07%20111208.png)


-- In accountadmin role

create database rolesdb;

create schema sampleschema;

Create user shreyas password='Password59'
default_role=ACCOUNTADMIN
must_change_password=true;

grant role ACCOUNTADMIN to user shreyas;

create user shreya password='Password59'
default_role=securityadmin
must_change_password=true;

grant role securityadmin to user shreya;

create user nishma password='Password59'
default_role=sysadmin
must_change_password=true;

grant role sysadmin to user nishma;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Logged into to security admin and created the roles and users and granted them the required permissions

-- Logged in to security admin shreyas

CREATE ROLE sales_admin;
CREATE ROLE sales_users;

grant role sales_users to role sales_admin;
grant role sales_admin to role sysadmin;


create user ramasales password='Password59' default_role=sales_users
must_change_password=true;

grant role sales_users to user ramasales;

create user yashadmin password='Password59' 
default_role=sales_admin
must_change_password=true;

grant role sales_admin to user yashadmin;

=================================================================================================================================================

CREATE ROLE hr_admin;
CREATE ROLE hr_users;

grant role hr_users to role hr_admin;


create user ramahr password='Password59' default_role=hr_users
must_change_password=true;

grant role hr_users to user ramahr;

create user yashhr password='Password59' 
default_role=hr_admin
must_change_password=true;

grant role hr_admin to user yashhr;

=================================================================================================================================================
--logged in to nishma


CREATE WAREHOUSE public_wh 
WITH
WAREHOUSE_SIZE='SMALL'
AUTO_SUSPEND=300 
AUTO_RESUME= TRUE;

-- grant usage on warehouse to role public
GRANT USAGE ON WAREHOUSE public_wh 
TO ROLE PUBLIC

-- create database accessible to everyone
CREATE DATABASE public_db;
GRANT USAGE ON DATABASE public_db TO ROLE PUBLIC


// create sales database
CREATE DATABASE sales_db;

-- grant ownership to sales_admin that we had created using SECURITY ADMIN
GRANT OWNERSHIP ON DATABASE sales_db TO ROLE sales_admin;

-- now the owner of this database is sales_admin which is assigned to SYSADMIN
GRANT OWNERSHIP ON SCHEMA sales_db.public TO ROLE sales_admin;


// create hr database
CREATE DATABASE hr_db;

-- grant ownership to hr_admin that we had created using SECURITY ADMIN
GRANT OWNERSHIP ON DATABASE hr_db TO ROLE hr_admin;

-- now the owner of this database is hr_admin which is not assigned to SYSADMIN
GRANT OWNERSHIP ON SCHEMA hr_db.public TO ROLE hr_admin;

-- try to drop hr_db - but we can't drop
DROP DATABASE hr_db;

=================================================================================================================================================

-- custom roles






