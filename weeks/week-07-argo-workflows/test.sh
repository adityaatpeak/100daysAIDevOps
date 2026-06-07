#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
M="clusters/learning/manifests/workflows"

section "Artifacts in git"
check "manifests/workflows/ non-empty" bash -c "[ -d $M ] && [ -n \"\$(ls -A $M)\" ]"
check "uses a dag template" bash -c "grep -rq 'dag:' $M"
check "declares dependencies" bash -c "grep -rq 'dependencies:' $M"
check "uses parameters" bash -c "grep -rq 'parameters:' $M"
check "uses artifacts" bash -c "grep -rq 'artifacts:' $M"
check "has a retryStrategy" bash -c "grep -rq 'retryStrategy' $M"
check "has an exit handler (onExit)" bash -c "grep -rqE 'onExit|exitHandler' $M"

section "Secrets & client-detail hygiene (must stay clean)"
check "no obvious secret keys inline" bash -c "! grep -rqiE 'AKIA[0-9A-Z]{16}|secretkey:|password:|aws_secret' $M"

section "Live cluster (optional)"
want "argo workflow controller running" bash -c "kubectl get pods -A | grep -qi workflow-controller"

section "Self-grade — answer without notes"
ask "Why a DAG over linear steps here — what does it buy you?"
ask "Parameters vs artifacts — when do you use each?"
ask "A middle node fails after its retries — what happens to siblings, and does onExit still run?"
ask "How are the S3 artifact-repo creds supplied WITHOUT being in git?"
finish
