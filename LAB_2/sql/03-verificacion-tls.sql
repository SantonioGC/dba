--ACT 06 
--verificamos el estado del TSL 
SHOW ssl;                     
SHOW ssl_min_protocol_version; 
SHOW port;                     
SHOW listen_addresses;         

--revisamos la coonexion
SELECT inet_client_addr(), inet_client_port();

--y vemos si el tsl se esta usando ahora mismo 
SELECT
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();