-- 17-clear-items-and-inventory.sql
-- This script deletes all records from the 'items' and 'inventory' tables.
-- 'inventory' is cleared first to respect the foreign key dependency.

-- Step 1: Clear the inventory table.
TRUNCATE TABLE public.inventory RESTART IDENTITY;

-- Step 2: Clear the items table.
TRUNCATE TABLE public.items RESTART IDENTITY;
