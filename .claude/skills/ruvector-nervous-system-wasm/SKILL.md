---
name: ruvector-nervous-system-wasm
description: "Bio-inspired AI components in WASM: Hyperdimensional Computing, BTSP synaptic plasticity, and neuromorphic spiking networks. Use when building brain-inspired classifiers, implementing one-shot learning with HDC, or simulating spiking neural networks in browsers."
---

# @ruvector/nervous-system-wasm

Bio-inspired AI components compiled to WebAssembly. Implements Hyperdimensional Computing (HDC) for ultra-fast classification, Behavioral Time-Scale Synaptic Plasticity (BTSP) for one-shot learning, and neuromorphic spiking network primitives.

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { HyperdimensionalComputing, BTSP, SpikingNetwork } from '@ruvector/nervous-system-wasm';` |
| Initialize | `await init();` |
| HDC encode | `hdc.encode(data)` |
| HDC classify | `hdc.classify(vector)` |
| BTSP learn | `btsp.learn(input, target)` |
| Spiking sim | `snn.step(input)` |

## Installation

```bash
npx @ruvector/nervous-system-wasm@latest
```

## Node.js Usage

```typescript
import init, {
  HyperdimensionalComputing,
  BTSP,
  SpikingNetwork,
} from '@ruvector/nervous-system-wasm';

await init();

// Hyperdimensional Computing: encode and classify
const hdc = new HyperdimensionalComputing({
  dimensions: 10_000,
  numClasses: 5,
  encoding: 'random-projection',
});

// Train on labeled data
hdc.train('cat', new Float32Array([0.1, 0.8, 0.2, 0.9]));
hdc.train('dog', new Float32Array([0.9, 0.2, 0.8, 0.1]));

// Classify new input
const result = hdc.classify(new Float32Array([0.15, 0.75, 0.25, 0.85]));
console.log(`Class: ${result.label}, confidence: ${result.confidence}`);

// BTSP: one-shot synaptic plasticity
const btsp = new BTSP({
  inputSize: 100,
  outputSize: 50,
  plasticityRate: 0.1,
  plateauDuration: 10,
});

const input = new Float32Array(100).fill(0.5);
const target = new Float32Array(50).fill(1.0);
btsp.learn(input, target);  // Single-exposure learning

const output = btsp.forward(input);
console.log('BTSP output correlation:', btsp.correlation(output, target));

// Spiking Neural Network
const snn = new SpikingNetwork({
  neurons: 1000,
  excitatory: 800,
  inhibitory: 200,
  connectivity: 0.1,
  model: 'izhikevich',
});

const spikes = snn.step(new Float32Array(1000));
console.log(`Active neurons: ${spikes.filter(s => s > 0).length}`);
```

## Browser Usage

```html
<script type="module">
  import init, { HyperdimensionalComputing } from '@ruvector/nervous-system-wasm';
  await init();

  const hdc = new HyperdimensionalComputing({ dimensions: 10000, numClasses: 3 });
  hdc.train('A', new Float32Array([1, 0, 0]));
  hdc.train('B', new Float32Array([0, 1, 0]));
  const result = hdc.classify(new Float32Array([0.9, 0.1, 0]));
  console.log(result.label); // 'A'
</script>
```

## Key API

### HyperdimensionalComputing

Ultra-fast classification using high-dimensional binary vectors.

```typescript
const hdc = new HyperdimensionalComputing(config: HDCConfig);
```

**HDCConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | `10000` | Hypervector dimensionality |
| `numClasses` | `number` | required | Number of classes |
| `encoding` | `'random-projection' \| 'thermometer' \| 'level'` | `'random-projection'` | Encoding method |
| `similarity` | `'cosine' \| 'hamming'` | `'cosine'` | Similarity metric |

```typescript
hdc.train(label: string, features: Float32Array): void
hdc.classify(features: Float32Array): ClassifyResult
hdc.batchClassify(batch: Float32Array[]): ClassifyResult[]
hdc.encode(features: Float32Array): Float32Array  // Raw hypervector
hdc.retrain(): void  // Re-optimize class prototypes
hdc.accuracy(testData: Array<{ features: Float32Array; label: string }>): number
```

**ClassifyResult:** `{ label: string; confidence: number; scores: Record<string, number> }`

### BTSP

Behavioral Time-Scale Synaptic Plasticity for one-shot learning.

```typescript
const btsp = new BTSP(config: BTSPConfig);
```

**BTSPConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `inputSize` | `number` | required | Input neurons |
| `outputSize` | `number` | required | Output neurons |
| `plasticityRate` | `number` | `0.1` | Learning rate |
| `plateauDuration` | `number` | `10` | Plateau potential duration |
| `decayRate` | `number` | `0.01` | Weight decay |

```typescript
btsp.learn(input: Float32Array, target: Float32Array): void
btsp.forward(input: Float32Array): Float32Array
btsp.correlation(output: Float32Array, target: Float32Array): number
btsp.weights(): Float32Array
btsp.reset(): void
```

### SpikingNetwork

Spiking Neural Network with configurable neuron models.

```typescript
const snn = new SpikingNetwork(config: SNNConfig);
```

**SNNConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `neurons` | `number` | `1000` | Total neurons |
| `excitatory` | `number` | `800` | Excitatory count |
| `inhibitory` | `number` | `200` | Inhibitory count |
| `connectivity` | `number` | `0.1` | Connection probability |
| `model` | `'izhikevich' \| 'lif' \| 'hodgkin-huxley'` | `'izhikevich'` | Neuron model |
| `dt` | `number` | `0.5` | Timestep (ms) |

```typescript
snn.step(input: Float32Array): Float32Array          // One timestep, returns spikes
snn.stepN(input: Float32Array, n: number): Float32Array[]  // N timesteps
snn.membranePotentials(): Float32Array
snn.firingRates(): Float32Array
snn.reset(): void
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/nervous-system-wasm)
