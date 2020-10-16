#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Matrix
# Configures the Matrix Synapse server
# ==============================================================================
readonly CONF="/opt/server/app/config.yaml"
declare -A confs

#     python3 -m synapse.app.homeserver \
#         --server-name "$server_name" \
#         --config-path /data/matrix/matrix.yaml \
#         --generate-config \
#         --generate-keys \
#         --keys-directory /data/matrix \
#         --report-stats=no

#     mv /data/matrix/matrix.yaml "${CONF}"

#     yq delete --inplace "${CONF}" 'listeners[1]'



if bashio::fs.file_exists "${CONF}"; then
    bashio::log.info "CONF found"
    if bashio::config.has_value 'mqtt'; then
        bashio::log.info "Writing config to yaml"
        # server=$(bashio::config "mqtt.server")
        # username=$(bashio::config "mqtt.username")
        # password=$(bashio::config "mqtt.password")
        # client_id=$(bashio::config "mqtt.client_id")
        # sed -i "s/{mqtt_server_}/server/g" CONF
        # sed -i "s/{mqtt_username_}/server/g" CONF
        # sed -i "s/{mqtt_password_}/server/g" CONF
        # sed -i "s/{mqtt_client_id_}/server/g" CONF
        
        confs=(
            [%%mqtt_server%%]=$(bashio::config "mqtt.host")
            [%%mqtt_username%%]=$(bashio::config "mqtt.username")
            [%%mqtt_password%%]=$(bashio::config "mqtt.password")
            [%%mqtt_client_id%%]=$(bashio::config "mqtt.client_id")
            [%%mqtt_port%%]=$(bashio::config "mqtt.port")
        )

        for i in "${!confs[@]}"
        do
            bashio::log.info "configuring 1 element"
            search=$i
            replace=${confs[$i]}
            bashio::log.info "Searching for"
            bashio::log.info ${search}
            bashio::log.info "Replacing with"
            bashio::log.info ${replace}
            # Note the "" after -i, needed in OS X
            sed -i "s/${search}/${replace}/g" /opt/server/app/config.yaml
        done
    fi  
fi


        # "server": "str",
        # "username": "str",
        # "password": "str",
        # "client_id": "str"