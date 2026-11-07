#Configuracion inicial
SELECT name, setting, source FROM pg_settings WHERE name IN ('log_destination','logging_collector','log_directory','log_filename','log_connections','log_disconnections','log_line_prefix','log_statement','log_min_error_statement','log_timezone') ORDER BY name;

##Resultado

          name           |                 setting                 |       source       
-------------------------+-----------------------------------------+--------------------
 log_connections         | on                                      | configuration file
 log_destination         | stderr                                  | default
 log_directory           | log                                     | default
 log_disconnections      | on                                      | configuration file
 log_filename            | postgresql-%a.log                       | configuration file
 logging_collector       | on                                      | configuration file
 log_line_prefix         | %m [%p] user=%u db=%d app=%a client=%h  | configuration file
 log_min_error_statement | error                                   | default
 log_statement           | mod                                     | configuration file
 log_timezone            | America/Mazatlan                        | configuration file
(10 filas)

##Preguntas

Con esta configuración, ¿se registra quién se conecta?

No ya que log_connections esta en off.

¿Se registran las sentencias UPDATE?

No ya que log_statement esta en none.

¿La línea de bitácora incluye el usuario o la dirección IP del cliente?

No el prefijo por defecto es %m [%p]: solo fecha y PID.

¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?

En la que indica log_timezone. Importa para alinear la hora de la bitácora con la de la tabla de auditoría y demas.

Con logging_collector = off, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?

El mecanismo de despliegue porque postgresql solo escribe en stderr.

##Interpretacion

Con los valores por defecto el servidor no registra accesos ni sentencias, así que no puede responder a Direccion.
