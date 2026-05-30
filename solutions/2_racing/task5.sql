-- Задача 5: Определение классов автомобилей с наибольшим кол-вом авто с позицией > 3.0

WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Cars c
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class, cl.country
),
ClassStats AS (
    SELECT 
        car_class,
        SUM(race_count) AS total_races,
        SUM(CASE WHEN average_position >= 3.0 THEN 1 ELSE 0 END) AS low_position_count
    FROM CarStats
    GROUP BY car_class
)
SELECT 
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cs.car_country,
    cls.total_races,
    cls.low_position_count
FROM CarStats cs
JOIN ClassStats cls ON cs.car_class = cls.car_class
WHERE cs.average_position > 3.0
ORDER BY cls.low_position_count DESC, cs.car_class, cs.car_name;