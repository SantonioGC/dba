# 03 - Gestion de claves

## Objetivo
Identificar el riesgo de escribir una clave dentro de un script

## Comando
Archivo temporal `ejemplo-mala-practica.sql` se elimina antes de la entrega:
```sql
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA')
FROM clientes_protegidos;
```

## Resultado
La consulta funciona, pero la clave queda escrita en el archivo

## Analisis
Si fuera una clave real y el archivo se publicara en Git, cualquiera con acceso al repositorio podría descifrar los datos. Aunque se borre despues, la clave sigue en el historial de commits.

## Conclusion
Las claves no se guardan junto al código; se guardan en un gestor de secretos.
