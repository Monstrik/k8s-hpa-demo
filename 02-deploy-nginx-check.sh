#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx
IMAGE=mcr.microsoft.com/azurelinux/base/nginx:1
echo
echo "📌 Pod status:"
kubectl get pods -n ${NAMESPACE}
echo
echo "📌 Service status:"
kubectl get svc -n ${NAMESPACE}