/*EMPLOYEES																DEPARTMENTS	
employee_id	name		job_id	salary	department_id	hire_date		department_id	department_name
1			John Doe	101		 60000	1				2022-01-01		1				IT
2			Jane Smith	102		100000	1				2022-02-15		2				Finance
3			Bob Johnson	103		 75000	2				2022-03-10		3				Human Resources   */

--	Завдання 1. Вивести всі дані з таблиці "employees".			
select *
from "HR".employees
;

--	Завдання 2. Вибрати імена та зарплати всіх працівників, які отримують більше 50000.								
select 
	concat(first_name, ' ', last_name) as name,
	salary
from "HR".employees
where salary > 50000
;

--	Завдання 3. Знайти кількість працівників в департаменті з ідентифікатором 10.								
select 
	count(*) as num_employees
from "HR".employees
where department_id = 10
;

--	Завдання 4. Вивести унікальні департаменти в яких працюють працівники з таблиці "departments".								
select 
	distinct department_id 
from "HR".departments d 
;

--	Завдання 5. Вивести загальну кількість працівників в кожному департаменті та середню зарплату.								
select 
	d.department_id as department_id,
	count(e.employee_id) as num_employees,
	round(avg(e.salary),2) as salary
from "HR".employees e
left join "HR".departments d on e.department_id = d.department_id 
group by d.department_id 
--having d.department_id is not null
;

--	Завдання 6. Знайти працівника з найвищою зарплатою та вказати назву його департаменту department_name.								
select 
	e.employee_id,
	e.first_name,
	e.last_name,
	e.salary,
	d.department_name
from "HR".employees e
left join "HR".departments d on e.department_id = d.department_id 
order by e.salary desc 
limit 1
;

--	Завдання 7. Вивести загальну суму зарплат у кожному департаменті та відсортувати в порядку спадання.								
select 
	d.department_id,
	sum(e.salary) as amt_salary
from "HR".employees e
left join "HR".departments d on e.department_id = d.department_id 
group by d.department_id 
order by amt_salary desc 
;

--	Завдання 8. Знайти середню зарплату для працівників, найманих після 1 січня 2022 року.								
select 
	round(avg(salary),2) as avg_salary 
from "HR".employees e
where hire_date > '01.01.2022'
;

--	Завдання 9. Вивести топ-3 департаменти з найвищою середньою зарплатою.								
select
	d.department_id,
	round(avg(e.salary),2) as avg_salary
from "HR".employees e
join "HR".departments d on e.department_id = d.department_id 
group by d.department_id
order by avg_salary desc 
limit 3
;

--	Завдання 10. Вивести назву департаменту з другою найбільшою середньою зарплатнею.								
select
	department_name,
	avg_salary 
from (
	select 
		d.department_name,
		round(avg(e.salary),2) as avg_salary,
		rank() over (order by avg(e.salary) desc) as salary_rank
	from "HR".employees e
	join "HR".departments d on e.department_id = d.department_id 
	group by d.department_name 
) rank_departments
where salary_rank = 2
;

--	Завдання 11. Вибрати імена працівників, які мають унікальні зарплати та працюють в IT-відділі.								
select
	e.first_name 
from "HR".employees e
join "HR".departments d on e.department_id = d.department_id
where d.department_name = 'IT' and e.salary in (
	select
		salary
	from "HR".employees
	group by salary
	having count(*)=1
)
;
