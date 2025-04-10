Create table scd0_dim(
id int,
name varchar(20),
age int
);


create or replace transient table scd0_stage(
id int,
name varchar(20),
age int
);

insert into scd0_stage values(1,'Ram',20),(2,'Manoj',24),(1,'Mila',22)

Merge into scd0_dim as target
using scd0_stage as temp
on
target.id=temp.id
when not matched then
insert (target.id,target.name,target.age) values(temp.id,temp.name,temp.age)

select * from scd0_stage
select * from scd0_dim
