#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR


source ./functions.sh
source ./set-env.sh

FOO_PID=""
function finish {
  echo killing $FOO_PID
  kill $FOO_PID
}
trap finish EXIT


kubectl apply -f manifest/minimal-postgres-manifest.yaml

kubectl get all |grep acid

echo sleeping for 10s to wait for statefulset/acid-minimal-cluster to appear
sleep 10

kubectl patch sts acid-minimal-cluster --patch-file patch-file.yaml

#echo waiting for cluster to get 'Running'
#kubectl wait --for=condition=running postgresql.acid.zalan.do/acid-minimal-cluster --timeout=300s
#echo waiting for statefulset to get 'Ready'
#kubectl wait --for=condition=Ready statefulset/acid-minimal-cluster --timeout=300s
#kubectl wait --for=condition=available status statefulset/acid-minimal-cluster --timeout=300s

kubectl rollout status --watch --timeout=600s statefulset/acid-minimal-cluster



export PGMASTER=$(kubectl get pods -o jsonpath={.items..metadata.name} -l application=spilo,cluster-name=acid-minimal-cluster,spilo-role=master -n default)

echo PGMASTER: $PGMASTER
kubectl port-forward $PGMASTER 6432:5432 -n default &

FOO_PID=$!

export PGPASSWORD=$(kubectl get secret postgres.acid-minimal-cluster.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d)
export PGSSLMODE=require
psql -U postgres -h localhost -p 6432
#my-psql -U postgres -h localhost -p 6432
