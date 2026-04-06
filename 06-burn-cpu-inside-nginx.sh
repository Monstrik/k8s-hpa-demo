#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx

echo "🔥 Burning CPU inside nginx pods (this WILL trigger HPA)..."
echo "Press Ctrl+C to stop and allow scale-down."

kubectl exec -n ${NAMESPACE} -it deploy/${APP} -- \
  sh -c 'while true; do :; done'