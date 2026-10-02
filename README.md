# Unimus Core in Docker

[![status-badge](https://ci.si.solutions/api/badges/2/status.svg)](https://ci.si.solutions/repos/2)
[![GHCR](https://img.shields.io/badge/ghcr.io-smart--infra--solutions%2Funimus--core-blue?logo=github)](https://github.com/orgs/Smart-Infra-Solutions/packages/container/package/unimus-core)
[![Image Version](https://img.shields.io/github/v/tag/Smart-Infra-Solutions/docker-unimus-core?sort=semver&label=version)](https://github.com/orgs/Smart-Infra-Solutions/packages/container/package/unimus-core)

> **Unimus Remote Core** — a distributed worker for [Unimus](https://unimus.net/).
> It connects back to a Unimus **Server** and performs the actual device access,
> configuration backups and pushes for the network segment it lives in.

Unofficial, hardened container images for the Unimus **Remote Core**, available in
**Alpine** and **Debian** flavors, built for **`amd64`** and **`arm64`**.

> A Remote Core is **not** a standalone product — it must be paired with a running
> Unimus Server. For the server, see
> **[`ghcr.io/smart-infra-solutions/unimus`](https://github.com/orgs/Smart-Infra-Solutions/packages/container/package/unimus)**
> ([source](https://github.com/Smart-Infra-Solutions/docker-unimus)).

---

## How it fits together

A Remote Core lets you reach devices that the Server cannot reach directly — for
example, networks behind NAT, in remote sites, or in isolated security zones. The
core dials **out** to the Server, so only the core needs reachability to the Server's
core port (no inbound firewall rules toward the remote network).

```
        ┌──────────────────────────┐                ┌────────────────────────────┐
        │  Unimus Server           │   core conn.   │  Unimus Remote Core        │
        │  smart-infra-solutions/  │◄───────────────│  smart-infra-solutions/    │
        │  unimus                  │  TCP :5509     │  unimus-core               │
        │  Web UI :8085            │  + access key  │  (this image)              │
        └──────────────────────────┘                └─────────────┬──────────────┘
                                                                   │ SSH / Telnet / SNMP …
                                                                   ▼
                                                       ┌────────────────────────┐
                                                       │  Network devices in    │
                                                       │  the remote segment    │
                                                       └────────────────────────┘
```

1. In the Unimus Server Web UI, go to **Zones → Remote core access key** and copy the
   access key for the zone this core should serve.
2. Start this container with the Server address, the core connection port, and that
   access key.
3. The core registers itself with the Server and starts taking jobs.

---

## Highlights

- **Two flavors** — minimal **Alpine** or **Debian** (glibc).
- **Multi-stage build** — the JAR is downloaded in a builder stage; the final image
  ships only the runtime (no `curl`, smaller attack surface).
- **Java 25** runtime (Azul Zulu on Alpine, OpenJDK on Debian).
- **Zero-touch config** — the entrypoint generates
  `/etc/unimus-core/unimus-core.properties` from environment variables on startup.
- **Built-in HEALTHCHECK** (verifies the core process is alive).
- **Multi-arch** — `linux/amd64` and `linux/arm64/v8`.
- **`tini`** as PID 1 for correct signal handling and zombie reaping.

---

## Quick start

```bash
docker run -d \
  --name unimus-core \
  -e UNIMUS_SERVER_ADDRESS=unimus.example.com \
  -e UNIMUS_SERVER_PORT=5509 \
  -e UNIMUS_SERVER_ACCESS_KEY='<paste-access-key-from-server>' \
  -e XMX=1024M \
  -e TZ=Europe/Paris \
  -v unimus-core-config:/etc/unimus-core \
  ghcr.io/smart-infra-solutions/unimus-core:latest-alpine
```

### Docker Compose

```yaml
services:
  unimus-core:
    image: ghcr.io/smart-infra-solutions/unimus-core:latest-alpine
    container_name: unimus-core
    restart: unless-stopped
    environment:
      # --- connection to the Unimus Server ---
      UNIMUS_SERVER_ADDRESS: "unimus.example.com"
      UNIMUS_SERVER_PORT: "5509"
      UNIMUS_SERVER_ACCESS_KEY: "<paste-access-key-from-server>"
      # --- JVM memory ---
      XMX: "1024M"
      XMS: "256M"
      # OR fully custom JVM options (overrides XMS/XMX):
      # JAVA_OPTS: "-Xms128M -Xmx512M"
      TZ: "Europe/Paris"
    volumes:
      - ./config:/etc/unimus-core
      - /etc/localtime:/etc/localtime:ro
```

> Want the **Server** and a **Core** in one stack? See the combined example in the
> [`docker-unimus`](https://github.com/Smart-Infra-Solutions/docker-unimus) repo.

---

## Configuration

Configuration is driven entirely by environment variables. On startup the entrypoint
writes them into `/etc/unimus-core/unimus-core.properties`.

| Variable                   | Default                | Description                                                                                   |
|----------------------------|------------------------|-----------------------------------------------------------------------------------------------|
| `UNIMUS_SERVER_ADDRESS`    | `172.17.0.1`           | IP address or DNS name of the Unimus **Server**.                                              |
| `UNIMUS_SERVER_PORT`       | `8085`                 | Server **core connection** port. Set to the port configured in the Server's Zone (e.g. `5509`). |
| `UNIMUS_SERVER_ACCESS_KEY` | _(invalid placeholder)_| **Remote core access key**, copied from the Server Web UI (Zones → Remote core access key).   |
| `XMX`                      | _(JVM)_                | Maximum JVM heap size, e.g. `1024M`. Maps to `-Xmx`.                                          |
| `XMS`                      | _(JVM)_                | Initial JVM heap size, e.g. `256M`. Maps to `-Xms`.                                           |
| `JAVA_OPTS`                | _(unset)_              | Full override of JVM parameters. **If set, replaces `XMS`/`XMX`.**                            |
| `TZ`                       | `UTC`                  | Container timezone, e.g. `Europe/Paris`.                                                      |

> Treat `UNIMUS_SERVER_ACCESS_KEY` as a secret — prefer Docker/Compose secrets or an
> `.env` file over committing it.

> **Persistence** — the generated configuration lives in `/etc/unimus-core`. Mount a
> volume there to keep it across container recreation.

---

## Image tags

| Tag                    | Flavor | Description                                          |
|------------------------|--------|------------------------------------------------------|
| `latest-alpine`        | Alpine | Latest released version, Alpine base.                |
| `latest-debian`        | Debian | Latest released version, Debian base.                |
| `X.Y.Z-alpine-linux`   | Alpine | Pinned Core version (e.g. `2.9.1-alpine-linux`).     |
| `X.Y.Z-debian-linux`   | Debian | Pinned Core version (e.g. `2.9.1-debian-linux`).     |

> **Keep the Core version aligned with the Server version.** This repo is tagged in
> lockstep with [`docker-unimus`](https://github.com/Smart-Infra-Solutions/docker-unimus).

Browse all tags on **[GitHub Container Registry](https://github.com/orgs/Smart-Infra-Solutions/packages/container/package/unimus-core)**.

---

## Health & operations

The image declares a `HEALTHCHECK` that verifies the core process is running:

```
--interval=30s --timeout=10s --start-period=60s --retries=3
```

```bash
docker inspect --format '{{.State.Health.Status}}' unimus-core
docker logs -f unimus-core
```

A healthy core also appears as **connected** in the Server's Zone view.

---

## How the image is built

The Dockerfiles use a two-stage build:

1. **Builder stage** — downloads `Unimus-Core.jar` from the official Unimus download
   server.
2. **Runtime stage** — a clean JRE image that copies only the JAR plus the entrypoint,
   runs under `tini` as PID 1.

Build locally:

```bash
# Alpine
docker build -f Dockerfile-alpine -t unimus-core:alpine .

# Debian
docker build -f Dockerfile-debian -t unimus-core:debian .
```

---

## Supported architectures

`linux/amd64` · `linux/arm64/v8`

---

## Related projects & links

- **Unimus Server image** — [`ghcr.io/smart-infra-solutions/unimus`](https://github.com/orgs/Smart-Infra-Solutions/packages/container/package/unimus)
  · [source](https://github.com/Smart-Infra-Solutions/docker-unimus)
- **This image (Remote Core)** — [`ghcr.io/smart-infra-solutions/unimus-core`](https://github.com/orgs/Smart-Infra-Solutions/packages/container/package/unimus-core)
  · [source](https://github.com/Smart-Infra-Solutions/docker-unimus-core)
- **Unimus** — https://unimus.net/
- **GitHub Packages** — https://github.com/orgs/Smart-Infra-Solutions/packages

---

<sub>Maintained by [Smart Infra Solutions](https://si.solutions). Unimus is a product of
NetCore j.s.a.; this is a community-maintained packaging and is not an official Unimus
distribution.</sub>
