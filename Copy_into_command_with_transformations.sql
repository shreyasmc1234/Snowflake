--Case 1:

create or replace schema copy_into.external_stage;

create or replace stage copy_into.external_stage.aws_external_stage
url = s3://bucketsnowflakes3

list @copy_into.external_stage.aws_external_stage;


select $1,$2,$3,$4,$5,$6 from @copy_into.external_stage.aws_external_stage/OrderDetails.csv;

select $1 as order_id,$2 as amount from @copy_into.external_stage.aws_external_stage/OrderDetails.csv;

----------------------------------------------------------------------------------------------------------
-- Case 2:

create or replace table copy_into.external_stage.orders_sample(
order_id varchar(50),
amount int
);

truncate orders_sample;

copy into copy_into.external_stage.orders_sample
from (select $1, $2 from @copy_into.external_stage.aws_external_stage/OrderDetails.csv)
file_format=(type=csv,field_delimiter=',',skip_header=1)
--files ='OrderDetails.csv'

select * from copy_into.external_stage.orders_sample;
----------------------------------------------------------------------------------------------------------
--Case 3

--Doing some transformations to the data


create or replace table copy_into.external_stage.orders_sample1(
order_id varchar(50),
profit int,
amount int,
cat_substr varchar(50),
cat_concat varchar(50),
profit_or_loss varchar(20)
);

truncate copy_into.external_stage.orders_sample1;

copy into copy_into.external_stage.orders_sample1
from (
select s.$1
,s.$3
,s.$2
,substr(s.$5,1,5)
,s.$5||'-'||s.$6,
case
    when $3>0 then 'Profit'
    else 'Loss'
End
from @copy_into.external_stage.aws_external_stage as s)
file_format=(type=csv,field_delimiter=',',skip_header=1)
files=('OrderDetails.csv');

select * from copy_into.external_stage.orders_sample1;
----------------------------------------------------------------------------------------------------------
