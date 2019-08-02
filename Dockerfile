ARG BUILD_CONTAINER="golang:1.12.7-alpine3.10"
ARG RELEASE_CONTAINER="alpine:3.10.1"
ARG BUILD_VERSION
ARG CONTAINER_USER="itavy"
ARG CONTAINER_MAINTAINER="itavyg@gmail.com"

# build stage
FROM ${BUILD_CONTAINER} AS build


RUN apk update \
    && apk upgrade \
    && apk add --no-cache git make \
    && mkdir /app \
    && mkdir /app/bin


COPY . /app/

WORKDIR /app

RUN unset GOPATH \
  && git checkout -- .gitignore Dockerfile bin/.gitignore \
  && make build


##release stage
FROM ${RELEASE_CONTAINER}

LABEL maintainer="${CONTAINER_MAINTAINER}" \
    version="${BUILD_VERSION}"

COPY --from=build /app/bin/release-plan /usr/local/bin/release-plan

RUN apk update \
    && apk upgrade \
    && apk add --no-cache git \
    && adduser -D ${CONTAINER_USER}

USER ${CONTAINER_USER}

WORKDIR "/home/${CONTAINER_USER}"

