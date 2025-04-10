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
