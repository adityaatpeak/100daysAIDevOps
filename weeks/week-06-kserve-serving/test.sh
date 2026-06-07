#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/vllm"

section "Artifacts in git"
check "manifests/vllm/ non-empty" bash -c "[ -d $M ] && [ -n \"\$(ls -A $M)\" ]"
check "InferenceService or ServingRuntime defined" bash -c "grep -rqE 'kind: (InferenceService|ServingRuntime)' $M"
check "vLLM referenced" bash -c "grep -rqi 'vllm' $M"
check "GPU requested" bash -c "grep -rq 'nvidia.com/gpu' $M"
want  "Grafana dashboard committed" bash -c "grep -rliE 'dashboard|grafana' clusters/learning/manifests | head -1"

section "Live cluster (optional)"
want "InferenceService Ready" bash -c "kubectl get inferenceservice -A -o jsonpath='{.items[*].status.conditions[?(@.type==\"Ready\")].status}' | grep -q True"
want "DCGM metrics scraped" bash -c "kubectl get pods -A | grep -qi dcgm"

section "Self-grade — answer without notes"
ask "What does an InferenceService abstract over a raw Deployment + Service?"
ask "Where does cold-start time go (image pull, node spinup, model load)? Which dominates for a 7B model?"
ask "Which four signals are on your dashboard, and which one warns of saturation first?"
ask "Triton vs a vLLM runtime under KServe — when would you pick each?"
finish
