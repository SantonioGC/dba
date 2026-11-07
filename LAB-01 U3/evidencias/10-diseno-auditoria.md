# Diseño de la auditoría

| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
|---|---|---|---|
| id_evento | BIGSERIAL | Identifica y ordena cada evento | No, es la llave primaria |
| momento | TIMESTAMPTZ | ¿Cuándo? | No, siempre se sabe cuándo |
| usuario_sesion | TEXT | ¿Quién lo hizo? | No, toda sesión tiene usuario |
| usuario_efectivo | TEXT | ¿Con qué privilegios se ejecutó? | No, siempre hay un rol vigente |
| aplicacion | TEXT | ¿Desde qué aplicación? | Sí, el cliente puede no declararla |
| ip_cliente | INET | ¿Desde qué equipo? | Sí, es nula en conexiones por socket local |
| operacion | TEXT | ¿Qué ocurrió? | No, siempre hay una operación |
| id_cliente | BIGINT | ¿A qué registro afectó? | Sí, puede no aplicar a un solo registro |
| valores_antes | JSONB | ¿Qué valor tenía antes? | Sí, es nulo en un INSERT |
| valores_despues | JSONB | ¿Qué valor tiene ahora? | Sí, es nulo en un DELETE |

## Comandos

CREATE SCHEMA auditoria;
REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;
CREATE TABLE auditoria.cambios_clientes (...);

## Preguntas

¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?

Porque guarda la zona horaria y el instante es inequívoco entre servidores y zonas.

¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió?

Para conservar el estado completo aunque clientes cambie de estructura, y poder comparar o restaurar cualquier campo.

La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?

Es información sensible, igual que clientes. Debe tener la misma clasificación o mayor y acceso solo para el administrador o auditor, nunca público.

## Interpretacion

Cada campo responde una pregunta de Dirección y el esquema auditoria queda sin acceso público.
