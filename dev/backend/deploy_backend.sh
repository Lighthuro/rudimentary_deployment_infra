#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE}" )" >/dev/null 2>&1 && pwd )"
BACKEND_IMAGE_NAME=localhost/javadevcontainer
BACKEND_CONTAINER_NAME=javadevcontainer
HOST_PORT=2222


echo -e "${blue}Building backend container...${clear}"
podman build -f $SCRIPT_DIR/Dockerfile -t $BACKEND_IMAGE_NAME || exit 1
echo -e "${green}OK${clear}"

echo -e "${blue}Running container...${clear}"
podman container run -d --rm -p $HOST_PORT:22 -p 8081:8081 --name $BACKEND_CONTAINER_NAME $BACKEND_IMAGE_NAME || exit 1
echo -e "${green}OK${clear}"

echo -e "${blue}finalizing ssh configuration...${clear}"
podman cp $HOME/.ssh/authorized_keys $BACKEND_CONTAINER_NAME:/home/dev/.ssh/authorized_keys || exit 1
echo -e "${green}OK${clear}"
podman container ls | grep -zP " javadevcontainer"

echo -e "${green}Backend deployed${clear}"
exit 0