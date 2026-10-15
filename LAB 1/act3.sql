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