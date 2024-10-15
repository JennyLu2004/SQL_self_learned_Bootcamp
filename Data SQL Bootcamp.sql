SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT first_name, 
last_name, 
birth_date, 
age, 
(age + 10) * 20 * 2 
FROM parks_and_recreation.employee_demographics;
# mySQL follows PEMDAS

SELECT DISTINCT first_name, gender
FROM parks_and_recreation.employee_demographics;
# Since there are 2 variables and the first_name values are all unique, the pair is a unique value itself

-- # WHERE
SELECT *
FROM employee_salary 
WHERE first_name = 'Leslie';

SELECT *
FROM employee_salary 
WHERE salary >= 50000;

-- # AND, OR
SELECT * 
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44)
OR age > 55;

-- # LIKE Statement 
-- %: anything 
-- _: a specific value
SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a__';
# 'Jer%' means that as long as it starts with Jer, the rest can be anything
# '%a%' means that as long as there is an 'a' in the name 
# 'a%' means the output has to start with an 'a', can be understood as 'A' too
# 'a__' means the output starts with an 'a' and has 2 characters after it
# 'a___%' means the output starts with an 'a'l, has 3 characters after it, then anything after it

SELECT * 
FROM employee_demographics
WHERE birth_date LIKE '1989%';

-- # GROUP BY
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;
# Variables from SELECT usually match with those from GROUP BY

-- # ORDER BY 
SELECT *
FROM employee_demographics
ORDER BY gender, age
;
# ORDER BY gender, age DESC: gender will stay the same but age will be flipped
# You can also use the position of a column. Ex: 5 is the column position of 'gender'

-- HAVING vs WHERE 
SELECT gender, AVG(age) 
FROM employee_demographics 
WHERE AVG(age) > 40
GROUP BY gender;
# The code above doesn't work because the AVG(age) function only performs after the GROUP BY gender code; so WHERE AVG(age) is not applicable

SELECT gender, AVG(age) 
FROM employee_demographics 
GROUP BY gender
HAVING AVG(age) > 40;
# Instead, right after GROUP BY, use HAVING 

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;
# Using both WHERE and HAVING in one command 

-- # LIMIT & ALIASING 
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2,1; 

-- Aliasing 
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;
# AS is implied, so if you don't want to write it, it still works without AS
# LIMIT 3, 2: means at position 3, select the 2 rows after it 

-- # INNER JOINS 
SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_salary;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem 
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
# by default, JOIN is an INNER JOIN 
# Use aliases for shorter code 
# When it says "field list is ambigous", it's asking us to clarify which table do we take those columns from

-- OUTER JOINS 
# LEFT JOIN: Outputs the entire first table and anything that matches the first table from the second table 
# RIGHT JOIN: Outputs the entire second table and anything that matches the second table from the first table 
# If there is not a match, then that row values are NULL 
SELECT *
FROM employee_demographics AS dem 
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- SELF JOIN: when a table joins itself 
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

-- Joining multiple together 
SELECT *
FROM employee_demographics AS dem 
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id  = pd.department_id;
    
-- Union - collect ROWS of data from the same or separate table
SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;
# UNION DISTINCT: Removing all the duplicates, just keep unique values 
# UNION ALL: Show everything
# The selected columns should be the same from 2 tables

SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;
# 'Old' AS label: creates a column called label with the value Old 

-- String Functions 
SELECT LENGTH('skyfall');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;
# ORDER BY 2: Order the 2nd column in increasing order 

SELECT UPPER('Sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

-- TRIM: take the white space before and after the string and get rid of it 
SELECT TRIM('    Sky   ');
SELECT LTRIM('    Sky    ');
SELECT RTRIM('    Sky    ');

-- LEFT(column_name, a number): how many characters from the left hand side do we want to select 
SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3,2), 
birth_date,
SUBSTRING(birth_date, 6,2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

SELECT LOCATE('x', 'alexander');

SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;

-- Case Statements
SELECT first_name, 
last_name,
age,
CASE 
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Bracket
FROM employee_demographics;

-- Task: Determine the people's salaries at the end of the year and if they got a bonus, how much was it
-- 1. Look at Pay Increase and Bonus 
-- < 50000: 5% raise 
-- > 50000: 7% raise 
-- Finance: 10% bonus 

SELECT first_name, last_name, salary,
CASE 
	WHEN salary < 50000 THEN salary + (salary * 0.05) 
    WHEN salary > 50000 THEN salary + (salary * 0.07)
END AS New_Salary,
CASE 
	WHEN dept_id = 6 THEN salary * 0.1
END AS Bonus
FROM employee_salary;

-- Subqueries: a query within another query
-- Task: Only add the employees who works at the Parks and Recreation department (1)

SELECT  * 
FROM employee_demographics
WHERE employee_id IN (SELECT employee_id
						FROM employee_salary 
                        WHERE dept_id = 1);
# What this does is it will match the employee_id from employee_demographics to the employee_id from employee_salary where the dep_id = 1

SELECT first_name, salary, 
(SELECT AVG(salary) 
FROM employee_salary)
FROM employee_salary;

SELECT AVG(max_age)
FROM
(SELECT gender, 
AVG(age) AS avg_age,
MIN(age) AS min_age,
MAX(age) AS max_age, 
COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_table;

-- CTEs - common table expression 
WITH CTE_Example (Gender, AVG_sal, MAX_sal, MIN_sal, COUNT_sal) AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal 
FROM employee_demographics dem 
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;
# After WITH table_name, if you open parenthesis and add column names in there, it will overwrite the aliases you have
# Another way to do it. The first one is preferred because it's easier to understand

SELECT AVG(avg_sal)
FROM (SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal 
FROM employee_demographics dem 
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery;


# Joining CTE tables and doing a bit complex stuff
WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary 
WHERE salary > 50000
) 
SELECT * 
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;

-- TEMP TABLES: if you exit the program, it will be gone when you come back
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50), 
last_name varchar(50), 
favorite_movie varchar(100)
);

