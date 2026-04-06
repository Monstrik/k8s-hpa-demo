# Kubernetes HPA Demo — Notes

## Demo Goal (What you are proving)

This lab demonstrates **real Kubernetes CPU‑based autoscaling** using:

*   ✅ Horizontal Pod Autoscaler (HPA)
*   ✅ metrics‑server
*   ✅ A Deployment with CPU requests
*   ✅ A controlled CPU workload

**Important idea:**

> Kubernetes scales based on **measured resource usage**, not traffic or requests.

***

## Step 0 — Environment Verification

### What happens

We verify that:

*   Kubernetes is reachable
*   Minikube is running
*   Docker is pointed at Minikube

### Why it matters

Kubernetes can only use container images that exist inside its environment.

### Key terms

*   **Minikube**: Local single‑node Kubernetes cluster
*   **Docker daemon**: Component that builds and stores container images

***

## Step 1 — Create a Namespace

### What happens

We create a separate namespace called `test`.

### Why it matters

Namespaces isolate resources and make cleanup easier.

### Key terms

*   **Namespace**: Logical partition inside a Kubernetes cluster

***

## Step 2 — Deploy NGINX (Workload)

### What happens

We deploy NGINX from **Microsoft Container Registry (MCR)** with CPU requests.

### Why it matters

HPA requires CPU **requests** to calculate utilization.

### Key terms

*   **Deployment**: Ensures Pods are running and self‑healing
*   **Pod**: Smallest schedulable unit in Kubernetes
*   **imagePullPolicy**:
    *   `IfNotPresent`: Pull only if missing locally
*   **CPU request**: Guaranteed CPU baseline for scheduling
*   **CPU limit**: Maximum CPU container can use

***

## Step 3 — Install metrics‑server (Offline)

### What happens

We install **metrics‑server using a locally built image**.

### Why it matters

metrics‑server provides the metrics that HPA depends on.
Public registries are not available in many enterprise environments.

### Key terms

*   **metrics‑server**: Collects CPU and memory usage
*   **ImagePullPolicy: Never**: Do not contact external registries
*   **APIService**: Registers metrics API (`metrics.k8s.io`)

***

## Step 4 — Verify Metrics

### What happens

We check:

```bash
kubectl top nodes
kubectl top pods
```

### Why it matters

If `kubectl top` does not work, **HPA cannot work**.

There is a short warm‑up period after metrics‑server starts.

### Key terms

*   **kubectl top**: Displays resource metrics
*   **Warm‑up period**: Metrics are not available immediately

***

## Step 5 — Create the HPA

### What happens

We create an autoscaling/v2 HPA targeting NGINX.

### What the HPA is watching

*   CPU utilization of **nginx Pods**
*   Target: **50%**
*   Min replicas: **1**
*   Max replicas: **10**

### Key terms

*   **HPA (Horizontal Pod Autoscaler)**: Adjusts replicas based on metrics
*   **scaleTargetRef**: Resource that HPA scales
*   **averageUtilization**: CPU usage as % of requested CPU

***

## Step 6 — Burn CPU Inside NGINX (Trigger Scaling)

### What happens

We execute a busy loop **inside the nginx Pod**:

```bash
kubectl exec deploy/nginx -- sh -c 'while true; do :; done'
```

### Why it matters

HPA only sees **CPU usage of the target Pods**.
Burning CPU elsewhere does NOT trigger scaling.

### Key terms

*   **kubectl exec**: Run a command inside a container
*   **Busy loop**: Artificial CPU workload
*   **Target Pods**: Only Pods defined in `scaleTargetRef`

***

## Step 7 — Observe Autoscaling

### What happens

*   CPU usage rises above 50%
*   HPA increases replicas
*   New Pods are created automatically

### What does NOT happen

*   Kubernetes does **not** redistribute the busy loop
*   Only one Pod is consuming CPU
*   New Pods are idle

### Key concept (very important)

> HPA **changes replica count**, it does **not balance work**.

***

## Step 8 — Stop Load and Observe Scale‑Down

### What happens

After stopping the busy loop:

*   CPU drops to near zero
*   HPA waits before scaling down
*   Replicas reduce back to 1

### Why scale‑down is slow

Kubernetes intentionally delays scale‑down to:

*   Prevent flapping
*   Maintain stability

### Key terms

*   **Stabilization window**: Delay before scaling down
*   **Autoscaling lag**: Expected behavior

***

## Cleanup

### What happens

We remove:

*   HPA
*   Deployment
*   metrics‑server objects
*   Demo namespace

### Why it matters

Clean state ensures demos are repeatable.

***

# Key Lessons (Summary)

### Core truths You should remember

✅ HPA scales based on **resource metrics**, not requests  
✅ CPU requests are mandatory for CPU‑based HPA  
✅ Scaling and load balancing are separate concerns  
✅ Scale‑up is fast, scale‑down is intentionally slow  
✅ metrics‑server is required for HPA  
✅ `kubectl top` is the HPA “health check”

***

# One‑Sentence Mental Model

> **HPA adds capacity when Pods are busy, but it never moves the work.**

