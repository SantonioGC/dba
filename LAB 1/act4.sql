--ACT4
--creamos el rol de analista donde no se puede iniciar sesion solo es para agrupar permisos
CREATE ROLE analista NOLOGIN;
--dejamos que pueda entrar a esta carpeta y leer la tabla 
GRANT USAGE ON SCHEMA analitica TO analista;
GRANT SELECT ON analitica.clientes TO analista;
--asiganamos que podemos usar este rol
GRANT analista TO CURRENT_USER;

--nos ponemos el rol para las pruebas
SET ROLE analista
--pruebas
SELECT * FROM analitica.clientes;
SELECT * FROM pii.mapa_cliente;  
SELECT * FROM public.clientes; 
RESET ROLE;

--revisamos privilegios
SELECT
    has_table_privilege('analista','analitica.clientes','SELECT') AS analitica,
    has_table_privilege('analista','pii.mapa_cliente','SELECT')   AS mapa,
    has_table_privilege('analista','public.clientes','SELECT')    AS clientes;