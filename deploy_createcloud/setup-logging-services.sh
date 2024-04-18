#!/bin/bash

# This script is intended for setting up the MDENet Education Platform logging service
# for instances hosted on the KCL Create Cloud
#
# It should be run from the ubuntu user with sudo and the users 'ubuntu' and 'mdenet' should
# be created before running this script.

START_DIR="${PWD}"
SERVICE_INSTALL_PATH=/etc/systemd/system

# ---------------------
# Stats Page
# ---------------------
setupLogStats(){
    echo Installing stats logging...

    GEO_DB_GZ=dbip-city-lite-2024-04.mmdb.gz
    GEO_DB_URL=https://download.db-ip.com/free/${GEO_DB_GZ}
    LOG_TOOL_PATH=/home/ubuntu/logs
    REPORT_PAGE_PATH=/srv/www/ep-stats

    # Prepare install locations
    mkdir -p ${LOG_TOOL_PATH}
    mkdir -p ${LOG_TOOL_PATH}/db
    mkdir -p ${REPORT_PAGE_PATH}

    # Download and install GoAccess
    apt-get -qq update && apt-get -qq --yes install goaccess

    # Download geodb
    cd ${LOG_TOOL_PATH}
    wget -P ${GEO_DB_URL}
    gzip -d ${GEO_DB_GZ}
    cd $OLDPWD

    cp log-stats-realtime.sh ${LOG_TOOL_PATH}

    chown -R $SUDO_USER:$SUDO_USER ${LOG_TOOL_PATH}
    chown -R $SUDO_USER:$SUDO_USER ${REPORT_PAGE_PATH}

    # Install the service
    LOG_SCRIPT=${LOG_TOOL_PATH}/log-stats-realtime.sh envsubst < log-stats.service > ${SERVICE_INSTALL_PATH}/log-stats.service
    systemctl daemon-reload

    echo
    echo "Add the following line to the ubuntu users cron tab:"
    echo "0 * * * * sudo systemctl stop log-stats.service; /home/ubuntu/logs/log-stats-update.sh; sudo systemctl start log-stats.service"
    echo
}

startLogStats(){
    # Start service
    systemctl enable log-stats.service
    systemctl start log-stats.service
    echo Stats logging started.
}

# ---------------------
# Resource Monitoring
# ---------------------
setupResourceMonitoring(){
    echo Installing stats logging...
    RESOURCE_LOG_TOOL_PATH=/home/mdenet/tools
    MDENET_USER=mdenet
    
    # Prepare install location
     mkdir -p ${RESOURCE_LOG_TOOL_PATH}
    
    # Download and install prometheus and the node exorter
    cd ${RESOURCE_LOG_TOOL_PATH}
    
    PROMETHEUS_DIR_NAME=prometheus-2.51.2.linux-amd64
    wget https://github.com/prometheus/prometheus/releases/download/v2.51.2/${PROMETHEUS_DIR_NAME}.tar.gz
    tar -xzf ${PROMETHEUS_DIR_NAME}.tar.gz && rm ${PROMETHEUS_DIR_NAME}.tar.gz
    
    NODE_EXPORTER_DIR_NAME=node_exporter-1.7.0.linux-amd64
    wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/${NODE_EXPORTER_DIR_NAME}.tar.gz
    tar -xzf ${NODE_EXPORTER_DIR_NAME}.tar.gz && rm ${NODE_EXPORTER_DIR_NAME}.tar.gz
    
    cd ${START_DIR}
    cp ./config/prometheus.yml ${RESOURCE_LOG_TOOL_PATH}/${PROMETHEUS_DIR_NAME}


    # Install the services
    PROMETHEUS_PATH=${RESOURCE_LOG_TOOL_PATH}/${PROMETHEUS_DIR_NAME} envsubst < log-resources.service > ${SERVICE_INSTALL_PATH}/log-resources.service
    NODE_EXPORTER_PATH=${RESOURCE_LOG_TOOL_PATH}/${NODE_EXPORTER_DIR_NAME} envsubst < prometheus-exporter.service > ${SERVICE_INSTALL_PATH}/prometheus-exporter.service
    systemctl daemon-reload

    chown -R $MDENET_USER:$MDENET_USER ${RESOURCE_LOG_TOOL_PATH}    
}

startResourceMonitoring(){
    # Start services
    systemctl enable log-resources.service
    systemctl start log-resources.service
    
    systemctl enable prometheus-exporter.service
    systemctl start prometheus-exporter.service
    
    echo Resource monitoring started.
}


setupLogStats
startLogStats

setupResourceMonitoring
startResourceMonitoring

echo done.

