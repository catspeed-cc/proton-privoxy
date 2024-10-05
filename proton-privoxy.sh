#!/usr/bin/env sh

. ./config.cfg

echo ""
echo "Installing proton-privoxy"
echo ""

REPO_DIR=$PWD
echo "Repo dir '$REPO_DIR'"

sudo docker stop ${DOCKER_CONTAINER_NAME}
sudo docker rm ${DOCKER_CONTAINER_NAME}

echo ""
echo "Git pull, please wait..."
git pull

echo ""
echo "Building docker image, please wait..."
sudo docker build -t moolehsacat/proton-privoxy .

sudo docker network rm ${DOCKER_NETWORK_NAME}

sudo docker network create --subnet=${DOCKER_CONTAINER_SUBNET} ${DOCKER_NETWORK_NAME}

echo ""
echo "Running docker image, please wait..."
CONTAINER_ID=$(sudo docker run -d --net ${DOCKER_NETWORK_NAME} --ip ${DOCKER_CONTAINER_IP} --restart unless-stopped --device=/dev/net/tun --cap-add=NET_ADMIN -v /etc/localtime:/etc/localtime:ro -p 8888:8080 -e PVPN_USERNAME=${PVPN_LOGIN} -e PVPN_PASSWORD=${PVPN_PASS} -e PVPN_CMD_ARGS="${PVPN_CMD_ARGS}" --name ${DOCKER_CONTAINER_NAME} moolehsacat/proton-privoxy)
echo "Container ID: '${CONTAINER_ID}'"

sleep 15

echo ""
ext_ip=$(curl -s https://ipinfo.io/ip)
echo "External IP: ${ext_ip}"
new_ip=$(curl -s --proxy http://${DOCKER_CONTAINER_IP}:8080/ https://ipinfo.io/ip)
echo "VPN IP: ${new_ip}"
echo ""

echo "Docker proxy running on http://${DOCKER_CONTAINER_IP}:8080"
echo ""




