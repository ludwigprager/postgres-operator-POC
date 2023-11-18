#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh


# create secret before database
./kubectl create secret generic \
  postgres.acid-minimal-cluster.credentials.postgresql.acid.zalan.do \
  --from-literal=username=postgres \
  --from-literal=password=geheim \
  --dry-run=client -o yaml | ./kubectl apply -f -


./kubectl apply -f manifest/minimal-postgres-manifest.yaml

while [ $(./kubectl get postgresql.acid.zalan.do/acid-minimal-cluster \
                    -o jsonpath='{.status.PostgresClusterStatus}') == 'Creating' \
      ]; do
  echo waiting for postgres-cluster to get 'Running'
  sleep 10
  ./kubectl get --no-headers po
  ./kubectl get --no-headers statefulset.apps/acid-minimal-cluster
  ./kubectl get --no-headers postgresql.acid.zalan.do
  echo
done


# apply patch to enable 'rollout status':
./kubectl patch sts acid-minimal-cluster --patch-file patch-file.yaml
./kubectl rollout status --watch --timeout=600s statefulset/acid-minimal-cluster

