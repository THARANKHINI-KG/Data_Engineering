CREATE DATABASE HotelBookingAnalysis;
use HotelBookingAnalysis;

select * from hotels;
select * from bookings;

--1. AVERAGE ROOM RATES OF DIFFERENT CITIES
SELECT
  h.city,
  AVG(b.amount * 1.0 / b.no_of_rooms) AS avg_room_rate,
  COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN hotels h
  ON b.hotel_id = h.hotel_id
WHERE b.status = 'Stayed'
GROUP BY h.city
ORDER BY avg_room_rate DESC;

-- NUMBER OF BOOKINGS BY CITY
SELECT h.city,
       MONTH(b.date_of_booking) AS booking_month,
       COUNT(*) AS bookings_count
FROM bookings b
JOIN hotels h ON b.hotel_id = h.hotel_id
WHERE MONTH(b.date_of_booking) IN (1, 2, 3)
GROUP BY h.city, MONTH(b.date_of_booking);

--3. FREQUENCY OF EARLY BOOKINGS
SELECT DATEDIFF(day, b.date_of_booking, b.check_in) AS lead_time_days,
       COUNT(*) AS booking_count
FROM bookings b
GROUP BY DATEDIFF(day, b.date_of_booking, b.check_in)
ORDER BY lead_time_days;

--4. FREQUENCY OF NUMBER OF ROOMS PER BOOKING
SELECT no_of_rooms,
       COUNT(*) AS booking_count
FROM bookings
GROUP BY no_of_rooms
ORDER BY no_of_rooms;

-- 5. NEW CUSTOMERS IN JANUARY
SELECT COUNT(DISTINCT b.customer_id) AS new_customers_in_january
FROM bookings b
WHERE MONTH(b.date_of_booking) = 1 AND YEAR(b.date_of_booking) = 2022
  AND NOT EXISTS (
    SELECT 1
    FROM bookings b2
    WHERE b2.customer_id = b.customer_id
      AND b2.date_of_booking < '2022-01-01'
  );

  -- 6. NET REVENUE TO THE COMPANY
SELECT SUM(amount - discount) AS net_revenue
FROM bookings
WHERE status = 'Stayed';

-- 7. GROSS REVENUE
SELECT
  SUM(amount) AS gross_revenue
FROM bookings;

-- 8. AVERAGE ROOM RATES OF DIFF CITIES
SELECT
  h.city,
  AVG(b.amount * 1.0 / b.no_of_rooms) AS avg_room_rate,
  COUNT(b.booking_id) AS total_bookings
FROM bookings b
JOIN hotels h
  ON b.hotel_id = h.hotel_id
WHERE b.status = 'Stayed'
GROUP BY h.city
ORDER BY avg_room_rate DESC;
