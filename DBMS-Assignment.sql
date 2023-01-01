-- SQL ASSIGNMENT 1 --

-- 1
-- Give an SQL schema definition for the employee database as specified. 
-- Choose an appropriate primary key for each relation schema, and insert any other integrity constraints (for examples: foreign keys) you find necessary

-- Database Creation --
CREATE DATABASE db_Employee;

-- Selecting created Database from SQL Schema -- 
USE db_Employee;

-- Creating All tables with proper constraints as required
CREATE TABLE Tbl_employee(
    employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    street VARCHAR(32),
    city VARCHAR(32)
);

CREATE TABLE Tbl_Company(
	company_name VARCHAR(64) NOT NULL PRIMARY KEY,
    city VARCHAR(32)
);

CREATE TABLE Tbl_works(
	employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    company_name VARCHAR(64),
    salary FLOAT,
    FOREIGN KEY (employee_name) REFERENCES Tbl_employee(employee_name),
    FOREIGN KEY (company_name) REFERENCES Tbl_Company(company_name)
);

CREATE TABLE Tbl_manages(
	employee_name VARCHAR(64) NOT NULL PRIMARY KEY,
    manager_name VARCHAR(64) NOT NULL,
    FOREIGN KEY (employee_name) REFERENCES Tbl_employee(employee_name),
    FOREIGN KEY (manager_name) REFERENCES Tbl_employee(employee_name)
);

SHOW TABLES;

-- Inserting valid, sensible fabricated data into all tables as per requirement
INSERT INTO Tbl_employee(employee_name, street, city)
VALUES ('Ujjwal Poudel', 'Maitighar', 'Kathmandu'),
	   ('Rishav Subedi', 'Baneshwor Chowk', 'Kathmandu'),
       ('Santosh Pandey', 'Char Do bato', 'Bhaktapur'),
       ('Prabin Bohora', 'Jwagal', 'Lalitpur'),
       ('Hellington Javier', 'Bhanu Chowk', 'Dharan'),
       ('Einstein Karki', 'New Chowk', 'Biratnagar'),
       ('Newton Neupane', 'Old Chowk', 'Biratnagar'),
       ('Jones Dhakal', 'Old Chowk', 'Old Town'),
       ('Sahil Pradhan', 'Sukhedhara', 'Kathmandu'),
       ('Sajjan Poudel', 'Chovar Dhanda', 'Kritipur');
       
       
INSERT INTO Tbl_Company(company_name, city)
VALUES ('First Bank Corporation', 'Biratnagar'),
	   ('Bhoos Games', 'Lalitpur'),
       ('Fuse Machines', 'Bhaktapur'),
       ('F1Soft IT Solution', 'Kathmandu'),
       ('Small Bank Corporation', 'Birgunj'),
       ('MSI Corporated', 'Kathmandu');

       
INSERT INTO Tbl_Works(employee_name, company_name, salary)
VALUES ('Ujjwal Poudel', 'Bhoos Games', 25000),
	   ('Prabin Bohora', 'Fuse Machines', 69000),
       ('Santosh Pandey', 'F1Soft IT Solution', 45000),
       ('Rishav Subedi', 'Bhoos Games', 100000),
       ('Hellington Javier', 'First Bank Corporation', 25000),
	   ('Einstein Karki', 'First Bank Corporation', 56000),
       ('Newton Neupane', 'First Bank Corporation', 96256),
       ('Jones Dhakal', 'Small Bank Corporation', 56562),
       ('Sahil Pradhan', 'Small Bank Corporation', 98000),
       ('Sajjan Poudel', 'MSI Corporated', 150000);

INSERT INTO Tbl_manages(employee_name, manager_name)
VALUES ('Hellington Javier', 'Newton Neupane'),
	   ('Einstein Karki', 'Newton Neupane'),
       ('Rishav Subedi', 'Ujjwal Poudel'),
	   ('Jones Dhakal', 'Sahil Pradhan');
       
