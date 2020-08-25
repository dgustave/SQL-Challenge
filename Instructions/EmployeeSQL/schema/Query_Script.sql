--1. List the following details of each employee: employee number, last name, first name, sex, and salary.
	-- Columns can be matched by name in tables, in this case emp_no.(Natural Join)
	
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
NATURAL JOIN salaries 

CREATE VIEW employee_records AS
	SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary 
	FROM employees
	NATURAL JOIN salaries 
	
SELECT * FROM employee_records

--2. List first name, last name, and hire date for employees who were hired in 1986.
	--Call columns first and use operators to bound with in time constraints.
	
SELECT first_name, last_name, hire_date from employees 
	WHERE hire_date >= '01/01/1986'
	AND hire_date < '01/01/1987'
	ORDER BY hire_date ASC;

CREATE VIEW employee_hires_of_86 AS
	SELECT first_name, last_name, hire_date from employees 
		WHERE hire_date >= '01/01/1986'
		AND hire_date < '01/01/1987'
		ORDER BY hire_date ASC;
	
		
SELECT * FROM employee_hires_of_86

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
	-- Parent/Child relationship PK = FK look at ERD, could do Inner Join for more complex queries. 

SELECT mgr.dept_no, d.dept_name, emp.emp_no, emp.first_name, emp.last_name 
	FROM "Department_Managers" AS mgr, employees AS emp, departments AS d  
	WHERE mgr.emp_no = emp.emp_no AND 
	d.dept_no = mgr.dept_no;

CREATE VIEW manager_staff AS
	SELECT mgr.dept_no, d.dept_name, emp.emp_no, emp.first_name, emp.last_name 
		FROM "Department_Managers" AS mgr, employees AS emp, departments AS d  
		WHERE mgr.emp_no = emp.emp_no AND 
		d.dept_no = mgr.dept_no;
	
SELECT * FROM manager_staff

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
	--Relationship PK = FK look at ERD, could do Inner Join for more complex queries.

SELECT emp.emp_no, emp.first_name, emp.last_name, d.dept_name 
	FROM "Department_Employees" AS ed, employees  AS emp, departments AS d  WHERE ed.emp_no = emp.emp_no AND 
	d.dept_no = ed.dept_no;

CREATE VIEW department_deets AS
	SELECT emp.emp_no, emp.first_name, emp.last_name, d.dept_name 
		FROM "Department_Employees" AS ed, employees AS emp, departments AS d  WHERE ed.emp_no = emp.emp_no AND
		d.dept_no = ed.dept_no;
	
SELECT * FROM department_deets

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
	--Conditional for specific name and Like can be used for last names starting with b. 
	
SELECT first_name, last_name, sex FROM employees 
	WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%'

CREATE VIEW employee_search AS
	SELECT first_name, last_name, sex FROM employees 
	WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%'

SELECT * FROM employee_search

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
	--Conditional search with requests - already pulled relevant information in department deets

SELECT emp_no, last_name, first_name, dept_name
	FROM department_deets 
	WHERE dept_name = 'Sales'

CREATE VIEW sales_force AS	
	SELECT emp_no, last_name, first_name, dept_name
		FROM department_deets 
		WHERE dept_name = 'Sales'

SELECT * FROM sales_force		

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
	-- use department_deets select relevant info

SELECT emp_no, last_name, first_name, dept_name
	FROM department_deets
	WHERE dept_name = 'Sales'
	OR dept_name = 'Development'
	
CREATE VIEW sales_stratagist AS	
	SELECT emp_no, last_name, first_name, dept_name
		FROM department_deets
		WHERE dept_name = 'Sales'
		OR dept_name = 'Development'

SELECT * FROM sales_stratagist	

--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
	-- query employee table and filter by count function, group by statement, and order by keyword.

SELECT last_name, count(last_name) as "Surname Frequency"
	FROM employees
	GROUP BY last_name
	ORDER BY  count(last_name)DESC;

CREATE VIEW surname_freq_table AS	
	SELECT last_name, count(last_name) as "Surname Frequency"
		FROM employees GROUP BY last_name
		ORDER BY  count(last_name)DESC;


SELECT * FROM surname_freq_table	

--(Optional), create table with employee salary and title, plot bar chart in python for ave salary by title

-- Common salary ranges for employees
SELECT emp.emp_no, emp.emp_title_id, emp.first_name, emp.last_name, t.title, s.salary 
	FROM employees AS emp, salaries AS s, titles AS t  WHERE emp.emp_title_id = t.title_id 
	AND s.emp_no = emp.emp_no;

CREATE VIEW potential_earnings AS
	SELECT emp.emp_no, emp.emp_title_id, emp.first_name, emp.last_name, t.title, s.salary 
		FROM employees AS emp, salaries AS s, titles AS t  WHERE emp.emp_title_id = t.title_id 
		AND s.emp_no = emp.emp_no;

SELECT * FROM potential_earnings

--Count total employees by title

SELECT DISTINCT title AS "Title", COUNT(Title) AS Titles_Held
	FROM potential_earnings GROUP BY Title
	ORDER BY  COUNT(Title)DESC;

CREATE VIEW positions_held as
	SELECT DISTINCT title AS "Title", COUNT(Title) AS Titles_Held
		FROM potential_earnings GROUP BY Title
		ORDER BY  COUNT(Title)DESC;


--Creating a table of salary ranges by employee titles

WITH ranges ([range], fromValue, toValue)
AS ( SELECT 1 AS [range], @min AS fromValue, @min+@interval AS toValue
     UNION ALL
     SELECT [range]+1, toValue, toValue+@interval
     FROM ranges
     WHERE [range]<@levels)

SELECT r.fromValue,
       r.toValue,
       w.[count]
FROM ranges AS r
OUTER APPLY (
    SELECT COUNT(*) AS [count]
    FROM #values AS v
    --- In a CROSS/OUTER APPLY, the WHERE clause works like
    --- the JOIN condition:
    WHERE r.fromValue<=v.value AND
         (r.toValue>v.value OR
          r.toValue>@max-0.5*@interval AND
          v.value=@max)
    ) AS w
ORDER BY r.[range];



-- Average salary by title: 

CREATE VIEW avg_salary AS
SELECT title AS "Title", round(avg(salary),2) AS "Average Employee Salary" 
	FROM potential_earnings
	GROUP BY title;

SELECT * FROM avg_salary

--Just sampling data by departments, more practice experimental ... 

SELECT d.dept_name, emp.emp_no, emp.emp_title_id, emp.first_name, emp.last_name, t.title, s.salary 
	FROM "Department_Employees" AS ed, employees AS emp, salaries AS s, titles AS t, departments AS d WHERE emp.emp_title_id = t.title_id 
	AND s.emp_no = emp.emp_no AND ed.emp_no = emp.emp_no and d.dept_no = ed.dept_no;

CREATE VIEW future_position AS
	SELECT d.dept_name, emp.emp_no, emp.emp_title_id, emp.first_name, emp.last_name, t.title, s.salary 
		FROM "Department_Employees" AS ed, employees AS emp, salaries AS s, titles AS t, departments AS d WHERE emp.emp_title_id = t.title_id 
		AND s.emp_no = emp.emp_no AND ed.emp_no = emp.emp_no AND d.dept_no = ed.dept_no;


SELECT * FROM future_position

CREATE VIEW dept_avg_salary AS
	SELECT dept_name as "Department" title AS "Title", round(avg(salary),2) AS "Average Department Salary" 
		FROM future_position
		GROUP BY title, salary, dept_name
		ORDER BY salary DESC;

SELECT * FROM dept_avg_salary