#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx

echo "🔥 Burning CPU inside nginx pods (this WILL trigger HPA)..."
echo "Open Freelens or track with verify scripts (U WILL see the scaling and wait 5 min for descaling after stop)"
echo "Press Ctrl+C to stop and allow scale-down."

kubectl exec -n ${NAMESPACE} -it deploy/${APP} -- \
  sh -c 'while true; do :; done'