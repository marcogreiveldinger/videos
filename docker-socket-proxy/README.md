## docker socket proxy snippets

Software used:
 - docker-socket-proxy https://github.com/Tecnativa/docker-socket-proxy
 - traefik https://traefik.io/traefik/
 - docker api https://docs.docker.com/engine/api/v1.43/

[Link to the youtube video](https://youtu.be/bOmnkJYv39M)


## docker-socket-proxy

Project structure:
```
.
├── README.md
└── docker-compose.yml
```
[_docker-compose.yml_](docker-compose.yml)
```
version: "3.3"

services:

  docket-socket-proxy:
    image: tecnativa/docker-socket-proxy
    container_name: docket-socket-proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "2375:2375"
    environment:
      - CONTAINERS=1

  traefik:
    image: "traefik:v2.10"
    container_name: "traefik"
    command:
      #- "--log.level=DEBUG"
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--providers.docker.endpoint=tcp://docket-socket-proxy:2375"
    ports:
      - "80:80"
      - "8080:8080"

  whoami:
    image: "traefik/whoami"
    container_name: "simple-service"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
      - "traefik.http.routers.whoami.entrypoints=web"
```
The compose file defines the [docker-socket-proxy](https://github.com/Tecnativa/docker-socket-proxy) with READ rights for the CONTAINERS api section of the docker socket. 
Traefik uses the proxy to access the docker socket with `--providers.docker.endpoint=tcp://docket-socket-proxy:2375` and then reads container information over the socket-proxy.

## Deploy with docker compose

```
$ docker compose up -d
```
