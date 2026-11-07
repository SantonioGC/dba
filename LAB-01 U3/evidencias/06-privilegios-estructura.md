#Privilegios y estructura

Estudiante: Sergio
Actividad: 6 - Cambios de privilegios y de estructura

##Comandos

REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);
CREATE ROLE rol_temporal LOGIN PASSWORD '<REDACTED>';
DROP ROLE rol_temporal;
SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;

##Resultado

(pegar aquí las líneas statement; la contraseña de rol_temporal debe aparecer como <REDACTED>)

##Preguntas

¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?

REVOKE: privilegio. GRANT: privilegio. ALTER TABLE: estructura.

¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?

Porque ddl incluye CREATE, ALTER y DROP, y también GRANT, REVOKE y COMMENT.

Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.

Solo el administrador o un custodio designado. Las contraseñas no deben viajar en el texto de las sentencias (usar \password) y los secretos se gestionan fuera de ellas.

## Interpretación

Los cambios de privilegios y estructura quedan registrados, pero la bitácora también filtró la contraseña en texto claro.
