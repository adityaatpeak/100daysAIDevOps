#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"

section "Artifacts in git (GitOps source of truth)"
check "manifests/istio/ exists and is non-empty" bash -c '[ -d clusters/learning/manifests/istio ] && [ -n "$(ls -A clusters/learning/manifests/istio)" ]'
check "apps/istio.yaml exists" test -f clusters/learning/apps/istio.yaml
want  "apps/istio.yaml is an Argo Application" grep -q 'kind: Application' clusters/learning/apps/istio.yaml

section "Live cluster (optional)"
want "istiod running" kubectl -n istio-system get deploy istiod
want "a namespace has istio-injection=enabled" bash -c "kubectl get ns -L istio-injection | grep -q enabled"
want "STRICT PeerAuthentication exists somewhere" bash -c "kubectl get peerauthentication -A -o yaml | grep -q STRICT"

section "Self-grade — answer without notes"
ask "Draw the data plane vs control plane: what does istiod push, and to what?"
ask "Sidecar mode vs ambient (ztunnel + waypoint) — what moves where?"
ask "East-west vs north-south traffic — give a concrete example of each in this stack."
ask "How would you PROVE mTLS is actually happening, not just configured?"
finish
