Campos de la tabla clientes:

- id: no identifica solo, pero sirve para enlazar con el mapa si se protege
- nombre: identifica directamente si se protege
- correo: identifica directamente, trae nombre y apellido si se protege
- telefono: identifica directamente y sirve para contactar si se protege
- rfc: identifica directamente y trae fecha de nacimiento si se protege
- edad: cuasi identificador se protege
- ciudad: cuasi identificador se protege
- codigo_postal: cuasi identificador, es muy preciso se protege
- fecha_alta: cuasi identificador leve y sirve para la retencion se protege

**¿Qué campos identifican directamente?**
Nombre, correo, telefono y RFC.

**¿Qué campos no identifican solos pero pueden ayudar?**
Edad, ciudad, codigo postal y fecha de alta.

**¿Qué combinacion aumenta el riesgo?**
Edad, ciudad y código postal juntos con pocos clientes casi cada combinacion es unica.

**¿Todo lo que se protege es dato sensible jurídicamente?**
No un dato puede ser personal sin ser sensible, pero igual hay que protegerlo segun el riesgo.

## 2. Enmascaramiento

Se creo la vista v_clientes_soporte que oculta parte del correo, el teléfono y el RFC. El rol soporte solo puede consultar la vista y no la tabla clientes. Es para que soporte identifique al cliente sin ver todos sus datos.

**¿Qué sigue existiendo en la tabla original?**
Todos los datos completos el enmascaramiento solo cambia lo que se muestra.

**¿Qué ve soporte?**
El id, el nombre completo, el correo parcial, el teléfono con los últimos 4 dígitos y el RFC con los ultimos 4 caracteres.

**¿Por qué no basta ocultar los datos en la aplicación?**
Porque alguien puede conectarse directo a la base y saltarse la aplicación el control tiene que estar en la base de datos.

**¿Qué pasaría si soporte tuviera acceso a clientes?**
Vería todos los datos completos y la vista no serviría de nada.

## 3. Seudonimización

Se generó un token (UUID) para cada cliente con gen_random_uuid() y se guardó en pii.mapa_cliente. La tabla analitica.clientes solo tiene el token y datos como edad, ciudad y código postal. El analista tiene acceso a analitica.clientes pero no al mapa ni a la tabla original. El mapa solo debería verlo el DBA o alguien autorizado.

**¿Qué pasaría si el analista pudiera ver el mapa?**
Podría unir el token con el cliente y saber quién es cada uno. Se perdería la seudonimización.

**¿Qué principio se aplica?**
Separación de funciones y mínimo privilegio.

**¿Por qué seudonimizar no es anonimizar?**
Porque con el mapa se puede volver a la persona, y además quedan edad, ciudad y código postal.

**¿Qué permite relacionar el token con la persona?**
La tabla pii.mapa_cliente y después la tabla clientes.

## 4. Anonimización

Se quitaron los datos directos (nombre, correo, teléfono, RFC) y solo se muestran conteos. La edad se pasó a rangos y el código postal a sus dos primeros dígitos. Con HAVING COUNT(*) >= 5 se ocultan los grupos de menos de 5.

Con mis 5 clientes de prueba ningún grupo llega a 5, así que esa consulta no devuelve filas.

**¿Qué identificadores se eliminaron?**
Nombre, correo, teléfono, RFC e id.

**¿Qué cuasi-identificadores quedan?**
Rango de edad y región.

**¿Qué combinaciones reducen el anonimato?**
Rango de edad más región, sobre todo si se cruzan con otras fuentes de información.

**¿Qué pasa cuando un grupo es pequeño?**
Es fácil distinguir a las personas. Si el grupo es de 1, se identifica a esa persona.

**¿Qué se debería generalizar?**
La edad con rangos más grandes, el código postal a región o estado y la fecha de alta a solo el año.

**¿Qué se debería suprimir?**
Los datos directos, los grupos chicos y los valores raros que destacan.

**¿Es correcto decir que es 100 % anónimo?**
No cumplir con k = 5 no lo garantiza. Depende de los otros datos y de la información externa que se pueda cruzar.

**Reto**
deje la región en un solo dígito del código postal y quité la edad.

```sql
SELECT LEFT(codigo_postal, 1) AS region, COUNT(*) AS total
FROM clientes
GROUP BY 1
HAVING COUNT(*) >= 5;
```

grupos más grandes, más difícil distinguir a alguien.
un grupo region 8 con 5 registros.
identificar a alguien por edad y código postal. A cambio se pierde detalle.

## 5. Retención

Consulta usada:

```sql
SELECT * FROM clientes
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';
```

- **Registros afectados:** los dados de alta hace más de 5 años. Con los datos de prueba salen 0.
- **Justificación del periodo:** 5 años es un valor de ejemplo. En una empresa real lo definiría el área legal según la finalidad y las obligaciones.
- **Aprobación:** del responsable de los datos, legal o cumplimiento y el dueño del proceso.
- **Respaldo:** uno completo y probado antes de borrar.
- **Evidencia:** la consulta, el conteo, quién lo hizo, la fecha y la aprobación.
- **Recuperación:** hacer el borrado dentro de una transacción y, si ya se confirmó, restaurar el respaldo en otro ambiente y volver a insertar los registros.

## 6. Conclusiones

**¿Qué técnica usaría para soporte?**
Enmascaramiento con una vista.

**¿Y para analítica?**
Seudonimización con el mapa separado.

**¿Y para publicar estadísticas?**
Anonimización con agregación, generalización y mínimo de registros por grupo.

**¿Por qué ninguna sustituye al control de acceso?**
Porque cada una reduce un riesgo, pero ninguna evita por sí sola que alguien no autorizado llegue al dato original. El control de acceso es lo que decide quién entra.

## 7. Preguntas de reflexión

**1. ¿Diferencia entre enmascaramiento y seudonimización?**
El enmascaramiento oculta cómo se ve el dato. La seudonimización cambia el identificador por un token y guarda aparte cómo volver atrás.

**2. ¿Por qué seudonimizar no es anonimizar?**
Porque con el mapa se puede reidentificar y los cuasi-identificadores siguen ahí.

**3. ¿Por qué quitar nombre y RFC no basta?**
Porque edad, ciudad y código postal juntos pueden identificar a una persona.

**4. ¿Qué función tienen los cuasi-identificadores?**
No identifican solos, pero combinados permiten distinguir a una persona.

**5. ¿Por qué separar el mapa?**
Porque es la llave para volver a identificar. Si está junto a los datos, no sirve de nada.

**6. ¿Qué principio se aplica al impedir que el analista vea el mapa?**
Mínimo privilegio y separación de funciones.

**7. ¿Por qué una vista es mejor que dar acceso a la tabla?**
Porque solo muestra lo necesario y la tabla original queda sin permisos.

**8. ¿Diferencia entre proteger para visualización y contra acceso no autorizado?**
Lo primero cambia lo que se ve, pero el dato sigue ahí. Lo segundo evita que quien no debe llegue al dato. Lo primero sin lo segundo se puede saltar.

**9. ¿Por qué la retención es parte de la protección?**
Porque los datos que ya no se necesitan solo agregan riesgo. Conservar menos es exponer menos.

**10. ¿Qué riesgo hay al guardar información para siempre?**
Que si hay una fuga el daño es mayor, hay más datos que cuidar y se puede incumplir la minimización de datos.
