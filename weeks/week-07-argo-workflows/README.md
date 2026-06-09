# Week 07 — Argo Workflows: troubleshoot → design  `[infra]`

> You learned Argo Workflows to debug a failure; this week you **design** a clean DAG. Rebuild the SharePoint-sync workflow generically (no client details in git).

## Objectives
- [ ] `Workflow` / `WorkflowTemplate`, the controller, template types (container / script / steps / dag)
- [ ] Parameters vs artifacts (S3 artifact repo)
- [ ] Retries, timeouts, `exitHandler`, failure propagation
- [ ] **Build:** rebuild the sync workflow as a clean DAG with proper params/artifacts + exit handler

## The build (infra)
`clusters/learning/manifests/workflows/`:
- A `WorkflowTemplate` modelling a generic **extract → transform → load** sync as a **`dag`** (not linear steps), with explicit `dependencies`.
- **Parameters** for inputs (source path, target, batch size); **artifacts** passed between nodes via an **S3 artifact repository** (reference the repo config — do **not** commit credentials; use IRSA / a referenced secret).
- `retryStrategy` (limit + backoff), per-template `activeDeadlineSeconds` (timeout), and an **`onExit` exit handler** that runs on success *and* failure (e.g. notify / cleanup).
- A `Workflow` that instantiates the template for a test run.

> 🔒 Keep it **generic** — no client-identifying names, buckets, or paths. Artifact-repo creds via IRSA/SealedSecret, never inline.

## How to study (≈8h)
- argo-workflows.readthedocs.io: DAG templates, artifacts, retries, exit handlers, `WorkflowTemplate`.
- Run it, force a node failure, confirm retry + that the exit handler still fires + failure propagates to the Workflow status.

## Learn & do — topic by topic

### 1 · Workflow / WorkflowTemplate · controller · template types
- **Read:** [Argo Workflows docs](https://argo-workflows.readthedocs.io/en/latest/) · [DAG template](https://argo-workflows.readthedocs.io/en/latest/walk-through/dag/) · [WorkflowTemplates](https://argo-workflows.readthedocs.io/en/latest/workflow-templates/)
- **Hands-on:** model the extract→transform→load sync as a `dag` with explicit `dependencies` (not linear `steps`). Submit it and read the DAG view in the Argo UI.

### 2 · Parameters vs artifacts (S3 repo)
- **Read:** [Parameters](https://argo-workflows.readthedocs.io/en/latest/walk-through/parameters/) · [Artifacts](https://argo-workflows.readthedocs.io/en/latest/walk-through/artifacts/) · [Configuring an artifact repo](https://argo-workflows.readthedocs.io/en/latest/configure-artifact-repository/)
- **Hands-on:** pass inputs (source, target, batch size) as `parameters`; pass a file between nodes as an S3 `artifact`. Wire repo creds via **IRSA / a referenced secret** — never inline. Confirm the artifact lands in S3.

### 3 · Retries · timeouts · exitHandler · failure propagation
- **Read:** [Retries](https://argo-workflows.readthedocs.io/en/latest/retries/) · [Exit handlers / lifecycle hooks](https://argo-workflows.readthedocs.io/en/latest/lifecyclehook/)
- **Hands-on:** add `retryStrategy` (limit+backoff) and `activeDeadlineSeconds`; add an `onExit` handler. Force a node to fail — confirm it retries, the exit handler still fires, and the Workflow ends `Failed`.

## End-of-week test
```bash
bash weeks/week-07-argo-workflows/test.sh
```
Checks the DAG template uses dependencies, params, artifacts, retries, and an exit handler — and that no client/secret strings leaked. Quizzes failure propagation.
