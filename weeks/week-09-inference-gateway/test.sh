#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/inference-gateway"

section "Artifacts in git"
check "manifests/inference-gateway/ non-empty" bash -c "[ -d $M ] && [ -n \"\$(ls -A $M)\" ]"
check "apps/inference-gateway.yaml exists" test -f clusters/learning/apps/inference-gateway.yaml
check "Gateway defined" bash -c "grep -rq 'kind: Gateway' $M"
check "InferencePool defined" bash -c "grep -rq 'InferencePool' $M"
want  "InferenceModel / model-aware routing" bash -c "grep -rqE 'InferenceModel|modelName|lora' $M"
want  "token-aware rate limiting referenced" bash -c "grep -rqiE 'token|ratelimit|rate-limit' $M"

section "Live cluster (optional)"
want "Gateway programmed" bash -c "kubectl get gateway -A -o jsonpath='{.items[*].status.conditions[?(@.type==\"Programmed\")].status}' | grep -q True"
want "InferencePool present" kubectl get inferencepool -A

section "Self-grade — answer without notes"
ask "What does an InferencePool add over a plain HTTPRoute to a Service?"
ask "How does model/LoRA-aware routing pick a backend?"
ask "Why is token-aware rate limiting necessary — what fails with request-count limits?"
ask "Draw the path: client → ? → ? → vLLM. Where does Istio's Gateway sit vs this one?"
finish
