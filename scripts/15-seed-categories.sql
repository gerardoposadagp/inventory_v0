-- 15-seed-categories.sql
-- This script populates the 'categories' table with some sample data,
-- which is a prerequisite for adding items.

INSERT INTO public.categories (category_name) VALUES
    ('Office Furniture'),
    ('Electronics'),
    ('IT Equipment'),
    ('Office Supplies'),
    ('Vehicles'),
    ('Machinery')
ON CONFLICT (category_name) DO NOTHING;
