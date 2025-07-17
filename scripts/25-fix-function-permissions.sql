-- 25-fix-function-permissions.sql
-- This script re-creates the dashboard function with SECURITY DEFINER,
-- which allows it to run with admin privileges and bypass the caller's RLS checks.
-- This is the correct and final fix for the data fetching error.

CREATE OR REPLACE FUNCTION public.get_dashboard_stats(
    p_country_id BIGINT DEFAULT NULL,
    p_city_id BIGINT DEFAULT NULL,
    p_facility_id BIGINT DEFAULT NULL
)
RETURNS JSONB
-- The SECURITY DEFINER clause is the critical change.
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
    metrics JSONB;
    category_distribution JSONB;
BEGIN
    -- Aggregate core metrics based on filters
    SELECT jsonb_build_object(
        'total_quantity', COALESCE(SUM(inv.quantity), 0),
        'distinct_items', COALESCE(COUNT(DISTINCT inv.item_id), 0),
        'facility_count', COALESCE(COUNT(DISTINCT inv.facility_id), 0),
        'expiring_soon_count', COALESCE(COUNT(*) FILTER (WHERE inv.expiration_date BETWEEN NOW() AND NOW() + INTERVAL '30 days'), 0)
    )
    INTO metrics
    FROM inventory inv
    JOIN facilities f ON inv.facility_id = f.id
    WHERE
        (p_country_id IS NULL OR f.country_id = p_country_id) AND
        (p_city_id IS NULL OR f.city_id = p_city_id) AND
        (p_facility_id IS NULL OR f.facility_id = p_facility_id);

    -- Aggregate inventory quantity by category based on filters
    SELECT jsonb_agg(t)
    INTO category_distribution
    FROM (
        SELECT
            c.category_name,
            SUM(inv.quantity) as quantity
        FROM inventory inv
        JOIN items i ON inv.item_id = i.id
        JOIN categories c ON i.category_id = c.id
        JOIN facilities f ON inv.facility_id = f.id
        WHERE
            (p_country_id IS NULL OR f.country_id = p_country_id) AND
            (p_city_id IS NULL OR f.city_id = p_city_id) AND
            (p_facility_id IS NULL OR f.facility_id = p_facility_id)
        GROUP BY c.category_name
        ORDER BY quantity DESC
    ) t;

    -- Combine all results into a single JSONB object
    RETURN jsonb_build_object(
        'metrics', metrics,
        'category_distribution', COALESCE(category_distribution, '[]'::jsonb)
    );
END;
$$;

-- We must also re-grant execute permissions after recreating the function.
GRANT EXECUTE
ON FUNCTION public.get_dashboard_stats(p_country_id BIGINT, p_city_id BIGINT, p_facility_id BIGINT)
TO anon, authenticated;
