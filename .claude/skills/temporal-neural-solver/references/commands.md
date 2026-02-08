# temporal-neural-solver API Reference

Complete reference for the `temporal-neural-solver` WASM neural inference engine.

## Table of Contents

- [Installation](#installation)
- [TemporalSolver Class](#temporalsolver-class)
- [InferenceSession Class](#inferencesession-class)
- [Quantizer Class](#quantizer-class)
- [ModelLoader Class](#modelloader-class)
- [Types](#types)
- [Configuration](#configuration)
- [Performance Guide](#performance-guide)

---

## Installation

```bash
npx temporal-neural-solver@latest
```

---

## TemporalSolver Class

### Constructor

```typescript
import { TemporalSolver } from 'temporal-neural-solver';

const solver = new TemporalSolver(options?: TemporalSolverOptions);
```

**TemporalSolverOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `backend` | `string` | `'wasm'` | Backend: `'wasm'`, `'napi'`, `'js'` |
| `threads` | `number` | `1` | WASM worker threads (requires SharedArrayBuffer) |
| `quantization` | `string` | `'none'` | Quantization: `'none'`, `'int8'`, `'int4'`, `'fp16'` |
| `cacheModels` | `boolean` | `true` | Cache compiled WASM models |
| `maxMemoryMB` | `number` | `256` | Maximum WASM memory |
| `simd` | `boolean` | `true` | Enable WASM SIMD instructions |
| `memoryGrowth` | `boolean` | `true` | Allow memory growth |
| `graphOptimization` | `string` | `'all'` | Optimization: `'all'`, `'basic'`, `'none'` |
| `executionMode` | `string` | `'sequential'` | Execution: `'sequential'`, `'parallel'` |

### solve

Run inference on a single input.

```typescript
const result = await solver.solve(
  problem: SolveProblem
): Promise<SolveResult>;
```

**SolveProblem:**

| Field | Type | Description |
|-------|------|-------------|
| `input` | `Float32Array \| number[]` | Input data |
| `inputShape` | `number[]` | Input tensor shape (optional if model has fixed shape) |
| `outputNames` | `string[]` | Output tensor names (optional, returns all) |

**SolveResult:**

| Field | Type | Description |
|-------|------|-------------|
| `output` | `Float32Array` | Primary output tensor data |
| `outputs` | `Record<string, Float32Array>` | All named outputs |
| `outputShape` | `number[]` | Output tensor shape |
| `latencyUs` | `number` | Inference latency (microseconds) |
| `memoryUsedMB` | `number` | Memory used for this inference |

### solveBatch

Batch inference for multiple inputs.

```typescript
const results = await solver.solveBatch(
  problems: SolveProblem[],
  options?: BatchOptions
): Promise<SolveResult[]>;
```

**BatchOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `maxConcurrent` | `number` | `threads` | Max concurrent inferences |
| `timeout` | `number` | `30000` | Batch timeout (ms) |

### loadModel

Load a model from file path.

```typescript
await solver.loadModel(
  path: string,
  options?: LoadOptions
): Promise<void>;
```

**LoadOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `format` | `string` | auto-detect | Format: `'onnx'`, `'gguf'`, `'tflite'` |
| `optimize` | `boolean` | `true` | Apply graph optimizations |
| `warmup` | `number` | `0` | Warmup iterations after load |

### loadModelFromBuffer

Load model from memory buffer.

```typescript
await solver.loadModelFromBuffer(
  buffer: Uint8Array | ArrayBuffer,
  options?: LoadOptions
): Promise<void>;
```

### benchmark

Run performance benchmark.

```typescript
const result = await solver.benchmark(
  options?: BenchmarkOptions
): Promise<BenchmarkResult>;
```

**BenchmarkOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `iterations` | `number` | `1000` | Number of inference runs |
| `warmup` | `number` | `100` | Warmup iterations |
| `inputShape` | `number[]` | model default | Input shape for random data |

**BenchmarkResult:**

| Field | Type | Description |
|-------|------|-------------|
| `avgLatencyUs` | `number` | Average latency (us) |
| `p50LatencyUs` | `number` | Median latency |
| `p95LatencyUs` | `number` | 95th percentile |
| `p99LatencyUs` | `number` | 99th percentile |
| `minLatencyUs` | `number` | Minimum latency |
| `maxLatencyUs` | `number` | Maximum latency |
| `throughput` | `number` | Inferences per second |
| `memoryPeakMB` | `number` | Peak memory usage |
| `backend` | `string` | Backend used |
| `simdEnabled` | `boolean` | SIMD was enabled |

### getModelInfo

```typescript
const info = solver.getModelInfo(): ModelInfo;
```

**ModelInfo:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Model name |
| `format` | `string` | Model format |
| `inputs` | `TensorInfo[]` | Input tensor info |
| `outputs` | `TensorInfo[]` | Output tensor info |
| `paramCount` | `number` | Total parameters |
| `sizeBytes` | `number` | Model size |
| `opset` | `number` | ONNX opset version |
| `quantized` | `boolean` | Whether quantized |

### warmup / dispose

```typescript
await solver.warmup(iterations?: number): Promise<void>;
solver.dispose(): void;  // Free all WASM memory
```

---

## InferenceSession Class

Low-level session API for direct tensor manipulation.

### Constructor

```typescript
import { InferenceSession } from 'temporal-neural-solver';

const session = new InferenceSession(options: SessionOptions);
```

**SessionOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `model` | `Uint8Array` | required | Model buffer |
| `executionProviders` | `string[]` | `['wasm']` | Execution providers |
| `graphOptLevel` | `string` | `'all'` | Optimization level |
| `enableMemoryPattern` | `boolean` | `true` | Memory pattern optimization |
| `enableCpuMemArena` | `boolean` | `true` | CPU memory arena |
| `interOpNumThreads` | `number` | `1` | Inter-operator parallelism |
| `intraOpNumThreads` | `number` | `1` | Intra-operator parallelism |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `run(feeds)` | `Promise<OutputMap>` | Execute inference |
| `getInputNames()` | `string[]` | Input tensor names |
| `getOutputNames()` | `string[]` | Output tensor names |
| `getMetadata()` | `ModelMetadata` | Model metadata |
| `dispose()` | `void` | Release resources |

---

## Quantizer Class

### Constructor

```typescript
import { Quantizer } from 'temporal-neural-solver';

const quantizer = new Quantizer(options: QuantizerOptions);
```

**QuantizerOptions:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `method` | `string` | `'int8'` | Method: `'int8'`, `'int4'`, `'fp16'`, `'dynamic'` |
| `calibrationData` | `Float32Array[]` | `undefined` | Static quantization calibration |
| `perChannel` | `boolean` | `true` | Per-channel quantization |
| `symmetric` | `boolean` | `true` | Symmetric quantization |
| `excludeOps` | `string[]` | `[]` | Operations to skip |

### Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `quantize(model)` | `Promise<Uint8Array>` | Quantize model buffer |
| `calibrate(model, data)` | `Promise<CalibrationResult>` | Run calibration pass |
| `analyze(model)` | `Promise<QuantAnalysis>` | Analyze quantization impact |
| `compare(original, quantized, data)` | `Promise<CompareResult>` | Compare accuracy |

---

## ModelLoader Class

```typescript
import { ModelLoader } from 'temporal-neural-solver';

const model = await ModelLoader.fromUrl('https://example.com/model.onnx');
const model = await ModelLoader.fromFile('./model.onnx');
const model = await ModelLoader.fromBuffer(buffer);
```

### Static Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `fromUrl(url)` | `Promise<Uint8Array>` | Download model from URL |
| `fromFile(path)` | `Promise<Uint8Array>` | Load from file path |
| `fromBuffer(buf)` | `Uint8Array` | Validate and return buffer |
| `detectFormat(buf)` | `string` | Detect model format |
| `validate(buf)` | `boolean` | Validate model integrity |

---

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TEMPORAL_BACKEND` | Default backend | `'wasm'` |
| `TEMPORAL_THREADS` | Default thread count | `1` |
| `TEMPORAL_SIMD` | Enable SIMD | `true` |
| `TEMPORAL_MAX_MEMORY_MB` | Max WASM memory | `256` |
| `TEMPORAL_LOG_LEVEL` | Log level | `'warn'` |
| `TEMPORAL_CACHE_DIR` | Model cache directory | `~/.temporal-solver` |

### Type Exports

```typescript
import type {
  TemporalSolverOptions,
  SolveProblem,
  SolveResult,
  BatchOptions,
  LoadOptions,
  BenchmarkOptions,
  BenchmarkResult,
  ModelInfo,
  TensorInfo,
  SessionOptions,
  QuantizerOptions,
  CalibrationResult,
  QuantAnalysis,
  CompareResult,
} from 'temporal-neural-solver';
```

---

## Performance Guide

| Configuration | Latency | Use Case |
|--------------|---------|----------|
| `wasm + simd + int8` | <1us | Ultra-low latency, edge |
| `wasm + simd` | 1-10us | Standard edge inference |
| `wasm, no simd` | 10-100us | Browser compatibility |
| `napi` | 0.5-5us | Node.js server |
| `js` | 100us-1ms | Fallback, debugging |

**Tips:**
- Always run `warmup()` before benchmarking
- Use `int8` quantization for 2-4x speedup with <1% accuracy loss
- Enable SIMD for 2-4x speedup on supported runtimes
- Use `threads > 1` only for large models (>10M params)
