## 1. Objetivo

Establecer criterios para conservar, proteger y eliminar los datos y las evidencias de auditoría durante periodos justificados, reduciendo los riesgos de pérdida de información, incumplimiento de obligaciones y almacenamiento innecesario de datos personales.

Esta política busca equilibrar las necesidades operativas de Comercializadora Norte con la protección de la información y los requerimientos de auditoría interna.

## 2. Alcance

Aplica a los datos, respaldos, bitácoras y registros de auditoría administrados mediante PostgreSQL y MongoDB, incluyendo:

- Tabla `public.clientes` de PostgreSQL.
- Tabla `auditoria.cambios_clientes`.
- Bitácoras de acceso, modificación y cambios administrativos de PostgreSQL.
- Colección `comercial.clientes` de MongoDB.
- Colección `comercial.system.profile`.
- Bitácora operativa de `mongod`.
- Colección `auditoria.instantaneas_privilegios`.
- Exportaciones y archivos de evidencia utilizados en los laboratorios.
- Copias de seguridad generadas conforme a la POL-02.

Se aplica a los ambientes de desarrollo, pruebas y producción, considerando la finalidad de los datos y las obligaciones correspondientes a cada ambiente.

## 3. Regla verificable

Todo conjunto de datos y evidencia deberá tener un periodo de conservación aprobado por su propietario y validado por Seguridad de la Información y Auditoría Interna; al vencerlo, el responsable verificará si existe una obligación o investigación que exija conservarlo y, de no existir, autorizará y documentará su eliminación o anonimización.

El DBA revisará mensualmente los registros próximos a vencer y conservará evidencia de las decisiones tomadas.

Los periodos deberán ajustarse cuando exista una obligación normativa aplicable o una investigación pendiente.

## 4. Periodos de conservación propuestos

Los periodos siguientes proceden del criterio desarrollado en `evidencias/05-conservacion.md`.

| Tipo de registro | Conservación propuesta | Responsable de validación |
|---|---|---|
| Accesos de PostgreSQL | 90 días | Seguridad de la Información |
| Cambios de privilegios y estructura | 365 días | Auditoría Interna |
| Sentencias de modificación registradas por PostgreSQL | 180 días | Seguridad y Auditoría |
| Tabla `auditoria.cambios_clientes` | 365 días | Auditoría Interna y Gerencia Comercial |
| Bitácora de `mongod` | 180 días | Seguridad de la Información |
| Exportaciones seleccionadas de `system.profile` | 90 días | Auditoría Interna |
| Instantáneas de privilegios de MongoDB | 365 días | Seguridad de la Información |

Los periodos constituyen propuestas académicas; no deben interpretarse como plazos legales establecidos.

### Datos comerciales

Los registros de clientes en PostgreSQL y MongoDB se conservarán mientras exista una finalidad legítima y autorizada, considerando las obligaciones legales aplicables.

La Gerencia Comercial deberá revisar periódicamente si los datos siguen siendo necesarios.

No se establecerá automáticamente una eliminación de clientes a los 365 días, porque la conservación de datos operativos y la retención de bitácoras tienen finalidades distintas.

### Respaldos

Las copias de seguridad deberán conservarse durante un periodo autorizado y documentado, definido de acuerdo con la POL-02 y las necesidades de recuperación del servicio.

El periodo final se establecerá al diseñar los procedimientos técnicos de la Unidad V.

### Evidencias sujetas a investigación

Cuando exista una investigación, incidente o requerimiento válido de conservación, la eliminación de las evidencias relacionadas se suspenderá hasta que la autoridad interna responsable autorice su liberación.

Esta suspensión deberá registrarse, incluir una justificación y tener revisiones periódicas.

## 5. Responsables

| Responsable | Función |
|---|---|
| Gerencia Comercial | Definir la finalidad y las necesidades de conservación de los datos de clientes |
| Auditoría Interna | Determinar las necesidades de conservación de evidencias y revisar su eliminación |
| Seguridad de la Información | Verificar que se protejan las bitácoras y los registros durante su conservación |
| DBA | Aplicar los controles de almacenamiento y las eliminaciones autorizadas |
| Área jurídica | Validar los periodos exigidos por las obligaciones legales aplicables |
| Infraestructura | Proteger los repositorios y mantener disponibles las copias durante los periodos autorizados |

