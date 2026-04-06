#!/usr/bin/env bash
set -e

echo "🚀 Installing metrics-server (OFFLINE mode)..."

NAMESPACE=kube-system
APP=metrics-server
IMAGE=metrics-server-local:1

# Deploy metrics-server
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP}
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: ${APP}
  template:
    metadata:
      labels:
        k8s-app: ${APP}
    spec:
      containers:
      - name: ${APP}
        image: ${IMAGE}
        imagePullPolicy: Never
        args:
        - --secure-port=4443
        - --cert-dir=/tmp
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
        ports:
        - containerPort: 4443
EOF

# Service
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ${APP}
  namespace: ${NAMESPACE}
spec:
  selector:
    k8s-app: ${APP}
  ports:
  - port: 443
    targetPort: 4443
EOF

# Register Metrics API
kubectl apply -f - <<EOF
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.metrics.k8s.io
spec:
  group: metrics.k8s.io
  version: v1beta1
  service:
    name: ${APP}
    namespace: ${NAMESPACE}
  insecureSkipTLSVerify: true
  groupPriorityMinimum: 100
  versionPriority: 100
EOF

echo "✅ metrics-server deployed in OFFLINE mode."
