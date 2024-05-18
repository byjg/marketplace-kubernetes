#!/bin/sh

set -e

################################################################################
# repo
################################################################################
helm repo add byjg https://opensource.byjg.com/helm > /dev/null 2>&1
helm repo update > /dev/null 2>&1

################################################################################
# Pre-requisites
################################################################################

# Check if there is any node with the label "easyhaproxy/node=master"
master_node_exists=$(kubectl get nodes --selector=easyhaproxy/node=master -o jsonpath='{.items[*].metadata.name}')

# If there is no node with the label, then label the first node
if [ -z "$master_node_exists" ]; then
    masternode=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
    kubectl label nodes $(masternode) "easyhaproxy/node=master" --overwrite
fi

################################################################################
# chart
################################################################################
STACK="ingress"
CHART="byjg/easyhaproxy"
CHART_VERSION="0.1.7"
NAMESPACE="easyhaproxy"

helm upgrade --install "$STACK" "$CHART" \
    --namespace "$NAMESPACE" \
    --create-namespace \
    --set resources.requests.cpu=100m \
    --version "$CHART_VERSION" \
    --set resources.requests.memory=128Mi
