-- 18-seed-items-corrected.sql
-- This script adds 1000 items with true randomness for category and country.
-- It uses subqueries in the SELECT list to ensure random() is evaluated for each row.

INSERT INTO public.items (item_name, category_id, description, origin_country_id, enabled)
SELECT
    'Item ' || g.id,
    (SELECT id FROM public.categories ORDER BY random() LIMIT 1),
    'A standard-issue item for company use. Serial number: ' || (100000 + random() * 900000)::int,
    (SELECT id FROM public.countries ORDER BY random() LIMIT 1),
    TRUE
FROM
    generate_series(1, 1000) AS g(id);
