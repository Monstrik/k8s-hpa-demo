#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx
LOADGEN=loadgen

echo "🔥 Clean up  ${APP}..."

# Clean up any existing load generator pod
kubectl delete pod ${LOADGEN} -n ${NAMESPACE} --ignore-not-found
