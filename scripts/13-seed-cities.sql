-- 13-seed-cities.sql
-- This script populates the 'cities' table with 30 cities,
-- distributed across the 10 countries added previously.

INSERT INTO public.cities (city_name, country_id)
SELECT
    city_data.city_name,
    countries.id
FROM
    public.countries,
    LATERAL (
        VALUES
            ('United States', 'New York'), ('United States', 'Los Angeles'), ('United States', 'Chicago'),
            ('Canada', 'Toronto'), ('Canada', 'Vancouver'), ('Canada', 'Montreal'),
            ('Brazil', 'São Paulo'), ('Brazil', 'Rio de Janeiro'), ('Brazil', 'Brasília'),
            ('United Kingdom', 'London'), ('United Kingdom', 'Manchester'), ('United Kingdom', 'Edinburgh'),
            ('Germany', 'Berlin'), ('Germany', 'Munich'), ('Germany', 'Hamburg'),
            ('France', 'Paris'), ('France', 'Marseille'), ('France', 'Lyon'),
            ('Japan', 'Tokyo'), ('Japan', 'Osaka'), ('Japan', 'Kyoto'),
            ('China', 'Beijing'), ('China', 'Shanghai'), ('China', 'Shenzhen'),
            ('Australia', 'Sydney'), ('Australia', 'Melbourne'), ('Australia', 'Brisbane'),
            ('India', 'Mumbai'), ('India', 'Delhi'), ('India', 'Bangalore')
    ) AS city_data(country_name_ref, city_name)
WHERE
    public.countries.country_name = city_data.country_name_ref
ON CONFLICT (city_name, country_id) DO NOTHING;
