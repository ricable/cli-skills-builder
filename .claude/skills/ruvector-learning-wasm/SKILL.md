---
name: ruvector-learning-wasm
description: "Ultra-fast MicroLoRA weight adaptation in WASM with sub-100us latency for rank-2 LoRA. Use when fine-tuning models at the edge, adapting agent behavior in real-time, or running lightweight parameter-efficient training in browsers without GPU."
---

# @ruvector/learning-wasm

Ultra-fast MicroLoRA (Low-Rank Adaptation) engine compiled to WebAssembly. Performs rank-2 LoRA weight updates in under 100 microseconds, enabling real-time model adaptation in browsers and edge environments without GPU hardware.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { MicroLoRA, adaptWeights, resetAdapter } from '@ruvector/learning-wasm';` |
| Initialize | `await init();` |
| Create adapter | `new MicroLoRA(config)` |
| Adapt weights | `adapter.adapt(input, target)` |
| Apply to weights | `adapter.apply(weights)` |
| Reset | `adapter.reset()` |

## Installation

```bash
npx @ruvector/learning-wasm@latest
```

## Node.js Usage

```typescript
import init, { MicroLoRA, adaptWeights, resetAdapter } from '@ruvector/learning-wasm';

await init();

// Create a MicroLoRA adapter
const adapter = new MicroLoRA({
  inputDim: 768,
  outputDim: 768,
  rank: 2,
  alpha: 1.0,
  learningRate: 0.001,
});

// Adapt to a new example
const input = new Float32Array(768);   // Input activations
const target = new Float32Array(768);  // Target activations
const loss = adapter.adapt(input, target);
console.log(`Adaptation loss: ${loss}`);

// Apply adapter to base model weights
const baseWeights = new Float32Array(768 * 768);
const adaptedWeights = adapter.apply(baseWeights);

// Quick functional API
const result = adaptWeights(baseWeights, {
  inputDim: 768,
  outputDim: 768,
  rank: 2,
  examples: [{ input, target }],
});

// Reset adapter to initial state
adapter.reset();
```

## Browser Usage

```html
<script type="module">
  import init, { MicroLoRA } from '@ruvector/learning-wasm';
  await init();

  const adapter = new MicroLoRA({ inputDim: 256, outputDim: 256, rank: 2 });
  const input = new Float32Array(256).fill(0.1);
  const target = new Float32Array(256).fill(0.5);
  const loss = adapter.adapt(input, target);
  console.log(`Loss: ${loss}`);
</script>
```

## Key API

### MicroLoRA

Lightweight LoRA adapter for real-time weight adaptation.

```typescript
const adapter = new MicroLoRA(config: LoRAConfig);
```

**LoRAConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `inputDim` | `number` | required | Input dimension |
| `outputDim` | `number` | required | Output dimension |
| `rank` | `number` | `2` | LoRA rank (1-8, lower = faster) |
| `alpha` | `number` | `1.0` | Scaling factor |
| `learningRate` | `number` | `0.001` | Adaptation learning rate |
| `dropout` | `number` | `0.0` | LoRA dropout rate |
| `initScale` | `number` | `0.01` | Weight initialization scale |

### adapter.adapt(input, target)

Perform one adaptation step. Returns the loss value.

```typescript
adapter.adapt(input: Float32Array, target: Float32Array): number
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `input` | `Float32Array` | Input activation vector (length = inputDim) |
| `target` | `Float32Array` | Target activation vector (length = outputDim) |

### adapter.adaptBatch(examples)

Batch adaptation over multiple examples.

```typescript
adapter.adaptBatch(examples: Array<{ input: Float32Array; target: Float32Array }>): number
```

Returns average loss across the batch.

### adapter.apply(weights)

Apply the LoRA delta to base weights: `W' = W + alpha * B * A`.

```typescript
adapter.apply(weights: Float32Array): Float32Array
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `weights` | `Float32Array` | Base weight matrix (inputDim * outputDim, row-major) |

### adapter.delta()

Get the raw LoRA delta matrix without applying to weights.

```typescript
adapter.delta(): Float32Array  // Shape: inputDim x outputDim
```

### adapter.reset()

Reset adapter weights to initial state.

```typescript
adapter.reset(): void
```

### adapter.save() / MicroLoRA.load(data)

Serialize and restore adapter state.

```typescript
const data = adapter.save(): Uint8Array
const restored = MicroLoRA.load(data: Uint8Array): MicroLoRA
```

### adapter.free()

Release WASM memory.

```typescript
adapter.free(): void
```

### adaptWeights(baseWeights, config)

Functional API: adapt weights in a single call.

```typescript
const adapted = adaptWeights(
  baseWeights: Float32Array,
  config: { inputDim: number; outputDim: number; rank?: number; examples: Example[] }
): Float32Array
```

### resetAdapter(adapter)

Reset adapter to zero-initialized state.

```typescript
resetAdapter(adapter: MicroLoRA): void
```

## Common Patterns

### Online Learning in Browser

```typescript
const adapter = new MicroLoRA({ inputDim: 512, outputDim: 512, rank: 2 });

// Continuously adapt from user feedback
function onUserFeedback(input: Float32Array, correctedOutput: Float32Array) {
  const loss = adapter.adapt(input, correctedOutput);
  const updatedWeights = adapter.apply(modelWeights);
  return updatedWeights;
}
```

### Multi-Layer Adaptation

```typescript
const adapters = layers.map(dim => new MicroLoRA({
  inputDim: dim.in,
  outputDim: dim.out,
  rank: 2,
}));

// Adapt all layers
for (let i = 0; i < adapters.length; i++) {
  adapters[i].adapt(activations[i], targets[i]);
}
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/learning-wasm)