El DBA no podrá modificar por cuenta propia los periodos de conservación ni eliminar evidencias sujetas a investigación.

## 6. Excepciones

Podrán aprobarse excepciones cuando:

- Exista una investigación interna o externa en curso.
- Se requiera conservar información por una obligación normativa.
- Un incidente de seguridad exija preservar evidencia.
- Exista una necesidad extraordinaria de negocio debidamente justificada.

La excepción deberá incluir el registro afectado, motivo, responsable que autoriza, periodo adicional y fecha de revisión.

La autorización deberá contar con la participación del propietario de los datos y de Auditoría Interna o el área jurídica, según corresponda.

## 7. Evidencia de cumplimiento

### 7.1 Evidencias existentes

Laboratorio 01 — PostgreSQL

La vista `dba.bitacora` permite consultar el archivo de registro activo.

En la Actividad 3 del presente laboratorio se verificó la existencia de once eventos relacionados con instrucciones `COMMENT`, identificando usuario, fecha y sentencia ejecutada.

Esto demuestra que el servidor conserva registros de determinadas operaciones, pero no demuestra por sí solo una política de retención automatizada.

Laboratorio 02 — MongoDB

Se exportaron los archivos:

- `evidencias/system-profile.json`.
- `evidencias/bitacora-mongod.log`.
- `evidencias/hashes.sha256`.

Se comprobó la importancia de exportar la evidencia antes de que el perfilador sobrescriba documentos o se reinicie el historial temporal de `getLog`.

Laboratorio 03 — Actividad 5

El archivo `evidencias/05-conservacion.md` documenta los periodos propuestos, sus riesgos y los controles necesarios.

### 7.2 Evidencias pendientes

Todavía no existe evidencia de:

- Un calendario formalmente aprobado de eliminación.
- Un historial de eliminaciones autorizadas.
- Un reporte mensual de cumplimiento de los periodos.
- Una configuración verificada de conservación centralizada para todos los registros.

Por tanto, la política está documentada, pero su cumplimiento operativo no se ha demostrado completamente.

Una vez implementada, deberán conservarse actas de revisión, autorizaciones, registros de eliminación y constancias de preservación por investigaciones.

## 8. Protección durante la conservación

Las evidencias deberán conservarse con acceso restringido, medidas de integridad y almacenamiento protegido.

Cuando se exporten archivos, podrán calcularse hashes SHA-256 para detectar modificaciones posteriores.

Los registros confidenciales no deberán publicarse en repositorios abiertos ni compartirse con personal no autorizado.

La conservación de un registro no implica que cualquier usuario pueda consultarlo.

Las medidas de acceso deberán cumplir con POL-01 y POL-05.

## 9. Revisión

La política se revisará cada seis meses y también cuando ocurran cambios relevantes en:

- Obligaciones normativas.
- Finalidades de tratamiento de datos.
- Necesidades de auditoría.
- Tecnologías o mecanismos de registro.
- Riesgos de conservación de información.
- Incidentes de seguridad.

La revisión será coordinada por Seguridad de la Información y Auditoría Interna, con participación de los propietarios de los datos.

## 10. Criterio de cumplimiento

La política se considerará cumplida cuando los conjuntos de datos cuenten con periodos aprobados, las evidencias se conserven durante su vigencia y las eliminaciones o excepciones puedan verificarse mediante registros documentados.

Una evidencia destruida antes de finalizar su periodo será considerada un incumplimiento.

También será un hallazgo conservar indefinidamente datos personales sin finalidad justificada ni obligación aplicable.

## 11. Conclusión

La POL-03 establece criterios para administrar el ciclo de vida de los datos y de las evidencias de auditoría.

Los periodos propuestos se basan en los riesgos observados durante los laboratorios de PostgreSQL y MongoDB.

La política reconoce que conservar evidencia es necesario para investigar cambios e incidentes, pero que mantener datos personales indefinidamente puede generar riesgos adicionales.

Por ello, se requiere que cada eliminación o ampliación de conservación sea una decisión autorizada, documentada y verificable.

## 12. Documentos relacionados

- `evidencias/05-conservacion.md`.
- `evidencias/04-catalogo.md`.
- `POL-01-acceso.md`.
- `POL-02-respaldo.md`.
- `POL-05-datos-sensibles.md`.
