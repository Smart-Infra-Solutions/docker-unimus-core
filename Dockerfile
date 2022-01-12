FROM arm32v7/openjdk
ADD files/Unimus-Core.jar /usr/src/app
WORKDIR /usr/src/app
ENTRYPOINT ["java", "-jar", "./Unimus-Core.jar"]