SELECT * FROM Tbl_employee;
SELECT * FROM Tbl_company;
SELECT * FROM Tbl_works;
SELECT * FROM Tbl_manages;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2
-- Consider the employee database, where the primary keys are underlines. 
-- Give an expression in SQL for each of the following queries:

-- 2 (a)
-- QUESTION: Find all the names of all employees who works for First Bank Corporation

-- NOTE: The subquery (inner query) executes once before the main query (outer query) executes. 
--       The main query (outer query) use the subquery result. 

-- Solution using Sub Query
SELECT  TBE.employee_name AS 'Employee Name' FROM Tbl_employee AS TBE
WHERE TBE.employee_name IN
(SELECT TBW.employee_name FROM Tbl_Works AS TBW
WHERE TBW.company_name = 'First Bank Corporation');

-- Solution using INNER JOIN
SELECT TBE.employee_name AS 'Employee Name' FROM Tbl_employee AS TBE
INNER JOIN Tbl_works AS TBW ON TBE.employee_name = TBW.employee_name
WHERE TBW.company_name = 'First Bank Corporation';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (b)
-- QUESTION: Find all names and cities of residence of all employees who work for First Bank Corporation

-- NOTE: When used with a subquery, the word IN is an alias for (= ANY)

-- Solution using Sub Query
SELECT  TBE.employee_name AS 'Employee Name', TBE.city AS 'City of Residence' FROM Tbl_employee AS TBE
WHERE TBE.employee_name = ANY
(SELECT TBW.employee_name FROM Tbl_Works AS TBW
WHERE TBW.company_name = 'First Bank Corporation');

-- Solution using INNER JOIN
SELECT TBE.employee_name AS 'Employee Name', TBE.city AS 'City of Residence' FROM Tbl_employee AS TBE
INNER JOIN Tbl_works AS TBW ON TBE.employee_name = TBW.employee_name
WHERE TBW.company_name = 'First Bank Corporation';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (c)
-- QUESTION: Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10, 000

-- Solution using Sub Query
SELECT  TBE.employee_name AS 'Employee Name',TBE.street as 'Street', TBE.city AS 'City of Residence' FROM Tbl_employee AS TBE
WHERE TBE.employee_name = ANY
(SELECT TBW.employee_name FROM Tbl_Works AS TBW
WHERE TBW.company_name = 'First Bank Corporation' 
AND TBW.salary > 10000);

-- This shows same result for employees as above.
-- So, altering one of the employee salary to observe change in list of employee.
UPDATE Tbl_Works
SET salary = 5000
WHERE employee_name = 'Hellington Javier';

-- Checking for correct query operation
-- Solution using INNER JOIN
SELECT TBE.employee_name AS 'Employee Name', TBE.street as 'Street', TBE.city AS 'City of Residence' FROM Tbl_employee AS TBE
INNER JOIN Tbl_works AS TBW ON TBE.employee_name = TBW.employee_name
WHERE TBW.company_name = 'First Bank Corporation'
AND TBW.salary > 10000;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (d)
-- QUESTION: Find all employees in the database who live in the same cities as the companies for which they work

-- Solution using Sub Query
SELECT * FROM Tbl_employee AS TBE
WHERE TBE.employee_name IN
(SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE TBW.company_name IN
(SELECT TBC.company_name FROM Tbl_company AS TBC
WHERE TBC.city = TBE.city));

-- Solution using INNER JOIN
SELECT TBE.employee_name AS 'Employee Name', TBE.street AS 'Street', TBE.city as 'City of Residence' FROM Tbl_employee AS TBE
INNER JOIN Tbl_works AS TBW
ON TBW.employee_name = TBE.employee_name
INNER JOIN Tbl_company AS TBC
ON TBC.company_name = TBW.company_name
WHERE TBC.city = TBE.city;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (e)
-- QUESTION: Find all employees in the database who live in the same cities and on the same streets as do their managers

