# 14 Evaluación integral

## Objetivo
Identificar los riesgos de privacidad y gobierno en una base con 50,000 clientes y proponer controles.

## Procedimiento
Se revisó cada situación del escenario, se asoció al principio de privacidad afectado, se describió el riesgo y se propuso un control.

## Resultado

| # | Problema | Principio afectado | Riesgo | Control propuesto |
|---|---|---|---|---|
| 1 | Analítica consulta directamente la tabla clientes | Mínimo privilegio, minimización | Acceso a datos que no necesita | Rol analista con acceso solo a una vista agregada |
| 2 | Analítica puede ver nombre, correo, teléfono y RFC | Necesidad, proporcionalidad | Exposición de datos identificables y sensibles | Retirar permisos sobre la tabla y entregar datos generalizados |
| 3 | Analítica solo genera estadísticas mensuales | Limitación de finalidad | Uso de datos individuales sin necesidad | Entregar solo datos agregados |
| 4 | Datos conservados desde hace 12 años | Retención, minimización | Más datos expuestos y sin finalidad vigente | Definir plazos y eliminar o anonimizar lo vencido |
| 5 | No existe política de retención documentada | Gobierno de datos | Conservación indefinida | Política de retención aprobada |
| 6 | Desarrolladores reciben copias completas de la base | Mínimo privilegio | Fuga de información personal | Entregar datos de prueba, no copias productivas |
| 7 | Las copias de desarrollo contienen datos reales | Minimización, seguridad | Datos expuestos en entornos con menos controles | Enmascarar o generar datos sintéticos |
| 8 | Marketing usa correos para campañas | Limitación de finalidad, consentimiento | Uso no informado o sin base jurídica | Validar aviso de privacidad y consentimiento; excluir a quienes se opongan |
| 9 | No hay documentación de la finalidad de cada dato | Transparencia, gobierno | No se puede justificar el tratamiento | Catálogo de datos con finalidad por campo |
| 10 | No hay propietarios ni custodios definidos | Rendición de cuentas | Nadie decide ni responde por los datos | Asignar propietario y custodio por dato |
| 11 | No hay registros de auditoría de consultas | Trazabilidad | No se detecta mal uso ni se puede investigar | Auditoría de accesos y cambios |
| 12 | Falta procedimiento para atender solicitudes ARCO | Derechos del titular | Incumplir plazos o responder incompleto | Procedimiento y consultas para localizar datos por titular |
| 13 | RFC almacenado junto con datos de uso general | Protección de datos sensibles | Mayor impacto ante una filtración | Separar RFC y restringirlo a facturación, con cifrado |

## Análisis
La mayoría de los problemas no son de configuración técnica, sino de falta de finalidad definida, gobierno y límites de acceso. Un mismo riesgo suele afectar a más de un principio.

## Conclusión
Los riesgos se reducen combinando controles técnicos (roles, vistas, enmascarado, cifrado, auditoría) con controles administrativos (políticas de retención, responsables, procedimientos ARCO).
