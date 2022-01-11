#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KDIR="$(cd ../ && pwd )"
WKDIR="/go/src/github.com/kubernetes"

# download latest helm
${DIR}/download-helm.sh

#-------------------------------------------------------
# modify this section for each environment or condition

export K8S_DASHBOARD_CONTAINER_NAME="k8s-dashboard-dev"
export K8S_DASHBOARD_SRC=${KDIR}/dashboard
export K8S_DASHBOARD_CMD=$*
export K8S_DASHBOARD_BIND_ADDRESS="0.0.0.0"
export K8S_DASHBOARD_PORT=20443
export DOCKER_RUN_OPTS="-v ${HOME}/.git-credentials:/home/user/.git-credentials -v ${DIR}/update_master.sh:${WKDIR}/update_master.sh -v ${KDIR}/helm:${WKDIR}/helm -e NODE_OPTIONS=--max-old-space-size=6144"
export K8S_DASHBOARD_NPM_CMD=${K8S_DASHBOARD_NPM_CMD:-""}

# Start up dashboard development container
cd ${K8S_DASHBOARD_SRC}
aio/develop/run-npm-on-container.sh
