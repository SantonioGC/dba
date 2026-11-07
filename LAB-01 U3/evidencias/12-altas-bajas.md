# Altas y bajas

INSERT INTO clientes (nombre, correo, rfc, edad, ciudad, codigo_postal) VALUES ('Pedro Ruiz', 'pedro.ruiz@example.test', 'RUPE950101AAA', 30, 'Guasave', '81000');
DELETE FROM clientes WHERE nombre = 'Pedro Ruiz';
SELECT id_evento, usuario_sesion, aplicacion, ip_cliente, operacion, id_cliente, valores_antes ->> 'rfc' AS rfc_antes, valores_despues ->> 'rfc' AS rfc_despues FROM auditoria.cambios_clientes ORDER BY id_evento;

## Resultado

postgres=# INSERT INTO clientes (nombre, correo, rfc, edad, ciudad, codigo_postal) VALUES ('Pedro Ruiz', 'pedro.ruiz@example.test', 'RUPE950101AAA', 30, 'Guasave', '81000');
INSERT 0 1
postgres=# DELETE FROM clientes WHERE nombre = 'Pedro Ruiz';
DELETE 1

comercial=# SELECT id_evento, usuario_sesion, aplicacion, ip_cliente, operacion, id_cliente, valores_antes ->> 'rfc' AS rfc_antes, valores_despues ->> 'rfc' AS rfc_despues FROM auditoria.cambios_clientes ORDER BY id_evento;
1  app_ventas     | app-ventas-web           | 127.0.0.1  | UPDATE    |
3 | GAMA780912XYZ | GAMA780912ZZZ
2 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | INSERT    |
6 |               | RUPE950101AAA
3 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | DELETE    |
6 | RUPE950101AAA | 
4 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | UPDATE    |
1 | LOAA850315ABC | LOAA850315ABC
5 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | UPDATE    |
2 | PECA900720DEF | PECA900720DEF
6 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | UPDATE    |
4 | TOLU920201JKL | TOLU920201JKL
7 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | UPDATE    |
5 | SALA880525MNO | SALA880525MNO
8 | postgres       | pgAdmin 4 - CONN:1850607 | 127.0.0.1  | UPDATE    |
3 | GAMA780912GHI | GAMA780912GHI
9 | app_ventas     | app-ventas-web           | 127.0.0.1  | UPDATE    |
3 | GAMA780912GHI | GAMA780912ZZZ
10 | app_ventas     | app-ventas-web           | 127.0.0.1  | UPDATE    |
3 | GAMA780912ZZZ | GAMA780912ZZZ
(10 filas)

## Preguntas

El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?

En auditoria.cambios_clientes y estan eventos de INSERT y DELETE con el registro completo en JSONB y en la bitácora.

¿Por qué ip_cliente está vacía en los eventos 2 y 3?

Porque la sesión del administrador uso el socket local, sin IP. Si se hizo desde pgAdmin por TCP, puede salir 127.0.0.1.

La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?

La auditoría conserva datos personales de un cliente ya eliminado. Debe resolverlo el responsable de gobierno de datos junto con auditoría y el área legal, definiendo un periodo de retención.

## Interpretacion

La auditoría conserva altas y bajas aunque el registro ya no exista en clientes.
