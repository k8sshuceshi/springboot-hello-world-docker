FROM openjdk:8-jdk-alpine
RUN apk --no-cache add curl
EXPOSE 8080
MAINTAINER dongchen.co
COPY build/libs/spring-boot-0.0.1-SNAPSHOT.jar spring-boot-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/spring-boot-0.0.1-SNAPSHOT.jar"]
