#!/usr/bin/env bash
set -e

IMAGE_NAME=metrics-server-local:1

echo "🚀 Building metrics-server image inside Minikube..."

# Ensure we are using Minikube's Docker daemon
eval $(minikube docker-env)

# Verify binary exists
if [ ! -f metrics-server ]; then
  echo "❌ ERROR: metrics-server binary not found in current directory"
  echo "👉 Make sure the Linux ARM64 metrics-server binary is present"
  exit 1
fi

# Create Dockerfile if it doesn't exist
cat <<EOF > Dockerfile.metrics-server
FROM scratch
COPY metrics-server /metrics-server
ENTRYPOINT ["/metrics-server"]
EOF

# Build image
docker build -t ${IMAGE_NAME} -f Dockerfile.metrics-server .

echo "✅ metrics-server image built: ${IMAGE_NAME}"

echo
echo "📌 Verifying image inside Minikube:"
minikube image ls | grep metrics-server
