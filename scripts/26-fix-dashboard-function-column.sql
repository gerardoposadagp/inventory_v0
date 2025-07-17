-- 26-fix-dashboard-function-column.sql
-- Replace the faulty facility filter that used f.facility_id
-- with the correct primary-key column f.id.

CREATE OR REPLACE FUNCTION public.get_dashboard_stats(
  p_country_id    BIGINT DEFAULT NULL,
  p_city_id       BIGINT DEFAULT NULL,
  p_facility_id   BIGINT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER                                         -- keep elevated privileges
AS $$
DECLARE
  metrics              JSONB;
  category_distribution JSONB;
BEGIN
  /* --- core metrics ------------------------------------------------------ */
  SELECT jsonb_build_object(
           'total_quantity',        COALESCE(SUM(inv.quantity), 0),
           'distinct_items',        COALESCE(COUNT(DISTINCT inv.item_id), 0),
           'facility_count',        COALESCE(COUNT(DISTINCT inv.facility_id), 0),
           'expiring_soon_count',   COALESCE(
                                        COUNT(*) FILTER (
                                          WHERE inv.expiration_date BETWEEN NOW()
                                                AND NOW() + INTERVAL '30 days'
                                        ), 0)
         )
    INTO metrics
    FROM inventory  inv
    JOIN facilities f ON inv.facility_id = f.id
   WHERE (p_country_id  IS NULL OR f.country_id = p_country_id)
     AND (p_city_id     IS NULL OR f.city_id    = p_city_id)
     -- fixed line ↓ — use f.id instead of the non-existent f.facility_id
     AND (p_facility_id IS NULL OR f.id         = p_facility_id);

  /* --- quantity per category -------------------------------------------- */
  SELECT jsonb_agg(t)
    INTO category_distribution
    FROM (
           SELECT c.category_name,
                  SUM(inv.quantity) AS quantity
             FROM inventory  inv
             JOIN items      i  ON inv.item_id     = i.id
             JOIN categories c  ON i.category_id   = c.id
             JOIN facilities f  ON inv.facility_id = f.id
            WHERE (p_country_id  IS NULL OR f.country_id = p_country_id)
              AND (p_city_id     IS NULL OR f.city_id    = p_city_id)
              -- fixed line ↓
              AND (p_facility_id IS NULL OR f.id         = p_facility_id)
            GROUP BY c.category_name
            ORDER BY quantity DESC
         ) t;

  RETURN jsonb_build_object(
           'metrics',               metrics,
           'category_distribution', COALESCE(category_distribution, '[]'::jsonb)
         );
END;
$$;

-- Re-grant execution rights (function was recreated)
GRANT EXECUTE
  ON FUNCTION public.get_dashboard_stats(
       BIGINT, BIGINT, BIGINT
     )
  TO anon, authenticated;
