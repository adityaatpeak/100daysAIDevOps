#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/istio"

section "Artifacts in git"
check "VirtualService defined" bash -c "grep -rql 'kind: VirtualService' $M"
check "DestinationRule defined" bash -c "grep -rql 'kind: DestinationRule' $M"
check "weighted split present (weight:)" bash -c "grep -rq 'weight:' $M"
check "fault injection present" bash -c "grep -rq 'fault:' $M"
want  "AuthorizationPolicy defined" bash -c "grep -rql 'kind: AuthorizationPolicy' $M"

section "Live cluster (optional)"
want "VirtualService applied" kubectl get virtualservice -A
want "DestinationRule applied" kubectl get destinationrule -A
want "two subsets exist" bash -c "kubectl get destinationrule -A -o yaml | grep -c 'name: v' | grep -qv '^0$'"

section "Self-grade — answer without notes"
ask "VirtualService vs DestinationRule — which owns the split, which owns the subset definitions?"
ask "How does outlier detection (circuit breaking) differ from a retry policy?"
ask "You shifted 10% to v2 and error rate spiked — what golden signals tell you, and what's your rollback?"
ask "Where does the Gateway fit vs the VirtualService for north-south traffic?"
finish
