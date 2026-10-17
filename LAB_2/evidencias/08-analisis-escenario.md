# 08 - Analisis del escenario

## Objetivo
Identificar riesgos y mecanismos de proteccion

## Resultado

**1. ¿Principales riesgos?**
- Contraseñas en texto claro: si se filtra la base, se filtran las credenciales
- RFC en texto claro: cualquiera con acceso a la tabla lo lee
- Conexión sin validar el servidor: posible suplantación o espionaje
- Claves en archivos SQL: permiten descifrar los datos
- Respaldos sin protección: robar uno equivale a robar los datos

**2. ¿Mecanismo para cada elemento?**
- Contraseña: hash con sal
- RFC e información financiera: cifrado
- Conexiones: TLS con `verify-full`
- Claves: gestor de secretos
- Respaldos: cifrado del respaldo

**3. ¿Cual es el mas crítico?**
Las claves en archivos SQL, porque con ellas se descifra todo y el cifrado pierde valor

**4. ¿Usuarios y permisos eliminan estos riesgos?**
No no protegen respaldos robados, trafico de red, secretos expuestos ni contraseñas en texto claro

## Analisis
Los permisos controlan quien consulta, pero no protegen los datos fuera de la base ni en la red

## Conclusion
La seguridad necesita varias capas, no solo permisos
