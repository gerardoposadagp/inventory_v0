-- 06-seed-inventory.sql
-- This script populates the inventory with 450 random items in random facilities.

-- To avoid violating the UNIQUE(facility_id, item_id) constraint, we first
-- generate all possible pairs, shuffle them, and then pick 450.
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
    SELECT f.id AS facility_id, i.id AS item_id
    FROM facilities f, items i
    ORDER BY random()
    LIMIT 450
) AS random_pairs;
