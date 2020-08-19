--List Primary Keys: 
--It is easier to list all Primary Keys first to drop tables
--Will have to drop table dependencies associated with emp_no, dept_no, and title_id
-- Chose Titles first because its a primary key to the main table Employees

DROP TABLE IF EXISTS Titles;
CREATE TABLE Titles (
    "title_id" VARCHAR   not NULL,
    "title" VARCHAR   not NULL,
    PRIMARY KEY ("title_id"));
SELECT * FROM Titles


DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
	"sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    PRIMARY KEY ("emp_no"),
    FOREIGN KEY("emp_title_id") REFERENCES Titles ("title_id"));   
SELECT * FROM Employees

--Option: for if I declare Titles table after Employees table
--ALTER TABLE Employees 
--ADD FOREIGN KEY(emp_title_id) REFERENCES Titles (title_id));

DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments(
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    PRIMARY KEY ("dept_no")); 
SELECT * FROM Departments

DROP TABLE IF EXISTS "Department_Managers";
CREATE TABLE "Department_Managers" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    FOREIGN KEY("dept_no") REFERENCES Departments ("dept_no"),
    FOREIGN KEY("emp_no") REFERENCES Employees ("emp_no"));
SELECT * FROM "Department_Managers"

DROP TABLE IF EXISTS "Department_Employees";
CREATE TABLE "Department_Employees" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    FOREIGN KEY("emp_no") REFERENCES Employees ("emp_no"),
    FOREIGN KEY("dept_no") REFERENCES Departments ("dept_no"));
SELECT * FROM "Department_Employees"

DROP TABLE IF EXISTS Salaries;
CREATE TABLE Salaries (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    FOREIGN KEY("emp_no") REFERENCES Employees ("emp_no"));
SELECT * FROM Salaries

--Issues to remember(Postgres in DBM: DBeaver): 
	--Double check to see that columns aren't being created but already exists
	--Column names need "" double quotes
	--Table names with _(underscores) need double quotes
	--All primary keys take priority
    
--Create a Drop Script starting with foreign keys to prevent primary keys in Table error



