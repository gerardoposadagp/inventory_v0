-- 16-seed-items-by-logic.sql
-- This script adds 1000 items to the 'items' table using the specified logic.
-- It uses a set-based approach for high performance.

INSERT INTO public.items (item_name, category_id, description, origin_country_id, enabled)
SELECT
    'Item ' || g.id,
    cat.id,
    'A standard-issue item for company use. Serial number: ' || (100000 + random() * 900000)::int,
    country.id,
    TRUE
FROM
    -- Generate a series of numbers from 1 to 1000 to represent each new item.
    generate_series(1, 1000) AS g(id)
-- For each item, randomly select a category_id from the 'categories' table.
CROSS JOIN LATERAL (
    SELECT id FROM public.categories ORDER BY random() LIMIT 1
) AS cat
-- For each item, randomly select an origin_country_id from the 'countries' table.
CROSS JOIN LATERAL (
    SELECT id FROM public.countries ORDER BY random() LIMIT 1
) AS country;
