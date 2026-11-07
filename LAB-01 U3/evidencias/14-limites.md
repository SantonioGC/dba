#lecturas y volumen

psql "postgresql://soporte_ana:<REDACTED>@127.0.0.1/comercial" -c "SELECT nombre, rfc, telefono FROM clientes WHERE id = 3"

UPDATE clientes SET segmento = 'regular';
SELECT count(*) AS lineas_bitacora FROM dba.bitacora WHERE linea LIKE '%statement: UPDATE clientes SET segmento%';
SELECT operacion, count(*) FROM auditoria.cambios_clientes GROUP BY operacion ORDER BY operacion;
SELECT count(*) AS lecturas_soporte FROM dba.bitacora WHERE linea LIKE '%user=soporte_ana%SELECT nombre, rfc%';

##Resultado

comercial=# SELECT count(*) AS lineas_bitacora FROM dba.bitacora WHERE linea LIKE '%statement: UPDATE clientes SET segmento%';
 lineas_bitacora 
---------+-------
               0
(1 fila)

comercial=# SELECT operacion, count(*) FROM auditoria.cambios_clientes GROUP BY operacion ORDER BY operacion;
 operacion | count 
-----------+-------
 DELETE    |     1
 INSERT    |     1
 UPDATE    |     8
(3 filas)

comercial=# SELECT count(*) AS lecturas_soporte FROM dba.bitacora WHERE linea LIKE '%user=soporte_ana%SELECT nombre, rfc%';
 lecturas_soporte 
---------+--------
                0
(1 fila)

##Preguntas

Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?

La bitácora tendría una sola línea, pero la tabla de auditoría un millón de filas: mucho almacenamiento y lentitud.

Propón quién podría autorizar la depuración de auditoria.cambios_clientes.

El responsable de seguridad o gobierno de datos no el DBA por sí solo.

¿Por qué log_statement = 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?

Porque registra el texto de todas las consultas, con sus valores.

##Interpretacion

El UPDATE masivo deja una línea en la bitácora y una fila por registro en la auditoría. La lectura del RFC no deja rastro con mod.
