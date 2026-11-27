## 1. Objetivo

Construir un diccionario de datos operativo dentro de PostgreSQL mediante instrucciones `COMMENT`, complementando los metadatos técnicos del motor con información de negocio relacionada con la clasificación, finalidad, controles y reglas de calidad.

También se busca verificar que las modificaciones realizadas al diccionario puedan identificarse mediante la bitácora del servidor.

## 2. Documentación dentro del motor

Se utilizó `COMMENT ON TABLE` para documentar la tabla `public.clientes`, estableciendo los siguientes elementos:

- Propietario del dato:Gerencia Comercial.
- Custodio técnico: DBA.
- Clasificación: Confidencial, debido a que contiene datos personales.

Posteriormente se utilizaron instrucciones `COMMENT ON COLUMN` para documentar las diez columnas de la tabla.

Todas las instrucciones ejecutadas correctamente devolvieron `COMMENT`.

Se verificaron los metadatos mediante `information_schema.columns` y `col_description()`.

La consulta devolvió diez filas con sus respectivas descripciones, confirmando que el diccionario quedó incorporado a PostgreSQL.

## 3. Diccionario técnico

| Columna | Tipo de dato | Longitud | Permite NULL | Valor predeterminado |
|---|---|---|---|---|
| `id` | bigint | — | No | Secuencia `clientes_id_seq` |
| `nombre` | varchar | 120 | No | — |
| `correo` | varchar | 150 | No | — |
| `telefono` | varchar | 20 | Sí | — |
| `rfc` | varchar | 13 | Sí | — |
| `edad` | integer | — | Sí | — |
| `ciudad` | varchar | 80 | Sí | — |
| `codigo_postal` | varchar | 10 | Sí | — |
| `fecha_alta` | date | — | Sí | `CURRENT_DATE` |
| `segmento` | varchar | 20 | Sí | — |

Los tipos, las longitudes y la nulabilidad se obtuvieron directamente del motor de PostgreSQL.

## 4. Diccionario de negocio y gobierno

La siguiente tabla complementa los metadatos técnicos con información que el motor no conoce automáticamente.

| Columna | Clasificación | Finalidad | Control aplicado o verificado | ¿Cambios auditados? | Regla de calidad |
|---|---|---|---|---|---|
| `id` | Identificador interno | Identificación técnica del registro | Clave primaria y generación mediante secuencia | Según alcance del disparador del LAB-01 | Único y obligatorio |
| `nombre` | Dato personal directo | Identificación comercial | Acceso controlado según funciones | Mediante auditoría de cambios de clientes, según configuración | Obligatorio |
| `correo` | Dato personal | Notificaciones y contacto | Verificación de formato en Actividad 1 | Mediante auditoría de cambios de clientes, según configuración | Formato válido y unicidad normalizada |
| `telefono` | Dato personal | Contacto y atención | Acceso limitado por finalidad | Mediante auditoría de cambios de clientes, según configuración | Longitud y formato válidos |
| `rfc` | Dato personal | Facturación | Vista enmascarada para soporte en Unidad II | Sí, mecanismo del LAB-01 Parte B | Formato RFC válido |
| `edad` | Dato personal | Analítica agregada | Verificación de rango en Actividad 1 | Según configuración del disparador | Entre 18 y 120 años |
| `ciudad` | Dato de ubicación | Atención comercial y análisis regional | Uso de información agregada según finalidad | Según configuración del disparador | Ciudad normalizada |
| `codigo_postal` | Dato de ubicación | Segmentación geográfica | Acceso limitado por finalidad | Según configuración del disparador | Formato de código postal válido |
| `fecha_alta` | Dato operativo | Seguimiento de antigüedad | Valor predeterminado `CURRENT_DATE` | Según configuración del disparador | Fecha válida de registro |
| `segmento` | Dato comercial | Clasificación de clientes | Clasificación de negocio documentada | Según configuración del disparador | Valor perteneciente al catálogo aprobado de segmentos |

Las reglas de calidad de esta tabla son criterios de negocio documentados. No significa que todas estén implementadas mediante restricciones `CHECK`, `UNIQUE` o `NOT NULL`.

## 5. Exportación del diccionario

El diccionario se exportó utilizando `\copy` desde `psql`, generando el archivo:

`evidencias/diccionario-clientes.csv`

Posteriormente se verificó desde PowerShell.

Resultados obtenidos:
| Verificación | Resultado |
|---|---|
| Archivo creado | Sí |
| Tamaño | 1,215 bytes |
| Registros exportados | 10 |
| Codificación solicitada | UTF-8 |
| Descripciones presentes | 10 |

La exportación contiene metadatos de la tabla y no incluye registros personales de los clientes.

## 6. Evidencia de los comentarios en la bitácora

Se consultó la vista `dba.bitacora`, que contiene las columnas `num` y `linea`.

Para identificar los cambios se ejecutó:

