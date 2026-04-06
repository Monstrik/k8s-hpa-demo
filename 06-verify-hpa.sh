#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx

echo "🔥 get hpa"

kubectl get hpa -n ${NAMESPACE} -w

