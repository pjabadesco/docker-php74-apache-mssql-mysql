## OLD
docker-compose build
docker build -t pjabadesco/php74-apache-mssql-mysql:1.3 .

## NEW
docker buildx build --platform=linux/amd64 --tag=php74-apache-mssql-mysql:latest --load .

docker tag php74-apache-mssql-mysql:latest pjabadesco/php74-apache-mssql-mysql:1.3
docker push pjabadesco/php74-apache-mssql-mysql:1.3

docker tag pjabadesco/php74-apache-mssql-mysql:1.3 pjabadesco/php74-apache-mssql-mysql:latest
docker push pjabadesco/php74-apache-mssql-mysql:latest

docker tag pjabadesco/php74-apache-mssql-mysql:latest ghcr.io/pjabadesco/php74-apache-mssql-mysql:latest
docker push ghcr.io/pjabadesco/php74-apache-mssql-mysql:latest
