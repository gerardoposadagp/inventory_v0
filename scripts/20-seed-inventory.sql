-- 20-seed-inventory.sql
-- This script adds 450 random and unique records to the 'inventory' table.

INSERT INTO public.inventory (facility_id, item_id, quantity, expiration_date)
SELECT
    facility_id,
    item_id,
    (random() * 200 + 1)::int AS quantity,
    -- Assign an expiration date to about 30% of the items
    CASE
        WHEN random() < 0.3 THEN NOW() + (random() * 730) * '1 day'::interval
        ELSE NULL
    END AS expiration_date
FROM (
    -- This subquery creates a list of unique facility/item pairs,
    -- shuffles them, and takes the top 450 to ensure no duplicates are inserted.
    SELECT
        f.id AS facility_id,
        i.id AS item_id
    FROM
        public.facilities f,
        public.items i
    ORDER BY
        random()
    LIMIT 450
) AS random_pairs;
