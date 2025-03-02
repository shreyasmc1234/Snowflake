--Using sample data provided by snowflake 
select count(8) from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;
COUNT(8)
150000000

// Run with X-Small or Small Warehouse
// Run below queries and observe query profile

// Query is fetching results from Storage layer(Remote Disk)
SELECT * FROM  TPCH_SF1000.CUSTOMER; -- 1min 52sec
if you run again -> 64ms

// Fetching METADATA info is very fast, look at query profile
SELECT COUNT(*) FROM  TPCH_SF1000.CUSTOMER; -- 30ms
SELECT MIN(C_CUSTKEY) FROM  TPCH_SF1000.CUSTOMER; --70ms ms
SELECT MAX(C_CUSTKEY) FROM  TPCH_SF1000.CUSTOMER; -- 42ms
 

// Run the same query again and observe time taken and query profile
SELECT * FROM  TPCH_SF1000.CUSTOMER; -- 44ms

// Try to fetch same data by changing queries little bit and observe query profile
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER; -- 39s
SELECT C_CUSTKEY, C_ADDRESS FROM TPCH_SF1000.CUSTOMER; -- 25s
SELECT C_ADDRESS, C_CUSTKEY FROM TPCH_SF1000.CUSTOMER; -- 24s

// Try to fetch subset of data, with a filter
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER
    WHERE C_NATIONKEY in (1,2); -- 5.0s

==================================================================
// Turn off Results Cache, Suspend the VW, run same queries and see query profile
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

// First time, it will fetch the data from Remote Disk
SELECT * FROM  TPCH_SF1000.CUSTOMER; -- 2min 19sec

// Run the same query again and observe time taken and query profile
SELECT * FROM  TPCH_SF1000.CUSTOMER; -- 1m 47s

// Try to fetch same data by changing queries little bit and observe query profile
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER; -- 37sec
SELECT C_CUSTKEY, C_ADDRESS FROM TPCH_SF1000.CUSTOMER; -- 25sec
SELECT C_ADDRESS, C_CUSTKEY FROM TPCH_SF1000.CUSTOMER; -- 34sec

// Try to fetch subset of data, with a filter
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER
    WHERE C_CUSTKEY < 200000; -- 377ms
    
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER
    WHERE C_NATIONKEY in (1,2,3,4,5); -- 12sec
==================================================================

// Increase VW size to XL, run same queries and see query profile
// suspend warehouse and resume

// First time, it will fetch the data from Remote Disk
SELECT * FROM  TPCH_SF1000.CUSTOMER; --9.3s

// Run the same query again and observe time taken and query profile
SELECT * FROM  TPCH_SF1000.CUSTOMER; -- 10s

// Try to fetch same data by changing queries little bit and observe query profile
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER; -- 4.8sec
SELECT C_CUSTKEY, C_ADDRESS FROM TPCH_SF1000.CUSTOMER; -- 7.9 sec
SELECT C_ADDRESS, C_CUSTKEY FROM TPCH_SF1000.CUSTOMER; -- 3.4 sec

// Try to fetch subset of data, with a filter
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER
    WHERE C_CUSTKEY < 200000; -- 891
    
SELECT C_CUSTKEY, C_NAME, C_ACCTBAL, C_ADDRESS FROM TPCH_SF1000.CUSTOMER
    WHERE C_NATIONKEY in (1,2,3,4,5); -- 1.6 sec
==================================================================
