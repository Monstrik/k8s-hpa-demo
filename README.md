# Kubernetes HPA Demo

Quick demo of Kubernetes Horizontal Pod Autoscaler (HPA) using a custom metrics server in minikube.

## Prerequisites
- kubectl
- minikube
- docker

## Quick Start
Run each script in order:
1. 00-verify-env.sh
2. 01-create-namespace.sh
3. 02-deploy-nginx.sh
4. 02-deploy-nginx-check.sh
5. 03-build-metrics-server-image.sh
6. 03-install-metrics-server-offline.sh
7. 03-metrics-service-cleanup.sh
8. 04-verify-metrics.sh
9. 05-create-hpa.sh
10. 05-verify-hpa.sh
11. 06-burn-cpu-inside-nginx.sh
12. 06-verify-hpa.sh
13. 06-verify-pods.sh
14. 07-cleanup.sh
15. 08-stop-minikube.sh

## Key Points
- HPA scales pods based on CPU usage (not traffic).
- CPU requests are required for HPA.
- Scaling up is fast; scaling down is slow by design.
- `kubectl top` must show metrics for HPA to work.

**Mental model:** HPA adds pods when busy, but does not move work.

HPA only increases or decreases the number of pods based on resource usage (like CPU), but it does not redistribute or balance the actual workload (such as requests or CPU tasks) between pods. If one pod is overloaded and others are idle, HPA will add more pods, but it’s up to your application or a load balancer to distribute the work evenly among all pods. HPA only changes the number of pods, not how the work is assigned to them.
