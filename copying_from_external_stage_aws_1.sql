create database copy_into;

create or replace table loan_payment(
    loan_id string,
    loan_status string,
    principal string,
    terms string,
    effective_date string,
    due_date string,
    paid_off_time string,
    past_due_days string,
    age string,
    education string,
    gender string
);

select get_ddl('table','COPY_INTO.PUBLIC.LOAN_PAYMENT')

--Using publicly available data in the s3 bucket


copy into COPY_INTO.PUBLIC.LOAN_PAYMENT 
from s3://bucketsnowflakes3/Loan_payments_data.csv --External stage
file_format=(type=csv,skip_header=1,field_delimiter=',');

file	status	rows_parsed	rows_loaded	error_limit	errors_seen	first_error	first_error_line	first_error_character	first_error_column_name
s3://bucketsnowflakes3/Loan_payments_data.csv	LOADED	500	500	1	0		

select count(*) from COPY_INTO.PUBLIC.LOAN_PAYMENT;

COUNT(*)
500

