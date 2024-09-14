#!/bin/sh

rm -rf ctrl-management
git clone git@github.com:pycom/ctrl-management.git
cd ctrl-management
git checkout main
cp ../Dockerfile .
cp ../docker-entrypoint.sh .
chmod 755 docker-entrypoint.sh
version=$(jq ".version" package.json | sed -e 's/\"//g')

docker build . -t ctrl-management-dev:$version \
        --build-arg NODE_ENV="development" --build-arg APP_ENV="development"  \
        --build-arg DOCKER_DEV="true" --build-arg GITHUB_TOKEN="$GITHUB_TOKEN"

cd ..
rm -rf ctrl-management
# kubectl create secret docker-registry ghcr-login-secret --docker-server=https://ghcr.io \
#     --docker-username=brianlk --docker-password=$GITHUB_TOKEN \
#     --docker-email=brian.leung@sgwireless.com

# base64encode=$(echo -n "brianlk:$GITHUB_TOKEN"|base64)
# echo '{"auths":{"https://ghcr.io/":{"username":"USERNAME","password":"TOKEN","email":"brian.leungkp@gmail.com","auth":"AUTHTOKEN"}}}' | \
# sed -e 's/USERNAME/brianlk/' | sed -e "s/TOKEN/$GITHUB_TOKEN/" | sed -e "s/AUTHTOKEN/$base64encode/"


# docker run -d -e NODE_ENV="development" -e APP_ENV="development" -e DOCKER_DEV="true" pyauth:2.0.0


# docker run -d -e NODE_ENV="development" -e APP_ENV="development" -e DOCKER_DEV="true" pyauth:2.0.0

# docker push ghcr.io/sg-wireless/pyauth-dev:2.0.0

