-- 05-seed-items.sql
-- This script adds 1000 items across several categories.

-- First, ensure categories exist
INSERT INTO categories (category_name) VALUES
    ('Office Furniture'), ('Electronics'), ('Vehicles'), ('Office Supplies'), ('Machinery'), ('IT Equipment')
ON CONFLICT (category_name) DO NOTHING;

-- Now, generate 1000 items
INSERT INTO items (item_name, category_id, description, origin_country_id)
SELECT
    'Item ' || g.id || ' - ' || (array['Model A', 'Model B', 'Pro', 'Standard', 'Eco'])[floor(random() * 5) + 1],
    cat.id AS category_id,
    'A standard-issue item for company use. Serial number: ' || (random() * 1000000)::int,
    countries.id AS origin_country_id
FROM
    generate_series(1, 1000) AS g(id)
CROSS JOIN LATERAL (
    SELECT id FROM categories ORDER BY random() LIMIT 1
) AS cat
CROSS JOIN LATERAL (
    SELECT id FROM countries ORDER BY random() LIMIT 1
) AS countries;
