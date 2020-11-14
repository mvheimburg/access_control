ARG BUILD_FROM=hassioaddons/ubuntu-base:5.2.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}


# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update \
    \
    && apt install -y --no-install-recommends \
        git \
        openssl \
        libnginx-mod-http-lua \
        luarocks \
        npm \
        nginx \

    \
    && luarocks install lua-resty-http 0.15-0 


RUN ls
RUN mkdir -p /opt/web 
RUN git clone \
    https://github.com/mvheimburg/access_control_node.git /opt/web \
    \
    && cd /opt/web \
    && npm install \
      --no-optional \
      --only=production \
    \
    && npm cache clear --force \
    \
    && rm -fr \
        /tmp/* \
        /opt/web/.git \
        /etc/nginx


RUN \
    apt update \
    \
    && apt install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-dev 
    # python3-pip

# RUN ls
# RUN ls
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 

RUN mkdir -p /opt/server
RUN git clone \
    https://github.com/mvheimburg/access_control_server.git /opt/server \
    # \
    && cd /opt/server \
    && pip3 install --no-cache-dir -r requirements.txt
    # \
    # && python --version \

# RUN pip3 install -U \
#     pip

# RUN pip3 install --no-cache-dir -r requirements.txt


# Copy root filesystem
# RUN ls
WORKDIR /opt
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
