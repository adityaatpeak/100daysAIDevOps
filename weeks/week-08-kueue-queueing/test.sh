#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/kueue"

section "Artifacts in git"
check "manifests/kueue/ non-empty" bash -c "[ -d $M ] && [ -n \"\$(ls -A $M)\" ]"
check "apps/kueue.yaml exists" test -f clusters/learning/apps/kueue.yaml
check "ClusterQueue defined" bash -c "grep -rq 'kind: ClusterQueue' $M"
check "ResourceFlavor defined" bash -c "grep -rq 'kind: ResourceFlavor' $M"
check "gpu quota set" bash -c "grep -rq 'nvidia.com/gpu' $M"
want  "priority class for preemption" bash -c "grep -rqi 'priority' $M"

section "Live cluster (optional)"
want "kueue controller running" bash -c "kubectl get pods -A | grep -qi kueue"
want "workloads exist" kubectl get workloads -A

section "Self-grade — answer without notes"
ask "What does Kueue admit on — and what happens to a job that exceeds the ClusterQueue quota?"
ask "Walk through the preemption you forced: who got evicted, why, and where did it go?"
ask "Kueue vs Volcano — when do you actually need gang scheduling?"
ask "Argo CD vs Argo Rollouts vs Argo Events — one sentence each."
finish
