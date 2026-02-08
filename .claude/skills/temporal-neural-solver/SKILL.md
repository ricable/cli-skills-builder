---
name: "temporal-neural-solver"
description: "Ultra-fast WASM neural inference engine with sub-microsecond latency for edge and browser deployments. Use when running neural network inference in WebAssembly, deploying models to edge devices, performing real-time prediction in browsers, or needing minimal-overhead inference for latency-critical applications."
---

# temporal-neural-solver

Ultra-fast neural network inference engine compiled to WebAssembly, achieving sub-microsecond latency for edge, browser, and serverless deployments with minimal memory overhead.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx temporal-neural-solver@latest` |
| Import | `import { TemporalSolver } from 'temporal-neural-solver';` |
| Create | `const solver = new TemporalSolver();` |
| Load model | `await solver.loadModel(modelPath);` |
| Infer | `const result = await solver.solve(problem);` |
| Benchmark | `const perf = await solver.benchmark();` |

## Installation

**Install**: `npx temporal-neural-solver@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Key API

### TemporalSolver

The main WASM-accelerated neural inference engine.

```typescript
import { TemporalSolver } from 'temporal-neural-solver';

const solver = new TemporalSolver({
  backend: 'wasm',
  threads: 4,
  quantization: 'int8',
});
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `backend` | `string` | `'wasm'` | Backend: `'wasm'`, `'napi'`, `'js'` |
| `threads` | `number` | `1` | Worker threads for WASM |
| `quantization` | `string` | `'none'` | Quantization: `'none'`, `'int8'`, `'int4'`, `'fp16'` |
| `cacheModels` | `boolean` | `true` | Cache loaded models |
| `maxMemoryMB` | `number` | `256` | Maximum memory usage |
| `simd` | `boolean` | `true` | Enable WASM SIMD |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `solve(problem)` | `Promise<SolveResult>` | Run neural inference |
| `solveBatch(problems)` | `Promise<SolveResult[]>` | Batch inference |
| `loadModel(path)` | `Promise<void>` | Load ONNX/GGUF model |
| `loadModelFromBuffer(buf)` | `Promise<void>` | Load model from buffer |
| `benchmark(opts?)` | `Promise<BenchmarkResult>` | Run performance benchmark |
| `getModelInfo()` | `ModelInfo` | Loaded model information |
| `warmup(iterations?)` | `Promise<void>` | Warm up inference pipeline |
| `dispose()` | `void` | Free WASM memory |

### InferenceSession

Low-level inference session for fine-grained control.

```typescript
import { InferenceSession } from 'temporal-neural-solver';

const session = new InferenceSession({
  model: modelBuffer,
  executionProviders: ['wasm'],
});

const output = await session.run({ input: inputTensor });
```

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `run(feeds)` | `Promise<OutputMap>` | Run inference with named inputs |
| `getInputNames()` | `string[]` | Get model input names |
| `getOutputNames()` | `string[]` | Get model output names |
| `getMetadata()` | `ModelMetadata` | Get model metadata |

### Quantizer

Model quantization for size and speed optimization.

```typescript
import { Quantizer } from 'temporal-neural-solver';

const quantizer = new Quantizer({ method: 'int8', calibrationData: data });
const quantized = await quantizer.quantize(modelBuffer);
```

**Constructor Options:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `method` | `string` | `'int8'` | Quantization: `'int8'`, `'int4'`, `'fp16'`, `'dynamic'` |
| `calibrationData` | `Float32Array[]` | `undefined` | Calibration data for static quant |
| `perChannel` | `boolean` | `true` | Per-channel quantization |

## Common Patterns

### Edge Neural Inference

```typescript
import { TemporalSolver } from 'temporal-neural-solver';

const solver = new TemporalSolver({ backend: 'wasm', quantization: 'int8' });
await solver.loadModel('./model.onnx');
await solver.warmup(10);

const result = await solver.solve({ input: sensorData });
console.log(`Prediction: ${result.output}, Latency: ${result.latencyUs}us`);
```

### Browser Deployment

```typescript
import { TemporalSolver } from 'temporal-neural-solver';

const solver = new TemporalSolver({ backend: 'wasm', simd: true });

const response = await fetch('/models/classifier.onnx');
const buffer = await response.arrayBuffer();
await solver.loadModelFromBuffer(new Uint8Array(buffer));

const prediction = await solver.solve({ image: imageData });
```

### Batch Processing Pipeline

```typescript
import { TemporalSolver } from 'temporal-neural-solver';

const solver = new TemporalSolver({ threads: 4 });
await solver.loadModel('./model.onnx');

const results = await solver.solveBatch(
  inputs.map(input => ({ input }))
);
console.log(`Avg latency: ${results.reduce((a, r) => a + r.latencyUs, 0) / results.length}us`);
```

## RAN DDD Context

**Bounded Context**: RANO Optimization

## References

- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/temporal-neural-solver)
