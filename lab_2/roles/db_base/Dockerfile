FROM mysql:8.0.31 as build-env

RUN curl \
    https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql \
    | sed 's/\(^GRANT ALL PR\)/-- \1/' >/docker-entrypoint-initdb.d/1.sql
RUN curl \
    https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql \
    --output /docker-entrypoint-initdb.d/2.sql

ENV MYSQL_RANDOM_ROOT_PASSWORD="true" \
    MYSQL_USER="pc" \
    MYSQL_PASSWORD="petclinic" \
    MYSQL_DATABASE="petclinic"
