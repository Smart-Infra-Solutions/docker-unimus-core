#!/bin/bash
java -javaagent:apm-agent-java.jar \
-Delastic.apm.service_name=Unimus \
-Delastic.apm.application_packages=unimus.si.solutions \
-Delastic.apm.server_url=http://10.114.16.8:8200 \
-jar Unimus-Core.jar
