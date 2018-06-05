FROM openjdk:8-jre-alpine

ADD build/libs/config-*-SNAPSHOT.jar /usr/local/bin/config.jar

CMD ["java", "-jar", "/usr/local/bin/config.jar"]
