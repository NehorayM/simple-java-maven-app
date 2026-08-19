FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

ARG APP_VERSION

COPY pom.xml .

RUN mvn versions:set -DnewVersion=${APP_VERSION} -DgenerateBackupPoms=false
RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY --from=builder /app/target/*jar app.jar

EXPOSE 8080
ENTRYPOINT [ "java" , "-jar" , "app.jar"]
