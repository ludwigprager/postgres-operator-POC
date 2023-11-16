#!/usr/bin/env bash


function cluster-exists() {
  local cluster_name=$1
  #local K3D=$(get-k3d-path)
  local K3D=${BASEDIR}/k3d

  # need a blank after name. Else prefix would work, too.
  COUNT=$(${K3D} cluster list | grep ^${cluster_name}\  | wc -l)
  if [[ $COUNT -eq 0 ]]; then
    # 1 = false
    return 1
  else
    # 0 = true
    return 0
  fi
}

export -f cluster-exists



#function my-k3d() {
#
#  docker run --rm \
#    -e KUBECONFIG=/work/kubeconfig \
#    --volume $(pwd)/:/work \
#    ${POC_IMAGE} \
#    k3d $*
#
#}
#export -f my-k3d


get-primary-ip() {
  # no hostname -I on macOS
  if [ "$(uname -o)" == Darwin ]; then
    local PRIMARY_IP=$(ifconfig en0 | awk '/inet / {print $2; }' | egrep -v 127.0.0.1 | head -1)
  else
    local PRIMARY_IP=$(hostname -I | cut -d " " -f1)
  fi
  printf ${PRIMARY_IP}
}
export -f get-primary-ip

function my-psql() {

#   -e PGHOST=${PGHOST} \
#   -e PGPORT=${PGPORT} \
  docker run --rm \
    -e PGMASTER=${PGMASTER} \
    -e PGPASSWORD=${PGPASSWORD} \
    -e PGSSLMODE=${PGSSLMODE} \
    --net=host \
    ${POC_IMAGE} \
    psql $*

}
export -f my-psql

