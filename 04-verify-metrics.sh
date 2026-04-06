#!/usr/bin/env bash
set -e

echo "🔍 Verifying metrics-server Pod status..."
kubectl get pods -n kube-system | grep metrics-server

echo
echo "🔍 Verifying Metrics APIService..."
kubectl get apiservice v1beta1.metrics.k8s.io

echo
echo "⏳ Waiting for metrics to become available..."
until kubectl top nodes >/dev/null 2>&1; do
  echo "  ⏳ Metrics not available yet, waiting..."
  sleep 5
done

echo
echo "✅ Metrics are now available."

echo
echo "🔍 Node metrics:"
kubectl top nodes

echo
echo "🔍 Pod metrics in demo namespace:"
kubectl top pods -n test

echo
echo "✅ Metrics validation complete."