-- 03-seed-countries-cities.sql
-- This script populates the 'countries' and 'cities' tables with sample data.

-- Use a Common Table Expression (CTE) to define the data to be inserted.
WITH country_data AS (
    INSERT INTO countries (country_name) VALUES
        ('United States'), ('Canada'), ('Mexico'), ('Brazil'), ('Argentina'),
        ('United Kingdom'), ('Germany'), ('France'), ('Spain'), ('Italy'),
        ('China'), ('Japan'), ('India'), ('Australia'), ('South Africa')
    RETURNING id, country_name
)
INSERT INTO cities (city_name, country_id)
SELECT
    city_name,
    country_data.id
FROM
    country_data,
    LATERAL (
        VALUES
            (country_data.country_name, 'New York', 'Los Angeles'),
            (country_data.country_name, 'Toronto', 'Vancouver'),
            (country_data.country_name, 'Mexico City', 'Cancun'),
            (country_data.country_name, 'São Paulo', 'Rio de Janeiro'),
            (country_data.country_name, 'Buenos Aires', 'Córdoba'),
            (country_data.country_name, 'London', 'Manchester'),
            (country_data.country_name, 'Berlin', 'Munich'),
            (country_data.country_name, 'Paris', 'Marseille'),
            (country_data.country_name, 'Madrid', 'Barcelona'),
            (country_data.country_name, 'Rome', 'Milan'),
            (country_data.country_name, 'Beijing', 'Shanghai'),
            (country_data.country_name, 'Tokyo', 'Osaka'),
            (country_data.country_name, 'Mumbai', 'Delhi'),
            (country_data.country_name, 'Sydney', 'Melbourne'),
            (country_data.country_name, 'Johannesburg', 'Cape Town')
    ) AS city_list(country, city_1, city_2)
CROSS JOIN
    LATERAL (VALUES (city_1), (city_2)) AS c(city_name)
WHERE
    country_data.country_name = city_list.country
ON CONFLICT (city_name, country_id) DO NOTHING;
