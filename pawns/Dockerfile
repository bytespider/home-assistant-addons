# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
RUN curl -sSLf -o /usr/bin/pawns-cli \
    "https://download.iproyal.com/pawns-cli/latest/linux_${BUILD_ARCH}/pawns-cli" && chmod +x /usr/bin/pawns-cli

# Copy root filesystem
COPY rootfs /