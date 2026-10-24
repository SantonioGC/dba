# 11 Matriz de gobierno de datos

## Objetivo
Relacionar cada dato con su finalidad, responsable, usuarios autorizados, protección, retención y acción al finalizar, para demostrar que el acceso debe responder a una necesidad funcional.

## Procedimiento
Se asignó a cada campo un propietario según el área que lo necesita y se definieron los roles con acceso. El DBA actúa como custodio técnico, no como propietario de los datos. Además se clasificaron las medidas de la actividad 13 en técnicas y administrativas.

## Resultado

| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
|---|---|---|---|---|---|---|
| nombre | Atención y facturación | Atención al cliente | Atención al cliente, Facturación | Roles + vistas | Relación comercial + plazo legal | Eliminar o anonimizar |
| correo | Contacto y envío de facturas | Atención al cliente | Atención al cliente, Facturación | Roles + vistas | Relación comercial | Eliminar |
| telefono | Contacto de soporte | Atención al cliente | Atención al cliente | Roles + vistas | Relación comercial | Eliminar |
| rfc | Facturación | Facturación | Facturación | Roles + cifrado | Plazo fiscal aplicable | Eliminar al vencer el plazo |
| edad | Estadística | Analítica | Analítica (solo rangos) | Vista con rangos | Solo en forma agregada | Eliminar el dato individual |
| ciudad | Estadística y envío | Analítica | Analítica, Atención al cliente | Vista | Relación comercial | Eliminar o agregar |
| codigo_postal | Región para estadística | Analítica | Analítica (2 dígitos) | Vista con dato generalizado | Solo en forma agregada | Eliminar el dato completo |

### Roles

| Rol | Responsabilidad |
|---|---|
| Atención al cliente | Usa nombre, correo y teléfono |
| Facturación | Usa nombre, RFC y correo |
| Analítica | Usa solo datos agregados o generalizados |
| DBA | Custodio técnico: implementa permisos, respaldos y eliminación; no decide finalidades |
| Dirección | Aprueba la política y designa a los propietarios |

### Actividad 13 — Controles técnicos y administrativos

| Medida | Técnico | Administrativo |
|---|---|---|
| Crear roles de PostgreSQL | X | |
| Política de retención | | X |
| Cifrado de datos | X | |
| Procedimiento para solicitudes ARCO | | X |
| Vista con información limitada | X | |
| Clasificación de información | | X |
| Registro de auditoría | X | |
| Política de control de acceso | | X |

Medidas que involucran ambos tipos:
- Política de retención: la política es administrativa, pero se ejecuta con tareas técnicas de eliminación o anonimización.
- Clasificación de información: es administrativa, pero se apoya en etiquetas o esquemas técnicos.
- Registro de auditoría: es técnico, pero requiere un procedimiento administrativo para revisarlo.
- Política de control de acceso: es administrativa, pero se implementa con roles y permisos.

## Análisis
Cada dato tiene un responsable y solo lo ven los roles que lo necesitan. El RFC es visible solo para facturación y analítica no ve datos individuales. No se asignan todos los roles a todos los datos. Los controles técnicos solo son efectivos si están respaldados por políticas y procedimientos.

## Conclusión
El acceso se justifica por función y finalidad. Una matriz de gobierno permite demostrar quién usa cada dato, para qué y por cuánto tiempo.
