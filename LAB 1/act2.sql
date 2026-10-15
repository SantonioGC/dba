--ACT 2
--hacer un rol donde no se puede iniciar sesion solo es para agrupar permisos
CREATE ROLE soporte NOLOGIN;

--se crea un view para ver datos con las columnas tapadas
CREATE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,
    CONCAT(LEFT(correo, 2), '*****', SUBSTRING(correo FROM POSITION('@' IN correo))) AS correo,
    CONCAT('******', RIGHT(telefono, 4)) AS telefono,
    CONCAT('*********', RIGHT(rfc, 4)) AS rfc
FROM clientes;

--le dejamos al rol soporte para que puedan ver dentro 
GRANT USAGE ON SCHEMA public TO soporte;
--le decimos que solo puede leeer el view que hicimos
GRANT SELECT ON v_clientes_soporte TO soporte;
--le quitamos cualquier permiso sobre la tabla original
REVOKE ALL ON clientes FROM soporte;
--asiganamos que podemos usar este rol
GRANT soporte TO CURRENT_USER;

--PRUEBAS 
SET ROLE soporte
SELECT * FROM v_clientes_soporte
SELECT * FROM clientes
RESET ROLE

SELECT grantee, table_name, privilege_type
FROM information_schema.table_privileges
WHERE grantee = 'soporte';