```sql
SELECT num, left(linea, 200) AS evento
FROM dba.bitacora
WHERE linea ILIKE '%COMMENT ON%'
ORDER BY num DESC
LIMIT 12;
```

Resultado obtenido: 11 filas.
Las once filas corresponden a las instrucciones realizadas sobre la tabla y sus diez columnas.

| Línea | Objeto documentado | Hora registrada (CST) |
|---|---|---|
| 17 | Tabla `clientes` | 08:42:47.875 |
| 20 | Columna `id` | 08:43:27.571 |
| 21 | Columna `nombre` | 08:44:00.090 |
| 22 | Columna `correo` | 08:44:30.555 |
| 23 | Columna `rfc` | 08:45:02.666 |
| 24 | Columna `edad` | 08:45:34.578 |
| 25 | Columna `telefono` | 08:46:08.506 |
| 26 | Columna `ciudad` | 08:46:24.419 |
| 27 | Columna `codigo_postal` | 08:46:42.842 |
| 29 | Columna `fecha_alta` | 08:47:36.402 |
| 30 | Columna `segmento` | 08:47:57.154 |

La bitácora identificó los siguientes datos:

- Usuario: `postgres`.
- Base de datos: `comercial`.
- Aplicación: `psql`.
- Cliente: `127.0.0.1`.
- PID de sesión: `7528`.
- Tipo de evento: sentencia SQL registrada.
- Configuración: `log_statement = 'mod'`.

Esta evidencia demuestra que las modificaciones documentales realizadas mediante `COMMENT` quedaron registradas en la bitácora de PostgreSQL.

También se observaron caracteres incorrectamente representados en algunas palabras acentuadas. El problema corresponde a la interpretación de la codificación del texto y debe considerarse al conservar y consultar las bitácoras.

## 7. Preguntas de reflexión

### 1. ¿Qué ventaja tiene guardar el significado en `COMMENT` en lugar de solo en un documento aparte?

La principal ventaja es que las descripciones permanecen asociadas directamente con los objetos de la base de datos.

Esto permite que los administradores y desarrolladores consulten la finalidad de una columna desde PostgreSQL, sin depender exclusivamente de archivos externos que podrían quedar desactualizados.

Por ejemplo, mediante `col_description()` se puede conocer que la columna `rfc` contiene un dato personal utilizado para facturación.

No obstante, los comentarios deben complementarse con documentación externa que registre responsables, políticas, autorizaciones y procedimientos organizacionales.

### 2. ¿Quedaron registrados los `COMMENT` en la bitácora? ¿Con qué nivel de `log_statement`?

Sí. Durante la práctica se identificaron once eventos relacionados con instrucciones `COMMENT ON` en la vista `dba.bitacora`.

Los registros incluyeron fecha, hora, usuario, aplicación, dirección del cliente y el texto de las sentencias ejecutadas.

La configuración activa era:

`log_statement = 'mod'`

Este nivel registra sentencias de modificación y de definición de objetos, incluyendo las instrucciones `COMMENT`.

La evidencia permitió comprobar que las modificaciones a los metadatos del diccionario pueden investigarse mediante la bitácora, siempre que exista una configuración de registro adecuada.

### 3. ¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?

La documentación externa debe incluir principalmente la información organizacional que no forma parte de la estructura técnica de la base de datos.

Por ejemplo:

- Propietarios y custodios responsables de los conjuntos de datos.
- Finalidades autorizadas para utilizar la información.
- Reglas de clasificación y protección.
- Procedimientos de aprobación de accesos y correcciones.
- Políticas de conservación y eliminación.
- Excepciones autorizadas y responsables de aprobarlas.

Esta información debe mantenerse fuera del motor porque corresponde a decisiones de gobierno que pueden involucrar varios sistemas, áreas y procesos de negocio.

Además, un diccionario externo permite relacionar PostgreSQL con otras fuentes de información, como MongoDB, y conservar documentación independiente de la disponibilidad del servidor.

Lo recomendable es utilizar ambos mecanismos de manera complementaria: `COMMENT` para los metadatos cercanos a los objetos y documentación externa para las decisiones y responsabilidades organizacionales.

## 8. Conclusión

La Actividad 3 permitió construir un diccionario operativo para `public.clientes`, documentando directamente en PostgreSQL el significado de sus diez columnas.

Se verificaron correctamente las descripciones mediante las funciones de metadatos y se exportó el diccionario a un archivo CSV.

Adicionalmente, se comprobó que las once instrucciones `COMMENT` quedaron registradas en la bitácora, identificando la cuenta y la sesión desde la que se realizaron.

Esto demuestra que la documentación técnica también puede generar evidencia de cambios y contribuir a una administración de bases de datos más transparente.

Finalmente, se concluye que un diccionario completo debe combinar metadatos del motor con información de negocio sobre propietarios, finalidades, controles y reglas de calidad.

## 9. Archivos relacionados

- `sql/02-comentarios-diccionario.sql`
- `evidencias/diccionario-clientes.csv`
- `evidencias/03-diccionario.md`
