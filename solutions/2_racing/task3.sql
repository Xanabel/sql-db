-- Задача 3: Определение классов автомобилей с лучшей средней позицией

WITH CarData AS (
    SELECT c.name, c.class, cl.country, r.position
    FROM Cars c 
    JOIN Classes cl ON c.class = cl.class 
    JOIN Results r ON c.name = r.car
),
ClassAvg AS (
    SELECT class, country, AVG(position) as avg_pos, COUNT(*) as total_races
    FROM CarData 
    GROUP BY class, country
),
MinVal AS (
    SELECT MIN(avg_pos) as min_avg FROM ClassAvg
)
SELECT 
    cd.name AS car_name,
    cd.class AS car_class,
    AVG(cd.position) AS average_position,
    COUNT(cd.position) AS race_count,
    cd.country AS car_country,
    ca.total_races
FROM CarData cd
JOIN ClassAvg ca ON cd.class = ca.class
CROSS JOIN MinVal mv
WHERE ca.avg_pos = mv.min_avg
GROUP BY cd.name, cd.class, cd.country, ca.total_races
ORDER BY average_position, car_name;