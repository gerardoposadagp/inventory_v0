-- 07-reset-and-reseed-facilities-inventory.sql
-- This script clears and repopulates the 'facilities' and 'inventory' tables.

-- Step 1: Delete all records from the 'inventory' table.
-- This must be done first due to the foreign key relationship with 'facilities'.
TRUNCATE TABLE inventory RESTART IDENTITY;
-- Note: TRUNCATE is faster than DELETE and also resets any identity columns.

-- Step 2: Delete all records from the 'facilities' table.
-- The ON DELETE SET NULL on user_profiles.facility_id will handle unlinking users.
TRUNCATE TABLE facilities RESTART IDENTITY CASCADE;
-- Using CASCADE will automatically remove rows in tables that reference 'facilities'
-- if they have an ON DELETE CASCADE constraint, like 'inventory'. We already cleared
-- inventory, but this is good practice.

-- Step 3: Add 45 new facilities in 5 different countries.
WITH selected_countries AS (
    -- Select 5 random countries to host the new facilities
    SELECT id FROM countries ORDER BY random() LIMIT 5
),
cities_in_scope AS (
    -- Get all cities that belong to our 5 selected countries
    SELECT id, country_id, city_name FROM cities WHERE country_id IN (SELECT id FROM selected_countries)
)
INSERT INTO facilities (facility_name, country_id, city_id, address, phone_number)
SELECT
    c.city_name || ' office',
    c.country_id,
    c.id AS city_id,
    g.id || ' Commerce St',
    '555-' || LPAD((random() * 10000)::int::text, 4, '0')
FROM
    generate_series(1, 45) AS g(id)
CROSS JOIN LATERAL (
    -- For each of the 45 facilities, pick a random city from our scope
    SELECT * FROM cities_in_scope ORDER BY random() LIMIT 1
) AS c;

-- Step 4: Add 450 items to the 'inventory' table for the new facilities.
INSERT INTO inventory (facility_id, item_id, quantity, expiration_date)
SELECT
    facility_id,
    item_id,
    (random() * 200 + 1)::int AS quantity,
    -- Assign an expiration date to ~30% of items
    CASE
        WHEN random() < 0.3 THEN NOW() + (random() * 730) * '1 day'::interval
        ELSE NULL
    END AS expiration_date
FROM (
    -- Generate all possible pairs of new facilities and existing items,
    -- shuffle them randomly, and pick 450 unique pairs to insert.
    SELECT f.id AS facility_id, i.id AS item_id
    FROM facilities f, items i
    ORDER BY random()
    LIMIT 450
) AS random_pairs;
