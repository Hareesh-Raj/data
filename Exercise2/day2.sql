-- Question 1 
-- Write a SQL query to remove the details of an employee whose first name ends in ‘even’
-- stEVEN,STEvEn.
select * from employees where lower(first_name) like '%even';
delete from employees where lower(first_name) like '%even';
-- Question 2
-- Write a query in SQL to show the three minimum values of the salary from the table.
select * from employees order by salary limit 3;
-- Question 3
-- Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table.
create table EMPLOYEE as (select * from employees);
truncate table employees;
select * from EMPLOYEE;
-- Question 4
-- Write a SQL query to remove the column Age from the table
alter table employee drop column age;
alter table employee add age int;
-- Question 5
-- Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
select concat(first_name,' ',last_name) as FullName,email,year(hire_date) as hire_year from employee where (year(hire_date)<2000);
-- SELECT CONCAT_WS(' ', first_name, last_name);
-- Question 6
-- Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
select employee_id,job_id,year(hire_date) as hire_year from employee where year(hire_date) between 1990 and 1999 and year(hire_date) not in (1990,1999);
-- select * from job_history;
-- Question 7
-- Find the first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position
select employee_id,email,position('A',email)as letter_position from employee where letter_position > 0;
-- Question 8
-- Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
select employee_id,concat(first_name,' ',last_name) as FullName,email from employee where length(concat(first_name,last_name)) < 12;
-- Question 9
-- Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;
select email,concat(first_name,'@',last_name,'@',email) as UNQ_ID from employee;
-- Question 10
-- Write a SQL query to update the size of email column to 30
alter table employee modify email varchar(30); 
desc table employee;
-- Question 11
-- Write a SQL query to change the location of Diana to London
select * from (departments d join employee e on (d.department_id=(select department_id from employee where first_name='Diana') and e.first_name='Diana')) ;
update departments set location_id=2400 where department_id in (select department_id from employee where first_name='Diana') ;
select department_id from employee where first_name='Diana';
select location_id from departments where department_id=60;
-- Question 12
-- Fetch all employees with their first name , email , phone (without
-- extension part) and extension (just the extension)
-- Info : this mean you need to separate phone into 2 parts
-- eg: 123.123.1234.12345.235 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
select first_name,
email,
substr(phone_number,0,length(phone_number)-length(split_part(phone_number,'.',-1))-1) as phone_column,split_part(phone_number,'.',-1) as extension_column from employee;
-- Question 13
-- Write a SQL query to find the employee with second and third maximum
-- salary with and without using top/limit keyword
select distinct salary from employee order by salary desc limit 3;
select * from (select employee_id, salary, dense_rank() over(order by salary desc) as salary_rank from employee) max_salary where max_salary.salary_rank in (2,3);  
-- Question 14
-- Fetch all details of top 3 highly paid employees who are in department
-- Shipping and IT
select * from employee where department_id in (select department_id from departments where department_name in ('IT','Shipping')) order by salary desc limit 3;
-- Question 15
-- Display employee id and the positions(jobs) held by that employee (including the current position)
select * from employee;
select department_id,job_id from job_history;
select * from job_history;
select * from ((select e.employee_id,job.job_title  from employee as e,job_history as j_history,jobs as job where e.employee_id=j_history.employee_id and job.job_id=j_history.job_id )
union
(select e.employee_id,job_title  from jobs as j,employee as e where e.job_id=j.job_id) order by employee_id);
-- Question 16
-- Display Employee first name and date joined as WeekDay, Month Day, Year
select first_name,concat(dayname(hire_date),', ',monthname(hire_date),' ',day(hire_date),'st,',year(hire_date))as Date_Joined from employee;
-- Question 17
--The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
-- The job position might be removed based on market trends (so, save the changes). 
-- Later, update the maximum salary to 40,000 . 
-- Save the entries as well.
-- Now, revert back the changes to the initial state, where the salary was 30,000

select * from jobs;
delete from jobs where job_id = 'DT_ENGG';

start transaction;
ALTER SESSION SET AUTOCOMMIT = false;
insert into jobs values ('DT_ENGG','Data Engineer',12000,30000);
savepoint intial;
commit;
update jobs set max_salary=40000 where job_id='DT_ENGG';
rollback to intial;
ALTER SESSION UNSET AUTOCOMMIT;
-- Question 18
-- Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),3) from employee where hire_date between '08/01/1996' and '01/01/2000';
-- Question 19
-- Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions
select * from regions;
select  region_name from regions
union all select 'Australia' as REGION_NAME
UNION ALL select 'Asia' as REGION_NAME
UNION ALL select 'Antarctica' as REGION_NAME
UNION ALL select 'Europe' as REGION_NAME;

select  region_name from regions
union select 'Australia' as REGION_NAME
union select 'Asia' as REGION_NAME
union select 'Antarctica' as REGION_NAME
union select 'Europe' as REGION_NAME;
-- Question 20
-- Write a SQL query to remove the employees table from the database
drop table employees;