# 01 - Credenciales

## Objetivo
Comparar una contraseña en texto claro contra un hash con sal

## Comando
```sql
SELECT * FROM usuarios_insegura;
SELECT crypt('Password123', gen_salt('bf'));
SELECT * FROM usuarios_segura;
SELECT usuario, password_hash = crypt('Password123', password_hash) AS contraseña_correcta
FROM usuarios_segura WHERE usuario = 'juan';
SELECT usuario, password_hash = crypt('OtraPassword', password_hash) AS contraseña_correcta
FROM usuarios_segura WHERE usuario = 'juan';
```

## Resultado
usuarios_insegura la contraseña se ve completa:
```
id | usuario | password
1  | juan    | Password123
```

Hash generado con crypt():
```
$2a$06$keK0s0RI.55JUUt2JxSw2OipLEcn6eouXeqR9v3H/1UCm/NNnKnua
```

usuarios_segura solo se guarda el hash:
```
id | usuario | password_hash
1  | juan    | $2a$06$HQk9zZjVESISEXWoD7731e6gqIkfxARkaNhj2G6mrDHOkuTlHd4Kq
```

Verificación con contraseña correcta 
```
usuario | contraseña_correcta
juan    | true
```
Verificación con contraseña incorrecta 
```
usuario | contraseña_correcta
juan    | false
```

## Analisis
- **Si alguien lee usuarios_insegura:** ve la contraseña y puede usarla
- **¿Los hashes serían iguales al repetir?** No, porque `gen_salt()` crea una sal distinta cada vez se nota en que el hash de `crypt()` y el de `usuarios_segura` son diferentes aunque la contraseña es la misma
- **gen_salt():** genera la sal aleatoria
- **crypt():** calcula el hash con esa sal
- **¿Es reversible?** No
- **Contraseña correcta:** `true`. **Incorrecta:** `false`
- **¿Por que no se recupera la contraseña?** Solo se comparan hashes
- **Hash vs cifrado:** el cifrado se descifra con la clave el hash no

## Conclusion
Las contraseñas se guardan como hash con sal nunca en texto
