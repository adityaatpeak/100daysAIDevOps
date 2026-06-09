# Week 03 — Istio resource model  `[infra]`

> Mesh capstone for Month 1. Learn the CRDs by **using** them: a real mTLS-enforced canary with fault injection, watched in Grafana.

## Objectives
- [ ] `VirtualService` — routing, weighted splits, retries, timeouts, fault injection
- [ ] `DestinationRule` — LB, connection pools, circuit breaking, subsets
- [ ] `Gateway`; `PeerAuthentication` / `AuthorizationPolicy`
- [ ] **Build (mesh capstone):** mTLS-enforced weighted canary across two versions, inject fault + timeout, watch golden signals in Grafana

## The build (infra → Argo CD)
Extend `clusters/learning/manifests/istio/` (same Application from Week 2 picks it up):
- Two versions of a sample app (`v1`/`v2`, distinct `version` labels).
- `DestinationRule` with `subsets` v1/v2 + a connection pool / outlier-detection (circuit breaker).
- `VirtualService` with a **90/10 weighted split**, a `retries` policy, a `timeout`, and a `fault` (delay or abort) you can toggle.
- `Gateway` + ingress `VirtualService` for north-south entry.
- Keep `PeerAuthentication: STRICT`; add an `AuthorizationPolicy` (e.g. allow only the sample namespace).
- Install Istio addons (Prometheus + Grafana + Kiali) to watch golden signals.

## How to study (≈8h)
1. istio.io traffic-management docs: VirtualService, DestinationRule, fault injection.
2. Apply the canary, drive traffic with `fortio`/`hey`, flip weights 50/50 → 0/100.
3. Inject a 5s delay fault, confirm the timeout fires; open Grafana "Istio Service" dashboard and Kiali graph.

## Learn & do — topic by topic

### 1 · VirtualService — routing, splits, retries, timeouts, faults
- **Read:** [VirtualService concept](https://istio.io/latest/docs/concepts/traffic-management/#virtual-services) · [Fault injection task](https://istio.io/latest/docs/tasks/traffic-management/fault-injection/) · [Request timeouts](https://istio.io/latest/docs/tasks/traffic-management/request-timeouts/)
- **Hands-on:** deploy `v1`+`v2`, write a VS with a 90/10 split. Drive traffic with `hey`/`fortio`, flip to 50/50 then 0/100. Add a `timeout: 1s` + a `fault.delay` of 5s and watch requests fail fast.

### 2 · DestinationRule — subsets, LB, pools, circuit breaking
- **Read:** [DestinationRule concept](https://istio.io/latest/docs/concepts/traffic-management/#destination-rules) · [Circuit breaking task](https://istio.io/latest/docs/tasks/traffic-management/circuit-breaking/)
- **Hands-on:** define `subsets` v1/v2 (the VS routes to them). Add `outlierDetection` + a tiny `connectionPool`; hammer it past the limit and watch `503`s / ejections in the Envoy stats.

### 3 · Gateway · PeerAuthentication · AuthorizationPolicy
- **Read:** [Gateways](https://istio.io/latest/docs/concepts/traffic-management/#gateways) · [Authorization concepts](https://istio.io/latest/docs/concepts/security/#authorization)
- **Hands-on:** expose the app north-south via a `Gateway` + ingress VS. Keep `STRICT` mTLS; add an `AuthorizationPolicy` allowing only the app namespace and confirm a denied caller gets `RBAC: access denied`.

### Watch it — golden signals
- **Read:** [Istio observability/addons](https://istio.io/latest/docs/ops/integrations/grafana/) · [Kiali](https://kiali.io/docs/)
- **Hands-on:** install Prometheus+Grafana+Kiali addons, open the "Istio Service" dashboard, and watch latency/error rate move as you shift the canary and inject the fault.

## End-of-week test
```bash
bash weeks/week-03-istio-resource-model/test.sh
```
Confirms the CRDs are in git, optionally checks they're applied with subsets + weights + fault, then quizzes routing vs circuit breaking.
