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

## End-of-week test
```bash
bash weeks/week-11-cost-slo/test.sh
```
Checks the note has the cost model, SLO, and a real PromQL alerting rule; quizzes error budget and Spot trade-offs for inference.
