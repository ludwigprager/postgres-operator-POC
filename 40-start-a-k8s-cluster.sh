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

# ./k3d cluster create $CLUSTER \
#   --config k3d-config/$CLUSTER.yaml \
#   --wait

#   k3d cluster create \
#     $CLUSTER \
#     --k3s-arg "--disable=traefik@server:*" \
#     --port ${INGRESS_PORT}:80 \
#     --wait

#   k3d cluster create $CLUSTER \
#     --api-port 6550 -p "${INGRESS_PORT}:80@loadbalancer" \
#     --agents 2

    ./k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" --agents 2 $CLUSTER

  fi

#kube-system   coredns                  0/1     1            0           36s
#kube-system   metrics-server           0/1     1            0           35s
#kube-system   local-path-provisioner

#./kubectl rollout status        -n kube-system         deployment/coredns --timeout=600s
#./kubectl rollout status        -n kube-system         deployment/metrics-server --timeout=600s
#./kubectl rollout status        -n kube-system         deployment/local-path-provisioner --timeout=600s
#./kubectl rollout status        -n kube-system         deployment/traefik --timeout=600s

#./kubectl wait --for=condition=complete --timeout=30s job/myjob 

echo waiting for traefik jobs to complete
./kubectl wait -n kube-system job.batch/helm-install-traefik-crd --for=condition=complete --timeout=600s
./kubectl wait -n kube-system job.batch/helm-install-traefik     --for=condition=complete --timeout=600s
