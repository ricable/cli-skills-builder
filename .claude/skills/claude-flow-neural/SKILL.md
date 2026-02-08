---
name: "Claude Flow Neural"
description: "Neural pattern training with WASM SIMD acceleration, MoE routing, Flash Attention, and cognitive pattern learning. Use when training neural patterns, making predictions, optimizing models, or benchmarking WASM training performance."
---

# Claude Flow Neural

Neural module providing SONA learning integration, WASM SIMD-accelerated training, Mixture of Experts (MoE) routing, Flash Attention, and cognitive pattern analysis.

## Quick Command Reference

| Task | Command |
|------|---------|
| Train patterns | `npx @claude-flow/cli@latest neural train` |
| Check status | `npx @claude-flow/cli@latest neural status` |
| Analyze patterns | `npx @claude-flow/cli@latest neural patterns` |
| Make prediction | `npx @claude-flow/cli@latest neural predict` |
| Optimize models | `npx @claude-flow/cli@latest neural optimize` |
| Run benchmark | `npx @claude-flow/cli@latest neural benchmark` |
| List models | `npx @claude-flow/cli@latest neural list` |
| Export model | `npx @claude-flow/cli@latest neural export` |
| Import model | `npx @claude-flow/cli@latest neural import` |

## Core Commands

### neural train
Train neural patterns with WASM SIMD acceleration.
```bash
npx @claude-flow/cli@latest neural train
```

### neural status
Check neural network status and loaded models.
```bash
npx @claude-flow/cli@latest neural status
```

### neural patterns
Analyze and manage cognitive patterns.
```bash
npx @claude-flow/cli@latest neural patterns
```

### neural predict
Make AI predictions using trained models.
```bash
npx @claude-flow/cli@latest neural predict
```

### neural optimize
Optimize neural patterns (Int8 quantization, memory compression).
```bash
npx @claude-flow/cli@latest neural optimize
```

### neural benchmark
Benchmark RuVector WASM training performance.
```bash
npx @claude-flow/cli@latest neural benchmark
```

### neural list
List available pre-trained models.
```bash
npx @claude-flow/cli@latest neural list
```

### neural export
Export trained models to IPFS (Ed25519 signed).
```bash
npx @claude-flow/cli@latest neural export
```

### neural import
Import trained models from IPFS.
```bash
npx @claude-flow/cli@latest neural import
```

## Common Patterns

### Train and Evaluate
```bash
# Train neural patterns
npx @claude-flow/cli@latest neural train

# Check status
npx @claude-flow/cli@latest neural status

# Make predictions
npx @claude-flow/cli@latest neural predict
```

### Optimize for Production
```bash
# Optimize with Int8 quantization
npx @claude-flow/cli@latest neural optimize

# Benchmark performance
npx @claude-flow/cli@latest neural benchmark
```

### Share Models via IPFS
```bash
# Export trained model
npx @claude-flow/cli@latest neural export

# Import on another machine
npx @claude-flow/cli@latest neural import
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { NeuralService, SONAAdapter, FlashAttention } from '@claude-flow/neural';

// Initialize neural service
const neural = new NeuralService();

// Train patterns
await neural.train(trainingData);

// Make predictions
const prediction = await neural.predict(input);

// Use Flash Attention for large contexts
const result = await FlashAttention.compute(Q, K, V);
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow-embeddings](../claude-flow-embeddings/), [claude-flow-memory](../claude-flow-memory/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/neural)
