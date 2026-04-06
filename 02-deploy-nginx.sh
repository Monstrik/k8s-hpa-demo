#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx
IMAGE=mcr.microsoft.com/azurelinux/base/nginx:1

echo "🚀 Deploying NGINX..."

# Create or update the Deployment
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
      app: ${APP}
  template:
    metadata:
      labels:
        app: ${APP}
    spec:
      containers:
      - name: ${APP}
        image: ${IMAGE}
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: "100m"
          limits:
            cpu: "500m"
EOF

# Expose the Deployment as a ClusterIP service
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ${APP}
  namespace: ${NAMESPACE}
spec:
  selector:
    app: ${APP}
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF

echo "✅ NGINX Deployment and Service created."
echo
echo "📌 Pod status:"
kubectl get pods -n ${NAMESPACE}
echo
echo "📌 Service status:"
kubectl get svc -n ${NAMESPACE}