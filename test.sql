-- EXERCISE1
-- First I created a table and added some data
CREATE SCHEMA S3data.test1;

CREATE TABLE S3data.test1.exercise1 (
    order_id INT,
    order_country_code VARCHAR,
    order_city_code VARCHAR,
    order_created_at TIMESTAMP,
    total_cost_eur DECIMAL(10, 2),
    customer_id INT
);

Insert data into the table
INSERT INTO S3data.test1.exercise1 (order_id, order_country_code, order_city_code, order_created_at, total_cost_eur, customer_id)
VALUES
    (873321, 'KE', 'NBO', TIMESTAMP '2023-09-24 16:07:16', 22.5, 473321),
    (873322, 'MA', 'CAS', TIMESTAMP '2023-10-15 16:11:16', 10, 573777),
    (873323, 'KE', 'NBO', TIMESTAMP '2023-09-24 16:07:16', 45, 673322),
    (873324, 'MA', 'CAS', TIMESTAMP '2023-10-15 16:11:16', 20, 773778),
    (973321, 'KE', 'NBO', TIMESTAMP '2023-01-24 16:07:16', 42.5, 573321),
    (973322, 'MA', 'CAS', TIMESTAMP '2023-01-15 16:11:16', 20, 673777),
    (973323, 'KE', 'NBO', TIMESTAMP '2023-01-24 16:07:16', 25, 773322),
    (973324, 'MA', 'CAS', TIMESTAMP '2023-01-15 16:11:16', 30, 873778),
    (573321, 'KE', 'NBO', TIMESTAMP '2023-01-04 16:07:16', 12.5, 473321),
    (573322, 'MA', 'CAS', TIMESTAMP '2023-01-04 16:11:16', 60, 573777),
    (573323, 'KE', 'NBO', TIMESTAMP '2023-01-03 16:07:16', 65, 673322),
    (573324, 'MA', 'CAS', TIMESTAMP '2023-01-03 16:11:16', 60, 773778),
    (573321, 'KE', 'NBO', TIMESTAMP '2023-01-02 16:07:16', 52.5, 573321),
    (573322, 'MA', 'CAS', TIMESTAMP '2023-01-02 16:11:16', 10, 673777),
    (573323, 'KE', 'NBO', TIMESTAMP '2023-01-01 16:07:16', 15, 773322),
    (573324, 'MA', 'CAS', TIMESTAMP '2023-01-01 16:11:16', 20, 873778),
    (473321, 'KE', 'NBO', TIMESTAMP '2023-01-04 16:07:16', 22.3, 473321),
    (473322, 'MA', 'CAS', TIMESTAMP '2023-01-04 16:11:16', 30, 573777),
    (473321, 'KE', 'NBO', TIMESTAMP '2023-01-02 16:07:16', 32.3, 573321),
    (473322, 'MA', 'CAS', TIMESTAMP '2023-01-02 16:11:16', 30, 673777),
    (473321, 'KE', 'NBO', TIMESTAMP '2023-01-02 16:07:16', 32.3, 573321),
    (473322, 'MA', 'CAS', TIMESTAMP '2023-01-02 16:11:16', 40, 673777),
    (1, 'KE', 'NBO', TIMESTAMP '2023-01-01 16:07:16', 22.5, 101),
    (2, 'MA', 'CAS', TIMESTAMP '2023-01-02 16:11:16', 10, 102),
    (3, 'KE', 'NBO', TIMESTAMP '2023-01-03 16:07:16', 45, 103),
    (4, 'MA', 'CAS', TIMESTAMP '2023-01-04 16:11:16', 20, 104),
    (5, 'KE', 'NBO', TIMESTAMP '2023-01-05 16:07:16', 42.5, 101),
    (6, 'MA', 'CAS', TIMESTAMP '2023-01-06 16:11:16', 20, 102),
    (11, 'KE', 'NBO', TIMESTAMP '2024-02-01 16:07:16', 22.5, 201),
    (12, 'MA', 'CAS', TIMESTAMP '2024-02-02 16:11:16', 10, 202),
    (13, 'KE', 'NBO', TIMESTAMP '2024-02-03 16:07:16', 45, 203),
    (14, 'MA', 'CAS', TIMESTAMP '2024-02-04 16:11:16', 20, 204),
    (15, 'KE', 'NBO', TIMESTAMP '2024-02-05 16:07:16', 42.5, 201),
    (16, 'MA', 'CAS', TIMESTAMP '2024-02-06 16:11:16', 20, 202),
    (17, 'KE', 'NBO', TIMESTAMP '2024-01-03 16:07:16', 25, 203),
    (18, 'MA', 'CAS', TIMESTAMP '2024-01-04 16:11:16', 30, 204),
    (19, 'KE', 'NBO', TIMESTAMP '2024-01-05 16:07:16', 12.7, 201),
    (20, 'MA', 'CAS', TIMESTAMP '2024-01-06 16:11:16', 5, 202),
    (50, 'MA', 'CAS', TIMESTAMP '2023-12-30 16:11:16', 45, 501),
    (51, 'MA', 'CAS', TIMESTAMP '2024-02-06 16:11:16', 5, 501),
    (52, 'MA', 'CAS', TIMESTAMP '2024-01-06 16:11:16', 15, 501);

