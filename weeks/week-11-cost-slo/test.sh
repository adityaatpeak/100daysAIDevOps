#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
NOTE="notes/week-11-cost-slo.md"

section "Artifact: $NOTE"
file_has "$NOTE" '## *GPU cost model'
file_has "$NOTE" '## *Right-sizing'
file_has "$NOTE" '## *SLOs'
file_has "$NOTE" '## *Alerting'
file_has "$NOTE" '## *Failure modes'
check "has a $/token or $/hr figure" bash -c "grep -qE '\\\$[0-9]' $NOTE"
check "contains a PromQL alerting rule (expr/rate/histogram)" bash -c "grep -qiE 'expr:|rate\\(|histogram_quantile|alert:' $NOTE"

section "Self-grade — answer without notes"
ask "What's your $/1M-tokens estimate and the top driver of it?"
ask "Spot for inference — what breaks, and how do you make it tolerable?"
ask "State your SLO and compute the monthly error budget in minutes."
ask "Explain your alerting rule's PromQL — what fires it and why that threshold?"
finish
