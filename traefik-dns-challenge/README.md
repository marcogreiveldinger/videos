## traefik dns challenge tutorial

This sample is based on the [traefik documentation](https://doc.traefik.io/traefik/)

[Link to the youtube video](https://youtu.be/Ivxk6SuItbU)


## Traefik reverse proxy with dns challenge

Project structure:
```
.
├── README.md
├── docker-compose.yml
└── secrets
    ├── cloudflare-email.secret
    └── cloudflare-token.secret
```
[_docker-compose.yml_](docker-compose.yml)

The docker-compose file starts a traefik reverse proxy and has all the needed configs that it requests wildcard certificates for your domain.

[_secrets_](./secrets) (cloudflare dns provider configuration)

The secrets folder contains two files. One file four your email, the other for your api token.

Cloudflare api token needs to have the following permissions:
  - Zone/Zone/Read
  - Zone/DNS/Edit


## Deploy with docker compose

```
$ docker compose up -d
```