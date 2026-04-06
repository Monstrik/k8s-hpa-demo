# Kubernetes HPA Demo 

This repository contains a set of scripts to demonstrate Kubernetes Horizontal Pod Autoscaler (HPA) using a custom metrics server within a `minikube` environment.

## Prerequisites

- `kubectl`
- `minikube`
- `docker`

## Project Structure

The scripts are numbered sequentially to guide you through the process:

- `00-verify-env.sh`: Verifies that `kubectl`, `minikube`, and `docker` are correctly configured.
- `01-create-namespace.sh`: Creates a dedicated namespace for the HPA test.
- `02-deploy-nginx.sh`: Deploys an Nginx application with resource requests and limits.
- `02-deploy-nginx-check.sh`: Verifies the deployment of Nginx.
- `03-build-metrics-server-image.sh`: Builds a Docker image for the metrics server.
- `03-install-metrics-server-offline.sh`: Installs the metrics server in the cluster.
- `03-metrics-service-cleanup.sh`: Cleans up the metrics server resources.
- `04-verify-metrics.sh`: Verifies that metrics are being correctly collected.
- `05-create-hpa.sh`: Creates a Horizontal Pod Autoscaler for the Nginx deployment.
- `05-verify-hpa.sh`: Verifies the HPA configuration.
- `06-burn-cpu-inside-nginx.sh`: Generates CPU load inside one of the Nginx pods to trigger HPA.
- `06-verify-hpa.sh` & `06-verify-pods.sh`: Monitors the HPA status and pod scaling.
- `07-cleanup.sh`: Removes all resources created during the test.

## How to Run

1.  **Initialize the environment:**
    ```bash
    ./00-verify-env.sh
    ```
2.  **Follow the script sequence:** Run each script in numeric order to set up, test, and tear down the HPA demonstration.

## Files

- `Dockerfile.metrics-server`: Dockerfile used to build the metrics server image.
- `metrics-server`: The metrics server binary.
