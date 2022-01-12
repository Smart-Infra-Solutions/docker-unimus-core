FROM debian:stable-slim

ENV DOWNLOAD_URL https://download.unimus.net/unimus-core/-%20Latest/Unimus-Core.jar

RUN apt-get update && apt-get install -y curl less wget tzdata

#
# Unimus
RUN curl -L -o /opt/unimus-core.jar $DOWNLOAD_URL

# JRE install
RUN apt-get install -y openjdk-11-jre-headless
#
# Start script
COPY files/start.sh /opt/start.sh
RUN chmod 755 /opt/start.sh
#
ENTRYPOINT /opt/start.sh
