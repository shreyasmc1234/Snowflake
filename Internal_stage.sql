connecting to snowsql

snowsql -a account_identifier -u user_name
enter password : *******

  or

snowsql -a tltpsug-ne11343
User: shre1234
Password: *****

shre1234#COMPUTE_WH@(no database).(no schema)>show warehouses;
+------------------------------+-----------+----------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+-------------------------------------------------------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+-----------+----------------+--------+-----------------+---------------------+
| name                         | state     | type     | size    | min_cluster_count | max_cluster_count | started_clusters | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment                                               | enable_query_acceleration | query_acceleration_max_scale_factor | resource_monitor | actives | pendings | failed | suspended | uuid      | scaling_policy | budget | owner_role_type | resource_constraint |
|------------------------------+-----------+----------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+-------------------------------------------------------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+-----------+----------------+--------+-----------------+---------------------|
| CLUSTER                      | SUSPENDED | STANDARD | X-Small |                 1 |                 1 |
 0 |       0 |      0 | N          | N          |          300 | true        |           |              |           |       | 2025-02-22 03:09:57.598 -0800 | 2025-02-23 03:30:40.312 -0800 | 2025-02-23 03:30:40.312 -0800 | ACCOUNTADMIN |                                                       | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 131063360 | STANDARD       | NULL   | ROLE            | NULL                |
| COPYINTO_WAREHOUSE           | SUSPENDED | STANDARD | Small   |                 1 |                 1 |
 0 |       0 |      0 | N          | N          |          300 | true        |           |              |           |       | 2025-02-22 18:12:27.361 -0800 | 2025-02-27 08:32:00.417 -0800 | 2025-02-27 08:32:00.417 -0800 | ACCOUNTADMIN |                                                       | false                     |                                   8 | null             |       0 |        0 |      0 |         2 | 131063364 | STANDARD       | NULL   | ROLE            | NULL                |
| PC_DBT_WH                    | SUSPENDED | STANDARD | X-Small |                 1 |                 1 |
 0 |       0 |      0 | N          | N          |           60 | true        |           |              |           |       | 2025-02-21 21:58:48.784 -0800 | 2025-02-27 08:31:38.363 -0800 | 2025-02-27 08:31:38.363 -0800 | ACCOUNTADMIN | System created warehouse for partner etl integration. | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 131063348 | STANDARD       | NULL   | ROLE            | NULL                |
| SAMPLE_WAREHOUSE             | SUSPENDED | STANDARD | X-Small |                 1 |                 4 |
 0 |       0 |      0 | N          | N          |          300 | true        |           |              |           |       | 2025-02-21 20:57:20.161 -0800 | 2025-02-21 21:59:45.501 -0800 | 2025-02-21 21:59:45.501 -0800 | ACCOUNTADMIN |                                                       | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 131063336 | STANDARD       | NULL   | ROLE            | NULL                |
| SMALL_WAREHOUSE              | SUSPENDED | STANDARD | X-Small |                 1 |                 1 |
 0 |       0 |      0 | N          | N          |          300 | true        |           |              |           |       | 2025-02-22 02:17:42.571 -0800 | 2025-02-22 02:55:45.968 -0800 | 2025-02-22 02:55:45.968 -0800 | ACCOUNTADMIN | To practice the warehousing conecpt                   | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 131063352 | STANDARD       | NULL   | ROLE            | NULL                |
| SYSTEM$STREAMLIT_NOTEBOOK_WH | SUSPENDED | STANDARD | X-Small |                 1 |                10 |
 0 |       0 |      0 | N          | N          |           60 | true        |           |              |           |       | 2025-02-10 04:04:08.265 -0800 | 2025-02-10 04:04:08.274 -0800 | 2025-02-10 04:04:08.299 -0800 |              |                                                       | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 131063300 | STANDARD       | NULL   |                 | NULL                |
+------------------------------+-----------+----------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+-------------------------------------------------------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+-----------+----------------+--------+-----------------+---------------------+
6 Row(s) produced. Time Elapsed: 0.205s    

