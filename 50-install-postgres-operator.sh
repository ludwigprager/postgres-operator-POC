#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh


# apply the manifests in the following order
./kubectl apply -f manifest/configmap.yaml
./kubectl apply -f manifest/operator-service-account-rbac.yaml
./kubectl apply -f manifest/postgres-operator.yaml
./kubectl apply -f manifest/api-service.yaml

echo waiting for postgres operator to get Ready

./kubectl rollout status                         deployment/postgres-operator --timeout=600s

envsubst < manifest/ui/manifests/ingress.yaml.tpl > manifest/ui/manifests/ingress.yaml
./kubectl apply -k manifest/ui/manifests/

echo waiting for operator-ui to get Ready
./kubectl rollout status                         deployment/postgres-operator-ui --timeout=600s

echo http://$(get-primary-ip):8081/
#echo http://$(get-primary-ip):8081/postgres-operator-ui
