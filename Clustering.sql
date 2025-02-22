##Implementation of Clustering in Snowflake

Create database if not exists mydb;


create OR replace table mydb.public.non_cluster(
C_CUSTKEY NUMBER(38,0),
	C_NAME VARCHAR(25),
	C_ADDRESS VARCHAR(40),
	C_NATIONKEY NUMBER(38,0),
	C_PHONE VARCHAR(15),
	C_ACCTBAL NUMBER(12,2),
	C_MKTSEGMENT VARCHAR(10),
	C_COMMENT VARCHAR(117)
);

BEGIN TRANSACTION;

INSERT INTO mydb.public.non_cluster SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;

COMMIT;


CREATE OR REPLACE TABLE MYDB.PUBLIC.CLUSTER(
  C_CUSTKEY NUMBER(38,0),
  C_NAME VARCHAR(25),
  C_ADDRESS VARCHAR(40),
  C_NATIONKEY NUMBER(38,0),
  C_PHONE VARCHAR(15),
  C_ACCTBAL NUMBER(12,2),
  C_MKTSEGMENT VARCHAR(10),
  C_COMMENT VARCHAR(117)
)
CLUSTER BY (C_NATIONKEY);

INSERT INTO mydb.public.CLUSTER SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;

-- Difference in with cluster and without cluster;
-- wait for 30-40 mins to see the difference because snowflake will take some time to cluster and make the micro partition
-- suspend the warehouse and cache to see the difference
-- Alter session set use_cached_result =false;
Alter session set use_cached_result =false;

SELECT * FROM mydb.public.CLUSTER WHERE C_NATIONKEY=2;

5.8s

Partitions scanned
22
Partitions total
482

SELECT * FROM mydb.public.non_cluster WHERE C_NATIONKEY=2;
13s

Partitions scanned
420
Partitions total
420

-- Declaring the cache once the table is created by using alter statement

create or replace table mydb.public.orders_noncluster as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;

create or replace table mydb.public.orders_cluster as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;

alter table mydb.public.orders_cluster  cluster by (year(o_orderdate));


select count(*) from mydb.public.orders_noncluster where year(o_orderdate)=1995; 1.4s
Partitions scanned
85
Partitions total
233

select count(*) from mydb.public.orders_cluster where year(o_orderdate)=1995; 1.0s
Partitions scanned
39
Partitions total
233

-- Use the concept of reclustring 
alter table mydb.public.orders_cluster cluster by (year(o_orderdate),o_orderpriority)
alter session set use_cached_result=false;

SELECT * FROM PUBLIC.ORDERS_NONCLUSTER WHERE YEAR(O_ORDERDATE) = 1996 and O_ORDERPRIORITY = '1-URGENT'; -- 4.5s
SELECT * FROM PUBLIC.ORDERS_CLUSTER WHERE YEAR(O_ORDERDATE) = 1996 and O_ORDERPRIORITY = '1-URGENT'; -- 4.1s

--To check the details related to the cluster
SELECT SYSTEM$CLUSTERING_INFORMATION('ORDERS_CLUSTER');
{
  "cluster_by_keys" : "LINEAR(year(o_orderdate),o_orderpriority)",
  "total_partition_count" : 241,
  "total_constant_partition_count" : 196,
  "average_overlaps" : 0.7884,
  "average_depth" : 1.5145,
  "partition_depth_histogram" : {
    "00000" : 0,
    "00001" : 195,
    "00002" : 15,
    "00003" : 11,
    "00004" : 4,
    "00005" : 5,
    "00006" : 11,
    "00007" : 0,
    "00008" : 0,
    "00009" : 0,
    "00010" : 0,
    "00011" : 0,
    "00012" : 0,
    "00013" : 0,
    "00014" : 0,
    "00015" : 0,
    "00016" : 0
  },
  "clustering_errors" : [ ]
}

