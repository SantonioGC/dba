--LAB 04 Inspeccion
-- para ver los privilegios de la cuenta
SELECT rolname, rolsuper FROM pg_roles WHERE rolname = current_user;
SELECT pg_has_role(current_user, 'pg_read_all_settings', 'member');

-- superficie de ataque
SELECT version();
SHOW port;
SHOW listen_addresses;   -- cubre también la Actividad 3
SHOW ssl;
SHOW password_encryption;

SELECT pid, usename, datname, client_addr, client_port, application_name
FROM pg_stat_activity;

-- ver chivos de configuración, datos y logs
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

-- para ver las reglas de pg_hba.conf
SELECT type, database, user_name, address, auth_method
FROM pg_hba_file_rules;
