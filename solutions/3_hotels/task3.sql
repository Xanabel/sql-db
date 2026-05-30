-- Задача 3: Предпочтения клиентов по типу отелей

WITH hotel_categories AS (
    SELECT 
        ID_hotel,
        CASE 
            WHEN AVG(price) < 175 THEN 'Дешевый'
            WHEN AVG(price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_type
    FROM Room
    GROUP BY ID_hotel
),
customer_hotels AS (
    SELECT DISTINCT
        c.ID_customer,
        c.name,
        h.name AS hotel_name,
        hc.hotel_type
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    JOIN hotel_categories hc ON h.ID_hotel = hc.ID_hotel
)
SELECT 
    ID_customer,
    name,
    CASE 
        WHEN SUM(CASE WHEN hotel_type = 'Дорогой' THEN 1 ELSE 0 END) > 0 THEN 'Дорогой'
        WHEN SUM(CASE WHEN hotel_type = 'Средний' THEN 1 ELSE 0 END) > 0 THEN 'Средний'
        ELSE 'Дешевый'
    END AS preferred_hotel_type,
    GROUP_CONCAT(DISTINCT hotel_name ORDER BY hotel_name SEPARATOR ',') AS visited_hotels
FROM customer_hotels
GROUP BY ID_customer, name
ORDER BY 
    CASE 
        WHEN SUM(CASE WHEN hotel_type = 'Дорогой' THEN 1 ELSE 0 END) > 0 THEN 3
        WHEN SUM(CASE WHEN hotel_type = 'Средний' THEN 1 ELSE 0 END) > 0 THEN 2
        ELSE 1
    END;