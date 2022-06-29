#!/bin/bash
java -jar apm-agent-attach-cli.jar \
    --include-main Unimus-Core.jar \
    --include-vmarg elastic.apm.attach=true \
    --continuous \
    --config service_name=unimus-core \
    --config server_url=http://10.114.16.8:8200
