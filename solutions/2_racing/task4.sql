-- Задача 4: Определение автомобилей, опережающих средний показатель своего класса

WITH CarStat AS (
    SELECT 
        c.name,
        c.class,
        cl.country,
        AVG(r.position) AS car_avg,
        COUNT(*) AS race_count
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
),
ClassAgg AS (
    SELECT 
        class,
        AVG(car_avg) AS class_avg,
        COUNT(*) AS car_count
    FROM CarStat
    GROUP BY class
)
SELECT 
    cs.name AS car_name,
    cs.class AS car_class,
    cs.car_avg AS average_position,
    cs.race_count,
    cs.country AS car_country
FROM CarStat cs
JOIN ClassAgg ca ON cs.class = ca.class
WHERE cs.car_avg < ca.class_avg
  AND ca.car_count >= 2
ORDER BY cs.class, cs.car_avg;