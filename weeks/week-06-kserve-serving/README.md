# Week 06 — Model serving on EKS (KServe)  `[infra]`  ⭐ work-aligned

> Maps to your 2026 LLM-gateway goal — worth extra polish. Put the Week-4 model on EKS behind KServe with real serving observability.

## Objectives
- [ ] KServe / Triton; the `InferenceService` model; cold-start + model-load realities
- [ ] **Build:** Week-4 model on EKS behind KServe + Grafana dashboard (TTFT, tokens/sec, GPU mem, queue depth via DCGM exporter)

## The build (infra → Argo CD)
Fill in the existing `clusters/learning/manifests/vllm/` (and `apps/vllm.yaml` is already scaffolded):
- KServe install (controller + dependencies) as its own Application, or reuse a serving-runtime.
- An `InferenceService` (or `ServingRuntime` + `InferenceService`) running **vLLM** serving the small open-weight model from Week 4, requesting `nvidia.com/gpu: 1` on the Week-5 GPU NodePool.
- A **Grafana dashboard** (commit the dashboard JSON/ConfigMap) showing TTFT, tokens/sec, GPU memory (DCGM), and queue depth from vLLM's `/metrics`.
- Confirm scale-to-zero behaviour and note cold-start (model-load) time.

> Reuse the Week-4 model + numbers. ⭐ Polish the dashboard — you'll demo this layer at work.

## How to study (≈8h)
- kserve.github.io: `InferenceService` spec, vLLM/Triton runtimes, autoscaling basics (sets up Week 10).
- Wire vLLM `/metrics` + DCGM exporter into Prometheus; build the dashboard.
- Measure cold start: scale to zero, send one request, time first response.

## End-of-week test
```bash
bash weeks/week-06-kserve-serving/test.sh
```
Checks the InferenceService + dashboard in git; optionally verifies it's Ready and serving; quizzes cold-start and the serving metrics that matter.
