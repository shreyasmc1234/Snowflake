shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>CREATE OR REPLACE TABLE  COPY_INTO.INTERNAL_STAGE.TBL_ORDERS (
                                                         ORDER_ID VARCHAR(30),
                                                         AMOUNT VARCHAR(30),
                                                         PROFIT INT,
                                                         QUANTITY INT,
                                                         CATEGORY VARCHAR(30),
                                                         SUBCATEGORY VARCHAR(30));

+----------------------------------------+
| status                                 |
|----------------------------------------|
| Table TBL_ORDERS successfully created. |
+----------------------------------------+
1 Row(s) produced. Time Elapsed: 0.440s
  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>show tables;
+-------------------------------+--------------+---------------+----------------+-------+---------+------------+------+-------+--------------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+-------------------------+-----------------+----------+--------+-----------+------------+------------+--------------+
| created_on                    | name         | database_name | schema_name    | kind  | comment | cluster_by | rows | bytes | owner        | retention_time | automatic_clustering | change_tracking | search_optimization | search_optimization_progress | search_optimization_bytes | is_external | enable_schema_evolution | owner_role_type | is_event | budget | is_hybrid | is_iceberg | is_dynamic | is_immutable |
|-------------------------------+--------------+---------------+----------------+-------+---------+------------+------+-------+--------------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+-------------------------+-----------------+----------+--------+-----------+------------+------------+--------------|
| 2025-02-27 17:15:21.040 -0800 | TBL_ORDERS   | COPY_INTO     | INTERNAL_STAGE | TABLE |         |            |    0 |     0 | ACCOUNTADMIN | 1              | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           | N
| ROLE            | N        | NULL   | N         | N          | N          | N            |
| 2025-02-22 18:18:38.623 -0800 | LOAN_PAYMENT | COPY_INTO     | PUBLIC         | TABLE |         |            |  500 | 14336 | ACCOUNTADMIN | 1              | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           | N
| ROLE            | N        | NULL   | N         | N          | N          | N            |
+-------------------------------+--------------+---------------+----------------+-------+---------+------------+------+-------+--------------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+-------------------------+-----------------+----------+--------+-----------+------------+------------+--------------+

  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage COPY_INTO.INTERNAL_STAGE.stage
                                                     url='s3://snowflakebucket-copyoption/size/';
+----------------------------------------+
| status                                 |
|----------------------------------------|
| Stage area STAGE successfully created. |
+----------------------------------------+
1 Row(s) produced. Time Elapsed: 1.228s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>list @stage;
+--------------------------------------------------+-------+----------------------------------+-------------------------------+
| name                                             |  size | md5                              | last_modified                 |
|--------------------------------------------------+-------+----------------------------------+-------------------------------|
| s3://snowflakebucket-copyoption/size/Orders.csv  | 54600 | 1a1c4a47a8e8e43ecef5bf8a46ee4017 | Wed, 28 Apr 2021 16:14:06 GMT |
| s3://snowflakebucket-copyoption/size/Orders2.csv | 54598 | 36bcccace29563ceb1f86a62f599dba3 | Wed, 28 Apr 2021 16:29:32 GMT |
+--------------------------------------------------+-------+----------------------------------+-------------------------------+
2 Row(s) produced. Time Elapsed: 0.709s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>select current_date;
+--------------+
| CURRENT_DATE |
|--------------|
| 2025-02-27   |
+--------------+