-- Updating some info, to show up atleast a result rather than NULL. 
UPDATE Tbl_employee
SET street = 'Maitighar'
WHERE employee_name = 'Rishav Subedi';

-- Solution using Sub Query (Directly from Tbl_manages table based on sub-query condition)
SELECT TBM.employee_name AS 'Employee Name', 
(SELECT TBE.street FROM Tbl_employee AS TBE WHERE TBE.employee_name = TBM.employee_name) AS 'Street',
(SELECT TBE.city FROM Tbl_employee AS TBE WHERE TBE.employee_name = TBM.employee_name) AS 'City of Residence'
FROM Tbl_manages as TBM
WHERE ((SELECT TBE.city, TBE.street FROM Tbl_employee AS TBE WHERE TBE.employee_name = TBM.employee_name) =
(SELECT TBE.city, TBE.street FROM Tbl_employee AS TBE WHERE TBE.employee_name = TBM.manager_name));

-- Another Solution using Sub Query (Tbl_employee table => Tbl_manages table => Tbl_employee table)
SELECT TBE.employee_name AS 'Employee Name', TBE.street as 'Street', TBE.city as 'City of Residence'
FROM Tbl_employee AS TBE
WHERE TBE.employee_name IN
(SELECT TBM.employee_name FROM Tbl_manages AS TBM
WHERE TBM.manager_name IN
(SELECT TBES.employee_name FROM Tbl_employee AS TBES
WHERE TBES.city = TBE.city
AND TBES.street = TBE.street));

-- Solution using INNER JOIN
SELECT TBE.employee_name AS 'Employee Name', TBE.street AS 'Street', TBE.city AS 'City' FROM Tbl_employee AS TBE
INNER JOIN Tbl_manages AS TBM ON TBE.employee_name = TBM.employee_name
INNER JOIN Tbl_employee AS TBES ON TBM.manager_name = TBES.employee_name
WHERE (TBES.city = TBE.city
AND TBES.street = TBE.street);
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (f)
-- QUESTION: Find all employees in the database who do not work for First Bank Corporation

-- Solution using Sub Query (Tbl_employee table => Tbl_works table)
SELECT TBE.employee_name AS 'Employee Name', 
(SELECT TBW.company_name FROM Tbl_works as TBW WHERE TBE.employee_name = TBW.employee_name) as 'Company Name'
FROM Tbl_employee AS TBE
WHERE TBE.employee_name = ANY
(SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE NOT (TBW.company_name  = 'First Bank Corporation'));

-- Another solution using Sub Query (Tbl_works table => Tbl_employee table)
SELECT TBW.employee_name AS 'Employee_name', TBW.company_name AS 'Company Name' FROM Tbl_works AS TBW
WHERE TBW.employee_name IN 
(SELECT TBE.employee_name FROM Tbl_employee AS TBE
WHERE NOT (TBW.company_name = 'First Bank Corporation'));

-- Solution using INNER JOIN
SELECT TBW.employee_name AS 'Employee Name', TBW.company_name AS 'Company Name' FROM Tbl_works AS TBW
INNER JOIN Tbl_employee AS TBE
ON TBW.employee_name = TBE.employee_name
WHERE NOT (TBW.company_name = 'First Bank Corporation');
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (g)
-- QUESTION: Find all employees in the database who earn more than each employee of Small Bank Corporation

-- Understanding: employees with salary greater than the maximum salary earned by any employee of Small Bank Corporation
-- Solution using Inner Query
SELECT TBW.employee_name as 'Employee Name', TBW.salary as 'Employee Salary' FROM Tbl_works as TBW
WHERE TBW.salary >
(SELECT MAX(TBW.salary) FROM Tbl_works as TBW
WHERE TBW.company_name = 'Small Bank Corporation');
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (h)
-- QUESTION: Assume that the companies may be located in several cities. Find all companies located in every city in which Small Bank Corporation is located

