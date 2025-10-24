-- Active: 1761242575631@@127.0.0.1@5432@employees_db@public
-- Active: 1761242575631@@127.0.0.1@5432@employees_db@public
###############################################################
###############################################################
-- SQL CASE Statements
###############################################################
###############################################################
/*
 - The SQL CASE statement is used to create different conditions in a query.
 - It is similar to the IF-THEN-ELSE statement in programming languages.
 - The CASE statement goes through conditions and returns a value when the first condition is met.
 - Once a condition is true, it will stop reading and return the result.
 - If no conditions are true, it returns the value in the ELSE clause.
 - If there is no ELSE part and no conditions are true, it returns NULL.
 - Syntax:
 CASE
 WHEN condition_1 THEN result_1
 WHEN condition_2 THEN result_2
 ...
 ELSE result_n
 END;
 - You can also use the CASE statement in a simplified form:
 CASE expression
 WHEN value_1 THEN result_1
 WHEN value_2 THEN result_2
 ...
 ELSE result_n
 END;
 */
#############################
-- Conditional statement using a single CASE clause
#############################
-- Retrieve all the data in the employees table
SELECT * FROM employees;

-- Change M to Male and F to Female in the employees table
SELECT
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM employees;

-- 1.4: This gives the same result as above
SELECT
    emp_no,
    first_name,
    last_name,
    CASE gender
        WHEN 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM employees;

#############################
-- Adding multiple conditions to a CASE statement
#############################
-- Retrieve all the data in the customers table
SELECT * FROM customers;

-- Create a column called Age_Category that returns Young for ages less than 30, Aged for ages greater than 60, and Middle Aged otherwise
SELECT
    customer_id,
    customer_name,
    age,
    CASE
        WHEN age < 30 THEN 'Young'
        WHEN age > 60 THEN 'Aged'
        ELSE 'Middle Aged'
    END AS Age_Category
FROM customers
ORDER BY age;

-- Retrieve a list of employees that were employed before 1990, between 1990 and 1995, and after 1995
SELECT * FROM employees;

SELECT
    emp_no,
    first_name,
    last_name,
    hire_date,
    EXTRACT(
        YEAR
        FROM hire_date
    ) AS hire_year,
    CASE
        WHEN EXTRACT(
            YEAR
            FROM hire_date
        ) < 1990 THEN 'Employed before 1990'
        WHEN EXTRACT(
            YEAR
            FROM hire_date
        ) BETWEEN 1990 AND 1995  THEN 'Employed between 1990 and 1995'
        ELSE 'Employed after 1995'
    END AS employment_period
FROM employees
ORDER BY hire_date;

#############################
-- The CASE Statement and Aggregate Functions
#############################
-- Retrieve the average salary of all employees
SELECT * FROM salaries;

SELECT emp_no, ROUND(AVG(salary), 2) AS average_salary
FROM salaries
GROUP BY
    emp_no
ORDER BY average_salary DESC;

-- Retrieve a list of the average salary of employees. If the average salary is more than 80000, return Paid Well.
-- If the average salary is less than 80000, return Underpaid, otherwise, return Unpaid
SELECT
    emp_no,
    ROUND(AVG(salary), 2) AS average_salary,
    CASE
        WHEN AVG(salary) > 80000 THEN 'Paid Well'
        WHEN AVG(salary) < 80000 THEN 'Underpaid'
        ELSE 'Unpaid'
    END AS salary_category
FROM salaries
GROUP BY
    emp_no
ORDER BY average_salary DESC;

-- Retrieve a list of the average salary of employees.
-- If the average salary is more than 80000 but less than 100000, return Paid Well.
-- If the average salary is less than 80000, return Underpaid, otherwise, return Manager
SELECT
    emp_no,
    ROUND(AVG(salary), 2) AS average_salary,
    CASE
        WHEN AVG(salary) BETWEEN 80000 AND 100000  THEN 'Paid Well'
        WHEN AVG(salary) < 80000 THEN 'Underpaid'
        ELSE 'Manager'
    END AS salary_category
FROM salaries
GROUP BY
    emp_no
ORDER BY average_salary DESC;

-- Count the number of employees in each salary category
SELECT
    salary_category,
    COUNT(*) AS number_of_employees
FROM (
        SELECT
            emp_no, CASE
                WHEN AVG(salary) BETWEEN 80000 AND 100000  THEN 'Paid Well'
                WHEN AVG(salary) < 80000 THEN 'Underpaid'
                ELSE 'Manager'
            END AS salary_category
        FROM salaries
        GROUP BY
            emp_no
    ) a
GROUP BY
    salary_category;

#############################
-- The CASE Statement and SQL Joins
#############################
-- Retrieve all the data from the employees and dept_manager tables
SELECT * FROM employees ORDER BY emp_no DESC;

SELECT * FROM dept_manager;

-- Join all the records in the employees table to the dept_manager table
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name
FROM employees e
    LEFT JOIN dept_manager dm ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no;

