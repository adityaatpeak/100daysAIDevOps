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

## End-of-week test
```bash
bash weeks/week-03-istio-resource-model/test.sh
```
Confirms the CRDs are in git, optionally checks they're applied with subsets + weights + fault, then quizzes routing vs circuit breaking.
