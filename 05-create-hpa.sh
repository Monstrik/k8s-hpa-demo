#!/usr/bin/env bash
set -e

NAMESPACE=test
APP=nginx

echo "⚖️ Creating HorizontalPodAutoscaler for ${APP}..."

kubectl apply -f - <<EOF
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ${APP}
  namespace: ${NAMESPACE}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ${APP}
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
EOF

echo "✅ HPA created."
echo
echo "📌 Current HPA status:"
kubectl get hpa -n ${NAMESPACE}
