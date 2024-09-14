FROM node:18.18.2-alpine
ARG GITHUB_TOKEN
RUN echo "//npm.pkg.github.com/:_authToken=$GITHUB_TOKEN" >> ~/.npmrc
RUN apk add g++ make py3-pip
