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


#export PGPASSWORD=$(kubectl get secret postgres.acid-minimal-cluster.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d)
#export PGSSLMODE=require
#psql -U postgres

export PGMASTER=$(kubectl get pods -o jsonpath={.items..metadata.name} -l application=spilo,cluster-name=acid-minimal-cluster,spilo-role=master -n default)

kubectl port-forward $PGMASTER 6432:5432 -n default &

FOO_PID=$!



export PGPASSWORD=$(kubectl get secret postgres.acid-minimal-cluster.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d)
export PGSSLMODE=require
#psql -U postgres -h localhost -p 6432
my-psql -U postgres -h localhost -p 6432


