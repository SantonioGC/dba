## 1. Objetivo

Identificar problemas de calidad en la información de clientes mediante consultas SQL, documentar los hallazgos y establecer quién tiene la responsabilidad de autorizar las correcciones.

El propósito es demostrar que el DBA puede detectar inconsistencias, pero no debe modificar los datos de negocio sin autorización del propietario correspondiente.

## 2. Preparación y registros de prueba

Se verificó que la base `comercial` conservara los esquemas `public`, `auditoria` y `dba`, así como la configuración `log_statement = 'mod'`.

La vista `dba.bitacora` devolvió cinco registros.

Posteriormente se insertaron dos clientes con errores intencionales:

| ID | Cliente | Problemas introducidos |
|---|---|---|
| 7 | Ana Lopez | Posible correo duplicado y RFC incompleto |
| 8 | Jorge Díaz | Correo inválido, RFC ausente, teléfono corto, edad negativa y código postal corto |

La inserción devolvió `INSERT 0 2`, confirmando que ambos registros se guardaron correctamente.

## 3. Verificaciones realizadas

### 3.1 Posibles duplicados por correo

Se compararon los correos normalizados a minúsculas.

Resultado obtenido:
| Correo normalizado | Registros | IDs |
|---|---|---|
| `[CORREO_REDACTADO]` | 2 | 1, 7 |

Se identificó un posible duplicado entre los clientes 1 y 7.

Compartir el mismo correo no demuestra por sí solo que ambos registros pertenezcan a una misma persona. Es necesario que Gerencia Comercial lo investigue.

### 3.2 RFC inválidos o ausentes

Se aplicó una expresión regular para verificar el formato del RFC y se buscaron valores nulos.

Resultado obtenido:
| ID | Cliente | RFC | Problema |
|---|---|---|---|
| 7 | Ana Lopez | `LOAA850315AB` | RFC incompleto |
| 8 | Jorge Díaz | `NULL` | RFC no registrado |

La verificación identifica problemas de formato y completitud; no comprueba la existencia del RFC ante el SAT.

### 3.3 Correos electrónicos inválidos

Se aplicó una expresión regular para detectar correos cuyo formato no correspondiera al esperado.

Resultado obtenido:
| ID | Cliente | Correo |
|---|---|---|
| 8 | Jorge Díaz | `sin-correo` |

El valor no contiene la estructura mínima de una dirección de correo electrónico.

### 3.4 Edades fuera del rango permitido

Se buscaron edades menores de 18 o mayores de 120 años.

Resultado obtenido:
| ID | Cliente | Edad |
|---|---|---|
| 8 | Jorge Díaz | -3 |

La edad registrada es negativa y se encuentra fuera del rango definido para la práctica.

### 3.5 Completitud de información

Se calcularon los registros totales y los valores ausentes en teléfono y RFC.

Resultado obtenido:
| Indicador | Resultado |
|---|---:|
| Total de clientes | 7 |
| Clientes sin teléfono (`NULL`) | 0 |
| Clientes sin RFC (`NULL`) | 1 |

Aunque ningún cliente tiene el teléfono en `NULL`, esto no significa que todos los teléfonos sean correctos.

El registro de prueba de Jorge Díaz contiene el teléfono `667`, que requiere una verificación adicional de formato.

## 4. Tabla de hallazgos

| ID | Hallazgo | Registros | Regla de calidad | ¿Quién decide la corrección? | Acción propuesta |
|---|---|---|---|---|---|
| C1 | Posible cliente duplicado | 1, 7 | Unicidad del correo | Gerencia Comercial | Revisar si corresponden a una misma persona antes de fusionar o corregir registros |
| C2 | RFC incompleto | 7 | Formato del RFC | Gerencia Comercial | Solicitar documentación válida y autorizar la actualización |
| C3 | Correo con formato inválido | 8 | Formato del correo | Gerencia Comercial | Solicitar el correo correcto y validar su formato |
| C4 | Edad fuera de rango | 8 | Edad válida de 18 a 120 años | Gerencia Comercial | Confirmar el dato correcto antes de modificarlo |
| C5 | RFC ausente | 8 | Completitud del RFC | Gerencia Comercial | Determinar si el RFC es obligatorio para este cliente y solicitarlo cuando corresponda |

