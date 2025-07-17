-- 17-clear-items-and-inventory-v2.sql
-- This script correctly deletes all records from 'items' and any dependent tables like 'inventory'.

-- Using TRUNCATE with CASCADE will automatically empty the 'inventory' table
-- because it has a foreign key reference to the 'items' table.
-- This is the correct and safe way to perform this operation.
-- RESTART IDENTITY will also reset the primary key sequences for both tables.
TRUNCATE TABLE public.items RESTART IDENTITY CASCADE;
