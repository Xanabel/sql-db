-- Задача 1: Определение лучшего автомобиля по средней позиции в каждом классе

WITH car_stats AS (
    SELECT car, AVG(position) AS avg_pos, COUNT(race) AS race_count
    FROM Results
    GROUP BY car
),
min_by_class AS (
    SELECT c.class, MIN(cs.avg_pos) AS min_avg_pos
    FROM Cars c
    JOIN car_stats cs ON c.name = cs.car
    GROUP BY c.class
)
SELECT cs.car AS car_name, c.class AS car_class,
       cs.avg_pos AS average_position, cs.race_count
FROM car_stats cs
JOIN Cars c ON cs.car = c.name
JOIN min_by_class mbc ON c.class = mbc.class AND cs.avg_pos = mbc.min_avg_pos
ORDER BY cs.avg_pos;