-- Understanding: All companies in same city where Small Bank Corporation is located
-- In this case, company_name is the primary key so a company should exist only in a single city.
-- Another scenario could be that a company has multiple branches, and the query could be carried out to 
-- find all companies along with its branch city if one of its branch city is same as Small Bank Corporation

-- Making changes to existing Tbl_company to observer some output
UPDATE Tbl_company
SET city = 'Kathmandu'
WHERE company_name = 'Small Bank Corporation';

-- Solution using Inner Query
SELECT TBC.company_name AS 'Company Name', TBC.city AS 'Location (city)' FROM Tbl_company AS TBC
WHERE TBC.city = 
(SELECT TBC.city FROM Tbl_company AS TBC
WHERE TBC.company_name = 'Small Bank Corporation');
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (i)
-- QUESTION: Find all employees who earn more than the average salary of all employees of their company

SELECT * FROM tbl_works;

-- Approach: Using Temporary table generated using Group By on Company Name along with average salary of each company,
-- and joining this temporary table with existing work table to extract employee with salary greater than average salary of their company

-- Solution: Using only nested queries
SELECT temp_table.employee_name AS 'Employee Name', 
(SELECT TB.salary FROM Tbl_works AS TB WHERE TB.employee_name = temp_table.employee_name) AS 'Salary',
temp_table.AVG_salary AS 'Average Salary' FROM
(SELECT TBC.employee_name AS employee_name, TBC.company_name, AVG(TBC.salary) AS AVG_salary FROM Tbl_works AS TBC
GROUP BY TBC.company_name) AS temp_table
WHERE temp_table.company_name IN 
(SELECT TBCS.company_name FROM Tbl_works AS TBCS
WHERE TBCS.salary >= temp_table.AVG_salary);

-- Solution: Using INNER JOIN
SELECT DISTINCT temp_table.employee_name AS 'Employee Name', 
(SELECT TB.salary FROM Tbl_works AS TB WHERE TB.employee_name = temp_table.employee_name) AS 'Salary',
temp_table.AVG_salary AS 'Average Salary' FROM
(SELECT TBC.employee_name AS employee_name, TBC.company_name, AVG(TBC.salary) AS AVG_salary FROM Tbl_works AS TBC
GROUP BY TBC.company_name) AS temp_table
INNER JOIN Tbl_works AS TBCS
ON temp_table.company_name = TBCS.company_name
WHERE TBCS.salary >= temp_table.AVG_salary;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (j)
-- QUESTION: Find the company that has the most employees

-- A hacky solution to find maximum employee count
SELECT TBW.company_name AS 'Company Name', COUNT(TBW.employee_name) AS MAX_Employee_Count
FROM Tbl_works AS TBW GROUP BY TBW.company_name
ORDER BY MAX_Employee_Count DESC
LIMIT 1;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (k)
-- QUESTION: Find the company that has the smallest payroll

-- Simple solution uing Sorting (ORDER BY) and Limit
SELECT TBW.company_name AS 'Company Name', TBW.salary as 'Smallest Payroll' FROM Tbl_works AS TBW
ORDER BY TBW.salary ASC
LIMIT 1;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 (l)
-- QUESTION: Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation

SELECT temp_table.company_name AS 'Company Name' FROM 
(SELECT TBW.company_name, AVG(TBW.salary) AS AVG_Salary FROM Tbl_works AS TBW
GROUP BY TBW.company_name) AS temp_table
WHERE temp_table.AVG_Salary > 
(SELECT AVG(TBW.Salary) FROM Tbl_works AS TBW
GROUP BY TBW.company_name
HAVING TBW.company_name = 'First Bank Corporation');
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3
-- Consider the relational database of given schema. Give an expression in SQL for each of the following queries
 
 -- 3 (a)
 -- QUESTION: Modify the database so that Jones now lives in Newtown
 
 -- A peak at current record for Jones
 SELECT * FROM Tbl_employee AS TBE
 WHERE employee_name LIKE 'Jones%';
 
 UPDATE Tbl_employee
 SET city = 'Newtown', street = 'NewChowk'
 WHERE employee_name = 'Jones Dhakal';
 
 -- A peak at updated record for Jones
  SELECT * FROM Tbl_employee AS TBE
 WHERE employee_name = 'Jones Dhakal';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3 (b) 
