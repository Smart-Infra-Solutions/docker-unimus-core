FROM arm32v7/adoptopenjdk:latest
ADD files/Unimus-Core.jar /usr/src
WORKDIR /usr/src/
ENTRYPOINT ["java", "-jar", "./Unimus-Core.jar"]
