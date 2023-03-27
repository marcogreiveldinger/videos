## traefik docker tutorial

This sample is based on the [traefik documentation](https://doc.traefik.io/traefik/) and uses the privacy google analytics alternative [plausible.io](https://plausible.io/)

[Link to the youtube video](https://youtu.be/QC3weuCUr8o)


## Traefik reverse proxy 

Project structure:
```
.
├── README.md
├── docker-compose.yml
├── plausible-conf.env
```
[_docker-compose.yml_](docker-compose.yml)
```
traefik:
    image: "traefik:latest"
    container_name: "traefik"
    command:
      - "--api.dashboard=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
      - "--certificatesresolvers.myresolver.acme.email=yourEmail@example.com"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - "./letsencrypt:/letsencrypt"
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(`traefik.example.com`)"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.service=api@internal"
      - "traefik.http.routers.traefik.tls.certresolver=myresolver"      
      - "traefik.http.routers.traefik.middlewares=traefik-auth"
      - "traefik.http.middlewares.traefik-auth.basicauth.users=user:$$2y$$05$$6m8MvyzgJ4Kl7/3rL4X6VurX1huMas8a7oPB3xRfBjFbGCR8MUi7W"


  plausible:
    image: plausible/analytics:latest
    restart: always
    command: sh -c "sleep 10 && /entrypoint.sh db createdb && /entrypoint.sh db migrate && /entrypoint.sh run"
    depends_on:
      - plausible_db
      - plausible_events_db
      - mail
    ports:
      - 8000:8000
    env_file:
      - plausible-conf.env
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.plausible.rule=Host(`plausible.example.com`)"
      - "traefik.http.routers.plausible.entrypoints=websecure"
      - "traefik.http.routers.plausible.tls.certresolver=myresolver"
...
```
The compose file defines an application with two main services `traefik` and `plausible` (the others are helpers needed for plausible).

## Deploy with docker compose

```
$ docker compose up -d
```

## Traefik configuration
The commands at traefik create the following:
- entrypoints (80 & 443)
- a certificate resolver named `myresolver`
- enable the api dashboard

The labels at traefik enable the following:
- a http route to the subdomain: traefik.example.com
- an entrypoint to the service via `websecure` (https)
- using the `myresovler` to create a let's encrypt ssl certificate
- a middleware http basic authentication with the (user:demo)

## Plausible configuration
 The labels at plausible enable the following:
- a http route to the subdomain: plausible.example.com
- an entrypoint to the service via `websecure` (https)
- using the `myresovler` to create a let's encrypt ssl certificate
