#!/bin/bash

HELM_LATEST=$(curl -Ls https://github.com/helm/helm/releases | grep 'href="/helm/helm/releases/tag/v3.[0-9]*.[0-9]*\"' | sed -E 's/.*\/helm\/helm\/releases\/tag\/(v[0-9\.]+)".*/\1/g' | head -1)
echo "Helm latest version: ${HELM_LATEST}"

HELM_DOWNLOAD="/tmp/helm.tar.gz"
HELM_TMP="/tmp/helm"
curl -SsL https://get.helm.sh/helm-${HELM_LATEST}-linux-amd64.tar.gz -o ${HELM_DOWNLOAD}
mkdir -p ${HELM_TMP}
tar -xf ${HELM_DOWNLOAD} -C ${HELM_TMP}
mv ${HELM_TMP}/linux-amd64/helm ./

rm -fr ${HELM_DOWNLOAD}
rm -fr ${HELM_TMP}
