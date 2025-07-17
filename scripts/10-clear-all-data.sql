-- 10-clear-all-data.sql
-- This script deletes all records from the main data tables.
-- It is written to be safe and respect foreign key constraints,
-- particularly to avoid deleting user profiles.

-- Step 1: Unlink user profiles from locations.
-- This prevents foreign key violation errors when we truncate cities and countries.
-- We set the location-related fields to NULL for all users.
UPDATE user_profiles SET
    facility_id = NULL,
    city_id = NULL,
    country_id = NULL;

-- Step 2: Truncate all specified tables.
-- TRUNCATE is much faster than DELETE for clearing entire tables.
-- The 'RESTART IDENTITY' clause resets the primary key sequences, so new
-- rows will start from 1. The tables are listed together to be truncated
-- in a single transaction.
TRUNCATE
    inventory,
    facilities,
    items,
    cities,
    countries
RESTART IDENTITY;
