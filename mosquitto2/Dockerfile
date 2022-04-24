ARG BUILD_FROM
FROM $BUILD_FROM

# Install mosquitto + auth plugin
WORKDIR /usr/src
ARG MOSQUITTO_GO_AUTH_VERSION
RUN apk add --no-cache \
        mosquitto \
        nginx \
        pwgen \
        openssl \
        go

# Copy rootfs
COPY rootfs /

WORKDIR /