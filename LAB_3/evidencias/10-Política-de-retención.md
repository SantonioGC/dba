# 10 Política de retención

## Objetivo
Analizar la política propuesta: "Conservar todos los datos de clientes indefinidamente porque podrían ser útiles en el futuro."

## Procedimiento
Se evaluó la política contra los principios de minimización, finalidad y ciclo de vida, y se identificaron riesgos y la información necesaria para justificar un periodo.

## Resultado

### Pregunta 1
¿Es compatible con el principio de minimización?

No. La minimización pide tratar solo los datos necesarios para una finalidad. Conservar datos "por si acaso" no tiene finalidad definida.

### Pregunta 2
¿Qué riesgos genera conservar información innecesaria?

- Más datos expuestos si ocurre un incidente de seguridad.
- Más copias que proteger.
- Datos desactualizados o incorrectos.
- Uso posterior para fines no previstos.
- Mayor costo de almacenamiento y respaldos.
- Incumplimiento de obligaciones de privacidad.
- Más trabajo al atender solicitudes ARCO.

### Pregunta 3
¿Qué debería determinar la organización antes de establecer un periodo de retención?

- La finalidad de cada dato.
- Las obligaciones legales, fiscales y contractuales.
- Cuándo el dato deja de ser útil.
- Quién es el propietario del dato y quién aprueba el plazo.
- Qué se hará al terminar el plazo: eliminar, anonimizar o archivar con acceso restringido.

### Pregunta 4
¿Qué información debería documentarse para justificar el periodo seleccionado?

- El dato o campo al que aplica el plazo.
- La finalidad que justifica conservarlo.
- El plazo elegido.
- El fundamento: ley, contrato o necesidad operativa.
- El responsable que aprobó el plazo.
- La acción al finalizar: eliminar, anonimizar o archivar.
- Dónde existen copias del dato (respaldos, réplicas, exportaciones).

Ejemplo con datos ilustrativos (los plazos reales los define la organización con jurídico):

| Dato | Finalidad | Plazo | Fundamento | Aprueba | Acción al finalizar |
|---|---|---|---|---|---|
| telefono | Contacto de soporte | Mientras el cliente esté activo | Necesidad operativa | Atención al cliente | Eliminar |
| rfc | Facturación | Plazo fiscal aplicable | Obligación fiscal | Facturación y jurídico | Eliminar al vencer |
| edad | Estadística | No se conserva individual | Minimización | Analítica | Conservar solo rangos |

Ejemplo de implementación técnica por parte del DBA, una vez aprobado el plazo (el valor de 5 años es solo ilustrativo):

    UPDATE clientes
    SET nombre = 'ANONIMIZADO',
        correo = 'anonimizado-' || id || '@invalid',
        telefono = NULL,
        rfc = NULL
    WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';

## Análisis
Una política de retención necesita un plazo por tipo de dato, una justificación y una acción al terminar. Conservar todo indefinidamente aumenta el riesgo sin dar un beneficio demostrable.

## Conclusión
La retención es parte del ciclo de vida de los datos. El DBA implementa la eliminación o anonimización, pero los plazos los decide la organización con apoyo jurídico.
