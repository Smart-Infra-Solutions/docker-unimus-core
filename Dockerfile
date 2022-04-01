FROM arm64v8/openjdk:11-jdk
ADD files/Unimus-Core.jar /usr/src/
WORKDIR /usr/src/
ENTRYPOINT ["java", "-jar", "./Unimus-Core.jar"]
