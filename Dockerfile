FROM java:11
ADD files/Unimus-Core.jar /usr/src/app
WORKDIR /usr/src/app
ENTRYPOINT ["java", "-jar", "./Unimus-Core.jar"]
