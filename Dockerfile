ARG BUILD_FROM=hassioaddons/base:8.0.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /opt


RUN apk add --no-cache \
        git \
        lua-resty-http \
        nginx-mod-http-lua \
        nginx \
        nodejs \
        npm \
        yarn \
        \
        && apk del --no-cache
    
RUN git clone \
      https://github.com/mvheimburg/access_control_node.git /opt \
    \
    && npm install \
      --no-optional \
      --only=production \
    \
    && npm cache clear --force \
    \
    && rm -fr \
        /tmp/* \
        /opt/.git \
        /etc/nginx
    





# Copy root filesystem
COPY rootfs /


# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Access Control" \
    io.hass.description="add-on to perform access control validation" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="mvheimburg" \
    org.opencontainers.image.title="Access Control" \
    org.opencontainers.image.description="add-on to perform access control validation" \
    org.opencontainers.image.vendor="NA" \
    org.opencontainers.image.authors="mvheimburg" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/hassio-addons/addon-example" \
    org.opencontainers.image.documentation="https://github.com/hassio-addons/addon-example/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
