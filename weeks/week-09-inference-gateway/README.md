# Week 09 — Inference at the gateway  `[infra]`  ⭐ work-aligned

> Route to the model through an **inference-aware** gateway. Maps to your 2026 LLM-gateway goal — extra polish.

## Objectives
- [ ] Gateway API Inference Extension: `InferencePool`, model/LoRA-aware routing, token-aware rate limiting
- [ ] **Build:** route to the KServe/vLLM endpoint through an inference-aware gateway

## The build (infra → Argo CD)
`clusters/learning/manifests/inference-gateway/` + `clusters/learning/apps/inference-gateway.yaml`:
- A Gateway API `Gateway` + the **Inference Extension** (`InferencePool`, `InferenceModel`) pointing at the Week-6 vLLM `InferenceService`.
- Model-aware routing: route by model name / LoRA adapter to backends in the pool.
- **Token-aware rate limiting** (not request-count) so a few huge prompts can't starve everyone.
- Decide where this sits vs the Istio Gateway from Week 3 (north-south entry → inference gateway → KServe). Document the topology in the manifest comments.

> ⭐ This is the "LLM gateway" your team cares about — make the routing + rate-limit policy legible.

## How to study (≈8h)
- gateway-api-inference-extension.sigs.k8s.io: InferencePool/InferenceModel, the endpoint-picker, why request-count rate limits are wrong for LLMs.
- Send requests for two "models"/adapters, confirm they route differently; push token volume and watch the rate limiter engage.

## End-of-week test
```bash
bash weeks/week-09-inference-gateway/test.sh
```
Checks the gateway + InferencePool in git and the rate-limit policy; optionally verifies the Gateway is programmed; quizzes model-aware routing and token vs request limiting.
