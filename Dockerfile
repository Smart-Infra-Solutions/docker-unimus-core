FROM arm32v7/openjdk:7-jre
ADD files/Unimus-Core.jar /usr/src
WORKDIR /usr/src/
ENTRYPOINT ["java", "-jar", "./Unimus-Core.jar"]
