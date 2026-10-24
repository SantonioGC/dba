# 01 Inventario y finalidad de los datos

## Objetivo
Identificar qué datos personales almacena la tabla clientes, para qué se usa cada uno, si es necesario, quién debe acceder y cuánto tiempo conservarlo.

## Procedimiento
1. Se listaron los 9 campos de clientes.
2. Se revisaron los tres procesos de la organización: atención al cliente, facturación y analítica.
3. Para cada campo se evaluó: si es dato personal, su finalidad, su necesidad, el nivel de acceso y la retención.
4. Se justificó cada decisión.

## Resultado

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
|---|---|---|---|---|---|
| id | Indirecto: identifica un registro ligado a una persona | Llave técnica y relación entre tablas | Sí | Soporte, facturación, DBA | Mientras exista el registro del cliente |
| nombre | Sí | Atención al cliente y facturación | Sí | Soporte, facturación | Relación comercial + plazo legal aplicable |
| correo | Sí | Contacto de soporte y envío de facturas | Sí | Soporte, facturación | Relación comercial |
| telefono | Sí | Contacto de soporte | Sí para soporte; puede ser opcional | Solo soporte | Relación comercial |
| rfc | Sí, identifica fiscalmente a la persona | Facturación | Solo para facturación | Solo facturación | Plazo fiscal aplicable (a validar con jurídico) |
| edad | Sí | Estadística de analítica | No de forma individual; sí como rango | Analítica, solo como rango | Solo en forma agregada |
| ciudad | Sí, identifica combinada con otros datos | Estadística y envío | Sí, riesgo bajo | Analítica, soporte | Relación comercial |
| codigo_postal | Sí, identifica combinada con otros datos | Región para estadística | Solo como región (2 primeros dígitos) | Analítica, solo generalizado | Solo en forma agregada |
| fecha_alta | Sí, está asociada a la persona | Antigüedad del cliente | Sí | Soporte, analítica | Relación comercial |

### Justificación de las decisiones
- id: no es un dato de contacto, pero permite ubicar a la persona en cualquier tabla relacionada, por eso se trata como dato personal indirecto.
- nombre, correo, telefono: identifican directamente a la persona. Soporte los necesita para contactarla; analítica no.
- rfc: es el dato más sensible del conjunto. Solo facturación tiene una finalidad que lo justifique. Soporte y analítica no lo necesitan.
- edad: analítica necesita distribuciones, no la edad exacta de cada persona. Se generaliza en rangos.
- ciudad y codigo_postal: por sí solos son de bajo riesgo, pero combinados con edad pueden identificar a alguien en poblaciones pequeñas. El código postal se generaliza a región.
- fecha_alta: sirve para medir antigüedad y no requiere protección reforzada, pero sigue siendo dato asociado a una persona identificable.

## Análisis
No todos los campos son necesarios para todas las áreas. El campo con menos justificación fuera de facturación es el RFC. Edad y código postal solo son necesarios para analítica en forma generalizada, lo que aplica los principios de minimización y proporcionalidad. Los plazos de retención definitivos no los decide el DBA: los define el propietario de los datos con jurídico y cumplimiento, y el DBA los implementa.

## Conclusión
El acceso a los datos debe definirse por finalidad y necesidad, no por tener acceso administrativo a la base. El inventario es el primer paso para poder aplicar minimización, control de acceso y retención.
