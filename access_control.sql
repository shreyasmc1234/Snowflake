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


