-- Delivery-level table
CREATE TABLE deliveries(
	delivery_id TEXT,
	delivery_person_id TEXT,
	restaurant_area TEXT,
	customer_area TEXT,
	delivery_distance_km REAL,
	delivery_time_min INTEGER,
	order_placed_at DATETIME,
	weather_condition TEXT,
	traffic_condition TEXT,
	delivery_rating REAL
);

-- Delivery personnel metadata table
CREATE TABLE delivery_persons (
	delivery_person_id INTEGER,
	name TEXT,
	region TEXT,
	hired_date DATE,
	is_active BOOLEAN
);

-- Restaurant metadata table
CREATE TABLE restaurants (
	restaurant_id TEXT,
	area TEXT,
	name TEXT,
	cuisine_type TEXT,
	avg_preparation_time_min REAL
);

-- Orders table
CREATE TABLE orders(
	order_id INTEGER,
	delivery_id TEXT,
	restaurant_id TEXT,
	customer_id TEXT,
	order_value REAL,
	items_count INTEGER
);

-- Q1: Top 5 customer areas with highest average delivery time in the last 30 days
SELECT
	customer_area,
	CAST(JULIANDAY('now') - JULIANDAY(order_placed_at) AS INTEGER) AS days,
	AVG(delivery_time_min) AS avg_delivery_time
FROM deliveries
WHERE days <= 30
GROUP BY customer_area
ORDER BY avg_delivery_time DESC
LIMIT 5;

-- Q2: Average delivery time per traffic condition, by restaurant area and cuisine type
SELECT
	d.restaurant_area,
	d.traffic_condition,
	AVG(d.delivery_time_min) AS avg_delivery_time,
	r.cuisine_type
FROM deliveries d 
LEFT JOIN restaurants r ON d.restaurant_area = r.area
GROUP BY d.traffic_condition, d.restaurant_area, r.cuisine_type
ORDER BY d.restaurant_area, avg_delivery_time DESC;
--PRAGMA table_info(deliveries);

-- Q3: Top 10 delivery people with the fastest average delivery time, considering only those with at least 50 deliveries and who are still active
SELECT 
	d.delivery_person_id,
	p.name,
	COUNT(d.delivery_id) AS count_deliveries,
	AVG(d.delivery_time_min) AS avg_delivery_time
FROM deliveries d
LEFT JOIN delivery_persons p ON d.delivery_person_id = p.delivery_person_id
GROUP BY d.delivery_person_id
HAVING count_deliveries >= 50 AND p.is_active = 1
ORDER BY avg_delivery_time ASC
LIMIT 10;

-- with at least 10 delivieries:
SELECT 
	d.delivery_person_id,
	p.name,
	COUNT(d.delivery_id) AS count_deliveries,
	AVG(d.delivery_time_min) AS avg_delivery_time
FROM deliveries d
LEFT JOIN delivery_persons p ON d.delivery_person_id = p.delivery_person_id
GROUP BY d.delivery_person_id
HAVING count_deliveries >= 10 AND p.is_active = 1
ORDER BY avg_delivery_time ASC
LIMIT 10;

-- Q4: The most profitable restaurant area in the last 3 months, defined as the area with the highest total order value
SELECT
	d.restaurant_area,
	SUM(o.order_value) AS total_order_value,
	SUM(o.items_count) AS total_items
FROM orders o
LEFT JOIN deliveries d ON o.delivery_id  = d.delivery_id
WHERE DATE(d.order_placed_at) >= DATE('now','-3 months')
GROUP BY d.restaurant_area
ORDER BY total_order_value DESC
LIMIT 1;

-- Q5: Identify whether any delivery people show an increasing trend in average delivery time
SELECT
	d.delivery_person_id,
	STRFTIME('%Y-%m', d.order_placed_at) AS year_month,
	AVG(d.delivery_time_min) AS avg_delivery_time,
	AVG(d.delivery_distance_km) AS avg_delivery_distance
FROM deliveries d
GROUP BY year_month, d.delivery_person_id
ORDER BY d.delivery_person_id;