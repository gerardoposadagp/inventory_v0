-- 22-grant-function-permissions.sql
-- This script grants permission to call the dashboard statistics function.

-- By default, new functions are private. We need to grant EXECUTE permission
-- to the roles that will be calling the function from the web client.
-- 'anon' is for unauthenticated users, and 'authenticated' is for logged-in users.
GRANT EXECUTE
ON FUNCTION public.get_dashboard_stats(p_country_id BIGINT, p_city_id BIGINT, p_facility_id BIGINT)
TO anon, authenticated;
