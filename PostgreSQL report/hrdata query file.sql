-- CREATING THE TABLE
create table hrdata
(
	emp_no int8 PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_status varchar(50),
	age_band varchar(50),
	age int8,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int8,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int8,
	active_employee int8
)


-- Import Data in Table Using Query
COPY hrdata FROM 'E:\PROJECTS\HR ANALYSIS\PostgreSQL report' DELIMITER ',' CSV HEADER;

-- Check if all the data has been imported
select * from hrdata;


-- 1. TESTING THE KPI's IN THE DASHBOARD

-- a)TOTAL EMPLOYEE COUNT 
select sum(employee_count) as Employee_Count from hrdata; -- 1470
-- or
select count(emp_no) from hrdata; -- 1470

-- Associates Degree
select sum(employee_count) as Employee_Count from hrdata where education='Associates Degree';

-- Bachelor's Degree
select sum(employee_count) as Employee_Count from hrdata where education='Bachelor''s Degree';

-- Doctoral Degree
select sum(employee_count) as Employee_Count from hrdata where education='Doctoral Degree';

-- High Scool Degree
select sum(employee_count) as Employee_Count from hrdata where education='High School';

-- Master's Degree
select sum(employee_count) as Employee_Count from hrdata where education='Master''s Degree';


-- b) TOTAL ATTRITION COUNT
select count(attrition) from hrdata
where attrition='Yes';

-- Associates Degree
select count(attrition) from hrdata where attrition='Yes' and education='Associates Degree';

-- Bachelor's Degree
select count(attrition) from hrdata where attrition='Yes' and education='Bachelor''s Degree';

-- Doctoral Degree
select count(attrition) from hrdata where attrition='Yes' and education='Doctoral Degree';

-- High Scool Degree
select count(attrition) from hrdata where attrition='Yes' and education='High School';

-- Master's Degree
select count(attrition) from hrdata where attrition='Yes' and education='Master''s Degree';


-- c) ATTRITION RATE
select round((select count(attrition) from hrdata 
	   where attrition='Yes')/
	   sum(employee_count)*100,2) from hrdata;
-- Associate Degree

select round((select count(attrition) from hrdata 
	   where attrition='Yes' and education='Associates Degree')/
	   (select sum(employee_count) from hrdata
		where education='Associates Degree')*100,2);

-- Bachelor's Degree

select round((select count(attrition) from hrdata 
	   where attrition='Yes' and education='Bachelor''s Degree')/
	   (select sum(employee_count) from hrdata
		where education='Bachelor''s Degree')*100,2);
        
-- Doctoral Degree

select round((select count(attrition) from hrdata 
	   where attrition='Yes' and education='Doctoral Degree')/
	   (select sum(employee_count) from hrdata
		where education='Doctoral Degree')*100,2);

-- High Scool Degree

select round((select count(attrition) from hrdata 
	   where attrition='Yes' and education='High School')/
	   (select sum(employee_count) from hrdata
		where education='High School')*100,2);
        
-- Master's Degree

select round((select count(attrition) from hrdata 
	   where attrition='Yes' and education='Master''s Degree')/
	   (select sum(employee_count) from hrdata
		where education='Master''s Degree')*100,2);


-- d) ACTIVE EMPLOYEES
SELECT COUNT(attrition) AS "Active Employees"
FROM hrdata WHERE attrition = 'No';
-- OR
select sum(employee_count) - (select count(attrition) 
from hrdata  where attrition='Yes') from hrdata;
-- OR
select (select sum(employee_count) from hrdata) - count(attrition) 
as active_employee from hrdata
where attrition='Yes';


-- Associates Degree

SELECT COUNT(attrition) AS "Active Employees"
FROM hrdata WHERE attrition = 'No'
AND Education='Associates Degree';

-- Bachelor's Degree

SELECT COUNT(attrition) AS "Active Employees"
FROM hrdata WHERE attrition = 'No'
AND Education='Bachelor''s Degree';

-- Doctoral Degree

SELECT COUNT(attrition) AS "Active Employees"
FROM hrdata WHERE attrition = 'No'
AND Education='Doctoral Degree';


-- High Scool Degree

SELECT COUNT(attrition) AS "Active Employees"
FROM hrdata WHERE attrition = 'No'
AND Education='High School';

-- Master's Degree

SELECT COUNT(attrition) AS "Active Employees"
FROM hrdata WHERE attrition = 'No'
AND Education='Master''s Degree';

-- e) AVERAGE AGE

SELECT round(AVG(AGE)) AS "Average Age"
FROM hrdata;

-- Associates Degree

SELECT round(AVG(AGE)) AS "Average Age"
FROM hrdata where Education='Associates Degree';

-- Bachelor's Degree

SELECT round(AVG(AGE)) AS "Average Age"
FROM hrdata where Education='Bachelor''s Degree';

-- Doctoral Degree

SELECT round(AVG(AGE)) AS "Average Age"
FROM hrdata where Education='Doctoral Degree';

-- High Scool Degree

SELECT round(AVG(AGE)) AS "Average Age"
FROM hrdata where Education='High School';

-- Master's Degree

SELECT round(AVG(AGE)) AS "Average Age"
FROM hrdata where Education='Master''s Degree';

-- 2) ATTRITION BY GENDER
SELECT gender, COUNT(attrition) AS attrition_count
FROM hrdata
WHERE attrition='Yes'
GROUP BY gender
ORDER BY COUNT(attrition) DESC;

-- 3) DEPARTMENT WISE ATTRITION:
SELECT department, COUNT(attrition), round((CAST (COUNT(attrition) AS numeric) / 
(SELECT COUNT(attrition) FROM hrdata WHERE attrition= 'Yes')) * 100, 2) AS percent
FROM hrdata
WHERE attrition='Yes'
GROUP BY department 
ORDER BY COUNT(attrition) DESC;

-- 4) NO OF EMPLOYEE BY AGE GROUP
SELECT age_band, gender, SUM(employee_count) 
AS count_of_employees
FROM hrdata
GROUP BY age_band, gender
ORDER BY age_band, gender DESC;

-- 5) EDUCATION FIELD WISE ATTRITION:
SELECT education_field, COUNT(attrition) AS attrition_count
FROM hrdata
WHERE attrition='Yes'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC;

-- 6) ATTRITION RATE BY GENDER FOR DIFFERENT AGE GROUP
SELECT age_band, gender, COUNT(attrition) AS attrition_count, 
round((CAST(COUNT(attrition) AS numeric) /
(SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes')) * 100,2) AS percent
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender DESC;


-- 7) JOB SATISFACTION RATING
CREATE EXTENSION IF NOT EXISTS tablefunc;
-- Run this query first to activate the cosstab() function in postgres
CREATE EXTENSION IF NOT EXISTS tablefunc;
-- Then run this to get o/p
SELECT * FROM crosstab(
  'SELECT job_role, job_satisfaction, sum(employee_count)
   FROM hrdata
   GROUP BY job_role, job_satisfaction
   ORDER BY job_role, job_satisfaction'
	) AS ct(job_role varchar(50), one numeric, 
			two numeric, three numeric, four numeric)
ORDER BY job_role;













