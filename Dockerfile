FROM openjdk:8-jre-alpine

ADD build/libs/demo-config-*-SNAPSHOT.jar /usr/local/bin/demo-config.jar

CMD ["java", "-jar", "/usr/local/bin/demo-config.jar"]
