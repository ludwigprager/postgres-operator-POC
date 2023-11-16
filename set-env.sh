#!/usr/bin/env bash

export KUBECONFIG=${BASEDIR:-$(pwd)}/kubeconfig

#export INGRESS_PORT="8123"

#export CLUSTERS=""
#export CLUSTER_PREFIX="gpo-keycloak-"
#CLUSTERS="${CLUSTERS} ${CLUSTER_PREFIX}"
CLUSTER="postgres-operator-poc"

POC_IMAGE=postgres-operator-poc:1

export INGRESS_PORT="8123"

export HOSTALIASES=${BASEDIR:-$(pwd)}/hosts

export DNS_DOMAIN=domain.k3d
