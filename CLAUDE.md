# CLAUDE.md — AI Infra Upskill (GitOps)

Context for Claude Code working in this repo. Read this first.

## What this repo is

A 3-month upskilling roadmap run as a GitOps workflow. It's two things at once:
1. **A tracked plan** — each week is an issue → a `week-NN` branch → a PR. "Done" means *merged*.
2. **A real infra-as-code repo** — the builds get committed as manifests and synced to a learning EKS cluster by **Argo CD** (app-of-apps pattern). By Month 3 it's a working GitOps stack: Istio, KServe, vLLM, monitoring, all declarative.

**End goal:** a mesh-routed, GPU-backed, autoscaling LLM inference service on EKS, fully GitOps-managed from this repo. See `ROADMAP.md` for the 12 weeks and `README.md` for conventions.

## Who I am — calibrate to this

Senior DevOps/SRE. Daily stack: **AWS EKS, Istio, Argo Workflows, Prometheus, Grafana, Kibana/ELK, Helm, AWS** (strong on cost optimization — Graviton/Karpenter/Spot).

- **Strong / can skim:** Kubernetes core, Prometheus/Grafana, Helm, AWS cost/FinOps, Python automation, incident response/RCA.
- **Deliberately leveling up — explain thoroughly, don't assume depth:**
  - **Argo Workflows** — I only learned it to troubleshoot a failing workflow; I want to *design* DAGs, not just debug them.
  - **Istio / service mesh** — weak spot. I want the fundamentals: data plane vs control plane, the resource model, mesh networking concepts. Teach from the model up.
  - **GPU + ML-serving layer** — new ground. vLLM/KServe, GPU scheduling (MIG/time-slicing/DRA), inference internals.

So: treat me as senior on platform/ops and a capable beginner on the GPU/ML-serving and mesh layers.

## Repo conventions Claude Code must follow

- **Weekly loop:** issue (`.github/ISSUE_TEMPLATE/week.md`) → `week-NN-short-name` branch → build → tick the milestone box in `ROADMAP.md` *in the same PR* → PR (`.github/pull_request_template.md`) → merge.
- **`[infra]` weeks:** add manifests under `clusters/learning/manifests/<component>/` **and** a child `Application` under `clusters/learning/apps/<component>.yaml`. Copy the pattern in `apps/vllm.yaml`.
- **`[notes]` weeks:** add a markdown write-up under `notes/` (e.g. `notes/week-01-k8s-networking.md`).
- **app-of-apps:** the root in `clusters/learning/bootstrap/app-of-apps.yaml` watches `apps/`. Add a component = add one `Application` file; Argo CD picks it up.
- **Progress:** `scripts/progress.sh` reads ticked boxes from `ROADMAP.md`. Keep `ROADMAP.md` the single source of truth for status.
- **Definition of done for infra weeks** extends to **Synced & Healthy** in the Argo CD UI, not just merged.

When I start a week, the most useful thing you can do is produce the actual artifact (manifests or note) in the correct path and repo style, tick the ROADMAP box, and draft the PR body from the template.

## Hard rules (non-negotiable)

- **Secrets — standing rule across all my sessions.** Never write tokens, passwords, kubeconfigs, AWS credentials, connection strings, or raw k8s `Secret` manifests in plaintext — not in files, commits, logs, or command output. Use Sealed Secrets / SOPS / External Secrets and reference, don't embed. **Redact/mask before showing me any log, kubectl output, or API response.**
- **GPU cost discipline.** Default to one small rented GPU torn down after each session; EKS GPU nodes scale to zero when idle; small open-weight models (1–8B) for learning. Flag any suggestion that would leave GPUs running.
- **Don't commit client-identifying details** to this repo. Where a build references real work (e.g. the SharePoint-sync Argo workflow rebuild in Week 7), keep it generic here; private context stays out of git.

## Current state

- Scaffold committed; `0/38` milestones.
- **Next up:** Week 1 (`[notes]` — k8s networking refresher) and Week 2 (`[infra]` — Istio installed via Argo CD).

## Tooling preferences

- Use real, current tooling: **vLLM, KServe/Triton, NVIDIA GPU Operator, MIG/time-slicing/DRA, Kueue, Gateway API Inference Extension, Argo CD/Workflows, Ray/KubeRay.**
- I have two Claude skills available — use them where they fit: **`devops-toolkit`** (k8s/Prometheus debugging, AWS cost, Python automation, runbooks, client comms) and **`pr-creator`** (team PR template).

## Work-alignment note

Three weeks map onto my 2026 work goals, so treat them as work-aligned (worth extra polish): **LLM gateway integration** (Weeks 6/9), **HPA on Istio Gateway metrics** (Week 10), **AI SRE multi-agent app** (the Month 4+ wedge). Team: Squad Enablers Etna.
