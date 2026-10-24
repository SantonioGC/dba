# LAB-03 Privacidad, cumplimiento y gobierno de los datos

## 1. Introducción
Una base de datos puede estar bien configurada y aun así tener problemas de privacidad: datos innecesarios, usos distintos a la finalidad informada, accesos amplios o conservación indefinida. En este laboratorio se aplican principios de privacidad (finalidad, minimización, retención, derechos ARCO y gobierno) a la tabla clientes de una empresa ficticia.

## 2. Inventario de datos
Todos los campos de clientes son datos personales. El RFC es el más sensible y solo se justifica para facturación. Edad y código postal solo son necesarios para analítica en forma generalizada. Detalle en evidencias/01-inventario-datos.md.

## 3. Finalidades

| Proceso | Datos necesarios |
|---|---|
| Atención al cliente | nombre, correo, teléfono |
| Facturación | nombre, correo, RFC |
| Analítica | ciudad, rango de edad, región de código postal (agregados) |

## 4. Minimización

Qué datos se eliminan o limitan y por qué:

| Dato | Decisión | Por qué |
|---|---|---|
| rfc | Se elimina de lo que ve soporte y analítica | Solo facturación lo necesita |
| edad | Se limita a rangos para analítica | No se necesita la edad exacta |
| codigo_postal | Se limita a región para analítica; se elimina para soporte | La región basta para estadística |
| nombre, correo, telefono | Se eliminan de lo que ve analítica | Analítica no identifica personas |
| salario, estado civil, ocupación | No se recopilan en nuevas tablas | No tienen finalidad |

Soporte usa la tabla clientes_soporte con 4 campos (sql/01-minimizacion.sql). Analítica recibe datos agregados (sql/02-finalidad.sql).

### Actividad 2 — Preguntas
¿Todos los campos son necesarios para atención al cliente?
No. Solo id, nombre, correo y teléfono.

¿Por qué soporte necesitaría conocer el RFC?
No lo necesita. El RFC solo se justifica para facturación.

¿Necesita conocer la edad?
No. No interviene en la atención al cliente.

¿Necesita conocer el código postal?
No. No es necesario para contactar al cliente.

¿Qué principio de privacidad está relacionado con esta decisión?
Minimización de datos.

### Actividad 3 — Pregunta
¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?
Porque son datos agregados que no identifican a nadie. Analítica solo necesita estadísticas, y la tabla completa expondría nombre, correo, teléfono y RFC sin necesidad.

## 5. Control de acceso

Los permisos se relacionan con las funciones así:

| Rol | Función | Acceso |
|---|---|---|
| analista | Estadísticas mensuales | Solo SELECT sobre v_analitica_clientes |
| Soporte | Atención al cliente | Solo clientes_soporte |
| Facturación | Facturar | Solo los datos fiscales necesarios |
| DBA | Administrar la base | Acceso técnico, sin usar los datos para otras finalidades |

El rol analista (NOLOGIN) no tiene permisos sobre clientes, por lo que no puede obtener nombre, correo ni RFC. La prueba con SET ROLE analista confirma el error permission denied. Ver sql/03-control-acceso.sql.

### Actividad 4 — Preguntas
¿Qué información puede consultar el rol?
Solo la vista v_analitica_clientes: ciudad, región de código postal y rango de edad.

¿Puede consultar directamente clientes?
No. PostgreSQL responde permission denied.

¿Puede obtener nombre, correo y RFC?
No. No están en la vista y el rol no tiene permisos sobre la tabla.

¿Qué principio de privacidad estás aplicando?
Minimización y limitación de finalidad.

¿Qué principio de seguridad estás aplicando?
Mínimo privilegio.

## 6. Derechos ARCO

| Derecho | Implicación técnica |
|---|---|
| Acceso | Consulta que localice todos los datos del titular, y buscarlos también en copias y otros sistemas |
| Rectificación | UPDATE solo del campo incorrecto, con registro de quién, cuándo y qué cambió |
| Cancelación | No hacer DELETE directo: revisar tablas relacionadas, respaldos, réplicas, auditoría, exportaciones y sistemas externos |
| Oposición | No implica borrar todo; se deja de usar el dato para esa finalidad, por ejemplo con una tabla de oposiciones |

La decisión final de cada solicitud no corresponde únicamente al DBA.

### Actividad 6 — Derecho de acceso
Consulta para localizar la información del titular:

    SELECT id, nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta
    FROM clientes
    WHERE correo = 'ana@example.com';

¿Qué información adicional debería proporcionar la organización además del resultado de esta consulta?
Para qué se usan los datos, de dónde se obtuvieron, con quién se comparten, cuánto tiempo se conservan, cómo ejercer los demás derechos y el aviso de privacidad.

Implicaciones técnicas: verificar la identidad del titular, buscar sus datos en todas las tablas y copias, entregar la información de forma segura y registrar la solicitud.

### Actividad 7 — Derecho de rectificación
Actualización y verificación:

    UPDATE clientes
    SET correo = 'nuevo-correo@example.com'
    WHERE id = 1;

    SELECT id, nombre, correo
    FROM clientes
    WHERE id = 1;

¿Cómo podría comprobarse que el cambio fue autorizado?
Con una solicitud documentada, verificación de identidad del titular y aprobación del responsable, por ejemplo un ticket asociado al cambio.

