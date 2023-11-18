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
trap finish INT TERM

export PGMASTER=$(./kubectl get pods -o jsonpath={.items..metadata.name} -l application=spilo,cluster-name=acid-minimal-cluster,spilo-role=master -n default)


USER=zalando
USER=backend
USER=postgres


export PGPASSWORD=$(./kubectl get secret ${USER}.acid-minimal-cluster.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d)
export PGSSLMODE=require


echo
env | grep '^PG'
echo

#psql -U backend -h localhost -p 6432
#my-psql -U postgres -h localhost -p 6432

# todo: test not working
#kubectl port-forward $PGMASTER 6432:5432 -n default &
#FOO_PID=$!
#wait-for-port-forward 6432
#pg_isready -U $USER -d neo -h localhost -p 6432

# bug psql + port-forward
# https://github.com/kubernetes/kubernetes/issues/111825

./kubectl port-forward $PGMASTER 6432:5432 -n default &
FOO_PID=$!
wait-for-port-forward 6432
psql -d postgres -U ${USER} -h localhost -p 6432 -c 'SELECT datname FROM pg_catalog.pg_database;'



./kubectl port-forward $PGMASTER 6432:5432 -n default &
FOO_PID=$!
wait-for-port-forward 6432

export PGPASSWORD="geheim"
psql -d postgres -U ${USER} -h localhost -p 6432 -c 'SELECT datname FROM pg_catalog.pg_database;'


echo test passed
