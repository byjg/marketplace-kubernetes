#!/bin/sh

set -e

################################################################################
# chart
################################################################################
STACK="ingress"
NAMESPACE="easyhaproxy"


helm uninstall "$STACK" \
  --namespace "$NAMESPACE"
