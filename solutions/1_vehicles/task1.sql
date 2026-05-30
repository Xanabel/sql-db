-- Задача 1: мотоциклы больше 150 л.с., менее $20k, тип Sport

SELECT 
    v.maker,
    v.model
FROM Vehicle v
JOIN Motorcycle m ON v.model = m.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;