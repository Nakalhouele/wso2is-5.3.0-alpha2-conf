#!/bin/bash
###############################################################
# This script creates a new container
###############################################################



## PROXY settings
### Commande line:
# Add this options as parameters: -e PROXY <PROXY_URL>
### In Dockerfile: 
# ARG PROXY <PROXY_URL> 

set -x

# Includes
source $(dirname $0)/__configurations.sh
source $(dirname $0)/common.sh

image_id="${PRODUCT_NAME}:${PRODUCT_TAG}"
image_exists=$(docker images $image_id | wc -l)
CONTAINER_NAME=${PRODUCT_NAME}_${PRODUCT_TAG}

if [[ ${image_exists} -eq 2 ]]; then
    _info "Docker image \"${image_id}\" already exist."
else
    _error "Docker image \"${image_id}\" not found. Maybe you forgot build."
    read -rsp $'Press enter to continue...\n'
    exit -1
fi

## PROXY
#-t $image_id \
docker run --hostname "${PRODUCT_NAME}" \
      --name "$CONTAINER_NAME" -p 9443:9443 -p 9763:9763 -p 8000:8000 -p 10500:10500 \
      --env WSO2_ADMIN_USERNAME="superAdmin" --env WSO2_ADMIN_PASSWORD="password"\
      -v "${PRODUCT_NAME}_repository:/opt/wso2is-$PRODUCT_VERSION/repository"\
      -v "${PRODUCT_NAME}_git_sources:$GIT_SOURCE_DIR" -d "$image_id" $*


# Wait for user action ensure that action doned successfully
read -rsp $'Press enter to continue...\n'
exit 0