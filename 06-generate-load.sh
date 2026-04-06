#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx
LOADGEN=loadgen

echo "🔥 Generating load against ${APP}..."

# Clean up any existing load generator pod
kubectl delete pod ${LOADGEN} -n ${NAMESPACE} --ignore-not-found

# Small delay to ensure cleanup
sleep 2

# Start load generator
kubectl run ${LOADGEN} \
  -n ${NAMESPACE} \
  --image=mcr.microsoft.com/azurelinux/base/nginx:1 \
  --restart=Never -- \
  sh -c 'while true; do wget -q -O- http://nginx; done'

echo
echo "✅ Load generator started."
echo "📌 Watch autoscaling with:"
echo "  kubectl get hpa -n ${NAMESPACE} -w"
echo "  kubectl get pods -n ${NAMESPACE} -w"
