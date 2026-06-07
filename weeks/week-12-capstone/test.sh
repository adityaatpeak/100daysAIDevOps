#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
APPS="clusters/learning/apps"
NOTE="notes/week-12-architecture.md"

section "All component Applications committed (GitOps complete)"
for a in istio gpu-operator vllm kueue inference-gateway; do
  check "apps/$a.yaml present" test -f "$APPS/$a.yaml"
done
want "autoscaling manifests present" bash -c "[ -d clusters/learning/manifests/autoscaling ]"
want "workflows manifests present" bash -c "[ -d clusters/learning/manifests/workflows ]"

section "Architecture note: $NOTE"
file_has "$NOTE" '## *Architecture'
file_has "$NOTE" '## *Decisions'
file_has "$NOTE" '## *Costs'
file_has "$NOTE" '## *Failure modes'
file_has "$NOTE" '## *Runbook'

section "Live cluster (optional) — the real definition of done"
want "all Argo apps Synced" bash -c "kubectl -n argocd get applications -o jsonpath='{.items[*].status.sync.status}' | grep -qv OutOfSync"
want "all Argo apps Healthy" bash -c "kubectl -n argocd get applications -o jsonpath='{.items[*].status.health.status}' | grep -q Healthy"

section "Self-grade — defend the design"
ask "Walk a request end to end naming every hop and what it adds."
ask "Where's mTLS enforced, and how do you prove it across the whole path?"
ask "What scales, on what signal, and what's the GPU cost at idle vs peak?"
ask "Tear-down + rebuild-from-git: what's the exact sequence, and what's NOT in git (and why)?"
finish
