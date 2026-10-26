-- LAB 04 Roles

--ver roles y privilegios
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- mirar las extensiones instaladas
SELECT extname, extversion
FROM pg_extension
ORDER BY extname;