-- Join all the records in the employees table to the dept_manager table where the employee number is greater than 109990
SELECT e.emp_no, dm.emp_no, e.first_name, e.last_name
FROM employees e
    LEFT JOIN dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;

-- Obtain a result set containing the employee number, first name, and last name
-- of all employees. Create a 4th column in the query, indicating whether this
-- employee is also a manager, according to the data in the
-- dept_manager table, or a regular employee
SELECT
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN emp_no IN (
            SELECT emp_no
            FROM dept_manager
        ) THEN 'Manager'
        ELSE 'Regular Employee'
    END AS employee_type
FROM employees
ORDER BY emp_no DESC;

-- Obtain a result set containing the employee number, first name, and last name
-- of all employees with a number greater than '109990'. Create a 4th column in the query,
-- indicating whether this employee is also a manager, according to the data in the
-- dept_manager table, or a regular employee
SELECT
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN emp_no IN (
            SELECT emp_no
            FROM dept_manager
        ) THEN 'Manager'
        ELSE 'Regular Employee'
    END AS employee_type
FROM employees
WHERE
    emp_no > 109990
ORDER BY emp_no DESC;

#############################
-- The CASE Statement together with Aggregate Functions and Joins
#############################
-- Retrieve all the data from the employees and salaries tables
SELECT * FROM employees;

SELECT * FROM salaries;

-- Retrieve a list of all salaries earned by an employee
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no;

/* Retrieve a list of employee number, first name and last name.
Add a column called 'salary difference' which is the difference between the
employees' maximum and minimum salary. Also, add a column called
'salary_increase', which returns 'Salary was raised by more than $30,000' if the difference 
is more than $30,000, 'Salary was raised by more than $20,000 but less than $30,000',
if the difference is between $20,000 and $30,000, 'Salary was raised by less than $20,000'
if the difference is less than $20,000 */
SELECT
    e.emp_no,
    first_name,
    last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN (MAX(s.salary) - MIN(s.salary)) > 30000 THEN 'Salary was raised by more than $30,000'
        WHEN (MAX(s.salary) - MIN(s.salary)) BETWEEN 20000 AND 30000  THEN 'Salary was raised by more than $20,000 but less than $30,000'
        ELSE 'Salary was raised by less than $20,000'
    END AS salary_increase
FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY
    e.emp_no;

-- Retrieve all the data from the employees and dept_emp tables
SELECT * FROM employees;

SELECT * FROM dept_emp;

/* Extract the employee number, first and last name of the first 100 employees, 
and add a fourth column called "current_employee" saying "Is still employed",
if the employee is still working in the company, or "Not an employee anymore",
if they are not more working in the company.
*/
SELECT
    e.emp_no,
    e.first_name,
    e.last_name,
    de.to_date,
    CASE
        WHEN MAX(de.to_date) > CURRENT_DATE THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
GROUP BY
    e.emp_no,
    de.to_date
LIMIT 100;

#############################
-- Transposing data using the CASE clause
#############################
-- Retrieve all the data from the sales table
SELECT * FROM sales;

-- Retrieve the count of the different profit_category from the sales table
SELECT a.profit_category, COUNT(*)
FROM (
        SELECT
            order_line, profit, CASE
                WHEN profit < 0 THEN 'No Profit'
                WHEN profit > 0
                AND profit < 500 THEN 'Low Profit'
                WHEN profit > 500
                AND profit < 1500 THEN 'Good Profit'
                ELSE 'High Profit'
            END AS profit_category
        FROM sales
    ) a
GROUP BY
    a.profit_category;

-- Transpose above
SELECT
    SUM(
        CASE
            WHEN profit < 0 THEN 1
            ELSE 0
        END
    ) AS no_profit,
    SUM(
        CASE
            WHEN profit > 0
            AND profit < 500 THEN 1
            ELSE 0
        END
    ) AS low_profit,
    SUM(
        CASE
            WHEN profit >= 500
            AND profit < 1500 THEN 1
            ELSE 0
        END
    ) AS good_profit,
    SUM(
        CASE
            WHEN profit >= 1500 THEN 1
            ELSE 0
        END
    ) AS high_profit
FROM sales;

-- Retrieve the number of employees in the first four departments in the dept_emp table
SELECT * FROM dept_emp;

SELECT dept_no, COUNT(*)
FROM dept_emp
WHERE
    dept_no IN (
        'd001',
        'd002',
        'd003',
        'd004'
    )
GROUP BY
    dept_no
ORDER BY dept_no;

--  Transpose above
SELECT
    SUM(
        CASE
            WHEN dept_no = 'd001' THEN 1
            ELSE 0
        END
    ) AS department_1,
    SUM(
        CASE
            WHEN dept_no = 'd002' THEN 1
            ELSE 0
        END
    ) AS department_2,
    SUM(
        CASE
            WHEN dept_no = 'd003' THEN 1
            ELSE 0
        END
    ) AS department_3,
    SUM(
        CASE
            WHEN dept_no = 'd004' THEN 1
            ELSE 0
        END
    ) AS department_4
FROM dept_emp;