#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIRECTORY="$SCRIPT_DIR/../.."
CMS_PATH="$ROOT_DIRECTORY/cms" 
BACKEND_IMAGE_NAME=localhost/javadevcontainer
BACKEND_CONTAINER_NAME=javadevcontainer
HOST_PORT=2222

if [ ! -f $CMS_PATH ]; then
    echo -e "${blue}Creating container management system (cms) symbolic link in $CMS_PATH ${clear}"
    (ln -s $(which docker) $CMS_PATH) 2> /dev/null || (ln -s $(which podman) $CMS_PATH) || (echo "No docker nor podman detected exiting" && exit 1)
fi

echo -e "${blue}Building backend container...${clear}"
$CMS_PATH build -f $SCRIPT_DIR/Dockerfile . -t $BACKEND_IMAGE_NAME || exit 1
echo -e "${green}OK${clear}"

echo -e "${blue}Running container...${clear}"
$CMS_PATH container run -d --rm -p $HOST_PORT:22 -p 8081:8081 --name $BACKEND_CONTAINER_NAME $BACKEND_IMAGE_NAME || exit 1
echo -e "${green}OK${clear}"

echo -e "${blue}finalizing ssh configuration...${clear}"
$CMS_PATH cp $HOME/.ssh/authorized_keys $BACKEND_CONTAINER_NAME:/home/dev/.ssh/authorized_keys || exit 1
$CMS_PATH container exec -u root javadevcontainer bash -c "chown dev /home/dev/.ssh/authorized_keys" || exit 1
echo -e "${green}OK${clear}"
$CMS_PATH container ls | grep -zP " javadevcontainer"

echo -e "${green}Backend deployed${clear}"
exit 0