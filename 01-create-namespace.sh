#!/usr/bin/env bash
set -e

echo "🚀 Creating demo namespace: test"

kubectl get ns test >/dev/null 2>&1 || kubectl create namespace test

echo "✅ Namespace status:"
kubectl get ns test