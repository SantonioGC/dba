# Manipulación de la auditoría
 
psql "postgresql://app_ventas:<REDACTED>@127.0.0.1/comercial?application_name=app-ventas-web" -c "DELETE FROM auditoria.cambios_clientes" -c "ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes"

ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes;
UPDATE clientes SET rfc = 'GAMA780912GHI' WHERE id = 3;
ALTER TABLE clientes ENABLE TRIGGER trg_auditoria_clientes;
SELECT count(*) FROM auditoria.cambios_clientes;
SELECT linea FROM dba.bitacora WHERE linea ~ 'statement: (ALTER TABLE clientes (DIS|EN)ABLE|UPDATE clientes SET rfc = .GAMA780912GHI)' ORDER BY num;

## Resultado

da-sergio@fedora:~/dba/lab-04-hardening$ psql "postgresql://app_ventas:Ventas_Practica_2026@127.0.0.1/comercial?application_name=app-ventas-web" -c "DELETE FROM auditoria.cambios_clientes" -c "ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes"
ERROR:  permiso denegado al esquema auditoria

da-sergio@fedora:~/dba/lab-04-hardening$ 

 count 
--+----
    10
(1 fila)

 linea 
---+---
(0 filas)

## Preguntas

¿Qué evidencia permite detectar que hubo un cambio sin auditar?

La bitácora muestra el DISABLE TRIGGER y el UPDATE de postgres, pero la tabla de auditoría no tiene ese evento.

¿Qué control administrativo (no técnico) reduciría este riesgo?

Separar funciones: que quien opera la base no custodie la evidencia, y que otra área revise las bitácoras y las guarde fuera del servidor.

Un administrador con control total puede desactivar la auditoría. Por eso quien opera la base y quien audita deben ser personas o áreas distintas.

## Interpretacion

app_ventas no pudo borrar ni desactivar la auditoría el administrador sí pudo, pero quedó rastro en la bitácora.
