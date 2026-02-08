# @ruvector/nervous-system-wasm API Reference

Complete API reference for `@ruvector/nervous-system-wasm`.

## Table of Contents

- [Initialization](#initialization)
- [HyperdimensionalComputing](#hyperdimensionalcomputing)
- [BTSP](#btsp)
- [SpikingNetwork](#spikingnetwork)
- [Types](#types)

---

## Initialization

```typescript
import init from '@ruvector/nervous-system-wasm';
await init();
```

---

## HyperdimensionalComputing

### Constructor

```typescript
import { HyperdimensionalComputing } from '@ruvector/nervous-system-wasm';
const hdc = new HyperdimensionalComputing(config: HDCConfig);
```

**HDCConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | `10000` | Hypervector size |
| `numClasses` | `number` | required | Class count |
| `encoding` | `string` | `'random-projection'` | Encoding type |
| `similarity` | `string` | `'cosine'` | Similarity measure |
| `quantize` | `boolean` | `false` | Binary quantization |

### hdc.train(label, features)

```typescript
hdc.train(label: string, features: Float32Array): void
```

### hdc.classify(features)

```typescript
hdc.classify(features: Float32Array): ClassifyResult
```

### hdc.batchClassify(batch)

```typescript
hdc.batchClassify(batch: Float32Array[]): ClassifyResult[]
```

### hdc.encode(features)

Get raw hypervector encoding.

```typescript
hdc.encode(features: Float32Array): Float32Array
```

### hdc.retrain()

Re-optimize class prototype vectors.

```typescript
hdc.retrain(): void
```

### hdc.accuracy(testData)

Compute accuracy on labeled test set.

```typescript
hdc.accuracy(testData: Array<{ features: Float32Array; label: string }>): number
```

### hdc.save() / HyperdimensionalComputing.load(data)

```typescript
hdc.save(): Uint8Array
const restored = HyperdimensionalComputing.load(data: Uint8Array): HyperdimensionalComputing
```

### hdc.free()

```typescript
hdc.free(): void
```

---

## BTSP

### Constructor

```typescript
import { BTSP } from '@ruvector/nervous-system-wasm';
const btsp = new BTSP(config: BTSPConfig);
```

**BTSPConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `inputSize` | `number` | required | Input dimension |
| `outputSize` | `number` | required | Output dimension |
| `plasticityRate` | `number` | `0.1` | Learning strength |
| `plateauDuration` | `number` | `10` | Plateau window |
| `decayRate` | `number` | `0.01` | Weight decay |
| `sparsity` | `number` | `0.1` | Target sparsity |

### btsp.learn(input, target)

One-shot learning via plateau potential.

```typescript
btsp.learn(input: Float32Array, target: Float32Array): void
```

### btsp.forward(input)

```typescript
btsp.forward(input: Float32Array): Float32Array
```

### btsp.correlation(output, target)

```typescript
btsp.correlation(output: Float32Array, target: Float32Array): number
```

### btsp.weights()

```typescript
btsp.weights(): Float32Array
```

### btsp.reset()

```typescript
btsp.reset(): void
```

### btsp.free()

```typescript
btsp.free(): void
```

---

## SpikingNetwork

### Constructor

```typescript
import { SpikingNetwork } from '@ruvector/nervous-system-wasm';
const snn = new SpikingNetwork(config: SNNConfig);
```

**SNNConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `neurons` | `number` | `1000` | Total neuron count |
| `excitatory` | `number` | `800` | Excitatory neurons |
| `inhibitory` | `number` | `200` | Inhibitory neurons |
| `connectivity` | `number` | `0.1` | Connection probability |
| `model` | `string` | `'izhikevich'` | Neuron model |
| `dt` | `number` | `0.5` | Timestep (ms) |
| `synapticDelay` | `number` | `1.0` | Delay (ms) |

### snn.step(input)

```typescript
snn.step(input: Float32Array): Float32Array  // Returns spike mask
```

### snn.stepN(input, n)

```typescript
snn.stepN(input: Float32Array, n: number): Float32Array[]
```

### snn.membranePotentials()

```typescript
snn.membranePotentials(): Float32Array
```

### snn.firingRates()

Average firing rates over recent steps.

```typescript
snn.firingRates(): Float32Array
```

### snn.setWeight(from, to, weight)

```typescript
snn.setWeight(from: number, to: number, weight: number): void
```

### snn.enableSTDP(config)

Enable Spike-Timing Dependent Plasticity.

```typescript
snn.enableSTDP(config: { tauPlus: number; tauMinus: number; aPlus: number; aMinus: number }): void
```

### snn.reset()

```typescript
snn.reset(): void
```

### snn.free()

```typescript
snn.free(): void
```

---

## Types

### ClassifyResult

```typescript
interface ClassifyResult {
  label: string;
  confidence: number;
  scores: Record<string, number>;
}
```
