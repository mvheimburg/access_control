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
    # \
    # && apt-get purge -y --auto-remove \
    #     dirmngr \
    #     gpg-agent \
    #     gpg \
    #     git \
    #     libffi-dev \
    #     libxml2-dev \
    #     libxslt1-dev \
    #     zlib1g-dev \
    #     build-essential \
    #     gcc \
    #     python-dev \
    #     dpkg-dev \
    #     gcc-7 \
    #     luarocks \
    # && rm -fr \
    #     /var/{cache,log}/* \
    #     /var/lib/apt/lists/* \
    #     /root/.cache \
    # && find /tmp/ -mindepth 1  -delete


# RUN \
#     apk add --no-cache --virtual .build-dependencies \
#         g++\
#         # gcc=9.3.0-r2 \
#         # libc-dev=0.7.2-r3 \
#         linux-headers \
#         build-base \
#         py3-pip \
#         python3-dev \
#     \
#     && apk add --no-cache \
#         git \
#         lua-resty-http \
#         nginx-mod-http-lua \
#         nginx  \
#         nodejs \
#         npm \
#         openssh-client \
#         # patch=2.7.6-r6 \
#         python3 \
#     \
#      && apk del --no-cache

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
    https://github.com/mvheimburg/access_control_server.git /opt/server
    # \
    # && cd /opt/server \
    # \
    # && python --version \

# RUN pip3 install -U \
#     pip

RUN pip3 install --no-cache-dir \
    # # # && pip install --no-cache-dir -r requirements.txt \  
    paho-mqtt \
    PyYAML \
    # six
    grpcio \
    grpcio_tools \
    yq




# Copy root filesystem
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
