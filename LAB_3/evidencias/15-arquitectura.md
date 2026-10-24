# 15 Propuesta de arquitectura de datos protegidos

## Objetivo
Diseñar una propuesta conceptual que separe la información según su finalidad y traduzca los principios de privacidad en decisiones técnicas.

## Procedimiento
Se definieron tres zonas (operación, analítica y auditoría), qué datos contiene cada una y los controles aplicables a acceso, minimización, información sensible, retención, trazabilidad, eliminación y atención de solicitudes.

## Resultado

                           BASE DE DATOS
                                 │
              ┌──────────────────┼──────────────────┐
              ▼                  ▼                  ▼
          Operación           Analítica          Auditoría
              │                  │                  │
              ▼                  ▼                  ▼
      Datos necesarios      Datos agregados      Registro de
      por área:             y generalizados:     accesos y cambios
      - Soporte: nombre,    - ciudad
        correo, teléfono    - rango de edad
      - Facturación:        - región de CP
        nombre, RFC

| Control | Decisión técnica |
|---|---|
| Acceso | Un rol por área (soporte, facturación, analista, marketing); ninguno accede a la tabla clientes completa sin necesidad |
| Minimización | Tablas o vistas por área con solo los campos necesarios (clientes_soporte, v_analitica_clientes) |
| Información sensible | RFC separado, visible solo para facturación y cifrado |
| Retención | Plazo por dato; anonimización o eliminación programada al vencer |
| Trazabilidad | Registro de auditoría de consultas y cambios (quién, cuándo, qué) |
| Eliminación | Inventario de copias (respaldos, réplicas, exportaciones, sistemas externos) y procedimiento para cada una |
| Atención de solicitudes ARCO | Consulta para localizar datos por titular, tabla de oposiciones y procedimiento con responsable asignado |
| Desarrollo y pruebas | Datos enmascarados o sintéticos; nunca copias productivas |

## Análisis
Cada zona recibe únicamente lo que necesita para su finalidad. La separación evita que un mismo usuario tenga acceso a datos que no requiere y facilita la retención, la eliminación y la atención de derechos ARCO. No es necesario implementar físicamente toda la arquitectura para demostrar la decisión.

## Conclusión
Los principios de privacidad se traducen en decisiones concretas de diseño, permisos y procesos. El DBA implementa los controles técnicos, mientras que finalidades, plazos y obligaciones legales los definen otras áreas.
