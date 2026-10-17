# LAB-02 - Cifrado, credenciales y comunicaciones

## 1. Introduccion
Una base de datos puede tener usuarios y permisos bien configurados y aun así exponer información si las contraseñas están en texto claro, los datos sensibles no estan protegidos, las conexiones no usan TLS o las claves quedan escritas en scripts. En esta practica se aplican mecanismos basicos de proteccion con PostgreSQL para reducir esos riesgos

## 2. Proteccion de credenciales
- **Texto claro:** la contraseña se guarda tal cual cualquiera con acceso a la tabla la ve
- **Hash:** transformacion que no se puede revertir con sal y `crypt()`/`gen_salt('bf')` se guarda solo el hash y se compara al iniciar sesion
- **Cifrado:** transforma el dato y se puede recuperar con la clave sirve para datos que hay que leer después, no para contraseñas

## 3. Proteccion de datos sensibles
Se protegio el **RFC** de los clientes con cifrado `pgp_sym_encrypt`, porque es un dato personal que no debe quedar legible para cualquiera que consulte la tabla, pero que sí puede necesitarse recuperar con autorizacion

## 4. TLS
TLS protege la informacion mientras viaja entre cliente y servidor confidencialidad, integridad y autenticacion. En PostgreSQL se verificó con `SHOW ssl` y la vista `pg_stat_ssl` si el servidor y la sesion usan TLS. Tambien se revisó la diferencia entre `sslmode=require` y `verify-full`

## 5. Gestion de claves
Las claves no deben guardarse junto a los scripts porque quien vea el codigo o el repositorio podría descifrar los datos. Ademas, Git conserva el historial, así que una clave borrada despues sigue disponible en commits anteriores

## 6. Resultados
- **Contraseñas:** `usuarios_insegura` muestra `Password123` en claro; `usuarios_segura` solo guarda un hash `$2a$06$...`. La verificación con la contraseña correcta da `true` y con la incorrecta `false`
- **RFC:** en `clientes_protegidos` se guarda como `[binary data]` y se recupera como `LOPA900101ABC` con la clave correcta. Con una clave incorrecta marca `Wrong key or corrupt data`
- **TLS:** `SHOW ssl` devuelve `off` y `pg_stat_ssl` muestra `ssl = false`, así que el servidor no usa TLS y la conexion viaja sin cifrar
- **Red:** el servidor escucha en el puerto 5432 y en `listen_addresses = *` todas las interfaces
- **sslmode:** como el servidor tiene TLS desactivado, `require` y `verify-full` no podrían establecer una conexion protegida

## 7. Problemas encontrados
- `SHOW ssl_min_protocol_version` dio el error `42501`: mi usuario no tiene el privilegio
- Al conectar con psql no apareció la línea "SSL connection", lo que ya indicaba que la sesión no usaba TLS

## 8. Conclusiones
Aprendí que cada riesgo necesita su propio mecanismo: hash para contraseñas, cifrado para datos recuperables, TLS para el tránsito y gestión de claves para los secretos. En este servidor encontre que TLS está desactivado. En produccion activaría TLS y conectaria con `verify-full`, usaría hash con sal para credenciales, cifraría datos sensibles y respaldos, guardaría las claves en un gestor de secretos y revisaría los archivos antes de cada commit

## Preguntas de reflexion
**1. ¿Por qué una contraseña no debe almacenarse como texto claro?**
Porque si alguien lee la base o se filtra, obtiene las credenciales de inmediato

**2. ¿Por qué un hash no es equivalente a un cifrado?**
El hash no se puede revertir y solo sirve para comparar; el cifrado se puede descifrar con la clave

**3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?**
Porque el cifrado protege el dato, pero no decide quién puede consultar, modificar o borrar tablas; ambos se complementan

**4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**
TLS solo protege la comunicación; no limita qué puede hacer cada usuario una vez conectado

**5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**
Los datos cifrados quedarían irrecuperables

**6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**
Quedaría comprometida, aunque se borre, porque permanece en el historial; habría que rotarla y volver a cifrar los datos

**7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**
Porque reduce la exposición pero no la elimina: lo ven otros usuarios, se clona y conserva historial

**8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**
Lo almacenado se protege con hash o cifrado en el disco o la base; lo que viaja por la red se protege con TLS

**9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**
Porque un algoritmo fuerte no sirve si la clave se pierde, se expone o se guarda junto a los datos

**10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**
Cifrar los respaldos, guardar su clave aparte y restringir el acceso a ellos
