#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx

echo "🔥 get pods ${APP}..."

kubectl get pods -n ${NAMESPACE} -w

kubectl get hpa -n test -w