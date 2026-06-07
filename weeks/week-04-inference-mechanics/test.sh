#!/usr/bin/env bash
source "$(dirname "$0")/../lib/test-helpers.sh"
NOTE="notes/week-04-inference-internals.md"

section "Artifact: $NOTE"
file_has "$NOTE" '## *KV cache'
file_has "$NOTE" '## *Continuous batching'
file_has "$NOTE" '## *PagedAttention'
file_has "$NOTE" '## *Quantization'
file_has "$NOTE" '## *Speculative decoding'
file_has "$NOTE" '## *Measured results'
check  "recorded a TTFT number" bash -c "grep -iqE 'ttft' $NOTE"
check  "recorded tokens/sec" bash -c "grep -iqE 'tokens?/s|tok/s|tokens per sec' $NOTE"

section "Self-grade — answer without notes"
ask "Why does the KV cache dominate memory, and what does PagedAttention do about fragmentation?"
ask "Continuous (in-flight) batching vs static batching — why does it raise throughput?"
ask "When would you reach for TensorRT-LLM or SGLang over vLLM?"
ask "What's TTFT measuring vs tokens/sec, and which one do users feel first?"
echo
echo "  Reminder: did you TEAR DOWN the rented GPU? (y to confirm in your head)"
finish
