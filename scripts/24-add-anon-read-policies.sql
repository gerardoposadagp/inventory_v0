-- 24-add-anon-read-policies.sql
-- This script adds read-access policies for the 'anon' (unauthenticated) role.
-- This is necessary for development before a login system is implemented.

-- NOTE: These policies grant public read access.
-- They should be reviewed and tightened before moving to production.

DROP POLICY IF EXISTS "Allow anonymous read access" ON public.countries;
CREATE POLICY "Allow anonymous read access"
ON public.countries FOR SELECT
TO anon
USING (true);

DROP POLICY IF EXISTS "Allow anonymous read access" ON public.cities;
CREATE POLICY "Allow anonymous read access"
ON public.cities FOR SELECT
TO anon
USING (true);

DROP POLICY IF EXISTS "Allow anonymous read access" ON public.facilities;
CREATE POLICY "Allow anonymous read access"
ON public.facilities FOR SELECT
TO anon
USING (true);

DROP POLICY IF EXISTS "Allow anonymous read access" ON public.categories;
CREATE POLICY "Allow anonymous read access"
ON public.categories FOR SELECT
TO anon
USING (true);

DROP POLICY IF EXISTS "Allow anonymous read access" ON public.items;
CREATE POLICY "Allow anonymous read access"
ON public.items FOR SELECT
TO anon
USING (true);

DROP POLICY IF EXISTS "Allow anonymous read access" ON public.inventory;
CREATE POLICY "Allow anonymous read access"
ON public.inventory FOR SELECT
TO anon
USING (true);
