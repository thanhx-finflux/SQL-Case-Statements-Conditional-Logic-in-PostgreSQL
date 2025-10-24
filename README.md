# SQL-Case-Statements-Conditional-Logic-in-PostgreSQL
This repository is about the SQL CASE statement in PostgreSQL for implementing conditional logic directly in database queries.

- Conditional logic with simple and searched CASE statements
- Combining transposition for pivoting results in a column format.
- Real-world use case: employee categorization, salary evaluations, and profit analysis.

### Tools
- Database: PostgreSQL
- Language: SQL
- Tool: pgAdmin

### Set Up the Database:
- Create a PostgreSQL database
- Run the script EmployeesExcerpt.sql

### Execute queries
- Open the script in your SQL client.
- Run sections incrementally to explore results.

### Conditional statement using a single CASE clause
```sql
SELECT
    emp_no,
    first_name,
    last_name,
    CASE gender
        WHEN 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM employees;
```

```sql
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
```
### CASE with Data Logic

```sql
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
```

### CASE with Aggregates
```sql
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
```
### Count employees per salary category
```sql
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
```
### CASE with joins

```sql
-- Manager vs. Regular Employee
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

-- Employment status
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
```
### Data Transposition with CASE
```sql
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
FROM sale
```
### Why CASE statements?
- Handle complex logic without external scripting
- Application for HR analysis, such as salary, employment status, and sales reporting.
### Contact
Thanh Xuyen, Nguyen

LinkedIn: [xuyen-thanh-nguyen-0518](https://www.linkedin.com/in/xuyen-thanh-nguyen-0518/)

Email: thanhxuyen.nguyen@outlook.com