shre1234#COMPUTE_WH@(no database).(no schema)>use warehouse COPYINTO_WAREHOUSE;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.169s
  
shre1234#COPYINTO_WAREHOUSE@(no database).(no schema)>use database MYDB;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.144s
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>use SCHEMA PUBLIC;
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+
1 Row(s) produced. Time Elapsed: 0.098s

shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>create table emp(
                                        empid varchar(100),
                                        empname varchar(60),
                                        sal integer,
                                        deptid integer);
+---------------------------------+
| status                          |
|---------------------------------|
| Table EMP successfully created. |
+---------------------------------+
1 Row(s) produced. Time Elapsed: 0.344s

shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>INSERT INTO emp (EMPID,EMPNAME,sal,DEPTID) VALUES
                                                                                    (101, 'Asha', 25000, 2),
                                                                                    (102, 'Shreya', 60000, 1),
                                                                                    (103, 'Nishu', 70000, 2);
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+

shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>select * from emp;
+-------+---------+-------+--------+
| EMPID | EMPNAME |   SAL | DEPTID |
|-------+---------+-------+--------|
| 101   | Asha    | 25000 |      2 |
| 102   | Shreya  | 60000 |      1 |
| 103   | Nishu   | 70000 |      2 |
+-------+---------+-------+--------+
3 Row(s) produced. Time Elapsed: 0.550s
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>list @~;
+------+------+-----+---------------+
| name | size | md5 | last_modified |
|------+------+-----+---------------|
+------+------+-----+---------------+
0 Row(s) produced. Time Elapsed: 0.274s

--User Stage
  
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>put file://C:\Users\shrey\Downloads\customer_data_user.csv @~/staged;
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                 | target                    | source_size | target_size | source_compression | target_compression | status   | message |
|------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| customer_data_user.csv | customer_data_user.csv.gz |        1720 |        1040 | NONE               | GZIP               | UPLOADED |         |
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.500s
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>list @~;
+----------------------------------+------+----------------------------------+-------------------------------+
| name                             | size | md5                              | last_modified                 |
|----------------------------------+------+----------------------------------+-------------------------------|
| staged/customer_data_user.csv.gz | 1040 | 6dc45c9507759e5c39498e909293040b | Thu, 27 Feb 2025 16:56:26 GMT |
+----------------------------------+------+----------------------------------+-------------------------------+
1 Row(s) produced. Time Elapsed: 0.147s
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>list @~staged
                                        ;
002003 (02000): SQL compilation error:
Stage '"~STAGED"' does not exist or not authorized.
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>list @~/staged;
+----------------------------------+------+----------------------------------+-------------------------------+
| name                             | size | md5                              | last_modified                 |
|----------------------------------+------+----------------------------------+-------------------------------|
| staged/customer_data_user.csv.gz | 1040 | 6dc45c9507759e5c39498e909293040b | Thu, 27 Feb 2025 16:56:26 GMT |
+----------------------------------+------+----------------------------------+-------------------------------+
1 Row(s) produced. Time Elapsed: 0.514s

--Table stage
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>CREATE OR REPLACE TABLE mydb.public.customer_data_table (
                                        customerid NUMBER,
                                        custname STRING,
                                        email STRING,
                                        city STRING,
                                        state STRING,
                                        DOB DATE
                                        );

+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Table CUSTOMER_DATA_TABLE successfully created. |
+-------------------------------------------------+

shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>put file://C:\Users\shrey\Downloads\customer_data_user.csv @%customer_data_table;
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                 | target                    | source_size | target_size | source_compression | target_compression | status   | message |
|------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| customer_data_user.csv | customer_data_user.csv.gz |        1720 |        1040 | NONE               | GZIP               | UPLOADED |         |
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.853s

