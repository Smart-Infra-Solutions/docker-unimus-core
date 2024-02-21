# Docker-unimus-core

[![status-badge](https://ci.si.solutions/api/badges/2/status.svg)](https://ci.si.solutions/repos/2)

**Unimus core** container, should be run with [Docker-Unimus](https://hub.docker.com/r/smartinfrasolutions/unimus)

## Configuration

Check the [docker-compose](https://github.com/Smart-Infra-Solutions/docker-unimus-core/blob/main/docker-compose.yml) file for available options.

- `UNIMUS_SERVER_ADDRESS=xx.xx.xx.xx` - the IP address or DNS name of the unimus server
- `UNIMUS_SERVER_PORT=5509` - the core connection port of the unimus server
- `UNIMUS_SERVER_ACCESS_KEY=......` - a very-very-very long string, this is the access token that you can copy from the Zone menu of Unimus Server Web under the "Remote core access key" option

## Supported architectures

arm64, amd64  

## Links

<https://hub.docker.com/r/smartinfrasolutions>  
<https://github.com/Smart-Infra-Solutions/docker-unimus>  
