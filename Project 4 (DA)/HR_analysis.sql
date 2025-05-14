-- Classical HR schema --
---------------------------------------------------------------------------------------------------------------------------------
-- Work Description
-- In this work, we utilize the HR database created in PostgreSQL to perform data analysis using fundamental SQL queries. 
-- The primary goal is to study and apply key SQL functionalities, including selections, filtering, sorting, aggregation, 
-- table joins, subqueries, window functions, common table expressions (CTEs), and data management operations (UPDATE, DELETE).
---------------------------------------------------------------------------------------------------------------------------------
-- Описание работы
-- В данной работе мы используем базу данных HR, созданную в PostgreSQL, для выполнения анализа данных с помощью основных запросов SQL.
-- Основная цель — изучение и применение ключевых функций SQL, включая выборки, фильтрацию, сортировку, агрегацию, соединения таблиц, 
-- подзапросы, оконные функции, общие табличные выражения (CTE) и управление данными (UPDATE, DELETE).
---------------------------------------------------------------------------------------------------------------------------------

-- простые выборки 
SELECT * 
  FROM regions
 LIMIT 10;
 
SELECT * 
  FROM countries
 LIMIT 10;

SELECT * 
  FROM locations
 LIMIT 10;

SELECT * 
  FROM departments
 LIMIT 10;

SELECT * 
  FROM jobs
 LIMIT 10;
 
-- названия стран
SELECT country_name 
  FROM countries;

-- сотрудники с ограничением количества строк (5)
SELECT first_name, last_name 
  FROM employees 
 LIMIT 5;

-- уникальные городы из таблицы locations
SELECT DISTINCT city 
  FROM locations;

-- сотрудники с зарплатой больше 10000
SELECT first_name, last_name, salary 
  FROM employees 
 WHERE salary > 10000;

-- сортировка сотрудников по зарплате (по убыванию)
  SELECT first_name, last_name, salary 
    FROM employees 
ORDER BY salary DESC;

-- сотрудники из определенного отдела (напр., department_id = 80)
SELECT first_name, last_name 
  FROM employees 
 WHERE department_id = 80;

-- выборка сотрудников с комиссией (commission_pct не NULL)
SELECT first_name, last_name, commission_pct 
  FROM employees 
 WHERE commission_pct IS NOT NULL;

-- сотрудники, чьи имена начинаются на 'A'
SELECT first_name, last_name 
  FROM employees 
 WHERE first_name LIKE 'A%';

-- содтрудники с зарплатой в диапазоне от 5000 до 10000
SELECT first_name, last_name, salary 
  FROM employees 
 WHERE salary BETWEEN 5000 AND 10000;

-- сотруднки из нескольких отделов (с IN)
SELECT first_name, last_name, department_id 
  FROM employees 
 WHERE department_id IN (50, 80, 90);

-- подсчет общего количества сотрудников
SELECT COUNT(*) AS total_employees 
  FROM employees;

-- подсчет сотрудников в каждом отделе
  SELECT department_id, COUNT(*) AS employee_count 
    FROM employees 
GROUP BY department_id;

-- вычисление средней зарплаты сотрудников
SELECT AVG(salary) AS average_salary 
  FROM employees;

-- максимальная и минимальная зарплата в компании
SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary 
  FROM employees;

-- сумма зарплат сотрудников в отделе 80
SELECT SUM(salary) AS total_salary 
  FROM employees 
 WHERE department_id = 80;

-- соединение таблиц employees и departments (INNER JOIN)
    SELECT e.first_name, e.last_name, d.department_name
      FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- сотрудники и их должности (JOIN с jobs)
    SELECT e.first_name, e.last_name, j.job_title
      FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id;

-- LEFT JOIN для получения всех отделов, даже без сотрудников
   SELECT d.department_name, COUNT(e.employee_id) AS employee_count
     FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
 GROUP BY d.department_name;

-- выборка сотрудников и их менеджеров (самосоединение)
   SELECT e1.first_name AS employee, e1.last_name, e2.first_name AS manager
     FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- сотрудники, работающие в США(многотабличный JOIN)
