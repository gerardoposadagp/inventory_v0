-- 09-reset-facilities-inventory-v3.sql
-- This script resets and reseeds the 'facilities' and 'inventory' tables
-- with a precise distribution of facilities as requested.

-- Step 1: Delete all records from the 'inventory' table.
TRUNCATE TABLE inventory RESTART IDENTITY;

-- Step 2: Delete all records from the 'facilities' table.
TRUNCATE TABLE facilities RESTART IDENTITY CASCADE;

-- Step 3: Add 45 facilities with specific distribution and naming.
WITH
-- First, find countries that have at least 5 cities to choose from.
countries_with_enough_cities AS (
    SELECT country_id
    FROM cities
    GROUP BY country_id
    HAVING COUNT(id) >= 5
),
-- From that list, randomly select 5 countries.
selected_countries AS (
    SELECT country_id
    FROM countries_with_enough_cities
    ORDER BY random()
    LIMIT 5
),
-- For each of the 5 chosen countries, select 5 distinct cities.
-- This creates our pool of 25 specific locations (5 countries * 5 cities).
target_cities AS (
    SELECT id, country_id
    FROM (
        SELECT
            c.id,
            c.country_id,
            ROW_NUMBER() OVER(PARTITION BY c.country_id ORDER BY random()) as rn
        FROM cities c
        WHERE c.country_id IN (SELECT country_id FROM selected_countries)
    ) AS ranked_cities
    WHERE rn <= 5
),
-- Now, create the 45 facility assignments, distributing them randomly
-- across our 25 target cities.
facility_assignments AS (
    SELECT
        tc.id as city_id,
        tc.country_id,
        -- Add a unique number for each facility within the same city to ensure a unique name.
        ROW_NUMBER() OVER (PARTITION BY tc.id ORDER BY random()) as facility_instance_num
    FROM
        generate_series(1, 45)
    CROSS JOIN LATERAL (
        SELECT id, country_id FROM target_cities ORDER BY random() LIMIT 1
    ) AS tc
)
-- Finally, insert the 45 facilities into the table.
INSERT INTO facilities (facility_name, country_id, city_id, address, phone_number)
SELECT
    -- Per instructions, the name is concatenated with city_id.
    -- A suffix is added to ensure uniqueness if a city has multiple facilities.
    'Facility-' || fa.city_id || '-' || fa.facility_instance_num,
    fa.country_id,
    fa.city_id,
    fa.facility_instance_num || ' Innovation Drive',
    '555-C' || fa.city_id || '-F' || fa.facility_instance_num
FROM
    facility_assignments fa;

-- Step 4: Add 450 items to the 'inventory' table for the new facilities.
INSERT INTO inventory (facility_id, item_id, quantity, expiration_date)
SELECT
    facility_id,
    item_id,
    (random() * 200 + 5)::int AS quantity,
    CASE
        WHEN random() < 0.3 THEN NOW() + (random() * 730) * '1 day'::interval
        ELSE NULL
    END AS expiration_date
FROM (
    SELECT f.id AS facility_id, i.id AS item_id
    FROM facilities f, items i
    ORDER BY random()
    LIMIT 450
) AS random_pairs;
