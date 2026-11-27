--Posibles duplicados por correo electronico
SELECT
    lower(correo) AS correo_normalizado,
    count(*) AS registros,
    string_agg(id::text, ', ') AS ids
FROM public.clientes
GROUP BY lower(correo)
HAVING count(*) > 1;

--RFC con formato incorrecto o ausente
SELECT id, nombre, rfc
FROM public.clientes
WHERE rfc IS NULL
   OR rfc !~ '^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$';

--correo electronico con formato incorrecto
SELECT id, nombre, correo
FROM public.clientes
WHERE correo !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$';

--Edad fuera del rango permitido
SELECT id, nombre, edad
FROM public.clientes
WHERE edad IS NOT NULL
  AND (edad < 18 OR edad > 120);
  
--Completitud de la informacion
SELECT
    count(*) AS total,
    count(*) FILTER (WHERE telefono IS NULL) AS sin_telefono,
    count(*) FILTER (WHERE rfc IS NULL) AS sin_rfc
FROM public.clientes;
