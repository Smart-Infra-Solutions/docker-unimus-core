FROM openjdk:19-jdk-slim
ADD files/Unimus-Core.jar /usr/src/app
WORKDIR /usr/src/app
ENTRYPOINT ["java", "-jar", "./Unimus-Core.jar"]
