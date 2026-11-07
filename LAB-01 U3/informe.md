#Informe
##1. Despliegue y situación inicial

PostgreSQL 16 nativo en Fedora, administrado desde pgAdmin 4 local. Por defecto no se registraban conexiones, sentencias, usuario ni IP, así que no se podía responder a Dirección.

##2. Configuración aplicada

- logging_collector = on 
- log_connections = on 
- log_disconnections = on 
- log_line_prefix con usuario, base, aplicación e IP 
- log_statement = mod

Se usó ALTER SYSTEM para que funcione igual en cualquier despliegue.

##3. Eventos observados

- Acceso: intento fallido por contraseña incorrecta y conexión exitosa con su desconexión.
- Privilegio: GRANT y REVOKE sobre clientes.
- Estructura: ALTER TABLE clientes ADD COLUMN.
- Datos: UPDATE de teléfono por app_ventas.
- Error: DELETE rechazado a soporte_ana.
- Configuración: parameter log_statement changed.

##4. Auditoría del dato

La tabla auditoria.cambios_clientes guarda quién, cuándo, aplicación, IP y el registro completo antes y después en JSONB. El disparador usa SECURITY DEFINER para que app_ventas pueda provocar el registro sin poder escribir en la auditoría. Se usa session_user porque current_user dentro de la función es el propietario. El incidente auditado mostró que app_ventas cambió el RFC de GAMA780912XYZ a GAMA780912ZZZ.

##5. Limitaciones

- Las lecturas no se registran con mod.
- Un UPDATE masivo genera una fila de auditoría por registro.
- Un administrador con control total puede desactivar el disparador y cambiar la configuración.

##6. Riesgos de la bitácora

- Secretos expuestos: la contraseña de rol_temporal quedó en texto claro.
- Pérdida: la bitácora vive en el servidor y se rota o se pierde si se reinstala.
- Acceso de terceros: quien lea dba.bitacora puede ver datos sensibles.

##7. Cronología y conclusión

Con esta configuración sí se puede demostrar quién cambió un dato sensible y qué valor tenía antes, pero solo para los cambios posteriores a la configuración. Los cambios anteriores o hechos con el disparador desactivado quedan como hueco.

##8. Exportación y conservación de la bitácora

La bitácora se exportó a evidencias/bitacora-lab01.log con la contraseña de rol_temporal sustituida por <REDACTED> antes de salir del servidor. El hash SHA-256 está en evidencias/bitacora-lab01.sha256.

Un resumen SHA-256, ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?

No lo impide. Permite demostrar si el archivo cambió después de calcular el hash.

¿Dónde debería guardarse el hash para que sea útil como control de integridad?

Separado del archivo y fuera del alcance del administrador, por ejemplo en el repositorio de GitLab o con otra área.

La guía NIST SP 800-92 trata la conservación y protección de bitácoras (REF-U3-03). ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?

Se pierde si el servidor se reinstala o falla, y quien comprometa el servidor puede borrar o alterar la bitácora para ocultar sus actos.

Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio. No existe una cifra única correcta.

Un año. Es suficiente para detectar y investigar incidentes que se descubren tarde, y no acumula datos sensibles por más tiempo del necesario. El criterio formal se completa en el LAB-03.

##Reflexion

¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

Porque lo que no se registró en su momento no puede reconstruirse.

¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

Para que funcione igual en cualquier despliegue, se lea desde el motor y quede bajo control del servidor.

¿Por qué el prefijo de línea es tan importante como el nivel de log_statement?

Sin usuario, base, aplicación e IP, la línea dice qué pasó pero no quién ni desde dónde.

¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?

La sentencia dice qué se ejecutó. El cambio en el dato conserva el valor anterior y el nuevo por cada registro, y permite restaurar.

¿Qué evidencia ofrece pg_stat_activity que no ofrece la bitácora, y viceversa?

pg_stat_activity muestra el estado actual de las sesiones. La bitácora conserva la historia de lo que ya ocurrió.

Si el administrador puede cambiar log_statement a none y desactivar el disparador, ¿quién audita al administrador?

Un sistema externo administrado por otra área: bitácoras enviadas fuera del servidor y separación entre quien opera y quien custodia la evidencia.
