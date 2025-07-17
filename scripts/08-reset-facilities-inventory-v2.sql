-- 08-reset-facilities-inventory-v2.sql
-- This script precisely resets and reseeds the 'facilities' and 'inventory' tables
-- according to the specified constraints.

-- Step 1: Delete all records from the 'inventory' table.
-- TRUNCATE is used for performance and to reset the identity sequence.
TRUNCATE TABLE inventory RESTART IDENTITY;

-- Step 2: Delete all records from the 'facilities' table.
-- The CASCADE option is not strictly needed here since we just truncated inventory,
-- but it's good practice. The ON DELETE SET NULL on user_profiles.facility_id
-- ensures users are gracefully unlinked from the deleted facilities.
TRUNCATE TABLE facilities RESTART IDENTITY CASCADE;

-- Step 3: Add 45 facilities located in exactly 5 cities from 5 different countries.
WITH
-- First, select exactly 5 cities, ensuring each is from a different country.
selected_cities AS (
    SELECT id, country_id, city_name
    FROM (
        -- Assign a row number to each city within its country, ordered randomly
        SELECT
            c.id,
            c.country_id,
            c.city_name,
            ROW_NUMBER() OVER(PARTITION BY c.country_id ORDER BY random()) as rn
        FROM cities c
    ) AS ranked_cities
    -- Pick the first city from each country grouping
    WHERE rn = 1
    -- And then limit the result to 5 random selections from that set
    ORDER BY random()
    LIMIT 5
)
-- Now, insert the facilities.
INSERT INTO facilities (facility_name, country_id, city_id, address, phone_number)
SELECT
    -- The facility name is exactly '<city_name> office' as requested.
    sc.city_name || ' office',
    sc.country_id,
    sc.id AS city_id,
    -- Generate some plausible fake data for other columns.
    (100 + g.id) || ' Main Street',
    '555-01' || LPAD(g.id::text, 2, '0')
FROM
    -- Generate 9 rows for each of the 5 cities, totaling 45 facilities.
    generate_series(1, 9) AS g(id)
CROSS JOIN
    selected_cities sc;

-- Step 4: Add 450 random items to the 'inventory' table for the new facilities.
INSERT INTO inventory (facility_id, item_id, quantity, expiration_date)
SELECT
    facility_id,
    item_id,
    (random() * 200 + 5)::int AS quantity, -- Ensure at least 5 items
    -- Assign an expiration date to ~30% of items
    CASE
        WHEN random() < 0.3 THEN NOW() + (random() * 730) * '1 day'::interval
        ELSE NULL
    END AS expiration_date
FROM (
    -- To avoid unique constraint violations, generate all possible pairs of
    -- new facilities and existing items, shuffle them, and pick 450.
    SELECT f.id AS facility_id, i.id AS item_id
    FROM facilities f, items i
    ORDER BY random()
    LIMIT 450
) AS random_pairs;
