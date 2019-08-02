ARG CONTAINER_GO_BUILD="golang:1.12.7-alpine3.10"
ARG CONTAINER_RELEASE_SUPPORT="alpine:3.10.1"
ARG BUILD_VERSION
ARG CONTAINER_USER="itavy"
ARG CONTAINER_MAINTAINER="itavyg@gmail.com"

# build stage
FROM ${CONTAINER_GO_BUILD} AS build

RUN apk update \
    && apk upgrade \
    && apk add --no-cache git make \
    && mkdir /app \
    && mkdir /app/bin


COPY . /app/

WORKDIR /app

RUN unset GOPATH \
  && make build

ARG CONTAINER_RELEASE_SUPPORT

##release stage
FROM ${CONTAINER_RELEASE_SUPPORT}

ARG BUILD_VERSION
ARG CONTAINER_USER
ARG CONTAINER_MAINTAINER

LABEL maintainer="${CONTAINER_MAINTAINER}" \
    version="${BUILD_VERSION}"

COPY --from=build /app/bin/* /usr/local/bin/*

RUN apk update \
    && apk upgrade \
    && apk add --no-cache git \
    && adduser -D ${CONTAINER_USER}

USER ${CONTAINER_USER}

WORKDIR "/home/${CONTAINER_USER}"

