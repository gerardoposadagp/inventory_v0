-- 19-seed-items-guaranteed-random.sql
-- This script uses a procedural DO block to add 1000 items,
-- guaranteeing that a new random category and country are selected for each item.

DO $$
DECLARE
    i INTEGER;
    random_category_id BIGINT;
    random_country_id BIGINT;
BEGIN
    -- Loop 1000 times, once for each item to be created.
    FOR i IN 1..1000 LOOP
        -- Inside the loop, select a new random category ID for this specific iteration.
        SELECT id INTO random_category_id FROM public.categories ORDER BY random() LIMIT 1;

        -- Select a new random country ID for this specific iteration.
        SELECT id INTO random_country_id FROM public.countries ORDER BY random() LIMIT 1;

        -- Insert the new item with the truly randomized IDs.
        INSERT INTO public.items (item_name, category_id, description, origin_country_id, enabled)
        VALUES (
            'Item ' || i,
            random_category_id,
            'A standard-issue item for company use. Serial number: ' || (100000 + random() * 900000)::int,
            random_country_id,
            TRUE
        );
    END LOOP;
END $$;
