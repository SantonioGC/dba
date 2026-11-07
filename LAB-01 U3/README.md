# Bitácoras y auditoría del dato en PostgreSQL
## Despliegue

- PostgreSQL 16 instalado de forma nativa en Fedora, con paquetes de la distribución.
- Versión: PostgreSQL 18.6 on x86_64-redhat-linux-gnu, compiled by gcc (GCC) 15.3.1 20260722 (Red Hat 15.3.1-1), 64-bit
- Servicio: sudo systemctl restart postgresql
- Sesión de administrador: psql con sudo -u postgres, y pgAdmin 4 local.
- Sesiones de aplicación: psql desde la terminal hacia 127.0.0.1, puerto 5432.
- Bitácora: logging_collector activado; archivos por día en el directorio log del servidor (postgresql-Fri.log, postgresql-Sat.log). El servidor registra en español.

## Contenido

- sql/: 01 a 06, scripts de las actividades 2, 4, 6, 10, 11 y 12
- evidencias/: 01 a 15, 16-pgaudit (Parte C), bitacora-lab01.log y bitacora-lab01.sha256
- informe.md

## Notas

- La bitácora exportada cubre los dos días de trabajo (viernes y sábado). La contraseña de rol_temporal se sustituyó por <REDACTED> antes de salir del servidor.
- El hash SHA-256 permite comprobar que bitacora-lab01.log no cambió después de exportarse.
- Las contraseñas de las evidencias y de los scripts sql aparecen como <REDACTED>.
- No se subió ningún volcado completo de la tabla de auditoría; solo las filas necesarias en cada evidencia.
