-- 23-enable-rls-and-policies.sql
-- This script enables Row Level Security (RLS) and creates the necessary
-- read-access policies for the dashboard to function.

-- Step 1: Enable RLS on all tables the dashboard function reads from.
-- This is a critical security step.
ALTER TABLE public.countries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;

-- Step 2: Create policies to allow authenticated users to read data.
-- Without these policies, no user can select data, and the RPC function will fail.

-- Drop policy if it exists, to allow re-running the script.
DROP POLICY IF EXISTS "Allow authenticated read access" ON public.countries;
CREATE POLICY "Allow authenticated read access"
ON public.countries FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Allow authenticated read access" ON public.cities;
CREATE POLICY "Allow authenticated read access"
ON public.cities FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Allow authenticated read access" ON public.facilities;
CREATE POLICY "Allow authenticated read access"
ON public.facilities FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Allow authenticated read access" ON public.categories;
CREATE POLICY "Allow authenticated read access"
ON public.categories FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Allow authenticated read access" ON public.items;
CREATE POLICY "Allow authenticated read access"
ON public.items FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Allow authenticated read access" ON public.inventory;
CREATE POLICY "Allow authenticated read access"
ON public.inventory FOR SELECT
TO authenticated
USING (true);