Los hallazgos C1 a C5 se sustentan en las consultas SQL ejecutadas.

Adicionalmente, los valores de prueba del teléfono `667` y del código postal `8000` requieren validaciones de longitud y formato, que todavía no se han documentado mediante consultas específicas.

## 5. Responsabilidad de las correcciones

El DBA actúa como custodio técnico y es responsable de detectar problemas, proteger la información y ejecutar los cambios autorizados.

El procedimiento propuesto es:

1. Registrar el hallazgo e identificar el cliente afectado.
2. Notificar a Gerencia Comercial.
3. Solicitar la verificación del dato correcto.
4. Obtener autorización de la corrección.
5. Aplicar el cambio y conservar su evidencia de auditoría.

Durante esta actividad no se corrigieron ni eliminaron registros.

## 6. Preguntas de reflexión

### 1. ¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 7?

Porque el DBA es responsable de administrar y proteger técnicamente la base de datos, pero no es quien determina el valor correcto de los datos de negocio.

En el registro 7, el RFC está incompleto. Aunque podemos identificar el problema mediante una consulta SQL, no podemos deducir los caracteres faltantes de forma confiable.

La Gerencia Comercial debe solicitar la información correspondiente, verificarla y autorizar la corrección.

Modificar el RFC sin autorización podría generar errores de facturación o introducir información falsa.

### 2. ¿Qué restricción (`CHECK`, `UNIQUE`) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?

Las siguientes restricciones podrían prevenir o reducir los problemas detectados:

| Hallazgo | Restricción propuesta |
|---|---|
| Correo duplicado | Índice único sobre `lower(correo)` para impedir duplicados sin distinguir mayúsculas y minúsculas |
| RFC incompleto | `CHECK` que valide el formato mediante una expresión regular |
| Correo inválido | `CHECK` para validar el formato del correo |
| Edad fuera de rango | `CHECK (edad BETWEEN 18 AND 120)` |
| RFC ausente | `NOT NULL` si el negocio determina que el RFC es obligatorio |

Un `UNIQUE` convencional sobre `correo` no necesariamente detectaría duplicados que difieren únicamente por mayúsculas y minúsculas; por ello se propone un índice único sobre la expresión `lower(correo)`.

Asimismo, `CHECK` no impide por sí solo los valores `NULL`. Para exigir un RFC se necesitaría una restricción adicional `NOT NULL`, siempre que esa obligación sea aprobada por el propietario del dato.

La Gerencia Comercial debe aprobar las reglas de negocio. El DBA debe evaluar su viabilidad, revisar los registros existentes y aplicar las restricciones mediante un cambio autorizado.

### 3. Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará evidencia del cambio?

El mecanismo es el disparador de auditoría implementado en el Laboratorio 01, que registra modificaciones sobre la tabla `clientes` en `auditoria.cambios_clientes`.

Este mecanismo permite conservar información de los cambios realizados, incluyendo los valores anteriores y posteriores según la configuración del disparador.

Adicionalmente, `log_statement = 'mod'` permite registrar las sentencias de modificación ejecutadas.

De esta manera, una corrección autorizada puede contar con evidencia técnica para comprobar qué se cambió y facilitar su revisión posterior.

## 7. Conclusión

La Actividad 1 permitió comprobar que la base de datos `comercial` contiene problemas de calidad relacionados con unicidad, formato, validez y completitud.

Se detectaron correos potencialmente duplicados, RFC inválidos o ausentes, un correo con formato incorrecto y una edad negativa.

También se identificó que una comprobación de valores `NULL` no es suficiente para garantizar la calidad de todos los datos, ya que un valor presente puede ser incorrecto.

El principal aprendizaje es que detectar un error no autoriza automáticamente al DBA a modificarlo. La Gerencia Comercial debe determinar el valor correcto y aprobar la corrección, mientras que el DBA debe garantizar su ejecución controlada y trazabilidad.

Los registros incorrectos permanecieron sin cambios, para incorporarlos como hallazgos del expediente de auditoría interna.

## 8. Archivo SQL relacionado

`sql/01-verificaciones-calidad.sql`
