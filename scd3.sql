
create or replace table stage5(
id int,
name varchar(100)
);

create or replace table final5(
id int,
ord_name varchar(100),
Changed_name varchar(100)
);


Merge into final5 a
using stage5 b on a.id=b.id
when matched then
update set a.ord_name =b.name,
a.changed_name=a.ord_name
when not matched then 
insert (id,ord_name,changed_name) values(b.id,b.name,null);


insert into stage5 values (3,'Shrey');
truncate stage5


select * from final5;
