-- LAB 04 verificacion
-- ver la versión minima del protocolo
SHOW ssl_min_protocol_version;

-- ver información detallada sobre la conexión actual
SELECT a.pid, a.usename, a.client_addr, s.ssl, s.version, s.cipher
FROM pg_stat_ssl s
JOIN pg_stat_activity a USING (pid)
WHERE pid = pg_backend_pid();
