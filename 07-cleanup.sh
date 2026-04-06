#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx

echo "🧹 Cleaning up HPA demo resources..."

echo "🗑 Deleting HPA (if exists)..."
kubectl delete hpa ${APP} -n ${NAMESPACE} --ignore-not-found

echo "🗑 Deleting Deployment and Service..."
kubectl delete deployment ${APP} -n ${NAMESPACE} --ignore-not-found
kubectl delete service ${APP} -n ${NAMESPACE} --ignore-not-found

echo "🗑 Deleting demo namespace (test)..."
kubectl delete namespace ${NAMESPACE} --ignore-not-found

echo
echo "🧹 Cleaning up metrics-server (offline install)..."

kubectl delete deployment metrics-server -n kube-system --ignore-not-found
kubectl delete service metrics-server -n kube-system --ignore-not-found
kubectl delete apiservice v1beta1.metrics.k8s.io --ignore-not-found

echo
echo "✅ Cleanup complete."
echo "📌 Notes:"
echo " - Minikube is still running"
echo " - Local images are preserved"
echo " - Ready for next demo run"