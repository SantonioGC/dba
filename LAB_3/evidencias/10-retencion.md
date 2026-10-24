# 10 Política de retención

## Objetivo
Analizar la política propuesta: "Conservar todos los datos de clientes indefinidamente porque podrían ser útiles en el futuro."

## Procedimiento
Se evaluó la política contra los principios de minimización, finalidad y ciclo de vida, y se identificaron riesgos y la información necesaria para justificar un periodo.

## Resultado

### Pregunta 1: ¿Es compatible con el principio de minimización?
No. La minimización exige tratar solo los datos necesarios para una finalidad. Conservar datos "por si acaso" no tiene finalidad definida, por lo que no cumple el criterio de necesidad.

### Pregunta 2: ¿Qué riesgos genera conservar información innecesaria?
- Mayor impacto si ocurre un incidente de seguridad (más personas y más datos expuestos).
- Más superficie de ataque y más copias que proteger.
- Datos desactualizados o inexactos.
- Uso posterior para fines no previstos.
- Mayor costo de almacenamiento, respaldos y mantenimiento.
- Incumplimiento de obligaciones de privacidad.
- Mayor complejidad al atender solicitudes ARCO.

### Pregunta 3: ¿Qué debería determinar la organización antes de establecer un periodo de retención?
- La finalidad de cada dato.
- Las obligaciones legales, fiscales y contractuales que obligan a conservarlo.
- El momento en que el dato deja de ser útil.
- Quién es el propietario del dato y quién aprueba el plazo.
- Qué se hará al terminar: eliminar, anonimizar o archivar con acceso restringido.

### Pregunta 4: ¿Qué información debería documentarse para justificar el periodo seleccionado?

| Dato | Finalidad | Plazo | Fundamento | Responsable que aprueba | Acción al finalizar |
|---|---|---|---|---|---|
| (uno por campo) | | | | | |

Ejemplo de implementación técnica por parte del DBA, una vez aprobado el plazo (el valor de 5 años es solo ilustrativo):

    UPDATE clientes
    SET nombre = 'ANONIMIZADO',
        correo = 'anonimizado-' || id || '@invalid',
        telefono = NULL,
        rfc = NULL
    WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';

## Análisis
Una política de retención debe fijar un plazo por tipo de dato con justificación y una acción al finalizar. Conservar todo indefinidamente aumenta el riesgo sin aportar beneficio demostrable.

## Conclusión
La retención forma parte del ciclo de vida de los datos. El DBA implementa la eliminación o anonimización, pero los plazos los decide la organización con apoyo jurídico.
