-- 02-seed-roles.sql

-- Insert the built-in roles into the 'roles' table.
-- The ON CONFLICT (role_name) DO NOTHING clause prevents errors if the roles already exist.
INSERT INTO roles (role_name) VALUES
    ('sys_admin'),
    ('facility_admin'),
    ('facility_operator'),
    ('user')
ON CONFLICT (role_name) DO NOTHING;
