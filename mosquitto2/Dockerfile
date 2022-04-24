ARG BUILD_FROM
FROM $BUILD_FROM

# Install mosquitto + auth plugin
WORKDIR /usr/src
ARG MOSQUITTO_GO_AUTH_VERSION
RUN apk add --no-cache \
        mosquitto \
        nginx \
        pwgen \
        go
# RUN apk add --no-cache --virtual .build-dependencies \
#         build-base \
#         git \
#         mosquitto-dev \
#         openssl-dev
# RUN git clone --depth 1 -b "${MOSQUITTO_GO_AUTH_VERSION}" https://github.com/iegomez/mosquitto-go-auth \
#         && cd mosquitto-go-auth \
#         && make \
#         && mkdir -p /usr/share/mosquitto \
#         && cp -f go-auth.so /usr/share/mosquitto \
#         && apk del .build-dependencies

# Copy rootfs
COPY rootfs /

WORKDIR /