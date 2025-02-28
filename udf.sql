create or replace schema udf;

--Funtion to create a tax

create or replace function tax_calculator(price float)
returns float
as
$$

(price*10)/100

$$


grant usage on function  udf.tax_calculator(float) to public;

select o_orderkey,tax_calculator(o_totalprice) as tax,o_totalprice from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

--variable tax function

create or replace function mydb.udf.tax_calculator(price float,tax float)
returns float
as
$$
    (price*tax)/100
$$

grant usage function udf.tax_calculator(price,tax) to public;

select o_totalprice,tax_calculator(o_totalprice,15) as tax from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;


Tabular udf


CREATE OR REPLACE TABLE COUNTRIES 
(COUNTRY_CODE CHAR(2), COUNTRY_NAME VARCHAR);

INSERT INTO COUNTRIES(COUNTRY_CODE, COUNTRY_NAME) VALUES 
    ('FR', 'FRANCE'),
    ('US', 'UNITED STATES'),
    ('IN', 'INDIA'),
    ('SP', 'SPAIN');

CREATE OR REPLACE TABLE USER_ADDRESSES 
(USER_ID INTEGER, COUNTRY_CODE CHAR(2));

INSERT INTO USER_ADDRESSES (USER_ID, COUNTRY_CODE) VALUES 
    (100, 'SP'),
    (123, 'FR'),
    (567, 'US'),
    (420, 'IN');


CREATE OR REPLACE FUNCTION mydb.udf.GET_COUNTRIES_FOR_USER(ID NUMBER)
  RETURNS TABLE (USER_ID NUMBER, COUNTRY_NAME VARCHAR)
AS 
$$
SELECT ID, C.COUNTRY_NAME FROM USER_ADDRESSES A, COUNTRIES C
      WHERE A.USER_ID = ID
      AND C.COUNTRY_CODE = A.COUNTRY_CODE
$$
;


// Fetch country name for specified user id	  
SELECT * from table(mydb.udf.GET_COUNTRIES_FOR_USER(100));


