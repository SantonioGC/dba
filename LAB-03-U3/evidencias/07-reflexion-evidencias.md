
Sí. Los privilegios observados en la evidencia E2 coinciden con la matriz de roles utilizada en el escenario académico de Comercializadora Norte.

La consulta a `information_schema.role_table_grants` mostró los siguientes resultados:

| Usuario | Privilegios encontrados |
|---|---|
| `app_ventas` | `SELECT`, `UPDATE` |
| `soporte_ana` | `SELECT` |

La cuenta `app_ventas` conserva permisos de lectura y actualización sobre la tabla `public.clientes`, mientras que `soporte_ana` únicamente dispone de lectura.

Estos resultados corresponden a los privilegios establecidos para ambas cuentas durante los laboratorios.

Por lo tanto, no se identificó una discrepancia respecto de la matriz utilizada en el escenario.

Sin embargo, esta coincidencia no significa que los permisos sean necesariamente los más adecuados para un sistema real.

Por ejemplo, el acceso de lectura directa de `soporte_ana` a una tabla que contiene datos personales podría requerir restricciones adicionales mediante vistas, enmascaramiento o permisos más específicos.

La Gerencia Comercial y Seguridad de la Información deben evaluar esta necesidad conforme a la POL-01 y la POL-05.

Evidencia: `E2-privilegios.txt`.

## 2. ¿Por qué E4 muestra solo metadatos y no `valores_antes` ni `valores_despues`?

La evidencia E4 muestra únicamente los metadatos de los eventos de auditoría para evitar exponer información personal innecesaria.

Los campos exportados fueron:

- `id_evento`.
- `momento`.
- `usuario_sesion`.
- `aplicacion`.
- `operacion`.
- `id_cliente`.

Estos elementos permiten identificar cuándo se realizó una modificación, qué cuenta la ejecutó, desde qué aplicación y cuál fue el registro afectado.

En cambio, los campos `valores_antes` y `valores_despues` pueden contener información como nombres, correos electrónicos, teléfonos y RFC.

Incluir estos valores completos en un expediente destinado a revisión académica produciría una exposición innecesaria de datos personales.

La decisión corresponde al principio de minimización de datos: compartir únicamente la información necesaria para demostrar el funcionamiento del control.

Si una investigación requiere conocer los valores originales, estos deberán consultarse mediante un procedimiento autorizado, restringido y documentado.

Evidencia: `E4-muestra-auditoria.txt`.

## 3. ¿Qué evidencia demostraría que E1 estuvo vigente durante todo el periodo revisado y no solo hoy?

La evidencia E1 muestra los parámetros de PostgreSQL en el momento en que se ejecutó la consulta.

Por sí sola, no demuestra que esos mismos valores hayan permanecido vigentes durante todo el periodo de auditoría.

Para comprobar la continuidad sería necesario conservar evidencias históricas, como registros de cambios de configuración, archivos de parámetros con control de versiones, reportes periódicos y bitácoras fechadas del servidor.

También sería útil contar con revisiones programadas de la configuración y registros de aprobación de las modificaciones administrativas.

Por ejemplo, una serie de verificaciones fechadas de `log_statement`, junto con un historial de modificaciones de `postgresql.conf` y registros de reinicios, ayudaría a determinar cuándo estuvo activa cada configuración.

Durante el Laboratorio 01 se identificó que `log_statement` estuvo inicialmente en `none`, antes de habilitarse el registro de modificaciones.

Por lo tanto, no sería correcto afirmar que la configuración actual estuvo vigente durante todo el periodo histórico.

La evidencia disponible demuestra el estado actual y determinados eventos anteriores, pero deben declararse los intervalos cuya cobertura no pueda comprobarse.

Evidencia `E1-configuracion-registro.txt` y los registros históricos de PostgreSQL revisados durante la Actividad 7.

## Conclusión

La Actividad 8 permitió integrar evidencias técnicas verificables de PostgreSQL y MongoDB.

Los resultados confirmaron los privilegios vigentes, el estado habilitado del disparador de auditoría, la existencia de diez eventos auditados y la integridad de los archivos exportados.

También se comprobó que las evidencias requieren medidas de protección, ya que las bitácoras pueden contener información confidencial.

Finalmente, se concluye que una auditoría debe distinguir entre el estado actual de un control y su funcionamiento histórico.

Conservar registros, documentar limitaciones y proteger las evidencias permite realizar revisiones más confiables y transparentes.

## Archivos relacionados

- `E1-configuracion-registro.txt`
- `E2-privilegios.txt`
- `E3-disparadores.txt`
- `E4-muestra-auditoria.txt`
- `E5-bitacora-postgresql.log`
- `E6-mongodb/`
