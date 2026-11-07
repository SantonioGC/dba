# Errores y operaciones rechazadas

psql "postgresql://soporte_ana:<REDACTED>@127.0.0.1/comercial" -c "DELETE FROM clientes WHERE id = 5"

DROP ROLE soporte_ana;
SELECT linea FROM dba.bitacora WHERE linea ~ '(ERROR|STATEMENT|DETAIL):  (permission|privileges|role|DELETE|DROP)' ORDER BY num;

## Resultado

da-sergio@fedora:~/dba/lab-04-hardening$ psql "postgresql://soporte_ana:Soporte_Practica_2026@127.0.0.1/comercial" -c "DELETE FROM clientes WHERE id = 5"
ERROR:  permiso denegado a la tabla clientes
da-sergio@fedora:~/dba/lab-04-hardening$ 

 linea 
---+---
(0 filas)

## Preguntas

¿El intento de soporte_ana causó algún daño? ¿Por qué debe auditarse de todos modos?

No fue rechazado debe auditarse porque es un intento de hacer algo fuera de su rol, que puede ser un error o un abuso.

¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?

Autenticación: quién eres. 
Autorización: qué puedes hacer. Aquí soporte_ana ya había entrado, pero no tenía permiso de DELETE.

¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?

Primero hay que retirar sus privilegios y objetos, y después eliminar el rol.

## Interpretacion

Los errores quedan registrados junto con la sentencia que los provocó, gracias a log_min_error_statement = error.
