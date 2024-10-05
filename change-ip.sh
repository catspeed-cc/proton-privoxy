#!/usr/bin/env sh

. ./config.cfg

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