--validation_mode
  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into COPY_INTO.INTERNAL_STAGE.TBL_ORDERS
                                                     from @COPY_INTO.INTERNAL_STAGE.stage
                                                     file_format=(type = csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Orders.*'
                                                     validation_mode=return_errors;
+-------+------+------+-----------+-------------+----------+------+-----------+-------------+------------+----------------+-----------------+
| ERROR | FILE | LINE | CHARACTER | BYTE_OFFSET | CATEGORY | CODE | SQL_STATE | COLUMN_NAME | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD |
|-------+------+------+-----------+-------------+----------+------+-----------+-------------+------------+----------------+-----------------|
+-------+------+------+-----------+-------------+----------+------+-----------+-------------+------------+----------------+-----------------+
0 Row(s) produced. Time Elapsed: 4.444s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into COPY_INTO.INTERNAL_STAGE.TBL_ORDERS
                                                     from @COPY_INTO.INTERNAL_STAGE.stage
                                                     file_format=(type=csv skip_header=1 field_delimiter=',')
                                                     pattern='.*Order.*'
                                                     validation_Mode=return_all_errors;
+-------+------+------+-----------+-------------+----------+------+-----------+-------------+------------+----------------+-----------------+
| ERROR | FILE | LINE | CHARACTER | BYTE_OFFSET | CATEGORY | CODE | SQL_STATE | COLUMN_NAME | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD |
|-------+------+------+-----------+-------------+----------+------+-----------+-------------+------------+----------------+-----------------|
+-------+------+------+-----------+-------------+----------+------+-----------+-------------+------------+----------------+-----------------+
0 Row(s) produced. Time Elapsed: 2.253s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into COPY_INTO.INTERNAL_STAGE.TBL_ORDERS
                                                     from @COPY_INTO.INTERNAL_STAGE.stage
                                                     file_format=(type=csv skip_header=1 field_delimiter=',')
                                                     pattern='.*Order.*'
                                                     validation_Mode=return_10_rows;
+----------+--------+--------+----------+-------------+------------------+
| ORDER_ID | AMOUNT | PROFIT | QUANTITY | CATEGORY    | SUBCATEGORY      |
|----------+--------+--------+----------+-------------+------------------|
| B-25601  | 1275   |  -1148 |        7 | Furniture   | Bookcases        |
| B-25601  | 66     |    -12 |        5 | Clothing    | Stole            |
| B-25601  | 8      |     -2 |        3 | Clothing    | Hankerchief      |
| B-25601  | 80     |    -56 |        4 | Electronics | Electronic Games |
| B-25602  | 168    |   -111 |        2 | Electronics | Phones           |
| B-25602  | 424    |   -272 |        5 | Electronics | Phones           |
| B-25602  | 2617   |   1151 |        4 | Electronics | Phones           |
| B-25602  | 561    |    212 |        3 | Clothing    | Saree            |
| B-25602  | 119    |     -5 |        8 | Clothing    | Saree            |
| B-25603  | 1355   |    -60 |        5 | Clothing    | Trousers         |
+----------+--------+--------+----------+-------------+------------------+
10 Row(s) produced. Time Elapsed: 1.687s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage  COPY_INTO.INTERNAL_STAGE.stage_error
                                                     url='s3://snowflakebucket-copyoption/returnfailed/';
+----------------------------------------------+
| status                                       |
|----------------------------------------------|
| Stage area STAGE_ERROR successfully created. |
+----------------------------------------------+
1 Row(s) produced. Time Elapsed: 1.134s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>list @stage_error;
+-----------------------------------------------------------------------------+-------+----------------------------------+-------------------------------+
| name                                                                        |  size | md5                              | last_modified                 |
|-----------------------------------------------------------------------------+-------+----------------------------------+-------------------------------|
| s3://snowflakebucket-copyoption/returnfailed/OrderDetails_error.csv         | 54622 | 99bb5d5b87e74256ca04c91359204dba | Wed, 28 Apr 2021 16:36:24 GMT |
| s3://snowflakebucket-copyoption/returnfailed/OrderDetails_error2 - Copy.csv | 10514 | 7c9dc0c0c8e6a9b82173c3df091a746a | Thu, 29 Apr 2021 08:02:50 GMT |
| s3://snowflakebucket-copyoption/returnfailed/Orders.csv                     | 54597 | cf56c5cfede468cdcacac48d7ab67e75 | Wed, 28 Apr 2021 16:36:06 GMT |
| s3://snowflakebucket-copyoption/returnfailed/Orders2.csv                    | 54598 | 36bcccace29563ceb1f86a62f599dba3 | Wed, 28 Apr 2021 16:36:07 GMT |
+-----------------------------------------------------------------------------+-------+----------------------------------+-------------------------------+
4 Row(s) produced. Time Elapsed: 1.032s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into COPY_INTO.INTERNAL_STAGE.TBL_ORDERS
                                                     from @COPY_INTO.INTERNAL_STAGE.stage_error
                                                     file_format=(type=csv skip_header=1 field_delimiter=',')
                                                     pattern='.*Order.*'
                                                     validation_Mode=return_errors;
+------------------------------------------------------+---------------------------------------------+------+-----------+-------------+------------+--------+-----------+----------------------------+------------+----------------+-------------------------------------------------+
| ERROR                                                | FILE                                        | LINE | CHARACTER | BYTE_OFFSET | CATEGORY   |   CODE | SQL_STATE | COLUMN_NAME                | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD                                 |
|------------------------------------------------------+---------------------------------------------+------+-----------+-------------+------------+--------+-----------+----------------------------+------------+----------------+-------------------------------------------------|
| Numeric value 'one thousand' is not recognized       | returnfailed/OrderDetails_error.csv         |    2 |        14 |          68 | conversion | 100038 | 22018     | "TBL_ORDERS"["PROFIT":3]   |          1 |              2 | B-25601,1275,one thousand,7,Furniture,Bookcases |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
| Numeric value 'two hundred twenty' is not recognized | returnfailed/OrderDetails_error.csv         |    3 |        12 |         115 | conversion | 100038 | 22018     | "TBL_ORDERS"["PROFIT":3]   |          2 |              3 | B-25601,66,two hundred twenty,5,Clothing,Stole  |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
| Numeric value '7-' is not recognized                 | returnfailed/OrderDetails_error2 - Copy.csv |    2 |        17 |          71 | conversion | 100038 | 22018     | "TBL_ORDERS"["QUANTITY":4] |          1 |              2 | B-30601,1275,10,7-,Furniture,Bookcases          |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
| Numeric value '3a' is not recognized                 | returnfailed/OrderDetails_error2 - Copy.csv |    4 |        16 |         143 | conversion | 100038 | 22018     | "TBL_ORDERS"["QUANTITY":4] |          3 |              4 | B-30601,8,-244,3a,Clothing,Hankerchief          |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
|                                                      |                                             |      |           |             |            |        |           |                            |            |                |                                                 |
+------------------------------------------------------+---------------------------------------------+------+-----------+-------------+------------+--------+-----------+----------------------------+------------+----------------+-------------------------------------------------+
4 Row(s) produced. Time Elapsed: 1.993s

--RETURN_FAILED_ONLY
  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into COPY_INTO.INTERNAL_STAGE.TBL_ORDERS
                                                     from @COPY_INTO.INTERNAL_STAGE.stage_error
                                                     file_format=(type=csv skip_header=1 field_delimiter=',')
                                                     pattern='.*Order.*'
                                                     validation_Mode=return_10_rows;
100038 (22018): Numeric value '7-' is not recognized
  File 'returnfailed/OrderDetails_error2 - Copy.csv', line 2, character 17
  Row 1, column "TBL_ORDERS"["QUANTITY":4]
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace table copy_into.internal_stage.returnfailedonly(
                                                     ORDER_ID VARCHAR(30),
                                                         AMOUNT VARCHAR(30),
                                                         PROFIT INT,
                                                         QUANTITY INT,
                                                         CATEGORY VARCHAR(30),
                                                         SUBCATEGORY VARCHAR(30));
+----------------------------------------------+
| status                                       |
|----------------------------------------------|
| Table RETURNFAILEDONLY successfully created. |
+----------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.221s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage COPY_INTO.INTERNAL_STAGE.stage2
                                                     url='s3://snowflakebucket-copyoption/returnfailed/';
+-----------------------------------------+
| status                                  |
|-----------------------------------------|
| Stage area STAGE2 successfully created. |
+-----------------------------------------+
1 Row(s) produced. Time Elapsed: 0.152s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.returnfailedonly
                                                     from @COPY_INTO.INTERNAL_STAGE.stage2
                                                     file_format= (type = csv field_delimiter=',' skip_header=1)
                                                         pattern='.*Order.*'
                                                         RETURN_FAILED_ONLY = TRUE;
100038 (22018): Numeric value '7-' is not recognized
  File 'returnfailed/OrderDetails_error2 - Copy.csv', line 2, character 17
  Row 1, column "RETURNFAILEDONLY"["QUANTITY":4]
  If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. For more information on loading options, please run 'info loading_data' in a SQL client.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>


--On_error
  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace table copy_into.internal_stage.on_error(
                                                      ORDER_ID VARCHAR(30),
                                                         AMOUNT VARCHAR(30),
                                                         PROFIT INT,
                                                         QUANTITY INT,
                                                         CATEGORY VARCHAR(30),
                                                         SUBCATEGORY VARCHAR(30));

+--------------------------------------+
| status                               |
|--------------------------------------|
| Table ON_ERROR successfully created. |
+--------------------------------------+
1 Row(s) produced. Time Elapsed: 0.416s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage copy_into.internal_stage.on_error_stage
                                                         url='s3://snowflakebucket-copyoption/returnfailed/';
+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Stage area ON_ERROR_STAGE successfully created. |
+-------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.206s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into  copy_into.internal_stage.on_error
                                                     from @copy_into.internal_stage.on_error_stage
                                                     file_format= (type = csv field_delimiter=',' skip_header=1)
                                                         pattern='.*Order.*';

100038 (22018): Numeric value '7-' is not recognized
  File 'returnfailed/OrderDetails_error2 - Copy.csv', line 2, character 17
  Row 1, column "ON_ERROR"["QUANTITY":4]
  If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. For more information on loading options, please run 'info loading_data' in a SQL client.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into  copy_into.internal_stage.on_error
                                                     from @copy_into.internal_stage.on_error_stage
                                                     file_format= (type = csv field_delimiter=',' skip_header=1)
                                                         pattern='.*Order.*';

100038 (22018): Numeric value '7-' is not recognized
  File 'returnfailed/OrderDetails_error2 - Copy.csv', line 2, character 17
  Row 1, column "ON_ERROR"["QUANTITY":4]
  If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. For more information on loading options, please run 'info loading_data' in a SQL client.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into  copy_into.internal_stage.on_error
                                                     from @copy_into.internal_stage.on_error_stage
                                                     file_format= (type = csv field_delimiter=',' skip_header=1)
                                                         pattern='.*Order.*'
                                                         on_error=continue;

+-----------------------------------------------------------------------------+------------------+-------------+-------------+-------------+-------------+------------------------------------------------+------------------+-----------------------+--------------------------+
| file                                                                        | status           | rows_parsed | rows_loaded | error_limit | errors_seen | first_error                                    | first_error_line | first_error_character | first_error_column_name  |
|-----------------------------------------------------------------------------+------------------+-------------+-------------+-------------+-------------+------------------------------------------------+------------------+-----------------------+--------------------------|
| s3://snowflakebucket-copyoption/returnfailed/OrderDetails_error2 - Copy.csv | PARTIALLY_LOADED |         285 |         283 |         285 |           2 | Numeric value '7-' is not recognized           |                2 |                    17 | "ON_ERROR"["QUANTITY":4] |
| s3://snowflakebucket-copyoption/returnfailed/Orders.csv                     | LOADED           |        1500 |        1500 |        1500 |           0 | NULL                                           |             NULL |                  NULL | NULL                     |
| s3://snowflakebucket-copyoption/returnfailed/Orders2.csv                    | LOADED           |        1500 |        1500 |        1500 |           0 | NULL                                           |             NULL |                  NULL | NULL                     |
| s3://snowflakebucket-copyoption/returnfailed/OrderDetails_error.csv         | PARTIALLY_LOADED |        1500 |        1498 |        1500 |           2 | Numeric value 'one thousand' is not recognized |                2 |                    14 | "ON_ERROR"["PROFIT":3]   |
+-----------------------------------------------------------------------------+------------------+-------------+-------------+-------------+-------------+------------------------------------------------+------------------+-----------------------+--------------------------+
4 Row(s) produced. Time Elapsed: 1.785s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace table copy_into.internal_stage.force(

shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>CREATE OR REPLACE TABLE   copy_into.internal_stage.force (
                                                         ORDER_ID VARCHAR(30),
                                                         AMOUNT VARCHAR(30),
                                                         PROFIT INT,
                                                         QUANTITY INT,
                                                         CATEGORY VARCHAR(30),
                                                         SUBCATEGORY VARCHAR(30));

+-----------------------------------+
| status                            |
|-----------------------------------|
| Table FORCE successfully created. |
+-----------------------------------+
1 Row(s) produced. Time Elapsed: 0.185s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>CREATE OR REPLACE STAGE  copy_into.internal_stage.force1
                                                         url='s3://snowflakebucket-copyoption/size/';

+-----------------------------------------+
| status                                  |
|-----------------------------------------|
| Stage area FORCE1 successfully created. |
+-----------------------------------------+
1 Row(s) produced. Time Elapsed: 0.128s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>LIST @MYDB.EXT_STAGES.sample_aws_stage;
002003 (02000): SQL compilation error:
Schema 'MYDB.EXT_STAGES' does not exist or not authorized.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>list @copy_into.internal_stage.force1;
+--------------------------------------------------+-------+----------------------------------+-------------------------------+
| name                                             |  size | md5                              | last_modified                 |
|--------------------------------------------------+-------+----------------------------------+-------------------------------|
| s3://snowflakebucket-copyoption/size/Orders.csv  | 54600 | 1a1c4a47a8e8e43ecef5bf8a46ee4017 | Wed, 28 Apr 2021 16:14:06 GMT |
| s3://snowflakebucket-copyoption/size/Orders2.csv | 54598 | 36bcccace29563ceb1f86a62f599dba3 | Wed, 28 Apr 2021 16:29:32 GMT |
+--------------------------------------------------+-------+----------------------------------+-------------------------------+
2 Row(s) produced. Time Elapsed: 0.694s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.force
                                                     from @
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.force
                                                     from @copy_into.internal_stage.force1
                                                     file delimiter=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order*.';
390114 (08001): None: Authentication token has expired.  The user must authenticate again.
Password:
* SnowSQL * v1.3.2
Type SQL statements or !help
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.force
                                                     from @copy_into.internal_stage.force1
                                                     file delimiter=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order*.';
001003 (42000): SQL compilation error:
syntax error line 3 at position 5 unexpected 'delimiter'.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.force
                                                     from @copy_into.internal_stage.force1
                                                     file_format=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order*.';
+---------------------------------------+
| status                                |
|---------------------------------------|
| Copy executed with 0 files processed. |
+---------------------------------------+
1 Row(s) produced. Time Elapsed: 2.342s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.force
                                                     from @copy_into.internal_stage.force1
                                                     file_format=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order*.';
+---------------------------------------+
| status                                |
|---------------------------------------|
| Copy executed with 0 files processed. |
+---------------------------------------+

1 Row(s) produced. Time Elapsed: 2.601s

--Force
  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.force
                                                     from @copy_into.internal_stage.force1
                                                     file_format=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order*.'
                                                     force=True;
+---------------------------------------+
| status                                |
|---------------------------------------|
| Copy executed with 0 files processed. |
+---------------------------------------+
1 Row(s) produced. Time Elapsed: 1.109s



--truncatecolumns
  
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace table copy_into.internal_stage.truncate
                                                     ( ORDER_ID VARCHAR(30),
                                                         AMOUNT VARCHAR(30),
                                                         PROFIT INT,
                                                         QUANTITY INT,
                                                         CATEGORY VARCHAR(10),
                                                         SUBCATEGORY VARCHAR(30));

+--------------------------------------+
| status                               |
|--------------------------------------|
| Table TRUNCATE successfully created. |
+--------------------------------------+
1 Row(s) produced. Time Elapsed: 0.209s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage copy_into.internal_stage.truncate_stage
                                                      url='s3://snowflakebucket-copyoption/size/';
+-------------------------------------------------+
| status                                          |
|-------------------------------------------------|
| Stage area TRUNCATE_STAGE successfully created. |
+-------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.218s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>list @truncate_stage;
+--------------------------------------------------+-------+----------------------------------+-------------------------------+
| name                                             |  size | md5                              | last_modified                 |
|--------------------------------------------------+-------+----------------------------------+-------------------------------|
| s3://snowflakebucket-copyoption/size/Orders.csv  | 54600 | 1a1c4a47a8e8e43ecef5bf8a46ee4017 | Wed, 28 Apr 2021 16:14:06 GMT |
| s3://snowflakebucket-copyoption/size/Orders2.csv | 54598 | 36bcccace29563ceb1f86a62f599dba3 | Wed, 28 Apr 2021 16:29:32 GMT |
+--------------------------------------------------+-------+----------------------------------+-------------------------------+
2 Row(s) produced. Time Elapsed: 0.810s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.truncate
                                                     from @copy_into.internal_stage.truncate_stage
                                                     file_format=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order.*';
100074 (54000): User character length limit (10) exceeded by string 'Electronics'
  File 'size/Orders.csv', line 5, character 18
  Row 4, column "TRUNCATE"["CATEGORY":5]
  If you would like to continue loading when an error is encountered, use other values such as 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option. For more information on loading options, please run 'info loading_data' in a SQL client.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into copy_into.internal_stage.truncate
                                                     from @copy_into.internal_stage.truncate_stage
                                                     file_format=(type=csv field_delimiter=',' skip_header=1)
                                                     pattern='.*Order.*'
                                                     truncatecolumns=true;
+--------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                             | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|--------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://snowflakebucket-copyoption/size/Orders2.csv | LOADED |        1500 |        1500 |           1 |           0 | NULL        |             NULL |
        NULL | NULL                    |
| s3://snowflakebucket-copyoption/size/Orders.csv  | LOADED |        1500 |        1500 |           1 |           0 | NULL        |             NULL |
        NULL | NULL                    |
+--------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
2 Row(s) produced. Time Elapsed: 1.952s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace table copy_into.internal_stage.size_limit(
                                                     ORDER_ID VARCHAR(30),
                                                         AMOUNT VARCHAR(30),
                                                         PROFIT INT,
                                                         QUANTITY INT,
                                                         CATEGORY VARCHAR(30),
                                                         SUBCATEGORY VARCHAR(30));

+----------------------------------------+
| status                                 |
|----------------------------------------|
| Table SIZE_LIMIT successfully created. |
+----------------------------------------+
1 Row(s) produced. Time Elapsed: 0.392s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage copy_into.internal_stage.size_limit_stage(

                                                         url='s3://snowflakebucket-copyoption/size/';
001003 (42000): SQL compilation error:
syntax error line 1 at position 65 unexpected '('.
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>create or replace stage copy_into.internal_stage.size_limit_stage

                                                         url='s3://snowflakebucket-copyoption/size/';
+---------------------------------------------------+
| status                                            |
|---------------------------------------------------|
| Stage area SIZE_LIMIT_STAGE successfully created. |
+---------------------------------------------------+
1 Row(s) produced. Time Elapsed: 0.142s
shre1234#COPYINTO_WAREHOUSE@COPY_INTO.INTERNAL_STAGE>copy into  copy_into.internal_stage.size_limit
                                                     from @copy_into.internal_stage.size_limit_stage
                                                     file_format=(type=csv field_delimiter=','  skip_header=1)
                                                     pattern='.*Order.*'
                                                     SIZE_LIMIT=30000;
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                            | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://snowflakebucket-copyoption/size/Orders.csv | LOADED |        1500 |        1500 |           1 |           0 | NULL        |             NULL |
       NULL | NULL                    |
+-------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
1 Row(s) produced. Time Elapsed: 2.440s
