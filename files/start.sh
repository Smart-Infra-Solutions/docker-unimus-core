#!/bin/bash
java -javaagent:elastic-apm-agent.jar \
-Delastic.apm.service_name=Unimus \
-Delastic.apm.environment=production \
-Delastic.apm.application_packages=org.unimus.si.solutions \
-Delastic.apm.server_url=http://10.114.16.8:8200 \
-jar Unimus-Core.jar
