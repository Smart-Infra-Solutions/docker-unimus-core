FROM arm64v8/openjdk:11-jdk
ADD files /usr/src/
RUN chmod +x /usr/src/start.sh
WORKDIR /usr/src/
ENTRYPOINT ["./start.sh"]
