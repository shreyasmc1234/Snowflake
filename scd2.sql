Create or replace table stage4(
id int,
name varchar(10)
);

create or replace table main4(
id int,
name varchar(10),
current_dt timestamp,
modified_dt timestamp,
flag string
);



update main4 a set
a.flag='N', a.modified_dt=current_timestamp
from stage4 b where a.id=b.id and a.name<>b.name and a.flag='Y';

insert into main4 (id,name,current_dt,modified_dt,flag)
select a.id,a.name,current_timestamp,null,'Y'
from stage4 a left join main4 b
on a.id=b.id and a.name=b.name and b.flag='Y' where b.id is null;


insert into main4 values (1,'Shre',current_timestamp,null,'Y');
insert into stage4 values(1,'Shreyas');
insert into stage4 values (2,'Shreyas G');

select * from main4;

truncate stage4;
