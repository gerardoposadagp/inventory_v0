-- 11-clear-data-guaranteed.sql
-- This script provides a reliable method to delete all records from the
-- specified tables by handling dependencies explicitly.

-- Step 1: Unlink all user profiles from any location or facility.
-- This is the most important step to prevent foreign key violation errors.
UPDATE public.user_profiles SET
    facility_id = NULL,
    city_id = NULL,
    country_id = NULL;

-- Step 2: Delete all records from the tables in the correct dependency order.
-- We start from the tables that reference others and move to the root tables.
DELETE FROM public.inventory;
DELETE FROM public.facilities;
DELETE FROM public.items;
DELETE FROM public.cities;
DELETE FROM public.countries;

-- Step 3: Reset the ID sequence for each table to 1.
-- This ensures that when you add new data, the IDs start from the beginning.
ALTER SEQUENCE public.inventory_id_seq RESTART WITH 1;
ALTER SEQUENCE public.facilities_id_seq RESTART WITH 1;
ALTER SEQUENCE public.items_id_seq RESTART WITH 1;
ALTER SEQUENCE public.cities_id_seq RESTART WITH 1;
ALTER SEQUENCE public.countries_id_seq RESTART WITH 1;
