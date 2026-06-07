# Week 04 — Inference mechanics + first serve  `[notes]`+`[infra]`

> New ground. Understand *why serving is hard*, then actually serve a small model on one rented GPU and record real numbers.

## Objectives
- [ ] KV cache, continuous batching, PagedAttention, quantization, speculative decoding — why serving is hard
- [ ] vLLM as default; where SGLang / TensorRT-LLM differ
- [ ] **Build:** `notes/week-04-inference-internals.md` + first vLLM run — serve a small open-weight model, hit the OpenAI-compatible API, record **TTFT + tokens/sec**

## The build
1. **Note** `notes/week-04-inference-internals.md`, required sections:
   - `## KV cache` · `## Continuous batching` · `## PagedAttention` · `## Quantization` · `## Speculative decoding` · `## Engine comparison` (vLLM vs SGLang vs TensorRT-LLM) · `## Measured results` (your TTFT + tokens/sec table).
2. **First serve** (one rented GPU, by the hour — **tear it down after**):
   - `vllm serve <1-8B open-weight model>` (e.g. a small Qwen/Llama-class model).
   - Hit `POST /v1/chat/completions` (OpenAI-compatible).
   - Capture TTFT (stream first token) and steady-state tokens/sec at a couple of concurrency levels.

> ⚠️ **GPU cost discipline:** ONE small GPU, rented hourly, **destroyed at end of session**. This week is a laptop/cloud-VM run, not EKS yet (that's Week 6).

## How to study (≈8h)
- docs.vllm.ai: architecture, PagedAttention paper summary, continuous batching.
- Run with `--max-model-len` modest; watch GPU memory vs KV-cache blocks in vLLM logs.

## End-of-week test
```bash
bash weeks/week-04-inference-mechanics/test.sh
```
Checks the note's sections + that you recorded numbers, and quizzes the mechanics. (No live cluster checks — this is a rented-GPU week.)
