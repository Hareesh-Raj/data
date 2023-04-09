-- Question 1
-- Write a SQL query to find the total salary of employees who is in Tokyo
-- excluding whose first name is Nancy.

select sum(salary) as Total_Salary
from employee e
join departments d 
on e.department_id = d.department_id
join locations l 
on l.location_id = d.location_id
where city = 'Seattle'
and
e.first_name not in ('Nancy');
-- Question 2
-- Fetch all details of employees who has salary more than the avg salary
-- by each department.
select * from employee e join 
(select emp.department_id ,avg(salary) as salary from employee emp group by emp.department_id) e1
on (e.department_id = e1.department_id and  e.salary > e1.salary ) order by e.salary;
-- Question 3
-- Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000
select loc.city, count(employee.employee_id) as employee_count
from departments as dept 
join locations as loc 
on dept.location_id = loc.location_id 
join employee 
on employee.department_id = dept.department_id 
where employee.salary >= 7000 and employee.salary < 10000 group by city ;
-- Question 4
-- Fetch maxsalary,minsalary and avgsalary by job and department. 
-- Info: grouped by department id and job id ordered by department id
-- and max salary.
select max(employee.salary) as max_sal,min(employee.salary) as min_salary,avg(employee.salary) as average_salary,department_id,job_id
from employee
group by department_id,job_id
order by (department_id,max_sal);
-- Question 5
-- Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
select
sum(employee.salary) as total_salary from employee 
join departments dept
on dept.department_id = employee.department_id 
join locations as location
on location.location_id = dept.location_id
where
country_id='US'
and 
not employee.first_name='Nancy';
-- Question 6
-- Fetch max salary,min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.

select j1.department_id, j1.job_id, MAX(e.salary) as max_sal, MIN(e.salary) as min_sal, AVG(e.salary) as avg_sal 
from job_history j1 
join job_history j2  
on j1.employee_id = j2.employee_id and j1.department_id = j2.department_id and j1.job_id != j2.job_id 
join employee e 
on j1.employee_id = e.employee_id 
group by j1.job_id,j1.department_id;

-- Question 7
-- Display the employee count in each department and also in the same result.
-- Info: * the total employee count categorized as "Total"
-- • the null department count categorized as "-" *
SELECT COALESCE(TO_VARCHAR(e.department_id), '-') as department_id,
       COUNT(*) as employee_count 
FROM  employee e
GROUP BY e.department_id;
-- Question 8
-- Display the jobs held and the employee count.
-- Hint: every employee is part of at least 1 job Hint: use the previous questions answer Sample
-- JobsHeld EmpCount 
-- 1 100 
-- 2  4
select cnt,count(cnt) as employee_count from
(
(select employee_id,count(employee_id) as cnt from job_history group by employee_id)
union 
(select employee_id,count(employee_id) as cnt from employee group by employee_id order by employee_id)
)
group by cnt;
-- Question 9
-- Display average salary by department and country.
select c.country_name,dept.department_id,avg(emp.salary) 
from employee emp 
join departments dept
on emp.department_id = dept.department_id
join locations loc 
on dept.location_id = loc.location_id
join countries c
on c.country_id = loc.country_id
group by c.country_name,dept.department_id order by c.country_name; 
-- Question 10
-- Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
select concat(e2.first_name,' ',e2.last_name) as manager_name , count(e1.manager_id) as Employees_Reporting,c.country_name
    from employee e1
    join departments dept
    on e1.department_id = dept.department_id
    join locations loc
    on dept.location_id = loc.location_id
    join countries c 
    on c.country_id = loc.country_id
    join employee e2 
    on e2.employee_id = e1.manager_id
    group by e1.manager_id, c.country_id, e2.first_name, e2.last_name, c.country_name;
    
select count(employee_id) from employee where manager_id = 101;
select * from 
select * from DEPARTMENTS;
select * from countries ;
select * from locations;
select * from departments;
select * from employee where first_name = 'Neena';


-- Question 11
 -- Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
