#!/usr/bin/env bash

set -e
echo "✅ Starting minikube..."
minikube start

echo "✅ Checking kubectl connectivity..."
kubectl version --client

echo "✅ Checking minikube status..."
minikube status

echo "✅ Pointing Docker to minikube..."
eval $(minikube docker-env)

echo "✅ Verifying Docker daemon..."
docker info | grep "Name:"
