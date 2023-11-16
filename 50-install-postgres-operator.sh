#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh


# apply the manifests in the following order
./kubectl apply -f manifest/configmap.yaml  # configuration
./kubectl apply -f manifest/operator-service-account-rbac.yaml  # identity and permissions
./kubectl apply -f manifest/postgres-operator.yaml  # deployment
./kubectl apply -f manifest/api-service.yaml  # operator API to be used by UI

# https://fabianlee.org/2022/01/27/kubernetes-using-kubectl-to-wait-for-condition-of-pods-deployments-services/
echo waiting for operator to get Ready

# ./kubectl rollout status --namespace mynamespace deployment/mydeploymentname --timeout=600s
./kubectl rollout status                         deployment/postgres-operator --timeout=600s
# ./kubectl wait pods -l name=postgres-operator --for condition=Ready

# Deploy the operator UI
envsubst < manifest/ui/manifests/ingress.yaml.tpl > manifest/ui/manifests/ingress.yaml
./kubectl apply -k manifest/ui/manifests/
# ./kubectl apply -k github.com/zalando/postgres-operator/ui/manifests

echo waiting for operator-ui to get Ready
./kubectl rollout status                         deployment/postgres-operator-ui --timeout=600s

#echo  ./kubectl port-forward svc/postgres-operator-ui 8081:80 --address='0.0.0.0' \&
#./kubectl port-forward svc/postgres-operator-ui 8081:80 --address='0.0.0.0' &
#echo http://$(get-primary-ip):8081
#sensible-browser echo http://$(get-primary-ip):8081
echo http://${DNS_DOMAIN}:8123/

