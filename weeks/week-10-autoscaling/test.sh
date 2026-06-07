#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/autoscaling"

section "Artifacts in git"
check "manifests/autoscaling/ non-empty" bash -c "[ -d $M ] && [ -n \"\$(ls -A $M)\" ]"
check "HPA defined" bash -c "grep -rq 'kind: HorizontalPodAutoscaler' $M"
check "scales on a non-CPU metric (Pods/External/Object)" bash -c "grep -rqE 'type: (Pods|External|Object)' $M"
check "prometheus-adapter config present" bash -c "grep -rqiE 'prometheus-adapter|seriesQuery|metricsQuery' $M"
want  "load-test artifact present" bash -c "grep -rqiE 'fortio|hey|k6|locust|load' $M"

section "Live cluster (optional)"
want "HPA exists" kubectl get hpa -A
want "custom.metrics API available" bash -c "kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1 >/dev/null 2>&1 || kubectl get --raw /apis/external.metrics.k8s.io/v1beta1 >/dev/null 2>&1"

section "Self-grade — answer without notes"
ask "Why is CPU utilization a bad scale signal for an LLM server? What does it miss?"
ask "Which serving metric did you scale on, and why that one over the alternatives?"
ask "Trace the path of your metric: vLLM/Istio → Prometheus → ? → HPA."
ask "What stabilization-window / min-max did you set, and what oscillation are you preventing?"
finish
