#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KDIR="$(cd ../ && pwd )"
WKDIR="/go/src/github.com/kubernetes"

#-------------------------------------------------------
# download latest helm

${DIR}/download-helm.sh

#-------------------------------------------------------
# minikube
KUBE_CLUSTER_HOST=${KUBE_CLUSTER_HOST:-"192.168.100.13"}
KUBE_USER=${KUBE_USER:-"kube"}
KUBE_CONFIG_ON_CLUSTER_HOST=/etc/kubernetes/admin.conf
API_HOST_PORT="control-plane.minikube.internal:8443"

# kubeconfig path to mount into dashboard container
export K8S_DASHBOARD_KUBECONFIG=${KDIR}/kubeconfig@${KUBE_CLUSTER_HOST}

# download kubeconfig from cluster
scp ${KUBE_USER}@${KUBE_CLUSTER_HOST}:${KUBE_CONFIG_ON_CLUSTER_HOST} ${K8S_DASHBOARD_KUBECONFIG}.org
sudo chown $USER ${K8S_DASHBOARD_KUBECONFIG}.org

# replace server URL on kubeconfig
sed -e "s/server: https:\/\/${API_HOST_PORT}/server: https:\/\/${KUBE_CLUSTER_HOST}:8443/g" ${K8S_DASHBOARD_KUBECONFIG}.org > ${K8S_DASHBOARD_KUBECONFIG}

#-------------------------------------------------------
# setup dashboard development container

export K8S_DASHBOARD_CONTAINER_NAME="k8s-dashboard-dev"
export K8S_DASHBOARD_SRC=${KDIR}/dashboard
#export K8S_DASHBOARD_DEBUG=true
export K8S_DASHBOARD_CMD=$*
export K8S_DASHBOARD_BIND_ADDRESS="0.0.0.0"
#export K8S_DASHBOARD_SIDECAR_HOST="http://192.168.100.13:8001/api/v1/namespaces/kubernetes-dashboard/services/dashboard-metrics-scraper:/proxy/"
export K8S_DASHBOARD_SIDECAR_HOST="http://192.168.100.13:30080/"
export K8S_DASHBOARD_PORT=20443
export DOCKER_RUN_OPTS="-v ${HOME}/.git-credentials:/home/user/.git-credentials -v ${DIR}/update_master.sh:${WKDIR}/update_master.sh -v ${KDIR}/helm:${WKDIR}/helm -e NODE_OPTIONS=--max-old-space-size=6144"
export K8S_DASHBOARD_NPM_CMD=${K8S_DASHBOARD_NPM_CMD:-"run start:https"}

# start up dashboard development container
cd ${K8S_DASHBOARD_SRC}
aio/develop/run-npm-on-container.sh