-- Exercise 1 Solution

-- I tried to get daily order number
WITH daily_orders AS (
    SELECT 
        CAST(DATE(order_created_at) AS VARCHAR) AS day,
        order_country_code AS country,
        COUNT(*) AS orders
    FROM 
        s3data.test1.exercise1
    WHERE 
    -- Filters orders by required date (Jan 2023) and grouped by date and country
        EXTRACT(YEAR FROM order_created_at) = 2023
        AND EXTRACT(MONTH FROM order_created_at) = 1
    GROUP BY 
        DATE(order_created_at), order_country_code
),
-- Tried to get % change in daily order number
daily_var AS (
    SELECT
        day,
        country,
        orders,
        CASE 
        -- I calculated daily percentage change in orders by comparing previous day with LAG function and grouped by country
            WHEN lag(orders, 1) OVER (PARTITION BY country ORDER BY day) IS NOT NULL THEN
                ROUND(((orders - lag(orders, 1) OVER (PARTITION BY country ORDER BY day)) / CAST(lag(orders, 1) OVER (PARTITION BY country ORDER BY day) AS double)) * 100, 2)
            ELSE
                0
        END AS var
    FROM
        daily_orders
)
SELECT *
FROM daily_var
ORDER BY country, day;

-- EXERCISE2

-- First I created a customers table and adding some value

CREATE TABLE s3data.test1.customers (
    customer_id INT,
    customer_id_prime BOOLEAN,
    account_created_at TIMESTAMP
);

INSERT INTO S3data.test1.customers (customer_id, customer_id_prime, account_created_at)
VALUES 
(123452, TRUE, TIMESTAMP '2023-09-24 16:07:16'),
(874639, FALSE, TIMESTAMP '2023-05-01 13:11:16'),
(101, TRUE, TIMESTAMP '2023-01-01 16:07:16'),
(102, FALSE, TIMESTAMP '2023-01-02 16:11:16'),
(103, TRUE, TIMESTAMP '2023-01-03 16:07:16'),
(104, FALSE, TIMESTAMP '2023-01-04 16:11:16'),
(201, TRUE, TIMESTAMP '2024-02-01 16:07:16'),
(202, FALSE, TIMESTAMP '2024-02-02 16:11:16'),
(203, TRUE, TIMESTAMP '2024-02-03 16:07:16'),
(204, FALSE, TIMESTAMP '2024-02-04 16:11:16'),
(501, TRUE, TIMESTAMP '2023-01-04 16:11:16');



-- Exercise2 solution

