#!/usr/bin/env bash
set -e

echo "🔍 Verifying metrics-server Pod status..."
kubectl get pods -n kube-system | grep metrics-server

echo
echo "🔍 Verifying Metrics APIService..."
kubectl get apiservice v1beta1.metrics.k8s.io

echo
echo "🔍 Checking node metrics..."
kubectl top nodes

echo
echo "🔍 Checking pod metrics in demo namespace..."
kubectl top pods -n test

echo
echo "✅ Metrics validation complete."