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

## Learn & do — topic by topic

### 1 · KV cache · continuous batching · PagedAttention
- **Read:** [vLLM PagedAttention blog](https://blog.vllm.ai/2023/06/20/vllm.html) · [vLLM docs home](https://docs.vllm.ai/en/latest/) · [Continuous batching (Anyscale write-up)](https://www.anyscale.com/blog/continuous-batching-llm-inference)
- **Hands-on:** start `vllm serve` and read the startup log — note the number of KV-cache blocks and GPU memory reserved. Lower `--max-model-len` and watch block count change.

### 2 · Quantization · speculative decoding
- **Read:** [vLLM quantization](https://docs.vllm.ai/en/latest/features/quantization/) · [vLLM speculative decoding](https://docs.vllm.ai/en/latest/features/spec_decode/)
- **Hands-on:** serve the model once at full precision and once quantized (e.g. AWQ/GPTQ build if available); compare GPU memory + tokens/sec. Note the quality/throughput trade-off you observe.

### 3 · Engine comparison — vLLM vs SGLang vs TensorRT-LLM
- **Read:** [SGLang](https://docs.sglang.ai/) · [TensorRT-LLM](https://nvidia.github.io/TensorRT-LLM/)
- **Hands-on:** write a 5-row comparison table (ease, perf ceiling, hardware lock-in, features like structured output / prefix caching) and pick a default + when you'd switch.

### Build · serve & measure
- **Read:** [vLLM OpenAI-compatible server](https://docs.vllm.ai/en/latest/serving/openai_compatible_server.html)
- **Hands-on:** hit `/v1/chat/completions` with `stream:true` to time **TTFT** (first token); then send N concurrent requests to measure steady **tokens/sec** at 2 concurrency levels. Record both in the note. **Then tear the GPU down.**

## End-of-week test
```bash
bash weeks/week-04-inference-mechanics/test.sh
```
Checks the note's sections + that you recorded numbers, and quizzes the mechanics. (No live cluster checks — this is a rented-GPU week.)
