# Claude Flow Neural Command Reference

Complete reference for `npx @claude-flow/cli@latest neural` subcommands.

---

## neural train
Train neural patterns with WASM SIMD acceleration.
```bash
npx @claude-flow/cli@latest neural train
```

## neural status
Check neural network status and loaded models.
```bash
npx @claude-flow/cli@latest neural status
```

## neural patterns
Analyze and manage cognitive patterns.
```bash
npx @claude-flow/cli@latest neural patterns
```

## neural predict
Make AI predictions using trained models.
```bash
npx @claude-flow/cli@latest neural predict
```

## neural optimize
Optimize neural patterns (Int8 quantization, memory compression).
```bash
npx @claude-flow/cli@latest neural optimize
```

## neural benchmark
Benchmark RuVector WASM training performance.
```bash
npx @claude-flow/cli@latest neural benchmark
```

## neural list
List available pre-trained models.
```bash
npx @claude-flow/cli@latest neural list
```

## neural export
Export trained models to IPFS (Ed25519 signed).
```bash
npx @claude-flow/cli@latest neural export
```

## neural import
Import trained models from IPFS.
```bash
npx @claude-flow/cli@latest neural import
```

---

## Programmatic API

```typescript
import { NeuralService, SONAAdapter, FlashAttention, MoERouter } from '@claude-flow/neural';

// Neural training
const neural = new NeuralService();
await neural.train(data);
const prediction = await neural.predict(input);

// SONA adaptation (<0.05ms)
const sona = new SONAAdapter();
await sona.adapt({ context: task, learningRate: 0.001 });

// Flash Attention (2.49x-7.47x speedup)
const result = await FlashAttention.compute(Q, K, V);

// MoE routing
const router = new MoERouter();
const route = await router.route(task);
```
