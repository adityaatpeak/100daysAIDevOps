# Week 02 — Service mesh: the mental model  `[infra]`

> Your declared weak spot. Teach yourself from the **model up**, then install Istio via Argo CD and prove mTLS.

## Objectives
- [ ] The "why": mTLS / retries / traffic splits / observability **out of app code**
- [ ] Data plane vs control plane: Envoy sidecars (and ambient: ztunnel/waypoints) vs `istiod`
- [ ] East-west vs north-south; Envoy LB / retries / circuit breaking
- [ ] **Build:** Istio installed via Argo CD, sidecar injection on a namespace, mTLS confirmed on a sample app

## The build (infra → Argo CD)
Working YAML lives in the canonical paths so Argo CD syncs it:
- `clusters/learning/manifests/istio/` — Istio install. Cleanest GitOps route: a `helm`-source `Application` for `base` + `istiod` (istio.io Helm charts), plus a namespace with `istio-injection=enabled` and a sample app (e.g. httpbin + sleep).
- `clusters/learning/apps/istio.yaml` — child `Application` (copy the pattern in `apps/vllm.yaml`). For Helm-based installs you may use one Application per chart or a wrapper chart under `manifests/istio/`.
- Add `PeerAuthentication` (mode `STRICT`) on the sample namespace to enforce mTLS.

> Keep the plan/test in this folder; the **deployable YAML goes under `clusters/learning/...`**.

## How to study (≈8h)
1. Read istio.io concepts: architecture (istiod + Envoy), sidecar vs ambient.
2. Install, label a namespace, deploy httpbin + sleep.
3. Prove mTLS: `istioctl x describe pod <sleep>`; check `STRICT` PeerAuthentication; try traffic from a non-mesh pod and watch it be rejected. `istioctl proxy-config secret` shows the issued certs.

## Learn & do — topic by topic

### 1 · The "why" — mTLS / retries / splits / observability out of app code
- **Read:** [Istio: what is a service mesh](https://istio.io/latest/about/service-mesh/) · [Concepts overview](https://istio.io/latest/docs/concepts/)
- **Hands-on:** list capabilities you currently solve in app code or an LB (retries, TLS, metrics) and mark which a mesh would move to the platform. Keep this list — it justifies the next two weeks.

### 2 · Data plane vs control plane (sidecar + ambient)
- **Read:** [Istio architecture](https://istio.io/latest/docs/ops/deployment/architecture/) · [Ambient mode](https://istio.io/latest/docs/ambient/overview/)
- **Hands-on:** install Istio (Helm via Argo CD), label a namespace `istio-injection=enabled`, deploy `httpbin` + `sleep`. `kubectl get pod <sleep> -o jsonpath='{.spec.containers[*].name}'` — see the injected `istio-proxy`. `istioctl proxy-config cluster <pod>` to view what istiod pushed.

### 3 · East-west vs north-south · Envoy LB / retries / circuit breaking
- **Read:** [Traffic management concepts](https://istio.io/latest/docs/concepts/traffic-management/) · [Security / mTLS concepts](https://istio.io/latest/docs/concepts/security/)
- **Hands-on:** apply `PeerAuthentication` mode `STRICT` on the namespace. From `sleep` (in-mesh) curl `httpbin` → works. From a pod in a non-injected namespace → fails. `istioctl proxy-config secret <pod>` shows the issued certs = mTLS proven.

## End-of-week test
```bash
bash weeks/week-02-service-mesh/test.sh
```
Verifies the manifests + Application exist, optionally checks `istiod` is running, injection is on, and a `STRICT` PeerAuthentication is applied — then quizzes the data/control-plane split.