-- QUESTION: Give all employees of First Bank Corporation a 10 percent raise
 
 
-- A peak at Current salary of First Bank Corporation Employees'
SELECT TBW.employee_name, TBW.salary FROM Tbl_works as TBW 
WHERE TBW.company_name = 'First Bank Corporation';

UPDATE Tbl_Works
SET Salary = Salary * 1.1
WHERE employee_name IN
(SELECT employee_name FROM Tbl_Works
WHERE company_name = 'First Bank Corporation');

-- A peak at Updated salary of First Bank Corporation Employees'
SELECT TBW.employee_name, TBW.salary FROM Tbl_works as TBW 
WHERE TBW.company_name = 'First Bank Corporation';
 
 -- ----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- 3 (c)
-- QUESTION: Give all managers of First Bank Corporation a 10 percent raise;

-- Before giving raise: A peak at salary of managers at 'First Bank Corporation'
SELECT TBW.employee_name, TBW.salary FROM Tbl_works AS TBW
WHERE TBW.employee_name IN 
(SELECT TBM.manager_name FROM Tbl_manages AS TBM)
AND TBW.company_name = 'First Bank Corporation';

UPDATE Tbl_works AS TBWS
SET TBWS.salary = TBWS.salary * 1.1
WHERE TBWS.employee_name IN 
(SELECT DISTINCT TBM.manager_name FROM Tbl_manages AS TBM
WHERE TBM.manager_name IN
(SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE TBW.company_name = 'First Bank Corporation'));

-- After giving raise: A peak at salary of managers at 'First Bank Corporation'
SELECT TBW.employee_name, TBW.salary FROM Tbl_works AS TBW
WHERE TBW.employee_name IN 
(SELECT TBM.manager_name FROM Tbl_manages AS TBM)
AND TBW.company_name = 'First Bank Corporation';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3 (d)
-- QUESTION: Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100, 000; in such cases, give only 3 percent raise
UPDATE Tbl_works AS TBWS
SET TBWS.salary = 
CASE
	WHEN TBWS.salary > 110000 THEN TBWS.salary * 1.03
	ELSE TBWS.salary * 1.1
END
WHERE TBWS.employee_name IN 
(SELECT DISTINCT TBM.manager_name FROM Tbl_manages AS TBM
WHERE TBM.manager_name IN
(SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE TBW.company_name = 'First Bank Corporation'));

-- After giving raise: A peak at salary of managers at 'First Bank Corporation'
-- Updated Salary according to raise condition
SELECT TBW.employee_name, TBW.salary FROM Tbl_works AS TBW
WHERE TBW.employee_name IN 
(SELECT TBM.manager_name FROM Tbl_manages AS TBM)
AND TBW.company_name = 'First Bank Corporation';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3 (e)
-- QUESTION: Delete all tuples in the works relation for employees of Small Bank Corporation

-- A peak at Tbl_works table for all employees who work at 'Small Bank Corporation'
SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE TBW.company_name = 'Small Bank Corporation';

-- Temporarily disabling MySQL safe-update session 
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Tbl_works
WHERE employee_name IN
(SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE TBW.company_name = 'Small Bank Corporation');

-- Enabling MySQL safe_update session
SET SQL_SAFE_UPDATES = 1;

-- Null return: specifying that there is no employees from Small Bank Corporation in Tbl_works table.
SELECT TBW.employee_name FROM Tbl_works AS TBW
WHERE TBW.company_name = 'Small Bank Corporation';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------