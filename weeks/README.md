# Weeks — follow-along plans + end-of-week tests

One folder per week. Each folder is your **workbook** for that week:

```
weeks/week-NN-short-name/
├── README.md   # the plan: objectives, the build, how to run it, resources
└── test.sh     # end-of-week test — run it before you tick the ROADMAP box
```

### How a week works
1. Open the week's **issue** (created from `.github/ISSUE_TEMPLATE/week.md`).
2. Branch `week-NN-short-name`, read `weeks/week-NN-*/README.md`.
3. Do the build:
   - **`[infra]`** → working YAML goes in **`clusters/learning/manifests/<component>/`** plus a child `Application` in `clusters/learning/apps/<component>.yaml`. The week README tells you exactly which paths. *(Keeping infra YAML there is what lets Argo CD sync it — the week folder is for the plan + test, not a second copy.)*
   - **`[notes]`** → write-up goes in **`notes/week-NN-*.md`**.
4. Run the test: `bash weeks/week-NN-short-name/test.sh`. It mixes **auto checks** (kubectl/file assertions) with **self-grade Qs** (the part that proves you learned it).
5. Tick the ROADMAP boxes **in the same PR**, open the PR, merge. Infra weeks: also confirm **Synced & Healthy** in Argo CD.

### The tests
- `lib/test-helpers.sh` — shared `check / want / file_has / ask / finish` helpers.
- Auto checks are best-effort: if your cluster/kubeconfig isn't up, they FAIL loudly rather than lie. The **Q** items are the real bar — answer them without notes.

### Index
| Wk | Type | Folder | Build lands in |
|----|------|--------|----------------|
| 01 | notes | `week-01-k8s-networking`     | `notes/week-01-k8s-networking.md` |
| 02 | infra | `week-02-service-mesh`       | `manifests/istio/` + `apps/istio.yaml` |
| 03 | infra | `week-03-istio-resource-model` | `manifests/istio/` (canary set) |
| 04 | notes+infra | `week-04-inference-mechanics` | `notes/week-04-inference-internals.md` + first vLLM run |
| 05 | infra | `week-05-gpu-on-k8s`         | `manifests/gpu-operator/` + `apps/gpu-operator.yaml` |
| 06 | infra | `week-06-kserve-serving`     | `manifests/vllm/` + `apps/vllm.yaml` |
| 07 | infra | `week-07-argo-workflows`     | `manifests/workflows/` |
| 08 | infra | `week-08-kueue-queueing`     | `manifests/kueue/` + `apps/kueue.yaml` |
| 09 | infra | `week-09-inference-gateway`  | `manifests/inference-gateway/` + `apps/inference-gateway.yaml` |
| 10 | infra | `week-10-autoscaling`        | `manifests/autoscaling/` |
| 11 | notes | `week-11-cost-slo`           | `notes/week-11-cost-slo.md` |
| 12 | infra+notes | `week-12-capstone`    | full stack + `notes/week-12-architecture.md` |
