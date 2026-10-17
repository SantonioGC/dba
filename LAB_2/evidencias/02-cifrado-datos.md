# 02 - Cifrado de datos

## Objetivo
Proteger el RFC con cifrado simetrico y recuperarlo con la clave

## Comando
```sql
SELECT * FROM clientes_protegidos;

SELECT id, nombre, pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') AS rfc
FROM clientes_protegidos;

-- Prueba con clave incorrecta
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-EQUIVOCADA')
FROM clientes_protegidos;
```

## Resultado
Dato almacenado el RFC no se puede leer
```
id | nombre    | rfc_cifrado
1  | Ana López | [binary data]
```

Dato descifrado con la clave correcta
```
id | nombre    | rfc
1  | Ana López | LOPA900101ABC
```

Descifrado con clave incorrecta
```
ERROR:  Wrong key or corrupt data
SQL state: 39000
```

## Analisis
- **crypt() vs pgp_sym_encrypt():** `crypt()` hace un hash que no se revierte; `pgp_sym_encrypt()` cifra y se puede descifrar con la clave
- **¿Cual recupera el dato?** `pgp_sym_encrypt()`
- **Con clave incorrecta:** da el error `Wrong key or corrupt data` y no entrega el dato
- **Problema de poner la clave en la consulta:** queda expuesta en scripts, logs y repositorios

## Conclusion
El cifrado protege datos que hay que recuperar, pero depende de cuidar la clave: sin la correcta, el dato no se puede leer