SELECT e.first_name, e.last_name, l.city
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN locations l ON d.location_id = l.location_id
  JOIN countries c ON l.country_id = c.country_id
 WHERE c.country_id = 'US';

-- подсчет сотрудников по странам
  SELECT c.country_name, COUNT(e.employee_id) AS employee_count
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
GROUP BY c.country_name;

-- сотрудники с зарплатой выше средней
SELECT first_name, last_name, salary
  FROM employees
 WHERE salary > (SELECT AVG(salary) FROM employees);

-- отделы, где больше 10 сотрудников
      SELECT d.department_name, COUNT(e.employee_id) AS employee_count
        FROM departments d
        JOIN employees e ON d.department_id = e.department_id
    GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 10;

-- сотрудники, нанятые после 1998 года
SELECT first_name, last_name, hire_date
  FROM employees
 WHERE EXTRACT(YEAR FROM hire_date) > 1998;

-- форматирование даты найма
SELECT first_name, last_name, TO_CHAR(hire_date, 'DD-MON-YYYY') AS formatted_hire_date
  FROM employees;

-- сотрудники с комиссией, отсортированные по убыванию комиссии
  SELECT first_name, last_name, commission_pct
    FROM employees
   WHERE commission_pct IS NOT NULL
ORDER BY commission_pct DESC;

-- вычисление годовой зарплаты (с учетом комиссии)
SELECT first_name, last_name, salary * 12 * (1 + COALESCE(commission_pct, 0)) AS annual_salary
  FROM employees;

-- категоризация зарплат (CASE)
SELECT first_name, last_name, salary,
       CASE
           WHEN salary > 15000 THEN 'High'
           WHEN salary > 8000 THEN 'Medium'
           ELSE 'Low'
       END AS salary_category
FROM employees;

-- поиск сотрудников с максимальной зарплатой
SELECT first_name, last_name, salary
  FROM employees
 WHERE salary = (SELECT MAX(salary) 
 				   FROM employees);


-- сотрудники, которые не работают в отделе Sales
SELECT e.first_name, e.last_name
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
 WHERE d.department_name != 'Sales';

-- подсчет сотрудников по должностям
  SELECT j.job_title, COUNT(e.employee_id) AS employee_count
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_title;

-- выборка истории работы сотрудника с именем Neena Kochhar
SELECT jh.start_date, jh.end_date, j.job_title
  FROM job_history jh
  JOIN employees e ON jh.employee_id = e.employee_id
  JOIN jobs j ON jh.job_id = j.job_id
 WHERE e.first_name = 'Neena' AND e.last_name = 'Kochhar';

-- ранжирование сотрудников по зарплате в каждом отделе 
SELECT e.first_name, e.last_name, e.salary, d.department_name,
       RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id;

-- вычисление доли зарплаты сотрудника от общей суммы зарплат в отделе
SELECT e.first_name, e.last_name, e.salary, d.department_name,
       e.salary / SUM(e.salary) OVER (PARTITION BY e.department_id) AS salary_share
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id;

-- топ-3 сотрудники по зарплате
  SELECT first_name, last_name, salary
    FROM employees
ORDER BY salary DESC
   LIMIT 3;

-- использование COALESCE для замены NULL в manager_id
SELECT first_name, last_name, COALESCE(manager_id::TEXT, 'No Manager') AS manager
  FROM employees;

-- сотрудники, чья зарплата выше минимальной для их должности
SELECT e.first_name, e.last_name, e.salary, j.job_title, j.min_salary
  FROM employees e
  JOIN jobs j ON e.job_id = j.job_id
 WHERE e.salary > j.min_salary;

-- подсчет количества сотрудников, нанятых в каждом году
  SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS employee_count
    FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

-- сотрудники, у которых есть записи в job_history
SELECT DISTINCT e.first_name, e.last_name
  FROM employees e
 WHERE EXISTS (SELECT 1 
 				 FROM job_history jh 
 				WHERE jh.employee_id = e.employee_id);


---------------------------------------------------------

