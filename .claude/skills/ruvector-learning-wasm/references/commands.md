# @ruvector/learning-wasm API Reference

Complete API reference for the `@ruvector/learning-wasm` MicroLoRA adaptation engine.

## Table of Contents

- [Initialization](#initialization)
- [MicroLoRA](#microlora)
- [Functional API](#functional-api)
- [Types](#types)

---

## Initialization

```typescript
import init from '@ruvector/learning-wasm';
await init();
```

---

## MicroLoRA

### Constructor

```typescript
import { MicroLoRA } from '@ruvector/learning-wasm';
const adapter = new MicroLoRA(config: LoRAConfig);
```

**LoRAConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `inputDim` | `number` | required | Input dimension |
| `outputDim` | `number` | required | Output dimension |
| `rank` | `number` | `2` | LoRA rank |
| `alpha` | `number` | `1.0` | Scale factor |
| `learningRate` | `number` | `0.001` | Learning rate |
| `dropout` | `number` | `0.0` | Dropout rate |
| `initScale` | `number` | `0.01` | Init weight scale |

### adapter.adapt(input, target)

Single-example adaptation step. Returns scalar loss.

```typescript
adapter.adapt(input: Float32Array, target: Float32Array): number
```

### adapter.adaptBatch(examples)

Batch adaptation. Returns average loss.

```typescript
adapter.adaptBatch(examples: Array<{ input: Float32Array; target: Float32Array }>): number
```

### adapter.apply(weights)

Apply LoRA delta to base weights.

```typescript
adapter.apply(weights: Float32Array): Float32Array
```

### adapter.delta()

Get the LoRA delta matrix (B * A * alpha).

```typescript
adapter.delta(): Float32Array
```

### adapter.reset()

Reset A and B matrices to initial values.

```typescript
adapter.reset(): void
```

### adapter.loss(input, target)

Compute loss without updating weights.

```typescript
adapter.loss(input: Float32Array, target: Float32Array): number
```

### adapter.stats()

Get adapter statistics.

```typescript
adapter.stats(): AdapterStats
```

**AdapterStats:**
| Field | Type | Description |
|-------|------|-------------|
| `rank` | `number` | Current rank |
| `inputDim` | `number` | Input dimension |
| `outputDim` | `number` | Output dimension |
| `stepsCompleted` | `number` | Total adapt() calls |
| `averageLoss` | `number` | Running average loss |
| `paramCount` | `number` | Trainable parameters |

### adapter.save()

Serialize adapter state to bytes.

```typescript
adapter.save(): Uint8Array
```

### MicroLoRA.load(data)

Restore adapter from serialized state.

```typescript
MicroLoRA.load(data: Uint8Array): MicroLoRA
```

### adapter.free()

Free WASM heap memory.

```typescript
adapter.free(): void
```

---

## Functional API

### adaptWeights(baseWeights, config)

One-shot weight adaptation.

```typescript
import { adaptWeights } from '@ruvector/learning-wasm';

adaptWeights(
  baseWeights: Float32Array,
  config: AdaptConfig
): Float32Array
```

**AdaptConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `inputDim` | `number` | required | Input dimension |
| `outputDim` | `number` | required | Output dimension |
| `rank` | `number` | `2` | LoRA rank |
| `examples` | `Example[]` | required | Training examples |
| `epochs` | `number` | `1` | Number of passes |
| `learningRate` | `number` | `0.001` | Learning rate |

### resetAdapter(adapter)

```typescript
import { resetAdapter } from '@ruvector/learning-wasm';
resetAdapter(adapter: MicroLoRA): void
```

---

## Types

### Example

```typescript
interface Example {
  input: Float32Array;
  target: Float32Array;
}
```
