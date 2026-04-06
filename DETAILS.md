# Kubernetes HPA Demo — Extended Notes (Concept‑First)

## 1. Minikube

### What it is

**Minikube** is a local Kubernetes cluster that runs on your laptop using a VM or container runtime.

### Why it exists

Running Kubernetes normally requires multiple machines. Minikube provides:

*   A real Kubernetes control plane
*   A single worker node
*   Full Kubernetes behavior (scheduler, HPA, networking)

### When to use it

*   Learning Kubernetes
*   Developing manifests
*   Testing autoscaling and scheduling behavior
*   Demos and workshops

### Important note

Minikube behaves like **production Kubernetes**, but with only **one node**, which makes resource limits easier to hit.

***

## 2. Namespace

### What it is

A **Namespace** is a logical boundary inside a Kubernetes cluster.

### Why it exists

Namespaces provide:

*   Resource isolation
*   Cleaner organization
*   Safer cleanup
*   Multi‑tenant support

### When to use it

Always use namespaces for:

*   Demos
*   Apps
*   Environments (dev / test / prod)

### Common mistake

> “Namespaces are security boundaries.”

They are **organizational**, not security‑enforced isolation by default.

***

## 3. Pod

### What it is

A **Pod** is the smallest runnable unit in Kubernetes.

It contains:

*   One or more containers
*   Shared network namespace
*   Shared storage

### Why it exists

Containers need:

*   A shared IP
*   Shared lifecycle
*   Shared volumes

Pods solve that.

### Critical rule

Pods are **ephemeral**:

*   They can be terminated at any time
*   They should not hold state

***

## 4. Deployment

### What it is

A **Deployment** manages a group of identical Pods.

It provides:

*   Self‑healing
*   Scaling
*   Rolling updates
*   Declarative management

### Why it exists

Humans should not manage Pods directly.

Deployments ensure:

*   Desired replica count is maintained
*   Failed Pods are recreated automatically

### When to use it

Use Deployments for:

*   Stateless services
*   Web servers
*   APIs
*   Background workers

### Key misconception

> “Deployment = pod”

❌ Deployment manages Pods  
✅ Pods are children of a Deployment

***

## 5. Service (ClusterIP)

### What it is

A **Service** provides a stable virtual IP and DNS name for Pods.

### Why it exists

Pods change:

*   IP addresses
*   Lifecycle
*   Count

Services provide:

*   Load balancing
*   Stable access point
*   Service discovery

### When to use ClusterIP

*   Internal communication
*   Microservices
*   In‑cluster traffic

### Important fact

Services **do not scale Pods** — they only distribute traffic.

***

## 6. Container Image

### What it is

A container image is a packaged filesystem + executable.

### Why we used Microsoft Container Registry (MCR)

*   Corporate environments often block Docker Hub
*   TLS inspection breaks public registries
*   MCR is commonly trusted in enterprise networks

### Key learning

> Image accessibility is an **infrastructure concern**, not a Kubernetes feature.

***

## 7. CPU Requests and Limits

### What they are

```yaml
resources:
  requests:
    cpu: 100m
  limits:
    cpu: 500m
```

### CPU **requests**

*   Used by the scheduler
*   Define “expected” CPU usage
*   Required for HPA

### CPU **limits**

*   Enforced by cgroups
*   Prevent runaway containers

### Why HPA needs requests

HPA computes:

    CPU utilization = actual usage / requested CPU

Without requests:

*   HPA cannot calculate percentages
*   Metrics become `<unknown>`

### Teaching phrase

> “CPU requests are not limits — they’re a baseline for decisions.”

***

## 8. metrics‑server

### What it is

A lightweight metrics collector.

It:

*   Talks to kubelets
*   Aggregates CPU and memory usage
*   Exposes metrics via `metrics.k8s.io` API

### Why it exists

Kubernetes core does **not** collect metrics by itself.

metrics‑server enables:

*   `kubectl top`
*   Horizontal Pod Autoscaler
*   Basic observability

### Important limitation

metrics‑server:

*   Is NOT Prometheus
*   Stores NO historical metrics
*   Gives near‑real‑time data only

***

## 9. APIService (metrics.k8s.io)

### What it is

An **APIService** registers an external API with Kubernetes.

### Why it exists

Some APIs (like metrics) are:

*   Implemented outside the core API server
*   Plugged in dynamically

### Without it

*   metrics‑server may run
*   But Kubernetes cannot find its API
*   HPA will not work

### Teaching phrase

> “Running is not enough. APIs must be registered.”

***

## 10. `kubectl top`

### What it is

A CLI view into metrics‑server data.

### Why it matters

If this command fails:

```bash
kubectl top pods
```

Then:

*   HPA will not work
*   Metrics are unavailable

### Warm‑up behavior

After starting metrics‑server:

*   Data appears after \~30–90 seconds
*   This delay is normal

***

## 11. Horizontal Pod Autoscaler (HPA)

### What it is

A controller that automatically changes replica count based on metrics.

### What it **does**

*   Reads resource metrics
*   Adjusts replica count
*   Reconciles desired state

### What it **does NOT do**

*   It does NOT move work
*   It does NOT balance CPU
*   It does NOT inspect traffic

### Teaching truth

> HPA reacts to symptoms, not causes.

***

## 12. HPA Target (scaleTargetRef)

```yaml
scaleTargetRef:
  kind: Deployment
  name: nginx
```

### What it means

HPA watches **only these Pods**.

### Important consequence

CPU usage in *any other pod*:

*   Is completely ignored
*   Will never trigger scaling

***

## 13. Average Utilization

```yaml
averageUtilization: 50
```

### What it means

Desired average CPU usage per Pod.

### How it’s calculated

    sum(pod CPU usage) / number of pods / cpu request

### Why averages matter

One overloaded Pod can:

*   Raise the average
*   Trigger scaling
*   Even if others are idle

***

## 14. `kubectl exec`

### What it does

Runs a command inside **one specific Pod**.

### Key clarification

When you run:

```bash
kubectl exec deploy/nginx -- sh
```

Kubernetes:

*   Picks **one** Pod
*   Executes **only there**

### Why CPU burn works

*   CPU is consumed by the target Pod
*   HPA metric rises
*   Scaling triggers correctly

***

## 15. Scale‑up vs Scale‑down Behavior

### Scale‑up

*   Fast
*   Aggressive
*   Seconds to react

### Scale‑down

*   Slow
*   Conservative
*   Default: \~5 minutes

### Why scale‑down is delayed

To prevent:

*   Pod thrashing
*   Connection instability
*   Rapid oscillation

### Teaching phrase

> “Scale up fast, scale down slow — by design.”

***

## 16. Cleanup

### Why cleanup matters

Leaving autoscaling resources:

*   Pollutes the cluster
*   Confuses future demos
*   Obscures results

### Good practice

Always clean:

*   HPA
*   Deployments
*   demo namespaces
*   custom controllers

***

# Final Mental Model (Most Important)

> **Kubernetes does not scale traffic.  
> It scales capacity based on measured resource usage.**

Everything else flows naturally from this.
