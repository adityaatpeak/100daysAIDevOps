#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/gpu-operator"

section "Artifacts in git"
check "manifests/gpu-operator/ non-empty" bash -c "[ -d $M ] && [ -n \"\$(ls -A $M)\" ]"
check "apps/gpu-operator.yaml exists" test -f clusters/learning/apps/gpu-operator.yaml
check "a pod/manifest requests nvidia.com/gpu" bash -c "grep -rq 'nvidia.com/gpu' $M"
want  "Karpenter scale-to-zero hinted (NodePool/limits/consolidation)" bash -c "grep -rqiE 'nodepool|consolidat|disruption' $M"

section "Live cluster (optional)"
want "GPU operator namespace present" bash -c "kubectl get ns | grep -qiE 'gpu-operator|nvidia'"
want "a node advertises nvidia.com/gpu" bash -c "kubectl get nodes -o jsonpath='{.items[*].status.allocatable.nvidia\\.com/gpu}' | grep -q '[1-9]'"
want "DCGM exporter present" bash -c "kubectl get pods -A | grep -qi dcgm"

section "Self-grade — answer without notes"
ask "What three things does the GPU Operator install, and what does each do?"
ask "MIG vs time-slicing — give one workload that fits each."
ask "What problem does DRA solve that the device plugin model doesn't?"
ask "How do you GUARANTEE this GPU node is gone (not just idle) after a session?"
finish
