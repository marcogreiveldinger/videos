## authelia docker tutorial with traefik

This sample is based on the [authelia documentation](https://www.authelia.com/configuration/prologue/introduction/)

It shows you how to setup a simple authelia service with traefik as reverse proxy. With that setup you can use authelia to protect your services with a single sign on (SSO) and two factor authentication (2FA). There are different possibilties like using authelia as [forward auth](https://doc.traefik.io/traefik/middlewares/http/forwardauth/) or using it as [identity provider](https://www.authelia.com/configuration/identity-providers/introduction/) for third party services.

[Link to the youtube video](https://youtu.be/upKaY6VkQqw)


## Authelia

Project structure:
```
.
├── config
│   ├── configuartion.yml
│   └── users_database.yml
├── .env
├── docker-compose.yml 
└── README.md
```

[_docker-compose.yml_](docker-compose.yml)
```
version: "3.3"
services:

####### AUTHELIA #######
  authelia:
    image: authelia/authelia
    container_name: authelia
    volumes:
      - ./config:/config
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.authelia.rule=Host(`auth.${DOMAIN}`)'
      - 'traefik.http.routers.authelia.entrypoints=websecure'
      - 'traefik.http.routers.authelia.tls=true'
      - 'traefik.http.routers.authelia.tls.certresolver=myresolver'
      - 'traefik.http.middlewares.authelia.forwardauth.address=http://authelia:9091/api/verify?rd=https://auth.${DOMAIN}'
      - 'traefik.http.middlewares.authelia.forwardauth.trustForwardHeader=true'
      - 'traefik.http.middlewares.authelia.forwardauth.authResponseHeaders=Remote-User,Remote-Groups,Remote-Name,Remote-Email'
    expose:
      - 9091
    restart: unless-stopped
    environment:
      - TZ=Europe/Berlin
...
```
The compose file defines authelia and adds all needed labels for traefik so that you are able to use the forwardAuth just with the label `- 'traefik.http.routers.whoami.middlewares=authelia@docker'` at any other container in your traefik universe. Check out the examples of the other services in the docker-compose file.

Configure your domain in the [_.env_](.env) file.
```
DOMAIN=example.com
```

Authelia needs some configurations and they are stored in the [config](config) folder. The [configuration.yml](config/configuration.yml) is the main configuration file and the [users_database.yml](config/users_database.yml) is the user database.

[_config/users_database.yml_](config/users_database.yml)
```
users:
  user1: #username
    disabled: false
    displayname: "User1"
    password: "$argon2id$v=19$m=65536,t=3,p=4$yJqRgSVgFHFUNn/wy+37wA$NaVCU4xvQlfeYqG7rpqWKysJGgB8etlZwxpj9bHmU5k"
#   to generate the password use 'docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'password''
    email: test@exmaple.com
    groups:
      - admin
      - user
  user2:
    disabled: false
    displayname: "User2"
    password: "$argon2id$v=19$m=65536,t=3,p=4$yJqRgSVgFHFUNn/wy+37wA$NaVCU4xvQlfeYqG7rpqWKysJGgB8etlZwxpj9bHmU5k"
    email: test+user2@example.com
```
To generate a password hash you can use the following command:
`docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'password'`

## Configure Authelia as identity provider for third party services (OIDC)

[_config/configuration.yml_](config/configuration.yml)

The clients.ID refers to the client which will be using authelia as identity provider. In this case it is portainer. Checkout the official documentation for more information about the configuration of authelia as identity provider. [https://www.authelia.com/configuration/identity-providers/open-id-connect/](https://www.authelia.com/configuration/identity-providers/open-id-connect/)

```
...
identity_providers:
  oidc:
    ## The other portions of the mandatory OpenID Connect 1.0 configuration go here.
    ## See: https://www.authelia.com/c/oidc
    ##### generate with 'docker run authelia/authelia:latest authelia crypto rand --length 128 --charset alphanumeric'
    hmac_secret: czdfKgpttNPxpCbKa7jWdjaMyxV4eiNmje0w0bktXIoxXG427atUObHN5SIo77U5qLicjoCTWdhzCHJB4o4GU0NcK6XzVfNWnKOx4L9NsSeUbjsj06f0ug0BdVUW6a5i 
    
    issuer_private_key: |
      -----BEGIN RSA PRIVATE KEY-----
      MIIJKgIBAAKCAgEA5Yrc3/AYfM0bT5uH9XngyW9z5g+cHN1Q5vp5Yq1KGKDI06CT
      ......
      -----END RSA PRIVATE KEY-----
    clients:
    - id: portainer
      description: Portainer
      # generate with 'docker run authelia/authelia:latest authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986'
      secret: '$pbkdf2-sha512$310000$gpA2QOY9wumGov5wo0SXoA$Z9NAf5tJxTshTtbV6ksq/1OJNyV8HIlU2M0ISrf166jrSBFLcehBv2o1OwYtqs7Ut76X9uFtBYb6YEuJP3Ml6A'  # The digest of '_KCF3WfJfdTgMXTBpO8qvkB1hMzLDx_C4xB94WYVtX~WADtMLtUOC5AfyW5JAD15L~ITi332'.
      public: false
      authorization_policy: two_factor
      redirect_uris:
        - https://portainer.example.com
      scopes:
        - openid
        - profile
        - groups
        - email
      userinfo_signing_algorithm: none
```

To make use of the above configured identity provider, here is an example configuration for portainer.
![portainer settings](./images/portainer_settings.png "Portainer settings for OIDC")


## Configure Authelia with an email service

[_config/configuration.yml_](config/configuration.yml)

```
notifier:
  smtp:
    username: your_username
    # This secret can also be set using the env variables AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE
    password: your_password_for_the_email
    host: your.smtp.provider
    port: 465
    sender: test@example.com
```
This configuration is for a smtp server. You can either check out different email services like [SendGrid](https://sendgrid.com/) or [Brevo](https://www.brevo.com/) or you can configure to use [Gmail](https://www.authelia.com/configuration/notifications/smtp/#using-gmail).



## Deploy with docker compose

```
$ docker compose up -d
```



## Traefik notes

To understand the traefik configurations better, please refer to the [my traefik tutorial](https://github.com/marcogreiveldinger/videos/tree/main/traefik-tutorial).

The commands at traefik create the following:
- entrypoints (80 & 443)
- a certificate resolver named `myresolver`
- enable the api dashboard

The labels at traefik enable the following:
- a http route to the subdomain: traefik.example.com
- an entrypoint to the service via `websecure` (https)
- using the `myresovler` to create a let's encrypt ssl certificate
- a middleware http basic authentication with the (user:demo)
