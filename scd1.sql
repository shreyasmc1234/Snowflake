create database scd;

create schema sample1;

Slowly Changing Dimensions Type 1 implementation

Create table fact_table(
id int,
name varchar(100),
city varchar(100)
);
insert into fact_table values(1,'Shreyas','Mangalore'),(2,'Nishmitha','Mangaore')

create table dimen(
id int,
name varchar(100),
city varchar(100)
);

select * from dimen

Merge into dimen as target
using fact_table as source
on target.id=source.id

when matched then
update set target.name=source.name,
target.city=source.city

when not matched then
insert (target.id,target.name,target.city) values(source.id,source.name,source.city)


------------------------------------------------------------------------------------------------------------
Or


create or replace transient table stage3(
id int ,
name varchar(100)
);

create or replace table main3(
id int,
name varchar(100)
);


merge into main3 a
using stage3 b on a.id=b.id
when matched and (a.name<>b.name) then
update set a.name=b.name
when not matched then
insert (id,name) values (b.id,b.name)
;

insert into main3 values (1,'Manju');
insert into stage3 values(1,'Manju');
insert into STAGE3 values(1,'Rama');
insert into stage3 values(2,'Manju');

select * from main3;


truncate table stage3;

