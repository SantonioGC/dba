# Informe 

## 1. Despliegue, edición y limitación

MongoDB Community 6.0.27 nativo en Fedora, con autorización habilitada. La edición se verificó con db.adminCommand({ buildInfo: 1 }).modules, que devolvió vacío. La auditoría nativa solo existe en Enterprise y Atlas, así que no está disponible.

## 2. Perfilador

Se activó en la base comercial. Con nivel 2 registró la consulta, la actualización y la eliminación de app_ventas con usuario, cliente, aplicación y momento. No guarda el valor anterior ni el contenido eliminado. Con un filtro (insert, update, remove) se redujo el volumen, a cambio de no registrar lecturas. Costo: desempeño y espacio, y el riesgo de guardar datos personales en system.profile (colección limitada a 1 MB).

## 3. Bitácora de mongod

Se escribe en /var/log/mongodb/mongod.log. Registra accesos exitosos y fallidos (Authentication succeeded y Authentication failed) y el cambio de configuración del perfilador (Profiler settings changed). El evento de configuración no trae el usuario: se atribuyó a admin correlacionando el ctx (conn41) con su autenticación.

## 4. Privilegios

Ni system.profile ni la bitácora registraron grantRolesToUser. Como control compensatorio se tomaron instantáneas de privilegios: detectan que app_ventas ganó el rol dbAdmin, pero no dicen quién lo agregó ni la hora exacta, solo que ocurrió entre dos instantáneas. No equivale a auditoría.

## 5. Conservación

La evidencia puede perderse sin que alguien la borre: system.profile se sobrescribe al llenarse, el reinicio vacía la memoria de getLog (de 318 a 51 eventos) y regresa el perfilador al nivel 0. Se exportaron system-profile.json, bitacora-mongod.log y mongod-archivo.log antes del reinicio, con su hash SHA-256 en hashes.sha256 (sin contraseñas).

## 6. Comparación

PostgreSQL con disparador conserva el valor anterior y registra privilegios con log_statement = ddl. MongoDB Community cubre accesos y modificaciones con el perfilador, pero no atribuye cambios de privilegios ni guarda el valor anterior. La auditoría nativa de Enterprise y Atlas está documentada pero no se practicó (evidencia 09).

## 7. Recomendación

Para una organización que necesite auditar cambios de privilegios en MongoDB, recomendaría evaluar MongoDB Enterprise o Atlas (clústeres M10 o superiores), porque es la única opción que registra el evento de forma nativa. Mientras tanto, mantener las instantáneas de privilegios, exportar y proteger system.profile y la bitácora con su hash, y limitar quién puede escribir en la colección de instantáneas.

Hechos verificados: en Community 6.0.27 el cambio de privilegios no aparece en system.profile ni en la bitácora; las instantáneas detectan el cambio sin atribuirlo.
Supuestos: que la auditoría nativa de Enterprise y Atlas cubre ese evento, según REF-U3-04 (documentado, no practicado); que las instantáneas se tomarían con la frecuencia adecuada.

## Reflexión

¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?

Fue diseñado para analizar desempeño. Se apaga al reiniciar, se sobrescribe, no registra cambios de privilegios ni valores anteriores, y quien administra la base puede cambiarlo.

¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?

Porque registra usuario, cliente, aplicación, momento y la operación completa, lo que permite atribuir lecturas y modificaciones.

¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?

Convierte system.profile en un nuevo depósito de datos sensibles (por ejemplo, el RFC en texto claro), accesible a quien pueda leer esa colección.

¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?

Detectar es saber que algo cambió (las instantáneas). Atribuir es saber quién, cuándo y desde dónde.

¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?

Porque evita dar a Dirección una falsa seguridad, permite decidir entre licenciar o compensar, y evita presentar controles que no son equivalentes.
