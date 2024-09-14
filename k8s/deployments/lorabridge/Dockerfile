FROM node:18.18.2-alpine
ARG NODE_ENV
ENV NODE_ENV=$NODE_ENV
ARG APP_ENV
ENV APP_ENV=$APP_ENV
ARG DOCKER_DEV
ENV DOCKER_DEV=$DOCKER_DEV
ARG GITHUB_TOKEN

WORKDIR /app
COPY . .
RUN echo "//npm.pkg.github.com/:_authToken=$GITHUB_TOKEN" >> .npmrc \
    && npm install
EXPOSE 3200 3201
ENTRYPOINT ["./docker-entrypoint.sh"]
