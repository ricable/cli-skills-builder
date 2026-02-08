# @ruvector/ruvllm-cli Command Reference

Complete reference for all `@ruvector/ruvllm-cli` commands and options.

## Table of Contents

- [run](#run)
- [chat](#chat)
- [download](#download)
- [models](#models)
- [serve](#serve)
- [bench](#bench)
- [info](#info)
- [quantize](#quantize)
- [embed](#embed)
- [Types](#types)

---

## run

Run inference on a prompt.

```bash
npx @ruvector/ruvllm-cli@latest run [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--model <path>` | Model file path (GGUF) |
| `--prompt <text>` | Input prompt |
| `--system <text>` | System prompt |
| `--max-tokens <n>` | Max output tokens (default: 512) |
| `--temperature <f>` | Sampling temperature (default: 0.7) |
| `--top-p <f>` | Top-p sampling (default: 0.9) |
| `--top-k <n>` | Top-k sampling (default: 40) |
| `--repeat-penalty <f>` | Repetition penalty (default: 1.1) |
| `--gpu` | Enable GPU acceleration (Metal/CUDA) |
| `--threads <n>` | CPU threads (default: auto) |
| `--ctx-size <n>` | Context window size (default: 2048) |
| `--seed <n>` | Random seed |
| `--format <type>` | Output format (text, json) |

**Examples:**
```bash
npx @ruvector/ruvllm-cli@latest run --model ./llama.gguf --prompt "Explain HNSW indexing"
npx @ruvector/ruvllm-cli@latest run --model ./model.gguf --prompt "Hello" --gpu --max-tokens 256
npx @ruvector/ruvllm-cli@latest run --model ./model.gguf --prompt "Code review" --temperature 0.3
```

---

## chat

Interactive chat mode with conversation history.

```bash
npx @ruvector/ruvllm-cli@latest chat [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--model <path>` | Model file path |
| `--system <prompt>` | System prompt |
| `--temperature <f>` | Temperature (default: 0.7) |
| `--gpu` | GPU acceleration |
| `--ctx-size <n>` | Context window |
| `--threads <n>` | CPU threads |
| `--save <path>` | Save conversation history |

**Examples:**
```bash
npx @ruvector/ruvllm-cli@latest chat --model ./llama.gguf --gpu
npx @ruvector/ruvllm-cli@latest chat --model ./model.gguf --system "You are a coding assistant"
```

---

## download

Download models from Hugging Face Hub.

```bash
npx @ruvector/ruvllm-cli@latest download <model-id> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--quantization <type>` | Quantization level |
| `--output <path>` | Download directory |
| `--token <string>` | HF access token |

**Quantization types:**
| Type | Size | Quality |
|------|------|---------|
| `q2_k` | Smallest | Lowest |
| `q3_k_m` | Small | Low |
| `q4_k_m` | Medium | Good |
| `q5_k_m` | Large | Better |
| `q6_k` | Larger | High |
| `q8_0` | Largest | Highest |
| `f16` | Full | Original |

**Examples:**
```bash
npx @ruvector/ruvllm-cli@latest download TheBloke/Llama-2-7B-GGUF --quantization q4_k_m
npx @ruvector/ruvllm-cli@latest download meta-llama/Llama-3.2-1B --output ./models/
```

---

## models

Model management.

### models list

```bash
npx @ruvector/ruvllm-cli@latest models list [--format json]
```

### models info

```bash
npx @ruvector/ruvllm-cli@latest models info <name>
```

### models delete

```bash
npx @ruvector/ruvllm-cli@latest models delete <name> [--yes]
```

### models search

```bash
npx @ruvector/ruvllm-cli@latest models search <query> [--limit <n>]
```

---

## serve

Serve model via OpenAI-compatible HTTP API.

```bash
npx @ruvector/ruvllm-cli@latest serve [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--model <path>` | Model file path |
| `--port <n>` | Server port (default: 8080) |
| `--host <string>` | Bind host (default: localhost) |
| `--gpu` | GPU acceleration |
| `--threads <n>` | CPU threads |
| `--ctx-size <n>` | Context window |
| `--cors` | Enable CORS |
| `--api-key <string>` | Require API key |

**API endpoints:**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v1/chat/completions` | POST | Chat completion |
| `/v1/completions` | POST | Text completion |
| `/v1/embeddings` | POST | Generate embeddings |
| `/v1/models` | GET | List loaded models |
| `/health` | GET | Health check |

**Examples:**
```bash
npx @ruvector/ruvllm-cli@latest serve --model ./model.gguf --port 8080 --gpu
npx @ruvector/ruvllm-cli@latest serve --model ./model.gguf --cors --api-key my-secret
```

---

## bench

Benchmark inference performance.

```bash
npx @ruvector/ruvllm-cli@latest bench [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--model <path>` | Model file |
| `--iterations <n>` | Iterations (default: 10) |
| `--prompt-length <n>` | Input token count |
| `--gen-length <n>` | Output token count |
| `--gpu` | GPU acceleration |
| `--output <path>` | Save results |

**Output metrics:**
- Tokens per second (prompt processing)
- Tokens per second (generation)
- Time to first token
- Total latency
- Memory usage

---

## info

Show model file information.

```bash
npx @ruvector/ruvllm-cli@latest info <model-path>
```

**Output includes:**
- Model architecture
- Parameter count
- Quantization type
- Context length
- Vocabulary size
- File size

---

## quantize

Quantize a model to a smaller format.

```bash
npx @ruvector/ruvllm-cli@latest quantize <input> <output> [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--type <quantization>` | Target quantization |
| `--threads <n>` | CPU threads |

---

## embed

Generate text embeddings.

```bash
npx @ruvector/ruvllm-cli@latest embed --model <path> --text "input text"
```

**Options:**
| Option | Description |
|--------|-------------|
| `--model <path>` | Model file |
| `--text <string>` | Input text |
| `--file <path>` | Input file (one text per line) |
| `--output <path>` | Save embeddings |
| `--format <type>` | Output format (json, npy) |

---

## Types

### Supported GPU Backends

| Backend | Platform | Flag |
|---------|----------|------|
| Metal | macOS | `--gpu` |
| CUDA | Linux/Windows | `--gpu` |
| Vulkan | Cross-platform | `--gpu --backend vulkan` |
| CPU | All | default |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `RUVLLM_MODEL_DIR` | Default model directory |
| `RUVLLM_GPU` | Enable GPU by default (0/1) |
| `RUVLLM_THREADS` | Default thread count |
| `HF_TOKEN` | Hugging Face token for downloads |