-- объединение результатов для получения всех городов и стран (UNION)
SELECT city AS place FROM locations
 UNION
SELECT country_name FROM countries;

-- обновление зарплаты сотрудника (UPDATE)
UPDATE employees
   SET salary = salary * 1.1
 WHERE employee_id = 100;

-- удаление записи из job_history для определенного сотрудника (DELETE)
DELETE FROM job_history
 WHERE employee_id = 176 AND start_date = '1998-03-24';

-- CTE для подсчета сотрудников по регионам
WITH region_counts AS (
      SELECT r.region_name, COUNT(e.employee_id) AS employee_count
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        JOIN regions r ON c.region_id = r.region_id
    GROUP BY r.region_name
)
  SELECT region_name, employee_count
    FROM region_counts
ORDER BY employee_count DESC;

-- сотрудники, чья зарплата выше средней по их должности
SELECT e.first_name, e.last_name, e.salary, j.job_title
  FROM employees e
  JOIN jobs j ON e.job_id = j.job_id
 WHERE e.salary > (
    				SELECT AVG(e2.salary)
    				  FROM employees e2
   					 WHERE e2.job_id = e.job_id);

-- функция для нумерации сотрудников в каждом отделе
SELECT e.first_name, e.last_name, d.department_name,
       ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.hire_date) AS employee_number
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id;

-- агрегация с ROLLUP для подсчета сотрудников по отделам и должностям
SELECT d.department_name, j.job_title, COUNT(e.employee_id) AS employee_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
GROUP BY ROLLUP (d.department_name, j.job_title);

-- сотрудники, у которых нет записей в job_history
SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
   				  SELECT 1 
					FROM job_history jh 
					WHERE jh.employee_id = e.employee_id);

-- запрос с несколькими CTE для анализа зарплат по регионам
WITH dept_salary AS (
      SELECT d.department_id, d.department_name, AVG(e.salary) AS avg_salary
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_id, d.department_name
),
region_salary AS (
      SELECT r.region_name, AVG(ds.avg_salary) AS region_avg_salary
        FROM dept_salary ds
        JOIN departments d ON ds.department_id = d.department_id
        JOIN locations l ON d.location_id = l.location_id
        JOIN countries c ON l.country_id = c.country_id
        JOIN regions r ON c.region_id = r.region_id
    GROUP BY r.region_name
)
  SELECT region_name, region_avg_salary
    FROM region_salary
ORDER BY region_avg_salary DESC;

-- анализ стажа сотрудников с использованием интервалов (AGE)
SELECT first_name, last_name, hire_date,
       AGE(CURRENT_DATE, hire_date) AS tenure
FROM employees
ORDER BY tenure DESC;

--------------------------------------------------------------------------------------------------------------------------------------
-- Conclusion
-- In this work, we conducted an analysis of the HR database using SQL queries that cover the core aspects of the SQL language. We began
-- with simple data selections from tables such as regions, countries, locations, departments, jobs, and employees. We then progressed to
-- more complex operations, including filtering, sorting, aggregation, table joins (INNER JOIN, LEFT JOIN, self-joins), subqueries, window
-- functions, common table expressions (CTEs), and data modification operations (UPDATE, DELETE). The queries enabled us to explore the 
-- company’s structure, employee distribution across departments, countries, and job roles, salary levels, tenure, and employment history.
--------------------------------------------------------------------------------------------------------------------------------------
-- Заключение
-- В данной работе мы провели анализ данных HR-базы с использованием SQL-запросов, охватывающих основные аспекты языка SQL. Мы начали с 
-- простых выборок данных из таблиц, таких как регионы, страны, местоположения, отделы, должности и сотрудники. Затем перешли к более 
-- сложным операциям, включая фильтрацию, сортировку, агрегацию, соединения таблиц (INNER JOIN, LEFT JOIN, самосоединения), подзапросы, 
-- оконные функции, общие табличные выражения (CTE), а также операции модификации данных (UPDATE, DELETE). Запросы позволили исследовать 
-- структуру компании, распределение сотрудников по отделам, странам и должностям, уровень зарплат, стаж работы и историю занятости. 


