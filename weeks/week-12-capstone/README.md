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

## End-of-week test
```bash
bash weeks/week-12-capstone/test.sh
```
The big one: verifies all component Applications exist in git and the architecture note is complete; optionally checks every Argo app is Synced & Healthy; quizzes you to defend the whole design.
