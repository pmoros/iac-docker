docker build -t getting-started:v1.9 .

docker run -dp 3000:3000 -e 'MYSQL_HOST=walxarmysql.mysql.database.azure.com' -e 'MYSQL_DB=todos' -e 'MYSQL_PASSWORD=Hsantiago*18' -e 'MYSQL_USER=walxar' --name activity5 getting-started:v1.9