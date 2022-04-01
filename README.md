# Docker-unimus-core

Arm64 based unimus core container for network device backup
Build from arm64v8/openjdk

## Build

```
docker build -t Smart-Infra-Solutions/docker-unimus-core .
```

## Configuration

Check the docker-compose file for available options.

  - `UNIMUS_SERVER_ADDRESS=192.168.72.133` - the IP address or DNS name of the unimus server
  - `UNIMUS_SERVER_PORT=5509` - the core connection port of the unimus server
  - `UNIMUS_SERVER_ACCESS_KEY=i............................E` - a very-very-very long string, this is the access token that you can copy from the Zone menu of Unimus Server Web under the "Remote core access key" option

## Run

## Docker compose

You should use the docker compose file for easier start.

```
docker-compose up -d
```

Forked from [Crocandr/docker-unimus](https://github.com/crocandr/docker-unimus)
