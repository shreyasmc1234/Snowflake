
create database if not exists mydb;
create schema if not exists external_stage;

--Publicly accessble data 

create or replace stage mydb.external_stage.sample_external_stage
url=s3://bucketsnowflakes3;


desc stage mydb.external_stage.sample_external_stage


list @mydb.external_stage.sample_external_stage;

create or replace table mydb.external_stage.orders(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

copy into mydb.external_stage.orders 
from @mydb.external_stage.sample_external_stage
file_format=(type=csv,skip_header=1,field_delimiter=',')
files=('OrderDetails.csv')

select count(*) from mydb.external_stage.orders ;

--If there is multiple files then loading them by using pattern

copy into mydb.external_stage.orders 
from @mydb.external_stage.sample_external_stage
file_format=(type=csv,skip_header=1,field_delimiter=',')
pattern='.*Order.*'


--Creating own file format
truncate mydb.fileformat.file

create or replace schema mydb.fileformat;

create or replace table mydb.fileformat.file(
age int
);

list @mydb.external_stage.sample_external_stage;
select $1 from @mydb.external_stage.sample_external_stage/sampledata.csv;

create or replace file format mydb.fileformat.simple_format
skip_header=1
field_delimiter=',',
type=csv;

copy into mydb.fileformat.file from 
(select $1 from @mydb.external_stage.sample_external_stage)
file_format=(format_name='mydb.fileformat.simple_format')
files=('sampledata.csv')

desc file format mydb.fileformat.simple_format;
alter file format mydb.fileformat.simple_format set skip_header=1;

select * from mydb.fileformat.file;
