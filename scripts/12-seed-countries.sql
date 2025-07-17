-- 12-seed-countries.sql
-- This script populates the 'countries' table with 10 different countries.

INSERT INTO public.countries (country_name) VALUES
    ('United States'),
    ('Canada'),
    ('Brazil'),
    ('United Kingdom'),
    ('Germany'),
    ('France'),
    ('Japan'),
    ('China'),
    ('Australia'),
    ('India')
ON CONFLICT (country_name) DO NOTHING;
