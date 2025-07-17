-- 14-seed-facilities-by-logic.sql
-- This script adds 45 facilities using a specific nested loop logic.

DO $$
DECLARE
    selected_country_id BIGINT;
    selected_city_id    BIGINT;
    i                   INTEGER;
    j                   INTEGER;
BEGIN
    -- Outer loop: runs 3 times to select 3 different countries.
    FOR i IN 1..3 LOOP
        -- Step 1: Choose a random country ID from the 'countries' table.
        SELECT id INTO selected_country_id FROM public.countries ORDER BY random() LIMIT 1;

        -- Inner loop: runs 15 times for each selected country to create 15 facilities.
        FOR j IN 1..15 LOOP
            -- Step 2: Choose a random city from within the currently selected country.
            SELECT id INTO selected_city_id FROM public.cities WHERE country_id = selected_country_id ORDER BY random() LIMIT 1;

            -- Step 3: Add the new facility record with the specified naming and data.
            INSERT INTO public.facilities (facility_name, country_id, city_id, address, phone_number)
            VALUES (
                'Facility ' || selected_city_id,
                selected_country_id,
                selected_city_id,
                'Address ' || selected_city_id,
                '555-' || LPAD((random() * 9000 + 1000)::int::text, 4, '0') -- Generates a 4-digit random number
            );
        END LOOP;
    END LOOP;
END $$;
