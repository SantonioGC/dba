# 08 — Ciclo de vida y derecho de cancelación

## Objetivo
Entender por qué eliminar un registro de la tabla clientes no significa que la información de esa persona haya desaparecido de la organización.

# 08 — Ciclo de vida y derecho de cancelación

## Objetivo
Entender por qué eliminar un registro de la tabla clientes no significa que la información de esa persona haya desaparecido de la organización.

## Procedimiento
Ante una solicitud de cancelación autorizada, no se ejecutó un DELETE sobre la tabla principal. Primero se analizaron las siguientes preguntas y se construyó un mapa.

## Resultado

### Análisis previo

| Pregunta | Respuesta |
|---|---|
| ¿Existen otras tablas relacionadas? | Sí, por ejemplo pedidos, facturas y tickets de soporte. Hay que revisar llaves foráneas y obligaciones legales |
| ¿Existen respaldos? | Sí. Conservan el dato hasta que expiran o se renuevan |
| ¿Existen réplicas? | Sí. El cambio se propaga con retraso y hay que verificarlo |
| ¿Existen registros de auditoría? | Sí. Puede ser necesario conservarlos por trazabilidad |
| ¿Existen copias utilizadas para analítica? | Sí. Deben eliminarse o confirmarse como ya agregadas |
| ¿Existen archivos exportados? | Sí. CSV, Excel o PDF fuera del control de la base |
| ¿Existen sistemas externos? | Sí. Correo masivo, facturación o proveedores con su propia copia |

### Mapa

    clientes
       │
       ├── tablas relacionadas (pedidos, facturas, tickets de soporte)
       ├── respaldos
       ├── réplicas
       ├── registros de auditoría
       ├── reportes (analítica)
       ├── exportaciones (CSV, Excel, PDF)
       ├── copias de desarrollo y pruebas
       └── sistemas externos

### ¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?
Porque el DELETE solo elimina la fila de una tabla. Los respaldos conservan el dato hasta que expiran, las réplicas pueden tardar en reflejar el cambio, las exportaciones y copias de desarrollo están fuera del control de la base, y los terceros mantienen su propia copia. Además, algunos datos pueden tener que conservarse por una obligación legal (por ejemplo fiscal), por lo que no siempre procede eliminarlos. Esa decisión no le corresponde al DBA.

## Análisis
Cancelar los datos de una persona es un proceso que involucra inventario de copias, plazos y varias áreas, no una sola instrucción SQL.

## Conclusión
El ciclo de vida de los datos debe estar documentado antes de recibir solicitudes de cancelación, para saber dónde buscar y qué decisiones escalar.
