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

Custom Roles
=============

// Operate with the custom roles we had created
USE ROLE sales_admin;
USE sales_db;

-- Create a table --
create or replace table customers(
  id number,
  full_name varchar, 
  email varchar,
  phone varchar,
  create_date DATE DEFAULT CURRENT_DATE);

-- insert data in table --
insert into customers (id, full_name, email,phone)
values
  (1,'abc','abc@gmail.com','262-665-9168'),
  (2,'def','def@gmail.com','734-987-7120'),
  (3,'ghi','ghi@gmail.com','867-946-3659'),
  (4,'jkl','jkl@gmail.com','563-853-8192'),
  (5,'mno','mno@gmail.com','730-451-8637'),
  (6,'pqr','pqr@gmail.com','568-896-6138');
  
SHOW TABLES;


-- switch to sales_users role
USE ROLE sales_users;

SELECT* FROM CUSTOMERS;

-- switch back to admin role and grant access
USE ROLE sales_admin;

GRANT USAGE ON DATABASE sales_db TO ROLE sales_users;
GRANT USAGE ON SCHEMA sales_db.public TO ROLE sales_users;
GRANT SELECT ON TABLE sales_db.public.CUSTOMERS TO ROLE sales_users;


-- switch to sales_users role
USE ROLE sales_users;

SELECT* FROM CUSTOMERS;

-- try DML operations using sales_users role

DELETE FROM CUSTOMERS;
DROP TABLE CUSTOMERS;


-- switch back to admin role and grant delete/drop access
USE ROLE sales_admin;
GRANT ALL ON TABLE sales_db.public.CUSTOMERS TO ROLE sales_users;

-- switch to sales_users role
USE ROLE sales_users;
DELETE FROM CUSTOMERS;

-- you can't drop this object with All privileges, only owner can drop objects
DROP TABLE CUSTOMERS;

-- switch back to admin role and grant ownsership
USE ROLE sales_admin;
GRANT OWNERSHIP ON TABLE sales_db.public.CUSTOMERS TO ROLE sales_users;

-- Above query won't work, first we have to revoke other privileges then only we can grant ownership
REVOKE ALL ON TABLE sales_db.public.CUSTOMERS FROM ROLE SALES_USERS;

GRANT OWNERSHIP ON TABLE sales_db.public.CUSTOMERS TO ROLE SALES_USERS;

-- switch to sales_users role
USE ROLE sales_users;
DROP TABLE CUSTOMERS;


=================================================================================================================================================

// login with sECURITYADMIN and switch to USERADMIN
-- create roles
CREATE ROLE market_admin;
CREATE ROLE market_users;

-- Create hierarchy
GRANT ROLE market_users to ROLE market_admin;
GRANT ROLE market_admin to ROLE SYSADMIN;

-- create users and grant roles
CREATE USER bharath PASSWORD = 'abc123' DEFAULT_ROLE =  market_users 
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE market_users TO USER bharath;


CREATE USER chandra PASSWORD = 'abc123' DEFAULT_ROLE =  market_admin
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE market_admin TO USER chandra;




