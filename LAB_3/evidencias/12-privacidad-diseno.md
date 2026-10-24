# 12 Privacidad por diseño

## Objetivo
Analizar la propuesta del desarrollador de crear una tabla clientes con muchos campos, con la justificación: "Es mejor guardar todos los datos por si posteriormente necesitamos alguno."

## Procedimiento
Se revisó cada campo propuesto contra los criterios de necesidad, finalidad y proporcionalidad, y se propuso un diseño alternativo.

## Resultado

### ¿Qué problemas identificas?
- Se recopilan datos sin finalidad definida (salario, estado civil, ocupación).
- Hay datos redundantes (edad y fecha_nacimiento).
- Algunos datos (salario, estado civil) pueden ser sensibles o discriminatorios.
- Todos los campos son TEXT sin restricciones de formato.
- No hay llave primaria ni campos obligatorios.
- La justificación se basa en una posibilidad futura, no en una necesidad.

### ¿Qué principio de privacidad se está ignorando?
Minimización de datos, junto con necesidad, proporcionalidad y limitación de finalidad.

### ¿Qué preguntas realizarías antes de aprobar el diseño?
- ¿Para qué proceso se usa cada campo?
- ¿Quién lo consultará?
- ¿El aviso de privacidad lo contempla?
- ¿Cuánto tiempo se conservará?
- ¿Se puede lograr la misma finalidad con menos datos?
- ¿Qué pasa si el dato se filtra?

### ¿Qué datos eliminarías?
salario, estado_civil, ocupacion y edad (se puede calcular a partir de fecha_nacimiento si es realmente necesario).

### ¿Qué datos requerirían una justificación adicional?
rfc, direccion y fecha_nacimiento.

### ¿Cómo aplicarías privacidad por defecto?
- Solicitar únicamente los campos necesarios.
- Dejar opcionales los campos que no sean indispensables.
- Ningún rol tiene acceso por defecto; los permisos se otorgan por finalidad.
- Entregar vistas por área en lugar de acceso a la tabla.
- Definir la retención desde el diseño.

Diseño propuesto:

    CREATE TABLE clientes (
        id BIGSERIAL PRIMARY KEY,
        nombre VARCHAR(120) NOT NULL,
        correo VARCHAR(150) NOT NULL,
        telefono VARCHAR(20),
        ciudad VARCHAR(80),
        fecha_alta DATE NOT NULL DEFAULT CURRENT_DATE
    );

El RFC y otros datos se agregarían solo si un proceso (por ejemplo facturación) lo justifica, en una tabla separada con acceso restringido.

## Análisis
Guardar más datos aumenta el riesgo, el costo y las obligaciones sin un beneficio demostrable. La privacidad se decide desde el diseño de la tabla, no después.

## Conclusión
Privacidad por diseño significa que cada campo debe justificarse antes de existir y que la configuración inicial debe exponer lo mínimo.
