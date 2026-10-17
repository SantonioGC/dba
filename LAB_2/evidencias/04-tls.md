# 04 - TLS

## Objetivo
Verificar si las conexiones al servidor usan TLS

## Comando
```sql
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;

SELECT inet_client_addr(), inet_client_port();

SELECT ssl, version, cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
```

## Resultado
```
SHOW ssl;                      -> off
SHOW ssl_min_protocol_version; -> ERROR: must be superuser or have privileges of
                                  pg_read_all_settings to examine "ssl_min_protocol_version"
                                  (SQL state 42501)
SHOW port;                     -> 5432
SHOW listen_addresses;         -> *
inet_client_addr, client_port  -> 172.18.0.3 | 41924
pg_stat_ssl                    -> ssl = false (version y cipher sin valor)
```

## Analisis
- **¿La conexión usa TLS?** No. `ssl` está en `off` en el servidor y `pg_stat_ssl` muestra `false`
- **Versión y algoritmo:** no hay, porque la sesión no usa TLS
- **Error en ssl_min_protocol_version:** mi usuario no tiene el privilegio `pg_read_all_settings`, por eso no pude consultarlo
- **Con TLS vs sin TLS:** con TLS el tráfico va cifrado y protegido contra cambios; sin TLS, como en esta conexión, quien observe la red puede leer consultas y resultados
- **listen_addresses:** el servidor escucha en todas las interfaces; junto con la falta de TLS, aumenta la exposición
- **sslmode:** `require` exige TLS sin verificar al servidor y fallaría aquí porque el servidor no tiene TLS `verify-full` además valida la CA y el nombre del certificado

## Conclusion
El servidor no tiene TLS habilitado, así que las conexiones viajan sin cifrar. En producción activaría TLS y conectaría con `verify-full`
