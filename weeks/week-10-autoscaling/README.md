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

## Learn & do — topic by topic

### 1 · Why CPU HPA is wrong for inference
- **Read:** [HPA concepts](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) · [HPA walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)
- **Hands-on:** load-test the vLLM service and chart CPU% vs queue depth vs latency. Show that CPU stays flat while queue depth and TTFT climb — i.e. CPU can't see saturation. Write the one-paragraph argument.

### 2 · Serving metrics → Prometheus adapter → HPA
- **Read:** [prometheus-adapter](https://github.com/kubernetes-sigs/prometheus-adapter) · [Custom/external metrics HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#scaling-on-custom-metrics) · [vLLM metrics](https://docs.vllm.ai/en/latest/serving/metrics.html)
- **Hands-on:** configure prometheus-adapter to expose `num_requests_waiting` (queue depth) or Istio p95 latency as a custom/external metric. Verify with `kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1`. Write an `autoscaling/v2` HPA targeting it with min/max + stabilization windows.

### Build · prove it scales
- **Hands-on:** ramp load with `hey`/`k6`/`fortio`; `kubectl get hpa -w` to watch replicas scale **up on queue depth**, then drain to min. Capture before/after replicas vs queue vs latency. Confirm the GPU NodePool scales back to zero after.

## End-of-week test
```bash
bash weeks/week-10-autoscaling/test.sh
```
Checks the HPA targets a non-CPU custom metric, the adapter config, and a load-test artifact; optionally reads live HPA status; quizzes why CPU is the wrong signal.
