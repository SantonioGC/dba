--ACT 7
--miramos los clientes dados de alta de hace mas de 5 años
SELECT * FROM clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';