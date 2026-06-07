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

## End-of-week test
```bash
bash weeks/week-05-gpu-on-k8s/test.sh
```
Checks the operator manifests + Application + a GPU resource request in git; optionally verifies GPU capacity / DCGM on a live node; quizzes MIG vs time-slicing vs DRA.
