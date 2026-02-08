---
name: "@ruvector/ruvllm-cli"
description: "CLI for local LLM inference with Metal/CUDA acceleration, model management, and benchmarking. Use when running local LLM inference, downloading and managing GGUF models, benchmarking inference performance, serving models via HTTP API, or comparing model outputs across different quantization levels."
---

# @ruvector/ruvllm-cli

CLI for local LLM inference, benchmarking, and model management. Run quantized models locally with Metal (macOS) and CUDA (Linux/Windows) GPU acceleration. Supports GGUF format models, HTTP serving, and performance benchmarking.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx @ruvector/ruvllm-cli@latest --help` |
| Run inference | `npx @ruvector/ruvllm-cli@latest run --model <path>` |
| Chat mode | `npx @ruvector/ruvllm-cli@latest chat --model <path>` |
| Download model | `npx @ruvector/ruvllm-cli@latest download <model-id>` |
| List models | `npx @ruvector/ruvllm-cli@latest models list` |
| Serve model | `npx @ruvector/ruvllm-cli@latest serve --model <path>` |
| Benchmark | `npx @ruvector/ruvllm-cli@latest bench --model <path>` |
| Model info | `npx @ruvector/ruvllm-cli@latest info <model-path>` |

## Installation

**Install**: `npx @ruvector/ruvllm-cli@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### run
Run inference on a prompt.
```bash
npx @ruvector/ruvllm-cli@latest run --model <path> --prompt "Your prompt"
```
**Options:** `--model <path>`, `--prompt <text>`, `--max-tokens <n>`, `--temperature <f>`, `--gpu`, `--threads <n>`

### chat
Interactive chat mode.
```bash
npx @ruvector/ruvllm-cli@latest chat --model <path>
```
**Options:** `--model <path>`, `--system <prompt>`, `--temperature <f>`, `--gpu`

### download
Download models from Hugging Face Hub.
```bash
npx @ruvector/ruvllm-cli@latest download <model-id> [--quantization q4_k_m]
```

### models
Model management.
```bash
npx @ruvector/ruvllm-cli@latest models list
npx @ruvector/ruvllm-cli@latest models info <name>
npx @ruvector/ruvllm-cli@latest models delete <name>
```

### serve
Serve model via HTTP API (OpenAI-compatible).
```bash
npx @ruvector/ruvllm-cli@latest serve --model <path> --port 8080
```

### bench
Benchmark inference performance.
```bash
npx @ruvector/ruvllm-cli@latest bench --model <path> [--iterations <n>]
```

## Common Patterns

### Quick Chat
```bash
npx @ruvector/ruvllm-cli@latest download TheBloke/Llama-2-7B-GGUF --quantization q4_k_m
npx @ruvector/ruvllm-cli@latest chat --model llama-2-7b-q4_k_m.gguf --gpu
```

### API Server
```bash
npx @ruvector/ruvllm-cli@latest serve --model ./model.gguf --port 8080 --gpu
# Then: curl http://localhost:8080/v1/chat/completions -d '{"messages": [...]}'
```

## RAN DDD Context
**Bounded Context**: Learning

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/ruvllm-cli)
