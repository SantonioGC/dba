# 10 - Politica de claves

## Objetivo
Definir reglas mínimas para gestionar claves criptograficas

## Resultado
1. **Generacion:** se generan con herramientas aprobadas, nunca a mano ni reutilizadas
2. **Almacenamiento:** en un gestor de secretos, nunca en el repositorio ni junto a los datos que protegen
3. **Acceso:** solo quien lo necesite, con minimo privilegio y registro de uso
4. **Rotacion:** se cambian periodicamente y cuando alguien con acceso sale de la organizacion
5. **Respaldo:** con copia cifrada y separada de los datos
6. **Revocacion:** una clave comprometida se revoca de inmediato
7. **Exposicion accidental:** si aparece en Git o en logs, se considera comprometida y se rota, aunque se borre el archivo
8. **Eliminacion:** al terminar su vida util se destruye de forma segura, con todas sus copias

## Analisis
Las reglas cubren todo el ciclo de vida de la clave

## Conclusion
La gestion de claves es tan importante como el algoritmo de cifrado
