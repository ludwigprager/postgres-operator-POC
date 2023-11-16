#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh


# install k3d
if [[ ! -f ./k3d ]]; then
  export K3D_INSTALL_DIR=${BASEDIR:-$(pwd)}
  export USE_SUDO='false'
  export PATH=$PATH:${BASEDIR} # k3d install fails otherwise
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
fi

# install kubectl
if [[ ! -f ./kubectl ]]; then
  KUBECTL_VERSION=1.28.3
  curl -LO https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
  chmod +x kubectl
fi


#or cluster in $CLUSTERS; do
  if ! cluster-exists $CLUSTER; then

  envsubst < k3d-config/${CLUSTER}.yaml.tpl > k3d-config/${CLUSTER}.yaml

# ./k3d cluster create $CLUSTER \
#   --config k3d-config/$CLUSTER.yaml \
#   --wait 

# ./k3d cluster create $CLUSTER --k3s-server-arg '--no-deploy=traefik'  \
#   --volume "$(pwd)/manifest/helm-ingress-nginx.yaml:/var/lib/rancher/k3s/server/manifests/helm-ingress-nginx.yaml"

  ./k3d cluster create $CLUSTER \
    --config k3d-config/$CLUSTER.yaml \
    --wait

  fi

#my-kubectl apply -f manifest/namespace.yaml

## create endpoint in cluster pointing to my primary IP address
#export PRIMARY_IP=$(get-primary-ip)
#envsubst < manifest/external-service.yaml.tpl > manifest/external-service.yaml
#my-kubectl apply -nargocd -f manifest/external-service.yaml

#done



