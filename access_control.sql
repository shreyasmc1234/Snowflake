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