--  DEPT ID 0-10000 10000-20000 
--  50         2     10
-- 60          6      5
SELECT department_id,
       count(case when salary >= 0 and salary <= 10000 then 1 end) AS "0-10000",
       count(case when salary > 10000 and salary <= 20000 then 1 end) AS "10000-20000",
       count(case when salary > 20000 and salary <= 30000 then 1 end) AS "20000-30000",
       count(case when salary > 30000 then 1 end ) AS "Above 30000"
FROM employee
GROUP BY department_id;

-- Question 12
-- Display employee count by country and the avg salary


select c.country_name,count(*) as employee_count,round(avg(salary),2) as average_sal
from  employee emp 
join departments dept
on emp.department_id = dept.department_id 
join locations loc
on dept.location_id = loc.location_id
join countries c
on c.country_id = loc.country_id 
group by c.country_id,c.country_name;
-- Question 13
-- Display region and the number off employees by department
select * from regions;
select * from job_history;
select * from locations;
select * from departments;
select * from countries;
select * from employee;
select r1.region_name,r.department_id,r.num_employees 
from regions r1 
join (
select r.region_id,dept.department_id,count(*) as num_employees 
from employee emp 
join departments dept
on emp.department_id = dept.department_id
join locations loc
on loc.location_id = dept.location_id
join countries c on loc.country_id = c.country_id 
join regions r
on r.region_id = c.region_id 
group by r.region_id,dept.department_id 
order by r.region_id,dept.department_id
) r on r1.region_id = r.region_id;
-- Question 14
 -- Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
 select emp.employee_id,iff(count(emp.department_id)=0, 'Not Yet Joined','Allocated') from employee emp group by emp.employee_id,emp.department_id;
 -- Question 15
 -- write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
 select concat(e1.first_name,' ',e1.last_name) as Employee_name,concat(e2.first_name,' ',e2.last_name) as Manager_name from employee e1 join employee e2 on e1.manager_id = e2.employee_id;
 -- Question 16
 -- write a SQL query to display the department name, city, and state province for each department.
 select dept.department_name,loc.city,loc.state_province from departments dept join locations loc on dept.location_id = loc.location_id;
  -- Question 17
  -- write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
  select emp.first_name,emp.last_name,dept.department_name,iff(emp.department_id = dept.department_id,'belongs to','does not belong') as belongs from employee emp join departments dept;
 -- Question 18
  -- The HR decides to make an analysis of the employees working in every department.
  -- Help him to determine the salary given in average per department and the total number of employees working in a department.
  -- List the above along with the department id, department name
  select e1.department_id,dept.department_name,e1.cnt,e1.avg_sal from (select emp.department_id,avg(emp.salary) as avg_sal,count(*) as cnt from employee emp group by emp.department_id) e1
  join departments dept on dept.department_id = e1.department_id;
-- Question 19
-- Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. 
-- (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
select * from employee join jobs order by employee_id;
-- Question 20
-- Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
select emp.first_name,emp.last_name,emp.email,c.country_name
from employee emp 
join departments dept 
on emp.department_id = dept.department_id 
join locations loc 
on loc.location_id = dept.location_id 
join countries c 
on c.country_id = loc.country_id
join regions r 
on r.region_id = c.region_id
where region_name in ('Europe','Americas');
-- Question 21
-- Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
select * from locations;
select concat(emp.first_name,' ',emp.last_name) as Full_name from employee emp join departments dept on emp.department_id = dept.department_id join locations loc on dept.location_id = loc.location_id where loc.city = 'Oxford' and dept.department_name not in ('Shipping','Finance') and SUBSTR(emp.last_name, -2, 1) = 'e';
-- Question 22
-- . Display the first name and phone number of employees who have less than 50 months of experience
select first_name,last_name,phone_number from employee where DATEDIFF(month,hire_date,CURRENT_DATE) > 50;
-- Question 23
-- Display Employee id, first_name, last name, hire_date and salary for employees 
-- who has the highest salary for each hiring year. 
-- (For eg: John and Deepika joined on year 2023, and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
select emp.employee_id,emp.first_name,emp.last_name,emp.hire_date,e.salary 
from employee emp 
join (select year(hire_date) as yr,max(salary)as salary
from employee group by yr) e 
on year(emp.hire_date) = e.yr and emp.salary = e.salary; 