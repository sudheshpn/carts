FROM maven:3.5.4


WORKDIR /opt/carts

COPY . .

RUN mvn package \
    && mv target/carts.jar /run \
    && rm -rf *

EXPOSE 8080

CMD java -jar /run/carts.jar --port=8080


