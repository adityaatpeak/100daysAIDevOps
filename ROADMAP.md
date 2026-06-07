# AI Infrastructure Upskilling Roadmap — 3 Months (GitOps Edition)

**Source of truth for progress.** Tick boxes here, in the PR that completes the week. Run `./scripts/progress.sh` for the count.

**Outcome by Month 3:** a mesh-routed, GPU-backed, autoscaling LLM inference service on EKS — fully GitOps-managed by Argo CD from this repo. Maps to your 2026 goals (LLM gateway, HPA on Istio Gateway metrics, AI SRE app).

**Workflow:** each week = issue → `week-NN` branch → build → tick box → PR → merge. `[infra]` weeks commit manifests (Argo CD syncs them); `[notes]` weeks commit a doc under `notes/`. See README.

**Time budget:** ~8 hrs/week. Slip a week before skipping a build.

**Guardrails:** rent ONE small GPU by the hour and tear it down; scale EKS GPU nodes to zero when idle; set a billing alarm; never commit secrets.

## Week tracker — plan · issue · test

Each week has a follow-along folder under `weeks/` (plan + end-of-week test) and a GitHub issue (close it when merged). Run `bash weeks/week-NN-*/test.sh` before ticking the boxes below.

| Wk | Type | Plan | Issue | Test |
|----|------|------|-------|------|
| 01 | notes | [week-01-k8s-networking](weeks/week-01-k8s-networking/README.md) | [#1](https://github.com/adityaatpeak/100daysAIDevOps/issues/1) | `weeks/week-01-k8s-networking/test.sh` |
| 02 | infra | [week-02-service-mesh](weeks/week-02-service-mesh/README.md) | [#2](https://github.com/adityaatpeak/100daysAIDevOps/issues/2) | `weeks/week-02-service-mesh/test.sh` |
| 03 | infra | [week-03-istio-resource-model](weeks/week-03-istio-resource-model/README.md) | [#3](https://github.com/adityaatpeak/100daysAIDevOps/issues/3) | `weeks/week-03-istio-resource-model/test.sh` |
| 04 | notes+infra | [week-04-inference-mechanics](weeks/week-04-inference-mechanics/README.md) | [#4](https://github.com/adityaatpeak/100daysAIDevOps/issues/4) | `weeks/week-04-inference-mechanics/test.sh` |
| 05 | infra | [week-05-gpu-on-k8s](weeks/week-05-gpu-on-k8s/README.md) | [#5](https://github.com/adityaatpeak/100daysAIDevOps/issues/5) | `weeks/week-05-gpu-on-k8s/test.sh` |
| 06 | infra ⭐ | [week-06-kserve-serving](weeks/week-06-kserve-serving/README.md) | [#6](https://github.com/adityaatpeak/100daysAIDevOps/issues/6) | `weeks/week-06-kserve-serving/test.sh` |
| 07 | infra | [week-07-argo-workflows](weeks/week-07-argo-workflows/README.md) | [#7](https://github.com/adityaatpeak/100daysAIDevOps/issues/7) | `weeks/week-07-argo-workflows/test.sh` |
| 08 | infra | [week-08-kueue-queueing](weeks/week-08-kueue-queueing/README.md) | [#8](https://github.com/adityaatpeak/100daysAIDevOps/issues/8) | `weeks/week-08-kueue-queueing/test.sh` |
| 09 | infra ⭐ | [week-09-inference-gateway](weeks/week-09-inference-gateway/README.md) | [#9](https://github.com/adityaatpeak/100daysAIDevOps/issues/9) | `weeks/week-09-inference-gateway/test.sh` |
| 10 | infra ⭐ | [week-10-autoscaling](weeks/week-10-autoscaling/README.md) | [#10](https://github.com/adityaatpeak/100daysAIDevOps/issues/10) | `weeks/week-10-autoscaling/test.sh` |
| 11 | notes | [week-11-cost-slo](weeks/week-11-cost-slo/README.md) | [#11](https://github.com/adityaatpeak/100daysAIDevOps/issues/11) | `weeks/week-11-cost-slo/test.sh` |
| 12 | infra+notes | [week-12-capstone](weeks/week-12-capstone/README.md) | [#12](https://github.com/adityaatpeak/100daysAIDevOps/issues/12) | `weeks/week-12-capstone/test.sh` |

⭐ = work-aligned (2026 goals — worth extra polish).

---

## Month 1 — Foundations & first inference deploy

### Week 1 `[notes]` — Kubernetes networking refresher
- [ ] pod/Service model, kube-proxy + ClusterIP, CoreDNS resolution path
- [ ] CNI role + why AWS VPC CNI hands out real VPC IPs (the IP-exhaustion class of bug from the SharePoint sync)
- [ ] L4 vs L7; Ingress vs Gateway API; NetworkPolicy
- [ ] **Build → `notes/week-01-k8s-networking.md`:** trace a request pod → Service → DNS → endpoint, in your own words

### Week 2 `[infra]` — Service mesh: the mental model
- [ ] The "why" (mTLS / retries / splits / observability out of app code)
- [ ] Data plane vs control plane: Envoy sidecars (+ ambient: ztunnel/waypoints) vs `istiod`
- [ ] East-west vs north-south; Envoy LB / retries / circuit breaking
- [ ] **Build → `manifests/istio/` + `apps/istio.yaml`:** Istio installed via Argo CD, sidecar injection on a namespace, mTLS confirmed on a sample app

### Week 3 `[infra]` — Istio resource model
- [ ] `VirtualService` (routing, weighted splits, retries, timeouts, fault injection)
- [ ] `DestinationRule` (LB, connection pools, circuit breaking, subsets)
- [ ] `Gateway`; `PeerAuthentication` / `AuthorizationPolicy`
- [ ] **Build (mesh capstone):** mTLS-enforced weighted canary across two service versions, inject fault + timeout, watch golden signals in Grafana

### Week 4 `[notes]`+`[infra]` — Inference mechanics + first serve
- [ ] KV cache, continuous batching, PagedAttention, quantization, speculative decoding — why serving is hard
- [ ] vLLM as default; where SGLang / TensorRT-LLM differ
- [ ] **Build → `notes/week-04-inference-internals.md` + first vLLM run:** serve a small open-weight model on one rented GPU, hit the OpenAI-compatible API, record TTFT + tokens/sec

**Month 1 milestone:** ✅ data-plane vs control-plane explained, mesh canary running via Argo CD, model served with vLLM.

---

## Month 2 — Serving on Kubernetes + GPU + Argo

### Week 5 `[infra]` — GPU on Kubernetes
- [ ] NVIDIA GPU Operator (driver, device plugin, DCGM)
- [ ] MIG vs time-slicing — when each fits
- [ ] DRA — what it is, why it's the direction
- [ ] **Build → `manifests/gpu-operator/` + `apps/gpu-operator.yaml`:** schedule a GPU pod on one EKS GPU node (Karpenter, scale-to-zero); `nvidia-smi` inside the pod

### Week 6 `[infra]` — Model serving on EKS (KServe)
- [ ] KServe / Triton; `InferenceService` model; cold-start + model-load realities
- [ ] **Build → `manifests/vllm/` + `apps/vllm.yaml`:** Week-4 model on EKS behind KServe, Grafana dashboard (TTFT, tokens/sec, GPU mem, queue depth via DCGM exporter)

### Week 7 `[infra]` — Argo Workflows: troubleshoot → design
- [ ] `Workflow`/`WorkflowTemplate`, controller, template types (container/script/steps/dag)
- [ ] Parameters vs artifacts (S3 artifact repo)
- [ ] Retries, timeouts, `exitHandler`, failure propagation
- [ ] **Build → `manifests/workflows/`:** rebuild the SharePoint-sync workflow as a clean DAG with proper params/artifacts + exit handler

### Week 8 `[infra]` — Job queueing + Argo ecosystem
- [ ] Kueue (admission + quota for GPU jobs); awareness of Volcano (gang scheduling)
- [ ] Argo CD / Rollouts / Events — what each is for
- [ ] **Build → `manifests/kueue/` + `apps/kueue.yaml`:** GPU batch job behind a Kueue quota; force + observe a preemption

**Month 2 milestone:** ✅ model serves on EKS GPU with full observability (GitOps-managed), Argo DAG designed not just debugged, GPU scheduling + quota understood.

---

## Month 3 — Mesh-routed, autoscaling inference (capstone)

### Week 9 `[infra]` — Inference at the gateway
- [ ] Gateway API Inference Extension: `InferencePool`, model/LoRA-aware routing, token-aware rate limiting
- [ ] **Build → `manifests/inference-gateway/` + `apps/inference-gateway.yaml`:** route to the KServe/vLLM endpoint through an inference-aware gateway

### Week 10 `[infra]` — Autoscaling on the right signal
- [ ] Why CPU HPA is wrong for inference; scale on queue depth / TTFT / tokens-in-flight
- [ ] Serving metrics → Prometheus adapter → HPA (your 2026 HPA-on-Istio-Gateway-metrics goal)
- [ ] **Build → `manifests/autoscaling/`:** autoscale vLLM on a serving metric, load-test, watch it scale

### Week 11 `[notes]` — Cost + reliability pass (home turf)
- [ ] GPU FinOps: right-sizing, Spot for inference, scale-to-zero, MIG packing
- [ ] Inference SLOs: error budget, latency objective, Prometheus alerting rule
- [ ] **Build → `notes/week-11-cost-slo.md`:** cost + SLO note for the serving stack

### Week 12 `[infra]`+`[notes]` — Capstone + write-up
- [ ] **Capstone:** open-weight LLM on EKS GPU → KServe → mesh + mTLS → inference-aware gateway → autoscaling on serving metrics → Grafana → Argo workflow that (re)deploys/batch-scores — all synced from this repo by Argo CD
- [ ] **Build → `notes/week-12-architecture.md`:** architecture note + runbook (decisions, costs, failure modes)

**Month 3 milestone:** ✅ end-to-end GitOps-managed inference service on EKS that I can explain, operate, and cost-justify.

---

## After (Month 4+, out of scope)

Ray/KubeRay (distributed), TensorRT-LLM/SGLang perf tuning, Slurm/HPC, extend the kagent AI-SRE system. Pick the wedge you enjoyed most in Weeks 9–12.

## Resource index

Istio (istio.io) · Kubernetes networking (kubernetes.io) · vLLM (docs.vllm.ai) · KServe (kserve.github.io/website) · NVIDIA GPU Operator (docs.nvidia.com) · Kueue (kueue.sigs.k8s.io) · Argo Workflows (argo-workflows.readthedocs.io) · Argo CD (argo-cd.readthedocs.io) · Gateway API Inference Extension (gateway-api-inference-extension.sigs.k8s.io) · Ray (docs.ray.io)
