--ACT 3
--creamos 2 carpetas 
CREATE SCHEMA pii;
CREATE SCHEMA analitica;

--hacemos una tabla donde estara los tokens
CREATE TABLE pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE REFERENCES public.clientes(id)
);

--obligamos a que cada cliente_id exista en clientes
INSERT INTO pii.mapa_cliente (token, cliente_id)	

--creamos un token para cada cliente
SELECT gen_random_uuid(), id FROM clientes;

--copiamos ciertos datos y cambiamos la identidad por el token 
--con el join conectamos cada token con el cliente original para armar la copia
CREATE TABLE analitica.clientes AS
SELECT m.token AS cliente_token, c.edad, c.ciudad, c.codigo_postal, c.fecha_alta
FROM pii.mapa_cliente m
JOIN clientes c ON c.id = m.cliente_id;

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