#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
NOTE="notes/week-01-k8s-networking.md"

section "Artifact: $NOTE"
file_has "$NOTE" '## *Pod-to-Service path'
file_has "$NOTE" '## *DNS'
file_has "$NOTE" '## *CNI'
file_has "$NOTE" '## *L4 vs L7'
file_has "$NOTE" '## *Request trace'

section "Live cluster (optional — skipped if no kubeconfig)"
want "kubectl reaches a cluster" kubectl version
want "CoreDNS deployment present" kubectl -n kube-system get deploy coredns
want "kube-proxy running" kubectl -n kube-system get ds kube-proxy

section "Self-grade — answer without notes"
ask "What is a ClusterIP really, and what makes traffic to it reach a pod?"
ask "Resolve my-svc.my-ns.svc.cluster.local — what does ndots:5 change?"
ask "Why does the AWS VPC CNI exhaust IPs, and two ways to mitigate it?"
ask "Ingress vs Gateway API — name two concrete advantages of Gateway API."
finish