SELECT * 
FROM temp_table;

INSERT INTO temp_table
VALUES('Jenny', 'Lu', 'Stranger Things');

SELECT * 
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

SELECT * 
FROM salary_over_50k;

-- Stored Procedures: ways to save your SQL code that you can reuse over and over again 
-- Parameters 
DELIMITER $$
CREATE PROCEDURE large_salaries4(employee_ID_param INT)
BEGIN
	SELECT salary
	FROM employee_salary
	WHERE employee_id = employee_ID_param;
END $$
DELIMITER ;

CALL large_salaries4(1);
# notice that you get two tables at the bottom 

-- Triggers and Events

SELECT * 
FROM employee_salary;

SELECT * 
FROM employee_demographics;

DELIMITER $$ 
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW  
BEGIN 
	INSERT INTO employee_demographics (employee_id, first_name, last_name) 
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
    # NEW: new rows that are inserted, in this case, it is the new employee_id, first_name, last_name
    # OLD: rows that are deleted or updated 
END $$ 
DELIMITER ;
    # You can also use BEFORE keyword, depending on what your command is 

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id) 
VALUES (13, 'Zendaya', 'Coleman', 'Entertainment 720 CEO', 1000000, NULL); 

-- EVENTS: An event takes place when it's scheduled
# Create an event where it checks daily or monthly that when an employee reaches a specific age, they are 
# out of the table and they will be retired

SELECT * 
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_old_people
ON SCHEDULE EVERY 30 SECOND 
DO 
BEGIN 
	DELETE
    FROM employee_demographics 
    WHERE age >= 60; 
END $$ 
DELIMITER ;

SHOW VARIABLES LIKE 'event';

select * 
from employee_salary;

# The max salary in the company
select *, max(salary) over() as max_salary
from employee_salary;

# The max salary by department_id, using partition by 
select *, max(salary) over(partition by dept_id) as max_salary 
from employee_salary;

-- row_number, rank, dense_rank, lead, lag 
# show the number of records in each dept_id 
select *, row_number() over(partition by dept_id) as rn
from employee_salary;

# Fetch the first 2 employees from each department to join the company 
-- using row_number and a subquery 
select * from(
	select *,
	row_number() over(partition by dept_id order by employee_id) as rn
	from employee_salary) x
where x.rn < 3 and dept_id IS NOT NULL;

-- fetch the top 3 employees in each department earning the max salary 
# rank(): For every duplicates, it's going to assign the same value, but the order after that duplicate will be skipped
select * from (
	select *,
	rank() over(partition by dept_id order by salary desc) as rnk 
	from employee_salary
	where dept_id IS NOT NULL) x
where x.rnk < 4;

-- dense_rank(): For every duplicates, it's going to assign the same value, but not skip the order after that
select * from (
	select *,
    rank() over(partition by dept_id order by salary desc) as rnk,
	dense_rank() over(partition by dept_id order by salary desc) as dense_rnk,
    row_number() over(partition by dept_id  order by salary desc) as rn
	from employee_salary
	where dept_id IS NOT NULL) x;
  
# row_number vs rank vs dense_rank
select *,
    rank() over(partition by dept_id order by salary desc) as rnk,
	dense_rank() over(partition by dept_id order by salary desc) as dense_rnk,
    row_number() over(partition by dept_id  order by salary desc) as rn
	from employee_salary;
    
-- lead / lag
-- fetch a query to display whether the salary of an employee is higher, lower or equal to the previous employee
# lag() shows the value from the previous row by default
select *,
lag(salary) over(partition by dept_id order by employee_id) as prev_emp_salary
from employee_salary;

# lag(column_name, 2, 0) shows the value from 2 previous rows and replace the NULL values with 0
select *,
lag(salary,2,0) over(partition by dept_id order by employee_id) as prev_emp_salary
from employee_salary;

-- lead(): shows the value from the next row by default
select *,
lag(salary) over(partition by dept_id order by employee_id) as prev_emp_salary,
lead(salary) over(partition by dept_id order by employee_id) as next_emp_salary
from employee_salary;

# show the employee whose salary is higher, lower or equal the previous employee
select e.*,
lag(e.salary) over(partition by dept_id order by employee_id) as prev_emp_salary,
case when e.salary > lag(e.salary) over(partition by dept_id order by employee_id) then 'Higher than previous employee'
	when e.salary < lag(e.salary) over(partition by dept_id order by employee_id) then 'Lower than previous employee'
    when e.salary = lag(e.salary) over(partition by dept_id order by employee_id) then 'Equal to previous employee'
    end sal_range
from employee_salary e
where dept_id IS NOT NULL;