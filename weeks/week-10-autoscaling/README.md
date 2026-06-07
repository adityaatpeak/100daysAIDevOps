# Week 10 — Autoscaling on the right signal  `[infra]`  ⭐ work-aligned

> Directly your 2026 "HPA on Istio Gateway metrics" goal. Scale vLLM on a **serving** signal, not CPU.

## Objectives
- [ ] Why CPU HPA is wrong for inference; scale on queue depth / TTFT / tokens-in-flight
- [ ] Serving metrics → Prometheus adapter → HPA
- [ ] **Build:** autoscale vLLM on a serving metric, load-test, watch it scale

## The build (infra → Argo CD)
`clusters/learning/manifests/autoscaling/`:
- **prometheus-adapter** config exposing a serving metric as a custom/external metric — e.g. vLLM `num_requests_waiting` (queue depth) or Istio Gateway request rate / p95 latency.
- An **HPA** (`autoscaling/v2`) on that custom metric targeting the vLLM deployment/InferenceService, with sane min/max and stabilization windows.
- A **load test** manifest/job (`fortio`/`hey`/`k6`) that ramps concurrency.
- Capture before/after: replicas vs queue depth vs latency as load ramps and drains.

> ⭐ This is the demo your team wants. Pick the metric deliberately and justify it in comments.
> ⚠️ Cost: max replicas bounded; GPU NodePool scales back to zero after the load test.

## How to study (≈8h)
- Prometheus adapter rules (`seriesQuery`/`metricsQuery`), `kubectl get --raw /apis/custom.metrics.k8s.io/...` to confirm the metric is served.
- Run the load test; watch `kubectl get hpa -w` scale up on queue depth, then down. Note the lag vs CPU-based scaling.

## End-of-week test
```bash
bash weeks/week-10-autoscaling/test.sh
```
Checks the HPA targets a non-CPU custom metric, the adapter config, and a load-test artifact; optionally reads live HPA status; quizzes why CPU is the wrong signal.
