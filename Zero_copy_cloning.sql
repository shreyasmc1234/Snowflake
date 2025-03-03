create or replace table MYDB.PUBLIC.ORDERS_NONCLUSTER_clone
clone MYDB.PUBLIC.ORDERS_NONCLUSTER


create or replace database mydb_blp
clone mydb;


select top 1 *  from MYDB.PUBLIC.ORDERS_NONCLUSTER_clone;

select top 1 * from MYDB.PUBLIC.ORDERS_NONCLUSTER;

--Inserting into cloned object


insert into MYDB.PUBLIC.ORDERS_NONCLUSTER_clone (O_ORDERKEY) values(10);
--data available in cloned object 
select * from MYDB.PUBLIC.ORDERS_NONCLUSTER_clone where O_ORDERKEY=10;
O_ORDERKEY	O_CUSTKEY	O_ORDERSTATUS	O_TOTALPRICE	O_ORDERDATE	O_ORDERPRIORITY	O_CLERK	O_SHIPPRIORITY	O_COMMENT
10	

--data not available in paren/original obj
select * from MYDB.PUBLIC.ORDERS_NONCLUSTER where O_ORDERKEY=10;
Query produced no results
