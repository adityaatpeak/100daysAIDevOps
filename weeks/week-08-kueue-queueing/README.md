# Week 08 — Job queueing + Argo ecosystem  `[infra]`

> Make GPU jobs wait their turn under a quota, and force a preemption so you *see* the queueing work.

## Objectives
- [ ] Kueue (admission + quota for GPU jobs); awareness of Volcano (gang scheduling)
- [ ] Argo CD / Rollouts / Events — what each is for
- [ ] **Build:** GPU batch job behind a Kueue quota; force + observe a preemption

## The build (infra → Argo CD)
`clusters/learning/manifests/kueue/` + `clusters/learning/apps/kueue.yaml`:
- Kueue install (Helm/manifests Application).
- A `ResourceFlavor` for the GPU node, a `ClusterQueue` with a small `nvidia.com/gpu` quota (e.g. 1), and a `LocalQueue` in your namespace.
- Two GPU batch `Job`s (suspended, Kueue-managed via the queue label). Submit both — quota of 1 means one **admits**, one **waits**.
- Add a higher-priority job (`WorkloadPriorityClass`) to force a **preemption**; watch the lower-priority workload get evicted and requeued.

> ⚠️ Cost: jobs are short and the GPU NodePool scales to zero after. Don't leave a queue draining overnight.

## How to study (≈8h)
- kueue.sigs.k8s.io: ClusterQueue/LocalQueue/ResourceFlavor, quotas, preemption, priorities.
- `kubectl get workloads` to watch admission state; trigger preemption and read the events.
- Skim Volcano (gang scheduling) — know when you'd need all-or-nothing scheduling.

## Learn & do — topic by topic

### 1 · Kueue — admission, quota, queues
- **Read:** [Kueue concepts](https://kueue.sigs.k8s.io/docs/concepts/) · [ClusterQueue](https://kueue.sigs.k8s.io/docs/concepts/cluster_queue/) · [Run a Job](https://kueue.sigs.k8s.io/docs/tasks/run/jobs/)
- **Hands-on:** define a `ResourceFlavor` (GPU node), a `ClusterQueue` with `nvidia.com/gpu` quota 1, and a `LocalQueue`. Submit two GPU jobs to the queue → one admits, one stays `Pending`. `kubectl get workloads` to see admission state.

### 2 · Preemption & priorities (+ Volcano awareness)
- **Read:** [Kueue preemption](https://kueue.sigs.k8s.io/docs/concepts/preemption/) · [WorkloadPriorityClass](https://kueue.sigs.k8s.io/docs/concepts/workload_priority_class/) · [Volcano](https://volcano.sh/en/docs/)
- **Hands-on:** submit a higher-priority job and **watch it preempt** the running one; the evicted workload requeues. Read the events. Note in one line when you'd reach for Volcano gang scheduling instead.

### 3 · Argo ecosystem — CD vs Rollouts vs Events
- **Read:** [Argo CD](https://argo-cd.readthedocs.io/en/stable/) · [Argo Rollouts](https://argo-rollouts.readthedocs.io/en/stable/) · [Argo Events](https://argoproj.github.io/argo-events/)
- **Hands-on:** write one sentence each on what problem each solves, and where each could slot into *this* stack (CD = the app-of-apps you already run; Rollouts = progressive canary; Events = trigger a Workflow on an event).

## End-of-week test
```bash
bash weeks/week-08-kueue-queueing/test.sh
```
Checks the queue objects + a quota + priority in git; optionally verifies admitted vs pending Workloads; quizzes quota/preemption and Argo CD vs Rollouts vs Events.