missing stage name in URL: com.snowflake.sql.common.LiteralSupplier$StringLiteralSupplier@3c5d56aa
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>list @%customer_data_table;
+---------------------------+------+----------------------------------+-------------------------------+
| name                      | size | md5                              | last_modified                 |
|---------------------------+------+----------------------------------+-------------------------------|
| customer_data_user.csv.gz | 1040 | 9580e694f2ba0f80ad68f9e230d601dd | Thu, 27 Feb 2025 17:02:49 GMT |
+---------------------------+------+----------------------------------+-------------------------------+
1 Row(s) produced. Time Elapsed: 0.503s
  
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>put file://C:\Users\shrey\Downloads\customer_data_user.csv @%customer_data_table;
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+---------+---------+
| source                 | target                    | source_size | target_size | source_compression | target_compression | status  | message |
|------------------------+---------------------------+-------------+-------------+--------------------+--------------------+---------+---------|
| customer_data_user.csv | customer_data_user.csv.gz |        1720 |           0 | NONE               | GZIP               | SKIPPED |         |
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+---------+---------+
1 Row(s) produced. Time Elapsed: 0.613s
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>

--Internal named stage 
shre1234#COPYINTO_WAREHOUSE@MYDB.PUBLIC>create or replace schema internal_stage;
+---------------------------------------------+
| status                                      |
|---------------------------------------------|
| Schema INTERNAL_STAGE successfully created. |
+---------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.196s

shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>create or replace stage named_customer_stage;
+-------------------------------------------------------+
| status                                                |
|-------------------------------------------------------|
| Stage area NAMED_CUSTOMER_STAGE successfully created. |
+-------------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.239s

  shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>show stages;
+-------------------------------+----------------------+---------------+----------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+----------+-----------------+-------------------+
| created_on                    | name                 | database_name | schema_name    | url | has_credentials | has_encryption_key | owner        | comment | region | type     | cloud | notification_channel | storage_integration | endpoint | owner_role_type | directory_enabled |
|-------------------------------+----------------------+---------------+----------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+----------+-----------------+-------------------|
| 2025-02-27 09:06:44.785 -0800 | NAMED_CUSTOMER_STAGE | MYDB          | INTERNAL_STAGE |     | N               | N                  | ACCOUNTADMIN |         | NULL   | INTERNAL | NULL  | NULL                 | NULL                | NULL     | ROLE            | N                 |
+-------------------------------+----------------------+---------------+----------------+-----+-----------------+--------------------+--------------+---------+--------+----------+-------+----------------------+---------------------+----------+-----------------+-------------------+
1 Row(s) produced. Time Elapsed: 0.184s

  shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>put file://C:\Users\shrey\Downloads\customer_data_user.csv @mydb.internal_stage.
                                                named_customer_stage;
001003 (42000): SQL compilation error:
syntax error line 2 at position 20 unexpected ';'.
shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>put file://C:\Users\shrey\Downloads\customer_data_user.csv @named_customer_stage;
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                 | target                    | source_size | target_size | source_compression | target_compression | status   | message |
|------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| customer_data_user.csv | customer_data_user.csv.gz |        1720 |        1040 | NONE               | GZIP               | UPLOADED |         |
+------------------------+---------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 1.412s


shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>list @named_customer_stage;
+------------------------------------------------+------+----------------------------------+-------------------------------+
| name                                           | size | md5                              | last_modified                 |
|------------------------------------------------+------+----------------------------------+-------------------------------|
| named_customer_stage/customer_data_user.csv.gz | 1040 | 1665d6ec607e0d7c19a6cc20116ebc2a | Thu, 27 Feb 2025 17:09:18 GMT |
+------------------------------------------------+------+----------------------------------+-------------------------------+
1 Row(s) produced. Time Elapsed: 0.174s

--Loading the data into table
shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>copy into mydb.public.customer_data_table
                                                from @MYDB.INTERNAL_STAGE.named_customer_stage
                                                file_format=(type=csv,field_delimiter = '|' skip_header = 1 ) ;
+------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                           | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| named_customer_stage/customer_data_user.csv.gz | LOADED |          19 |          19 |           1 |           0 | NULL        |             NULL |
         NULL | NULL                    |
+------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 1.462s
shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@MYDB.INTERNAL_STAGE>select count(8) from  mydb.public.customer_data_table;
+----------+
| COUNT(8) |
|----------|
|       19 |
+----------+
1 Row(s) produced. Time Elapsed: 0.140s







