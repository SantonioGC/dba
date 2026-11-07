# Comparación de los tres escenarios

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
|---|---|---|---|
| Acceso exitoso | Sí (log_connections) | Sí (Authentication succeeded, con ctx y dirección) | Documentado, no practicado |
| Acceso fallido | Sí (FATAL con usuario e IP) | Sí (Authentication failed con el error) | Documentado, no practicado |
| Cambio de privilegios | Sí (GRANT y REVOKE con log_statement = ddl) | Parcial: solo las instantáneas detectan el cambio; no dicen quién ni cuándo | Documentado, no practicado |
| Cambio de estructura | Sí (ALTER TABLE con ddl) | No observado: el perfilador no registró el comando de privilegios, así que no se debe asumir que registra DDL | Documentado, no practicado |
| Modificación de datos | Sí (log_statement = mod y disparador) | Sí (perfilador: usuario, cliente, aplicación y momento) | Documentado, no practicado |
| Valor anterior del dato | Sí (disparador, JSONB) | No (el update solo trae $set con el valor nuevo) | No figura entre los eventos de REF-U3-04 |
| Lectura de datos sensibles | Parcial: solo con log_statement = all; pgaudit no se practicó | Parcial: el nivel 2 registra la consulta y su filtro, con costo de desempeño | Documentado, no practicado (CRUD con auditAuthorizationSuccess: true) |
| Cambio de configuración del registro | Sí (parameter changed) | Sí (Profiler settings changed, atribuible por ctx) | No verificado en la documentación revisada |

## Interpretación

PostgreSQL con disparador es el único que conserva el valor anterior. MongoDB Community cubre accesos y modificaciones con el perfilador, pero no atribuye los cambios de privilegios. La auditoría nativa existe solo en Enterprise y Atlas.
