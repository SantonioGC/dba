# LAB-03 — Políticas prácticas, gobierno de datos y evidencias

## Objetivo

Integrar evidencias técnicas de auditoría con mecanismos de gobierno de datos, conservación, control de cambios y políticas de seguridad para construir un expediente de auditoría interna.

## Documento principal

[EXPEDIENTE.md](EXPEDIENTE.md)

El expediente contiene diez apartados:

1. Alcance
2. Configuración de auditoría
3. Bitácora interpretada
4. Elementos de gobierno
5. Conservación
6. Políticas
7. Conciliación de cambios
8. Hallazgos
9. Limitaciones y riesgos
10. Índice de evidencias

## Scripts SQL

| Archivo | Descripción |
|---|---|
| [01-verificaciones-calidad.sql](sql/01-verificaciones-calidad.sql) | Verificaciones de calidad de datos |
| [02-comentarios-diccionario.sql](sql/02-comentarios-diccionario.sql) | Documentación del diccionario |
| [03-inventario-tablas.sql](sql/03-inventario-tablas.sql) | Inventario de objetos |
| [04-registro-cambios.sql](sql/04-registro-cambios.sql) | Registro y conciliación de cambios |

Los scripts documentan actividades realizadas. No deben ejecutarse indiscriminadamente sobre una base de datos existente.

## Políticas

- [POL-01 — Acceso](politicas/POL-01-acceso.md)
- [POL-02 — Respaldo](politicas/POL-02-respaldo.md)
- [POL-03 — Retención](politicas/POL-03-retencion.md)
- [POL-04 — Restauración](politicas/POL-04-restauracion.md)
- [POL-05 — Datos sensibles](politicas/POL-05-datos-sensibles.md)
- [POL-06 — Cambios en producción](politicas/POL-06-cambios-produccion.md)

## Evidencias de gobierno

- [Calidad de datos](evidencias/01-calidad.md)
- [Matriz de responsables](evidencias/02-responsables.md)
- [Diccionario](evidencias/03-diccionario.md)
- [Catálogo](evidencias/04-catalogo.md)
- [Conservación](evidencias/05-conservacion.md)
- [Conciliación](evidencias/06-conciliacion.md)
- [Reflexión técnica](evidencias/07-reflexion-evidencias.md)
- [Diccionario exportado](evidencias/diccionario-clientes.csv)

## Evidencias técnicas E1–E6

| Evidencia | Descripción |
|---|---|
| [E1](evidencias/E1-configuracion-registro.txt) | Configuración de registro |
| [E2](evidencias/E2-privilegios.txt) | Privilegios de usuarios |
| [E3](evidencias/E3-disparadores.txt) | Estado del disparador |
| [E4](evidencias/E4-muestra-auditoria.txt) | Muestra de auditoría |
| [E5](evidencias/E5-bitacora-postgresql.log) | Bitácora PostgreSQL redactada |
| [E6](evidencias/E6-mongodb/) | Evidencias MongoDB redactadas y comparación |

## Integridad de archivos

- [SHA-256 de E5](evidencias/E5-bitacora-postgresql.sha256)
- [SHA-256 de E6](evidencias/E6-mongodb/hashes.sha256)

Estos hashes corresponden a las copias redactadas incluidas en este repositorio.

## Observaciones

El expediente documenta las verificaciones realizadas y reconoce las limitaciones históricas de registro y auditoría.

Los resultados pertenecen a un entorno académico y no representan una certificación de seguridad de un sistema de producción.