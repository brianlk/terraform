# Prerequisites

Before proceeding you need to the following.

## SSH

If you do not have one you should create an ssh key.

(Generating a new SSH key and adding it to the ssh-agent)[https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent]
## Github

Once your ssh key is done you now need to add it to your github account.

To copy the content of your public key you can echo the content and copy it to your account.

**ex:**

```
cat ~/.ssh/id_ed25519.pub
```

## Docker

[Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

[Linux post-install](https://docs.docker.com/engine/install/linux-postinstall/)

[Install Docker Compose](https://docs.docker.com/compose/install/)

# Docker Compose

All the major services are splitted in their own docker-compose and can be run independantly or together.

> Note that docker-compose.yml is always needed as it contains the nginx proxy and common services.

## Init Pycom

### Init the projects

To init Pycom stack you have to run the `init.sh` script and answer the questions.

⚠️ After this please make sure the `${PYBYTES_MICROSERVICES_DIR}` in `~/.pybytes-scripts/config` and `pybytes-scripts/docker/.env` are correct.

### Init Wordpress (pycom shop)

To init Pycom shop you have to run the `init-wordpress.sh` script and answer the questions.

Then you will have to [setup Pycom shop plugins](#setup-pycom-shop).

### Init Nodebb (pycom forum)

To init the Pycom forum you will have to run the docker containers (cf. Running services) before going through these commands (only needed for init).

Then you will have to [setup Pycom forum plugins](#setup-pycom-forum).

#### Setup nodebb

> Nodebb will generate for you the admin/password, please note them.

```bash
docker exec -ti pycom-sso-forum ./nodebb setup
```
#### Install dependencies

```bash
docker exec -ti pycom-sso-forum npm install nodebb-plugin-jwt-oauth2
```

#### Restart nodebb

The following command will restart the cnodebb container *(running build then start)*

```bash
docker-compose -f dc.web.yml restart nodebb
```

## Running services

You can run or stop the services alongside running containers.

### Common services

The following command will start only the services within `docker-compose.yml` *(common services)*

```bash
docker-compose up -d
```

You are now able to up or down any other services defined in they own compose.

#### eg. with sso
```bash
docker-compose -f dc.sso.yml up -d
```

## Combining services

You can also combine multiple docker-compose in one command.

```bash
docker-compose -f docker-compose.yml -f dc.sso.yml -f dc.pybytes.yml up -d
```

## Downing services

### By service

```bash
docker-compose -f dc.sso.yml down -v
```

## Restarting a service

```bash
docker-compose -f dc.sso.yml restart pycom-sso-frontend
```

## Stop and Remove every containers

This command will stop and remove every running containers.

```bash
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
```

## Pruning

If you have issues with docker cache etc... please consider the following commands:

```
docker builder prune -a
```

```
docker volume prune
```

```
docker container prune
```

## Setup Pycom Shop

Once on [http://shop.pycom.local](http://shop.pycom.local), follow the instructions and activate the plugins:
- `daggerhart-openid-connect-generic`
- `pycom-sso-plugin`

### Wordpress settings

In order to have the `wp REST API` to work, make sure to change the `permalinks` to `Post Name`.

### OpenID settings

|Options|Value|
|-|-|
|Client id|pycom|
|Client Secret Key|very-secret|
|OpenID Scope|profile|
|Login Endpoint URL|http://sso.pycom.local/login|
|Userinfo Endpoint URL|http://server:9090/oauth/userinfo|
|Token Validation Endpoint URL|http://server:9090/oauth/token|
|End Session Endpoint URL|http://sso.pycom.local/logout|
|Identity Key|email|
|Disable SSL Verify|unchecked|
|HTTP Request Timeout|5|
|Nickname Key|email|
|Email Formatting|{email}|
|Display Name Formatting|{firstname} {lastname}|
|Identify with User Name|unchecked|
|State time limit||
|Enable Refresh Token|checked|
|Link Existing Users|checked|
|Create user if does not exist|checked|
|Redirect Back to Origin Page|unchecked|
|Redirect to the login screen when session is expired|checked|
|Enforce Privacy|unchecked|
|Alternate Redirect URI|unchecked|
|Enable Logging|unchecked|
|Log Limit|1000|

### Pycom SSO settings

|Options|Value|
|-|-|
|Serive Key|6Le60QoUAAAAAPO94apxvVH6inmVsQSN98ayMdpg|
|Service Name|pycom-shop|

## Setup Pycom Forum

Login with your admin credentials generated during the [init process](#setup-nodebb).

Go to `admin > extends > inactive` and activate the following plugins:

- `nodebb-plugin-jwt-oauth2`


# CTRL - Docker

```bash
#!/usr/bin/env bash
docker-compose -f dc.ctrl.yml build ctrl-management
docker-compose -f dc.ctrl.yml run --rm ctrl-management /bin/sh -c "rm -rf node_modules && npm install"

docker-compose -f dc.ctrl.yml build ctrl-mqttserver
docker-compose -f dc.ctrl.yml run --rm ctrl-mqttserver /bin/sh -c "rm -rf node_modules && npm install"


docker-compose -f dc.ctrl.yml build ctrl-mqtt-broker
docker-compose -f dc.ctrl.yml run --rm ctrl-mqtt-broker /bin/sh -c "rm -rf node_modules && npm install"

docker-compose -f dc.ctrl.yml build ctrl-mqtt-proxy
docker-compose -f dc.ctrl.yml run --rm ctrl-mqtt-proxy /bin/sh -c "rm -rf node_modules && npm install"


docker-compose -f dc.ctrl.yml build ctrl-pyauth
docker-compose -f dc.ctrl.yml run --rm ctrl-pyauth /bin/sh -c "rm -rf node_modules && npm install"

docker-compose -f dc.ctrl.yml build ctrl-pyconfig
docker-compose -f dc.ctrl.yml run --rm ctrl-pyconfig /bin/sh -c "rm -rf node_modules && npm install"


docker-compose -f dc.ctrl.yml build ctrl-lorabridge
docker-compose -f dc.ctrl.yml run --rm ctrl-lorabridge /bin/sh -c "rm -rf node_modules && npm install"


docker-compose -f dc.ctrl.yml build ctrl-api-proxy
docker-compose -f dc.ctrl.yml run --rm ctrl-api-proxy /bin/sh -c "cd packages && cd api-utils && rm -rf node_modules && npm install"
docker-compose -f dc.ctrl.yml run --rm ctrl-api-proxy /bin/sh -c "cd packages && cd api-models && rm -rf node_modules && npm install"
docker-compose -f dc.ctrl.yml run --rm ctrl-api-proxy /bin/sh -c "rm -rf node_modules && npm install"

docker-compose -f dc.ctrl.yml up -d ctrl-gateway ctrl-management


docker-compose -f dc.ctrl.yml build ctrl-gateway
docker-compose -f dc.ctrl.yml run --rm ctrl-gateway /bin/sh -c "rm -rf node_modules && rm package-lock.json && npm install"


docker-compose -f dc.ctrl.yml build ctrl-management
docker-compose -f dc.ctrl.yml run --rm ctrl-management /bin/sh -c "rm -rf node_modules && rm package-lock.json && npm install"

```
