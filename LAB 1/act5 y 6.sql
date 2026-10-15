--ACT 5 Y 6
--hacemos una generalizacion la edad en rangos y cuenta cuantos hay en cada uno
SELECT CASE WHEN edad BETWEEN 18 AND 30 THEN '18-30' WHEN edad BETWEEN 31 AND 45 THEN '31-45' ELSE '46+' END AS rango_edad,
       COUNT(*) AS total
FROM clientes GROUP BY 1;

--generalizamos el codigo postal a de 2 numeros
SELECT LEFT(codigo_postal, 2) AS region, COUNT(*) AS total
FROM clientes GROUP BY 1;

--combinamos el rango de edad y region
SELECT CASE WHEN edad BETWEEN 18 AND 30 THEN '18-30' WHEN edad BETWEEN 31 AND 45 THEN '31-45' ELSE '46+' END AS rango_edad,
       LEFT(codigo_postal, 2) AS region, COUNT(*) AS total
FROM clientes GROUP BY 1, 2;

--combinamos el rango de edad y region pero de 5 o mas personas
SELECT CASE WHEN edad BETWEEN 18 AND 30 THEN '18-30' WHEN edad BETWEEN 31 AND 45 THEN '31-45' ELSE '46+' END AS rango_edad,
       LEFT(codigo_postal, 2) AS region, COUNT(*) AS total
FROM clientes GROUP BY 1, 2 HAVING COUNT(*) >= 5;

--combinamos de una forma mas general de a 1 digito de codigo postal 
SELECT LEFT(codigo_postal, 1) AS region, COUNT(*) AS total
FROM clientes GROUP BY 1 HAVING COUNT(*) >= 5;