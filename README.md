docker-compose build

docker build -t pjabadesco/php74-apache-mssql-mysql:1.0 .
docker push pjabadesco/php74-apache-mssql-mysql:1.0

docker build -t pjabadesco/php74-apache-mssql-mysql:latest .
docker push pjabadesco/php74-apache-mssql-mysql:latest

docker tag pjabadesco/php74-apache-mssql-mysql:latest ghcr.io/pjabadesco/php74-apache-mssql-mysql:latest
docker push ghcr.io/pjabadesco/php74-apache-mssql-mysql:latest
