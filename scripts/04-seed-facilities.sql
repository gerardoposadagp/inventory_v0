-- 04-seed-facilities.sql
-- This script adds 45 facilities, distributing them across the seeded cities.

INSERT INTO facilities (facility_name, country_id, city_id, address, phone_number)
SELECT
    'Facility ' || city_name || ' #' || g.id,
    c.country_id,
    c.id AS city_id,
    g.id || ' Industrial Ave',
    '555-' || LPAD((random() * 10000)::int::text, 4, '0')
FROM
    generate_series(1, 45) AS g(id)
CROSS JOIN LATERAL (
    SELECT id, country_id, city_name FROM cities ORDER BY random() LIMIT 1
) AS c;
