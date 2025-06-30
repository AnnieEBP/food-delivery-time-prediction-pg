# SQL Insights

- **Weekend vs. Weekday**: Delivery times are ~15% slower on weekends  
  ```sql
  SELECT CASE WHEN DAYOFWEEK(order_placed_at) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
         AVG(delivery_time_min)
  FROM deliveries
  GROUP BY day_type;