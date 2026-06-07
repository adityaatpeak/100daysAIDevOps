# Week 01 — Kubernetes networking refresher  `[notes]`

> Home turf, but the layer everything else this quarter sits on. Goal: be able to **trace a request end to end** and name the failure modes (the IP-exhaustion class from the SharePoint sync incident).

## Objectives
- [ ] Pod/Service model; kube-proxy + ClusterIP; CoreDNS resolution path
- [ ] CNI role + why AWS VPC CNI hands out real VPC IPs (and how that causes IP exhaustion)
- [ ] L4 vs L7; Ingress vs Gateway API; NetworkPolicy
- [ ] **Build:** `notes/week-01-k8s-networking.md` — trace a request pod → Service → DNS → endpoint, in your own words

## The build
Write `notes/week-01-k8s-networking.md`. Required sections (the test greps for them):
- `## Pod-to-Service path` — what a ClusterIP actually is (a virtual IP, no process listening), how kube-proxy (iptables/IPVS) DNATs to a pod IP from the EndpointSlice.
- `## DNS` — full resolution of `svc.ns.svc.cluster.local`, `ndots:5` and the search-domain gotcha.
- `## CNI / VPC CNI` — why pods get real VPC IPs, ENI/prefix delegation, the IP-exhaustion failure mode and mitigations.
- `## L4 vs L7` — Service/NetworkPolicy (L4) vs Ingress/Gateway API (L7), and where Istio will slot in next week.
- `## Request trace` — one concrete request walked hop by hop.

## How to study (≈8h)
1. On the learning cluster: `kubectl run`, `kubectl expose`, then `kubectl get endpointslices`, exec a busybox and `nslookup` the Service.
2. Inspect `kubectl -n kube-system get cm coredns -o yaml` — read the Corefile.
3. Read: kubernetes.io Services/DNS, AWS VPC CNI docs (prefix delegation).

## End-of-week test
```bash
bash weeks/week-01-k8s-networking/test.sh
```
Checks the note exists with the required sections, optionally probes a live cluster's CoreDNS, and asks you to explain the trace from memory.
