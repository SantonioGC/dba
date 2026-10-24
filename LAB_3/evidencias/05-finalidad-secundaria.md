# 05 Analisis de una finalidad secundaria

## Objetivo
Analizar si la organización puede usar los datos de clientes para una nueva finalidad: "Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra."

## Procedimiento
Se evaluó la propuesta contra los principios de limitación de finalidad, finalidad compatible, minimización y consentimiento, y se propusieron controles técnicos.

## Resultado

### 1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?
No. Los datos se recopilaron para fines concretos (atención, facturación, estadística). Un uso nuevo debe ser compatible con esas finalidades o contar con base jurídica y estar informado en el aviso de privacidad. Tener acceso técnico a los datos no equivale a tener permiso para usarlos.

### 2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?
- ¿El aviso de privacidad actual incluye esta finalidad?
- ¿Es una finalidad compatible con la original o requiere nuevo consentimiento?
- ¿Cuál es la base jurídica del tratamiento?
- ¿Cómo podrá el cliente oponerse a este uso?
- ¿Quién es el propietario del dato y quién autoriza el nuevo uso?
- ¿Qué datos son realmente indispensables para la campaña?
- ¿Cuánto tiempo se conservarán los datos usados en la campaña?
- ¿Se compartirán con terceros (por ejemplo, una plataforma de correo masivo)?

### 3. ¿Qué datos serían realmente necesarios?

| Dato | ¿Necesario? | Nota |
|---|---|---|
| correo | Sí | Canal de envío |
| ciudad | Sí | Segmentación |
| edad | Solo como rango | No se requiere la edad exacta |
| comportamiento de compra | Sí | Proviene de otra tabla, no de clientes |
| nombre | Opcional | Solo si la campaña lo personaliza |
| rfc | No | Sin relación con promociones |
| telefono | No | A menos que el canal sea SMS y esté autorizado |
| codigo_postal | No | Ciudad es suficiente |

### 4. ¿Necesitaría el área de marketing acceso directo a clientes?
No. Debe recibir únicamente una vista preparada con los campos necesarios y sin los clientes que se hayan opuesto al uso.

### 5. ¿Qué controles técnicos podrían limitar la información entregada?

    CREATE TABLE oposiciones_marketing (
        cliente_id BIGINT PRIMARY KEY REFERENCES clientes(id),
        fecha_oposicion TIMESTAMP NOT NULL DEFAULT now()
    );

    CREATE VIEW v_marketing_clientes AS
    SELECT c.id, c.correo, c.ciudad,
           CASE
               WHEN c.edad < 18 THEN 'Menor de 18'
               WHEN c.edad BETWEEN 18 AND 29 THEN '18-29'
               WHEN c.edad BETWEEN 30 AND 44 THEN '30-44'
               WHEN c.edad BETWEEN 45 AND 59 THEN '45-59'
               ELSE '60 o más'
           END AS rango_edad
    FROM clientes c
    WHERE c.id NOT IN (SELECT cliente_id FROM oposiciones_marketing);

    CREATE ROLE marketing NOLOGIN;
    GRANT USAGE ON SCHEMA public TO marketing;
    GRANT SELECT ON v_marketing_clientes TO marketing;

Además: registro de auditoría de consultas de ese rol y revisión periódica de sus permisos.

## Análisis
La nueva finalidad no se puede implementar solo porque técnicamente sea posible. Requiere validación de privacidad y jurídico. La vista limita los campos, la tabla de oposiciones respeta el derecho de oposición y el rol evita acceso directo a la información completa.

## Conclusión
