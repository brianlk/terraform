# CTRL - Docker compose

> This `docker-compose` is used to build **CTRL** using the development branch without cloning the github repository

## Pre-requisites
- login to Github Hub
    ```sh
    cat token.txt | docker login ghcr.io -u YOUR_USERNAME --password-stdin
    ```

> `token.txt` you can add your Github token with read access to the packages

## Start

```sh
docker-pull && docker compose up -d
```

