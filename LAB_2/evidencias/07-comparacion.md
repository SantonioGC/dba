# 07 - Reposo vs tránsito

## Objetivo
Relacionar cada situación con su mecanismo de proteccion

## Resultado

Situacion = Mecanismo apropiado = ¿Que protege? 
Contraseña de usuario = Hash con sal = Que no se recupere si se filtra la base 
RFC almacenado en una tabla = Cifrado simetrico = El dato guardado 
Consulta de cliente a servidor = TLS (`verify-full`) = El dato en transito y la identidad del servidor 
Respaldo de base de datos = Cifrado del respaldo = El dato guardado fuera de la base 
Clave criptografica = Gestion segura de claves = Que la clave no se exponga 

## Analisis
Lo almacenado se protege con hash o cifrado lo que viaja, con TLS las claves, con gestion segura

## Conclusión
Cada riesgo necesita su propio mecanismo
