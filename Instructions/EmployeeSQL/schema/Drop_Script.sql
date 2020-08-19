--temporarily disable all the foreign key constraints in order for the drop statements work:
SET FOREIGN_KEY_CHECKS = 0;

SELECT
    tables 
FROM
    schemas.tables
WHERE
    table_schema = postgres; --table_schema = db_name;

--Delete all tables on by one from the list:

DROP TABLE IF EXISTS Titles;

DROP TABLE IF EXISTS Employees;

DROP TABLE IF EXISTS Departments;

DROP TABLE IF EXISTS "Department_Managers";

DROP TABLE IF EXISTS "Department_Employees";

DROP TABLE IF EXISTS Salaries;

--Turn on foreign key constraint after it’s done:

SET FOREIGN_KEY_CHECKS = 1;



--Possible workaround with mysqldump which is faster and easier.

--First, disable foreign key check:
	--echo "SET FOREIGN_KEY_CHECKS = 0;" > ./temp.sql

--Then dump the db with no data and drop all tables:
	--mysqldump --add-drop-table --no-data -u root -p db_name | grep 'DROP TABLE' >> ./temp.sql

--Turn the foreign key check back on:
	--echo "SET FOREIGN_KEY_CHECKS = 1;" >> ./temp.sql

--Now restore the db with the dump file:
	--mysql -u root -p db_name < ./temp.sql
