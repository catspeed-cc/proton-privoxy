#!/usr/bin/bash

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)

# Absolute path this script is in. /home/user/bin
export SCRIPT_PATH=`dirname $SCRIPT`

. ${SCRIPT_PATH}/config.cfg

sudo docker restart ${DOCKER_CONTAINER_NAME}

sleep 15

echo ""
ext_ip=$(curl -s https://ipinfo.io/ip)
echo "External IP: ${ext_ip}"
new_ip=$(curl -s --proxy http://${DOCKER_CONTAINER_IP}:8080/ https://ipinfo.io/ip)
echo "VPN IP: ${new_ip}"
echo ""

echo "Docker proxy running on http://${DOCKER_CONTAINER_IP}:8080"
echo "" 