kubectl delete deployment metrics-server -n kube-system --ignore-not-found
kubectl delete service metrics-server -n kube-system --ignore-not-found
kubectl delete apiservice v1beta1.metrics.k8s.io --ignore-not-found

