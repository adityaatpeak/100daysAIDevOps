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

## Learn & do — topic by topic
> Each topic = a focused resource set + a hands-on. The hands-on is what makes the test green.

### 1 · Pod/Service model · kube-proxy · ClusterIP · CoreDNS
- **Read:** [k8s Services](https://kubernetes.io/docs/concepts/services-networking/service/) · [Service & Pod DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) · [Virtual IPs & kube-proxy](https://kubernetes.io/docs/reference/networking/virtual-ips/)
- **Hands-on:** deploy 2 replicas, `kubectl expose`, then `kubectl get endpointslices` and watch the IPs match the pods. Exec a `busybox` and `nslookup <svc>`, `<svc>.<ns>`, and the FQDN — note which resolve.

### 2 · CNI + AWS VPC CNI (the IP-exhaustion class)
- **Read:** [k8s CNI/network model](https://kubernetes.io/docs/concepts/cluster-administration/networking/) · [AWS VPC CNI](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html) · [Increase IPs / prefix delegation](https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html)
- **Hands-on:** on an EKS node, `kubectl get node -o yaml | grep -i 'pods\|allocatable'` and compare max-pods to ENI/IP math. Write down how prefix delegation changes the ceiling and what `WARM_IP_TARGET` does.

### 3 · L4 vs L7 · Ingress vs Gateway API · NetworkPolicy
- **Read:** [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) · [Gateway API](https://gateway-api.sigs.k8s.io/) · [NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- **Hands-on:** apply a default-deny `NetworkPolicy` to a namespace, confirm a pod loses egress, then allow one path back. Sketch why Gateway API's role split (infra vs app) beats Ingress annotations.

## End-of-week test
```bash
bash weeks/week-01-k8s-networking/test.sh
```
Checks the note exists with the required sections, optionally probes a live cluster's CoreDNS, and asks you to explain the trace from memory.