¿Debería registrarse quién realizó el cambio?
Sí, junto con la fecha, el valor anterior y el nuevo.

¿Por qué la trazabilidad será importante?
Permite demostrar que el cambio fue autorizado, investigar cambios indebidos y cumplir con auditorías.

### Actividad 9 — Derecho de oposición
¿Es necesario eliminar inmediatamente todos sus datos de la base?
No. La oposición se refiere a una finalidad, no a borrar todo.

Qué información podría necesitar mantenerse:
Los datos necesarios para la relación comercial, la facturación y las obligaciones legales.

Qué información podría dejar de utilizarse para determinada finalidad:
Correo, edad y ciudad para promociones.

Qué mecanismos técnicos podrían separar finalidades:
Tabla de oposiciones, vistas por finalidad que excluyan a esos clientes y roles separados.

Por qué la decisión final no debe ser tomada únicamente por el DBA:
Porque qué procede y qué debe conservarse es una decisión jurídica y de privacidad. El DBA solo implementa la medida técnica.

## 7. Retención
El periodo se define por dato según su finalidad, las obligaciones legales y cuándo deja de ser útil, con una acción al terminar (eliminar o anonimizar) y un responsable que lo aprueba. Conservar todo indefinidamente no es compatible con la minimización. Ver evidencias/10-retencion.md.

## 8. Gobierno de datos
Cada dato tiene un responsable y usuarios autorizados por función. El DBA es custodio técnico y no decide finalidades. Ver la matriz en evidencias/11-gobierno-datos.md.

## 9. Evaluación integral
Se identificaron 13 riesgos. Los principales: analítica con acceso directo a clientes, datos reales en copias de desarrollo, 12 años de datos sin política de retención, uso de correos para marketing sin finalidad documentada y falta de responsables y auditoría. Ver evidencias/14-evaluacion-integral.md y la propuesta en evidencias/15-arquitectura.md.

## 10. Conclusiones
La seguridad protege los datos de accesos no autorizados; la privacidad decide si los datos deben recopilarse, para qué se usan y cuánto tiempo se conservan. Una base técnicamente segura puede incumplir la privacidad. El DBA implementa controles técnicos, pero las decisiones de finalidad, base jurídica y plazos corresponden a privacidad, jurídico y los propietarios de los datos.

## Verificación final

Privacidad: ¿Qué diferencia existe entre seguridad de la información y privacidad?
La seguridad protege los datos de accesos no autorizados. La privacidad decide si se deben recopilar, para qué se usan y cuánto tiempo se conservan.

Finalidad: ¿Por qué una organización no debería utilizar automáticamente todos los datos que posee para cualquier propósito?
Porque los datos se recopilaron para fines informados. Un uso nuevo necesita ser compatible o tener base jurídica o consentimiento.

Minimización: ¿Por qué almacenar más información no necesariamente es mejor?
Porque más datos significan más riesgo, más costo y más obligaciones sin un beneficio claro.

ARCO: ¿Qué implicaciones técnicas tienen los derechos de acceso, rectificación, cancelación y oposición?
Acceso: localizar los datos en todas las copias. Rectificación: actualizar con registro del cambio. Cancelación: revisar respaldos, réplicas y exportaciones. Oposición: separar finalidades sin borrar todo.

Retención: ¿Por qué la conservación indefinida puede representar un riesgo?
Porque deja más datos expuestos, sin finalidad y con posible incumplimiento.

Gobierno: ¿Quién debería decidir qué datos pueden utilizarse y para qué finalidad?
El propietario de los datos, con apoyo de privacidad y jurídico. No el DBA por sí solo.

DBA: ¿Cuál es la responsabilidad del DBA y cuáles decisiones deben involucrar a otras áreas?
El DBA implementa y mantiene los controles técnicos. Las finalidades, plazos y decisiones legales las toman privacidad, jurídico y los propietarios de los datos.

## Preguntas de reflexión

1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?
No. Puede estar bien protegida y aun así guardar datos innecesarios, usarlos para otra finalidad o conservarlos de más.

2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?
Porque cada usuario ve solo los datos que necesita, lo que reduce la exposición y los usos indebidos.

3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?
Porque la finalidad es una decisión de negocio y jurídica. El DBA tiene acceso técnico, pero no esa responsabilidad.

4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?
No necesitan datos reales para desarrollar y recibirlos expone información personal sin justificación.

5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?
Tiene datos reales pero menos controles, más usuarios con acceso y menos auditoría que producción.

6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?
Porque los datos deben tener un final definido, como eliminarse o anonimizarse, cuando ya no se necesitan.

7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?
En el diseño se decide qué campos existen, quién los ve y cuánto se conservan. Con privacidad por diseño la base nace con lo mínimo necesario.

8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?
Roles por función, vistas con datos limitados, enmascarado, cifrado de datos sensibles, auditoría y datos sintéticos en desarrollo.

9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?
En qué tablas, respaldos, réplicas, reportes y sistemas externos está el dato del titular y cómo identificarlo.

10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?

| Rol | Responsabilidad |
|---|---|
| DBA | Implementar y mantener los controles técnicos |
| Responsable de privacidad | Coordinar avisos, solicitudes ARCO y cumplimiento |
| Área jurídica | Definir obligaciones legales y plazos |
| Propietario de los datos | Decidir finalidad, uso y quién accede |