-- First I calculated the total orders for the last month, and others (MAUs, RC, RC orders, RC spend, AMORU)
WITH last_month_orders AS (
    SELECT 
        order_country_code,
        order_city_code,
        COUNT(*) AS total_orders
    FROM 
        s3data.test1.exercise1
    WHERE 
        DATE_TRUNC('month', order_created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
    GROUP BY 
        order_country_code,
        order_city_code
),
maus AS (
    SELECT 
        e.order_country_code,
        e.order_city_code,
        COUNT(DISTINCT e.customer_id) AS maus
    FROM 
        s3data.test1.exercise1 e
    JOIN 
        s3data.test1.customers c ON e.customer_id = c.customer_id
    WHERE 
        DATE_TRUNC('month', e.order_created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
    GROUP BY 
        e.order_country_code,
        e.order_city_code
),
recurrent_customers AS (
    SELECT 
        e.order_country_code,
        e.order_city_code,
        COUNT(DISTINCT e.customer_id) AS rc
    FROM 
        s3data.test1.exercise1 e
    JOIN 
        s3data.test1.customers c ON e.customer_id = c.customer_id
    WHERE 
        -- Filtered customers who created their accounts before last month and filtered orders for the last month
        DATE_TRUNC('month', c.account_created_at) < DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
        AND DATE_TRUNC('month', e.order_created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
    GROUP BY 
        e.order_country_code,
        e.order_city_code
),
recurrent_customer_orders AS (
    SELECT 
        e.order_country_code,
        e.order_city_code,
        COUNT(*) AS rc_orders
    FROM 
        s3data.test1.exercise1 e
    JOIN 
        s3data.test1.customers c ON e.customer_id = c.customer_id
    WHERE 
        DATE_TRUNC('month', c.account_created_at) < DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
        AND DATE_TRUNC('month', e.order_created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
    GROUP BY 
        e.order_country_code,
        e.order_city_code
),
recurrent_customer_spend AS (
    SELECT 
        e.order_country_code,
        e.order_city_code,
        SUM(e.total_cost_eur) AS rc_spend
    FROM 
        s3data.test1.exercise1 e
    JOIN 
        s3data.test1.customers c ON e.customer_id = c.customer_id
    WHERE 
        DATE_TRUNC('month', c.account_created_at) < DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
        AND DATE_TRUNC('month', e.order_created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1' MONTH)
    GROUP BY 
        e.order_country_code,
        e.order_city_code
)
SELECT 
    last_month_orders.order_country_code,
    last_month_orders.order_city_code,
    last_month_orders.total_orders,
    COALESCE(m.maus, 0) AS maus,
    COALESCE(rc.rc, 0) AS rc,
    COALESCE(rco.rc_orders, 0) AS rc_orders,
    COALESCE(rcs.rc_spend / NULLIF(rco.rc_orders, 0), 0) AS rc_spend,  -- Avoiding division by 0
    CASE WHEN COALESCE(rc.rc, 0) > 0 THEN rco.rc_orders / rc.rc ELSE 0 END AS amoru 
FROM 
    last_month_orders 
LEFT JOIN 
    maus m ON last_month_orders.order_country_code = m.order_country_code AND last_month_orders.order_city_code = m.order_city_code
LEFT JOIN 
    recurrent_customers rc ON last_month_orders.order_country_code = rc.order_country_code AND last_month_orders.order_city_code = rc.order_city_code
LEFT JOIN 
    recurrent_customer_orders rco ON last_month_orders.order_country_code = rco.order_country_code AND last_month_orders.order_city_code = rco.order_city_code
LEFT JOIN 
    recurrent_customer_spend rcs ON last_month_orders.order_country_code = rcs.order_country_code AND last_month_orders.order_city_code = rcs.order_city_code;



-- EXERCISE3

-- Created a CTE to calculate new customers numbers acquired each month
WITH monthly_new_customers AS (
    SELECT 
        DATE_TRUNC('month', c.account_created_at) AS month,
        COUNT(DISTINCT e.customer_id) AS new_customers
    FROM 
        s3data.test1.customers c
    JOIN 
        s3data.test1.exercise1 e ON c.customer_id = e.customer_id
        -- Filtered orders created after account creation date
    WHERE 
        e.order_created_at >= DATE_TRUNC('month', c.account_created_at)
        -- Grouped the results by the months
    GROUP BY 
        DATE_TRUNC('month', c.account_created_at)
),
retained_customers AS (
    -- Selected the account creation month and count the distinct number of customer IDs who made orders after 1 month
    SELECT 
        DATE_TRUNC('month', c.account_created_at) AS month,
        COUNT(DISTINCT e.customer_id) AS retained_customers
    FROM 
        s3data.test1.customers c
    JOIN 
        s3data.test1.exercise1 e ON c.customer_id = e.customer_id
    WHERE 
        e.order_created_at >= DATE_TRUNC('month', c.account_created_at + INTERVAL '1' MONTH)
    GROUP BY 
        DATE_TRUNC('month', c.account_created_at)
),
retention_rates AS (
    SELECT 
        DATE_FORMAT(mnc.month, '%Y-%m-%d') AS month,
        mnc.new_customers AS M0,
        COALESCE(rc.retained_customers, 0) AS M1,
        COALESCE(rc2.retained_customers, 0) AS M2,
        COALESCE(rc3.retained_customers, 0) AS M3
    FROM 
        monthly_new_customers mnc
        -- Joined the monthly new customers with the retained customers
    LEFT JOIN 
        retained_customers rc ON mnc.month = rc.month
    LEFT JOIN 
        retained_customers rc2 ON mnc.month = DATE_TRUNC('month', rc2.month - INTERVAL '1' MONTH)
    LEFT JOIN 
        retained_customers rc3 ON mnc.month = DATE_TRUNC('month', rc3.month - INTERVAL '2' MONTH)
)
SELECT 
    month,
    M0,
    M1,
    M2,
    M3
FROM 
    retention_rates;


