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

## Learn & do — topic by topic

### 1 · KServe / Triton + the InferenceService model
- **Read:** [KServe docs](https://kserve.github.io/website/latest/) · [InferenceService concept](https://kserve.github.io/website/latest/modelserving/control_plane/) · [vLLM/HF runtime](https://kserve.github.io/website/latest/modelserving/v1beta1/llm/huggingface/)
- **Hands-on:** install KServe via Argo CD; deploy an `InferenceService` running vLLM for the Week-4 model, requesting `nvidia.com/gpu: 1` on the Week-5 NodePool. Hit its OpenAI-compatible endpoint and confirm Ready.

### 2 · Cold-start & model-load realities
- **Read:** [KServe autoscaling / scale-to-zero](https://kserve.github.io/website/latest/modelserving/autoscaling/autoscaling/)
- **Hands-on:** scale to zero, send one request, and **time the cold start**. Break it down: node spin-up vs image pull vs model load. Note which dominates for a 7B model.

### 3 · Serving observability (the dashboard)
- **Read:** [vLLM metrics](https://docs.vllm.ai/en/latest/serving/metrics.html) · [DCGM exporter](https://github.com/NVIDIA/dcgm-exporter) · [Grafana provisioning](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/)
- **Hands-on:** scrape vLLM `/metrics` + DCGM into Prometheus; build (and commit as JSON/ConfigMap) a dashboard with **TTFT, tokens/sec, GPU memory, queue depth**. Watch it move under load.

## End-of-week test
```bash
bash weeks/week-06-kserve-serving/test.sh
```
Checks the InferenceService + dashboard in git; optionally verifies it's Ready and serving; quizzes cold-start and the serving metrics that matter.
