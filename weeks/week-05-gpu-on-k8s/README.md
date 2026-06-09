# Week 05 — GPU on Kubernetes  `[infra]`

> New ground. Get a GPU schedulable on EKS, scale-to-zero, and `nvidia-smi` from inside a pod.

## Objectives
- [ ] NVIDIA GPU Operator (driver, device plugin, DCGM)
- [ ] MIG vs time-slicing — when each fits
- [ ] DRA — what it is, why it's the direction
- [ ] **Build:** schedule a GPU pod on one EKS GPU node (Karpenter, scale-to-zero); `nvidia-smi` inside the pod

## The build (infra → Argo CD)
- `clusters/learning/manifests/gpu-operator/` — GPU Operator (Helm-source Application is cleanest), plus:
  - A **Karpenter NodePool/NodeClass** for a single small GPU instance (e.g. `g5`/`g6` family), `consolidation` + scale-to-zero so idle = no node.
  - A throwaway **GPU test pod** requesting `nvidia.com/gpu: 1` that runs `nvidia-smi`.
- `clusters/learning/apps/gpu-operator.yaml` — child Application (copy `apps/vllm.yaml`).

> ⚠️ **Cost:** the GPU NodePool MUST scale to zero when the test pod is gone. Verify the node terminates. Prefer Spot for the learning node.

## How to study (≈8h)
- docs.nvidia.com GPU Operator install on EKS; confirm DCGM exporter pod + `nvidia.com/gpu` capacity on the node.
- Read MIG vs time-slicing trade-offs; skim DRA (`DeviceClass`/`ResourceClaim`) as the future direction.
- `kubectl exec` into the GPU pod → `nvidia-smi`. Then delete it and watch Karpenter drain the node to zero.

## Learn & do — topic by topic

### 1 · NVIDIA GPU Operator (driver · device plugin · DCGM)
- **Read:** [GPU Operator overview](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/overview.html) · [Install on EKS](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/install-gpu-operator.html)
- **Hands-on:** install via Argo CD, then confirm `nvidia.com/gpu` shows in a node's `allocatable` and the DCGM exporter pod is running. Run a `nvidia-smi` pod requesting `nvidia.com/gpu: 1`.

### 2 · MIG vs time-slicing
- **Read:** [Time-slicing in the operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/gpu-sharing.html) · [MIG user guide](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/)
- **Hands-on:** enable time-slicing config (e.g. 2–4 replicas), schedule 2 pods on one physical GPU, confirm both run. Write one line each: when MIG (hard isolation) wins vs time-slicing (bursty/dev).

### 3 · DRA — Dynamic Resource Allocation
- **Read:** [k8s DRA](https://kubernetes.io/docs/concepts/scheduling-eviction/dynamic-resource-allocation/) · [NVIDIA DRA driver](https://github.com/NVIDIA/k8s-dra-driver)
- **Hands-on:** no install needed — write a short note: what `DeviceClass`/`ResourceClaim` express that the device-plugin `nvidia.com/gpu: N` count can't (fractional, topology, attributes).

### Build · Karpenter scale-to-zero
- **Read:** [Karpenter NodePools](https://karpenter.sh/docs/concepts/nodepools/) · [Disruption/consolidation](https://karpenter.sh/docs/concepts/disruption/)
- **Hands-on:** a GPU `NodePool` (g5/g6, prefer Spot) with consolidation. Submit the GPU pod → node appears; delete it → **watch the node terminate to zero**. Confirm `kubectl get nodes` has no GPU node at idle.

## End-of-week test
```bash
bash weeks/week-05-gpu-on-k8s/test.sh
```
Checks the operator manifests + Application + a GPU resource request in git; optionally verifies GPU capacity / DCGM on a live node; quizzes MIG vs time-slicing vs DRA.
