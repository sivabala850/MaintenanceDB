
select 		count(*)
from		(select		categories, max(price) as max_price
from		menu_items
group by 	categories) as mp
where		max_price < 15;

with mp 	as(
select		categories, max(price) as max_price
from		menu_items
group by 	categories)
select		count(*)
from		mp
where		max_price < 15;

use practice;
select 		*
from 		emp_details;

-- Stored Procedure
delimiter $$
create procedure employeeCount()
begin
select count(*) from emp_details;
end $$
delimiter ;

call employeeCount();

-- Display the emp_details table
delimiter $$
create procedure displayEmp()
begin
select * from emp_details;
end $$
delimiter ;

call displayEmp();

-- Local and Global Variables

-- Local Variable
delimiter $$
create procedure maxSalary()
begin
declare ms int default 0;
select max(salary) into ms from emp_details;
select ms;
end $$
delimiter ;

call maxSalary();

-- Global Variable
set @ms = -1;
select @ms;

delimiter $$
create procedure globalVariable(
out ms int )
begin
select max(salary) into ms from employee;
end $$
delimiter ;

call globalVariable(@ms);

--  ---------------------
delimiter $$
create procedure incrementCounter(
inout	counter int,
in 		increase int)
begin
set counter = counter + increase;
end $$
delimiter ;
set @counter = 50;
select @counter;
call incrementCounter(@counter,10);
select @counter;


-- input designation, check the condition if ceo then return level 1, if data scientist or data analyst return level 2

delimiter $$
create procedure levels(
in desg varchar(20))
begin
declare l int default  -1;
if desg = 'CEO' then set l = 1;
elseif desg = 'Data Analyst' or desg = 'Data Scientist' then set l = 2;
else set l = 0 ;
end if ;
select l;
end $$
delimiter ;

call levels('Data Scientist'); 

-- High and Low salary finder, return 'High' when salary greater than average salary otherwise 'Low'
select 		*
from		emp_details;

delimiter $$
create procedure salaryFinder(
in value int)
begin
declare display varchar(20) default 'Enter Value';
case		when value > (select avg(salary) from emp_details)  then set display= 'High';
			when value <= (select avg(salary) from emp_details) then set display = 'Low';
            else set display ='Unknown Value';
            end case;
            select display;
end $$
delimiter ;

call salaryFinder(null);

-- Loops
---------
delimiter $$
create procedure loopMultiTabs()
begin
declare i int ;
set i = 1 ;
looplabel : loop
if 
i > 10 then leave looplabel;
end if;
select i;
set i = i + 1;
end loop;
end $$
delimiter ;
call loopMultiTabs;

-- loop with results in single tab using concat
delimiter $$
create procedure loopSingleTab()
begin
declare i int;
declare str varchar(50) default '';
set i = 1;
looplabel : loop
if i > 10 then leave looplabel;
end if ;
set str = concat(str, i, '');
set i = i + 1;
end loop;
select str;
end $$
delimiter ;
call loopSingleTab;

-- functions
select * from emp_details;

delimiter $$
create function branchDetails(
id int)
returns varchar(100)
deterministic
begin
declare details varchar(100) default '';
select concat(address,' ',name) into  details from branch where id = id;
return details;
end $$
delimiter ;



start transaction;
alter table emp_details add column branch_id int;
alter table emp_details add constraint foreign key br  branch_id;
set sql_safe_updates =0;
update emp_details set branch_id = 2 where mod(id,2) =0;
update emp_details set branch_id =1 where id % 2 = 1;

create table branch (id int primary key auto_increment,name varchar(25) not null,address varchar(100));
drop table branch;
select * from branch;
insert into branch (name,address) values('Mumbai','No, 200, Mumbai Main Road Mumbai- 200000');

select * from emp_details;

select 		id, name, branchDetails(branch_id)
from		emp_details;