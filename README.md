# Proyecto Parte2

*Para bajar el contenedor*
  docker-compose down
*Luego, si es usuario nuevo, para construir los contenedores*
  docker-compose up --build -d

*Linea para acceder a una instancia de MariaDB* 
**Opcional**
  docker exec -it wikidb mariadb -u wikiuser -p

*Y por consecuente, instalamos dependencias para mariadb*
  docker exec -it wikidb bash
apt-get update && apt-get install -y 
mariadb-client mysql -u wikiuser -p

 *
3  mysql -h 127.0.0.1 -P 3306 -u wikiuser -p
