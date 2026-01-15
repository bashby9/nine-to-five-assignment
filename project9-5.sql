USE LaborStatisticsDB;



/*SELECT ROUND(SUM(value*1000), 0) AS employees_2016
FROM employment
WHERE year = 2016
SELECT s.supersector_code, p.supersector_name, s.series_id, d.data_type_code, s.data_type_code, s.industry_code, i.industry_code, i.industry_name
FROM dbo.series s
JOIN dbo.supersector p
ON s.supersector_code = p.supersector_code
JOIN dbo.datatype d
ON d.data_type_code = s.data_type_code
JOIN dbo.industry i
ON s.industry_code = i.industry_code
WHERE p.supersector_name LIKE '%financial%' AND d.data_type_code = 10 AND i.industry_name LIKE '%banking%';

SELECT ROUND(SUM(a.value), 0) AS employees_2016
FROM dbo.annual_2016 a
JOIN dbo.series s
    ON a.series_id = s.series_id
JOIN dbo.datatype d
    ON s.data_type_code = d.data_type_code
JOIN dbo.industry i
    ON s.industry_code = i.industry_code
WHERE a.year = 2016
AND a.period = 'M13'
AND d.data_type_code = '01'
AND i.industry_code = '000000';

SELECT ROUND(SUM(a.value), 0) AS women_employees_2016
FROM dbo.annual_2016 a
JOIN dbo.series s
    ON a.series_id = s.series_id
JOIN dbo.datatype d
    ON s.data_type_code = d.data_type_code
JOIN dbo.industry i
    ON s.industry_code = i.industry_code
WHERE a.year = 2016
AND a.period = 'M13'
AND d.data_type_code = '10'
AND i.industry_code = '000000';

select * from dbo.series
WHERE series_title = 'Production and nonsupervisory employees';

--data_type_code for Production and nonsupervisory employees is 6 

SELECT ROUND(SUM(a.value), 0) AS production_employees_2016
FROM dbo.annual_2016 a
JOIN dbo.datatype d
on a.id = d.data_type_code
WHERE data_type_code = '6';

--In Jan 2017 what was the average weekly hours worked by production and nonsupervisory employees across all industries?

--series title - production and nonsuper
--data_type_code - production and nonsuper = 6
--data_type_code - average weekly hours of all employees = 2
--data_type_code - average weekly hours of production and nonsupervisory = 7 
--Jan 2017 M01 = Jan year = 2017 

SELECT d.data_type_text, d.data_type_code, j.year, j.PERIOD, j.[value]
FROM dbo.january_2017 j
JOIN dbo.datatype d
ON d.data_type_code = j.id
WHERE data_type_code = '7' AND j.period = 'M01';

SELECT
    ROUND(AVG(j.value), 2) AS avg_weekly_hours_jan_2017
FROM dbo.january_2017 j
JOIN dbo.series s
    ON j.series_id = s.series_id
JOIN dbo.datatype d
    ON s.data_type_code = d.data_type_code
JOIN dbo.industry i
    ON s.industry_code = i.industry_code
WHERE j.period = 'M01'
  AND d.data_type_code = '07'
  AND i.industry_code = '0'
 ;

--what was the total weekly payroll for production and nonsupervisory staff across all industries in 2017. round to nearest penny
--aggregate weekly payrolls of production and nonsupervisory employees = data_type_code = 82


SELECT ROUND(SUM(j.value), 2) AS total_weekly_payroll_jan_2017
FROM dbo.january_2017 j
JOIN dbo.series s
ON j.series_id = s.series_id
WHERE j.period = 'M01'
AND s.data_type_code = 82;

SELECT TOP 50 *
FROM dbo.series s
INNER JOIN dbo.industry i
ON s.industry_code = i.industry_code
ORDER BY id
;

SELECT
    j.series_id, s.industry_code, i.industry_name, j.value
FROM dbo.january_2017 j
JOIN dbo.series s
ON j.series_id = s.series_id
JOIN dbo.industry i
ON s.industry_code = i.industry_code
WHERE j.period = 'M01'
AND j.value > (
    SELECT AVG(a.value)
    FROM dbo.annual_2016 a
    JOIN dbo.series s2
    ON a.series_id = s2.series_id
    WHERE a.period = 'M13'
    AND s2.data_type_code = 82
  );

WITH avg_2016_payroll AS (SELECT AVG(a.value) AS avg_pr_2016
    FROM dbo.annual_2016 a
    JOIN dbo.series s
    ON a.series_id = s.series_id
    WHERE a.period = 'M13'
    AND s.data_type_code = 82)
SELECT j.series_id, s.industry_code, i.industry_name, j.value
FROM dbo.january_2017 j
JOIN dbo.series s
ON j.series_id = s.series_id
JOIN dbo.industry i
On s.industry_code = i.industry_code
WHERE j.period = 'M01'
AND j.value > (SELECT avg_pr_2016 FROM avg_2016_payroll);


SELECT ROUND(j.value, 2) AS average_weekly_earnings, j.year, j.period
FROM dbo.annual_2016 j
JOIN dbo.series s
    ON j.series_id = s.series_id
WHERE s.data_type_code = 30
  AND j.period = 'M13'
UNION
SELECT ROUND(j.value, 2) AS average_weekly_earnings, j.year, j.period
FROM dbo.january_2017 j
JOIN dbo.series s
    ON j.series_id = s.series_id
WHERE s.data_type_code = 30
  AND j.period = 'M01'
ORDER BY year;

--Jan 2017, which industry had most avg hours worked by production and nonsupervisory staff?  Which was lowest? 

SELECT i.industry_name, ROUND(j.value, 2) AS weekly_hrs_Avg
FROM dbo.january_2017 j
JOIN dbo.series s
ON J.SERIES_ID = S.series_id
JOIN dbo.industry i
    ON s.industry_code = i.industry_code
WHERE s.data_type_code = 7 AND j.value = ( 
    SELECT MAX (j2.value)
    FROM dbo.january_2017 j2
    JOIN dbo.series s2
    ON j2.series_id = s2.series_id
    WHERE s2.data_type_code = 7 
);

SELECT i.industry_name, ROUND(j.value, 2) AS weekly_hrs_Avg
FROM dbo.january_2017 j
JOIN dbo.series s
ON J.SERIES_ID = S.series_id
JOIN dbo.industry i
    ON s.industry_code = i.industry_code
WHERE s.data_type_code = 7 AND j.value = ( 
    SELECT MIN (j2.value)
    FROM dbo.january_2017 j2
    JOIN dbo.series s2
    ON j2.series_id = s2.series_id
    WHERE s2.data_type_code = 7 
);*/

SELECT i.industry_name, ROUND(j.value, 2) AS total_weekly_payroll
FROM dbo.january_2017 j
JOIN dbo.series s
ON J.series_id = S.series_id
join dbo.industry i
ON s.industry_code = i.industry_code
WHERE s.data_type_code = 82
AND j.value = (SELECT MIN(j2.value)
FROM dbo.january_2017 j2
JOIN dbo.series s2
ON j2.series_id = s2.series_id
WHERE s2.data_type_code = 82);