# Week 11 — Cost + reliability pass  `[notes]`

> Home turf (FinOps/SRE). Put a cost + SLO frame around the serving stack you've built.

## Objectives
- [ ] GPU FinOps: right-sizing, Spot for inference, scale-to-zero, MIG packing
- [ ] Inference SLOs: error budget, latency objective, Prometheus alerting rule
- [ ] **Build:** `notes/week-11-cost-slo.md` — cost + SLO note for the serving stack

## The build
`notes/week-11-cost-slo.md`, required sections (test greps for them):
- `## GPU cost model` — $/hr of the chosen instance, on-demand vs Spot, idle cost, scale-to-zero savings; a rough $/1M-tokens estimate from your Week-4/6 throughput numbers.
- `## Right-sizing & packing` — instance choice, MIG/time-slicing packing, when a smaller GPU or quantized model wins.
- `## SLOs` — a latency SLO (e.g. p95 TTFT) + an availability/error SLO, with **error budget** math.
- `## Alerting` — a concrete **Prometheus alerting rule** (PromQL) tied to the SLO (e.g. burn-rate or p95 breach). Include the rule YAML.
- `## Failure modes` — top 3 ways this stack degrades and the signal each shows.

## How to study (≈8h)
- Pull your real throughput numbers from Weeks 4/6; do the $/token math.
- Write the PromQL: SLO burn rate, p95 latency from histogram buckets.
- Cross-check against your AWS Spot/Karpenter experience — what you'd actually run in prod.

## Learn & do — topic by topic

### 1 · GPU FinOps — right-sizing · Spot · scale-to-zero · MIG packing
- **Read:** [Karpenter Spot / consolidation](https://karpenter.sh/docs/concepts/disruption/) · [EC2 Spot best practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html) · [GPU sharing/packing](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/gpu-sharing.html)
- **Hands-on:** from your Week-4/6 throughput, compute **$/1M tokens** for the chosen instance (on-demand vs Spot). Show idle cost and the scale-to-zero saving. Note where MIG packing or a quantized/smaller model wins.

### 2 · Inference SLOs · error budget · alerting
- **Read:** [Google SRE — Implementing SLOs](https://sre.google/workbook/implementing-slos/) · [Prometheus alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) · [Multi-window burn-rate alerts](https://sre.google/workbook/alerting-on-slos/)
- **Hands-on:** set a latency SLO (e.g. p95 TTFT) + an availability SLO; compute the monthly error budget in minutes. Write a real **PromQL alerting rule** (p95 from histogram buckets, or a burn-rate rule) and commit the rule YAML in the note.

### Failure modes
- **Hands-on:** list the top 3 ways the serving stack degrades (OOM/KV-cache exhaustion, GPU node loss on Spot reclaim, queue saturation) and the exact signal each shows on your Week-6/10 dashboard.

## End-of-week test
```bash
bash weeks/week-11-cost-slo/test.sh
```
Checks the note has the cost model, SLO, and a real PromQL alerting rule; quizzes error budget and Spot trade-offs for inference.
