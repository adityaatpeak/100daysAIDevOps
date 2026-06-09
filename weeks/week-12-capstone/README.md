# Week 12 — Capstone + write-up  `[infra]`+`[notes]`

> Everything wired together, synced from this repo by Argo CD, and a write-up you can defend.

## Objectives
- [ ] **Capstone:** open-weight LLM on EKS GPU → KServe → mesh + mTLS → inference-aware gateway → autoscaling on serving metrics → Grafana → an Argo workflow that (re)deploys / batch-scores — all synced from this repo
- [ ] **Build:** `notes/week-12-architecture.md` — architecture note + runbook (decisions, costs, failure modes)

## The build
1. **Integration:** confirm the full path works end to end with every prior component **Synced & Healthy** in Argo CD. No orphaned/manual pieces — if it's running, it's in git.
2. **Architecture note** `notes/week-12-architecture.md`, required sections:
   - `## Architecture` — the full diagram/topology, request path client → gateway → mesh → KServe → vLLM/GPU.
   - `## Decisions` — key choices and the alternative you rejected (mesh mode, runtime, scale metric, instance).
   - `## Costs` — steady-state + per-token, pulled from Week 11.
   - `## Failure modes` — what degrades, the signal, the runbook step.
   - `## Runbook` — deploy, roll back, scale, tear down (GPU to zero).

## How to study (≈8h)
- Walk every Argo CD app to Healthy; fix drift.
- Do a real end-to-end request and a real rollback. Time a cold start. Tear the GPU down and bring it back from git only.

## Learn & do — topic by topic

### 1 · Integrate — everything Synced & Healthy
- **Read:** [Argo CD app-of-apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/) · [Sync & health status](https://argo-cd.readthedocs.io/en/stable/operator-manual/health/)
- **Hands-on:** walk every child Application (istio, gpu-operator, vllm/kserve, kueue, inference-gateway, autoscaling, workflows) to **Synced & Healthy**. Fix any drift. Nothing running that isn't in git.

### 2 · Operate — prove the path & rollback
- **Read:** [Argo Rollouts (if used for canary)](https://argo-rollouts.readthedocs.io/en/stable/) · re-skim your Week-3 canary + Week-10 HPA notes
- **Hands-on:** run one real end-to-end request through the full path (client → gateway → mesh → KServe → vLLM/GPU). Then do a **real rollback** of one component and confirm Argo heals it. Time a cold start.

### 3 · Document — architecture note + runbook
- **Read:** [Google SRE — writing runbooks/playbooks](https://sre.google/workbook/incident-response/)
- **Hands-on:** write `notes/week-12-architecture.md` with the topology diagram, key decisions (+ rejected alternatives), steady-state & per-token cost, failure modes→signals, and a runbook: deploy / roll back / scale / **tear down (GPU to zero)**. Then actually tear the GPU down and rebuild from git only.

## End-of-week test
```bash
bash weeks/week-12-capstone/test.sh
```
The big one: verifies all component Applications exist in git and the architecture note is complete; optionally checks every Argo app is Synced & Healthy; quizzes you to defend the whole design.
