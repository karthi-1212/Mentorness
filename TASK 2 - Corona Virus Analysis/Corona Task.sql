-- Q1. Write a code to check NULL values.

SELECT *
FROM `corona virus`
WHERE Province IS NULL
   OR `Country/Region` IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;

-- Q2. If NULL values are present, update them with zeros for all columns. 

UPDATE `corona virus`
SET Province = COALESCE(Province, '0'),
    `Country/Region` = COALESCE(`Country/Region`, '0'),
    Date = COALESCE(Date, '0'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0)
WHERE Province IS NULL
   OR `Country/Region` IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;

-- Q3. Check total number of rows.

SELECT COUNT(*) AS total_rows
FROM `corona virus`;

-- Q4. Check what is start_date and end_date

SELECT MIN(Date) AS start_date, MAX(Date) AS end_date
FROM `corona virus`;

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m')) AS num_months
FROM `corona virus`;

--- The number of months present in each year 

SELECT EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year, 
       COUNT(DISTINCT EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y'))) AS num_month_present
FROM `corona virus`
GROUP BY EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y'));

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT
    CASE
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 1 THEN 'January'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 12 THEN 'December'
    END AS month,
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    ROUND(AVG(confirmed), 2) AS avg_confirmed,
    ROUND(AVG(deaths), 2) AS avg_deaths,
    ROUND(AVG(recovered), 2) AS avg_recovered
FROM `corona virus`
GROUP BY month, EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y'))
ORDER BY year, month;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH grouped_counts AS (
    SELECT 
        CASE
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 1 THEN 'January'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 2 THEN 'February'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 3 THEN 'March'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 4 THEN 'April'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 5 THEN 'May'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 6 THEN 'June'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 7 THEN 'July'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 8 THEN 'August'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 9 THEN 'September'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 10 THEN 'October'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 11 THEN 'November'
            WHEN EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) = 12 THEN 'December'
        END AS month,
        EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
        confirmed,
        deaths,
        recovered,
        COUNT(*) AS frequency
    FROM `corona virus`
    GROUP BY month, year, confirmed, deaths, recovered
),
max_counts AS (
    SELECT month, year, MAX(frequency) AS max_frequency
    FROM grouped_counts
    GROUP BY month, year
)
SELECT gc.month, gc.year, gc.confirmed, gc.deaths, gc.recovered
FROM grouped_counts gc
JOIN max_counts mc ON gc.month = mc.month AND gc.year = mc.year AND gc.frequency = mc.max_frequency
ORDER BY gc.year, gc.month;


-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    MIN(confirmed) AS min_confirmed,
    MIN(deaths) AS min_deaths,
    MIN(recovered) AS min_recovered
FROM `corona virus`
GROUP BY year
ORDER BY year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    MAX(confirmed) AS min_confirmed,
    MAX(deaths) AS min_deaths,
    MAX(recovered) AS min_recovered
FROM `corona virus`
GROUP BY year
ORDER BY year;

-- Q10. The total number of case of confirmed, deaths, recovered each month.
SELECT
    MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS month,
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered
FROM `corona virus`
GROUP BY month, year
ORDER BY year, month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )


SELECT
    SUM(confirmed) AS total_confirmed,
    ROUND(AVG(confirmed), 2) AS avg_confirmed,
    ROUND(VARIANCE(confirmed), 2) AS var_confirmed,
    ROUND(STDDEV(confirmed), 2) AS std_confirmed
FROM `corona virus`;


-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total deaths cases, their average, variance & STDEV )

SELECT
    SUM(deaths) AS total_deaths,
    ROUND(AVG(deaths), 2) AS avg_deaths,
    ROUND(VARIANCE(deaths), 2) AS var_deaths,
    ROUND(STDDEV(deaths), 2) AS std_deaths
FROM `corona virus`;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total recovered cases, their average, variance & STDEV )

SELECT
    SUM(recovered) AS total_recovered,
    ROUND(AVG(recovered), 2) AS avg_recovered,
    ROUND(VARIANCE(recovered), 2) AS var_recovered,
    ROUND(STDDEV(recovered), 2) AS std_recovered
FROM `corona virus`;

-- Q14. Find Country having highest number of the Confirmed case

SELECT `Country/Region`, SUM(Confirmed) AS total_confirmed
FROM `corona virus`
GROUP BY `Country/Region`
ORDER BY total_confirmed DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case

SELECT `Country/Region`, SUM(Deaths) AS total_deaths
FROM `corona virus`
GROUP BY `Country/Region`
ORDER BY total_deaths ASC
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case

SELECT `Country/Region`, SUM(Recovered) AS total_recovered
FROM `corona virus`
GROUP BY `Country/Region`
ORDER BY total_recovered DESC
LIMIT 5;
