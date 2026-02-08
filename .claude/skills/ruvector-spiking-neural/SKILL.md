---
name: ruvector-spiking-neural
description: "High-performance Spiking Neural Network engine with SIMD optimization, multiple neuron models, and STDP learning. Use when building neuromorphic computing applications, simulating brain-like networks, or running energy-efficient inference with spiking neurons."
---

# @ruvector/spiking-neural

High-performance Spiking Neural Network (SNN) engine with SIMD-accelerated simulation. Supports multiple neuron models (Izhikevich, LIF, Hodgkin-Huxley), Spike-Timing Dependent Plasticity (STDP), and both CLI and programmatic interfaces.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/spiking-neural@latest` |
| Create network | `new SpikingNetwork(config)` |
| Add layer | `network.addLayer(config)` |
| Connect | `network.connect(from, to, config)` |
| Simulate | `network.simulate(input, steps)` |
| Enable STDP | `network.enableSTDP(config)` |
| Export spikes | `network.spikeTrains()` |

## Installation

```bash
npx @ruvector/spiking-neural@latest
```

## Quick Start

```typescript
import {
  SpikingNetwork,
  IzhikevichNeuron,
  LIFNeuron,
} from '@ruvector/spiking-neural';

// Create a network
const network = new SpikingNetwork({
  dt: 0.5,            // 0.5ms timestep
  simd: true,          // Enable SIMD acceleration
  recordSpikes: true,
});

// Add layers
const input = network.addLayer({ size: 100, model: 'poisson', label: 'input' });
const hidden = network.addLayer({ size: 500, model: 'izhikevich', label: 'hidden' });
const output = network.addLayer({ size: 10, model: 'lif', label: 'output' });

// Connect layers
network.connect(input, hidden, { probability: 0.3, weightRange: [0.1, 0.5] });
network.connect(hidden, output, { probability: 0.5, weightRange: [0.2, 0.8] });

// Enable STDP learning
network.enableSTDP({
  tauPlus: 20,
  tauMinus: 20,
  aPlus: 0.01,
  aMinus: 0.012,
});

// Simulate
const inputCurrent = new Float32Array(100).fill(10.0);  // 10 mA input
const result = network.simulate(inputCurrent, 1000);     // 1000 timesteps

console.log(`Output spikes: ${result.outputSpikes}`);
console.log(`Firing rate: ${result.firingRate.toFixed(2)} Hz`);

// Get spike trains
const trains = network.spikeTrains();
console.log(`Spike times for neuron 0: ${trains[0].join(', ')}`);
```

## Core API

### SpikingNetwork

Main network container.

```typescript
const network = new SpikingNetwork(config: NetworkConfig);
```

**NetworkConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dt` | `number` | `0.5` | Timestep in ms |
| `simd` | `boolean` | `true` | SIMD acceleration |
| `recordSpikes` | `boolean` | `true` | Record spike times |
| `seed` | `number` | `42` | Random seed |
| `maxDelay` | `number` | `20` | Max synaptic delay (ms) |

### network.addLayer(config)

Add a neuron layer.

```typescript
const layerId = network.addLayer(config: LayerConfig): string
```

**LayerConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | `number` | required | Neuron count |
| `model` | `'izhikevich' \| 'lif' \| 'hodgkin-huxley' \| 'poisson'` | `'izhikevich'` | Neuron model |
| `label` | `string` | `'layer-N'` | Layer name |
| `params` | `NeuronParams` | model defaults | Neuron parameters |

**Izhikevich params:** `{ a: 0.02, b: 0.2, c: -65, d: 8 }` (regular spiking)
**LIF params:** `{ tau: 20, vThreshold: -55, vReset: -70, vRest: -65, refractoryMs: 2 }`

### network.connect(from, to, config)

Connect two layers.

```typescript
network.connect(from: string, to: string, config: ConnectionConfig): void
```

**ConnectionConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `probability` | `number` | `0.1` | Connection probability |
| `weightRange` | `[number, number]` | `[0.1, 1.0]` | Weight bounds |
| `delayRange` | `[number, number]` | `[1, 5]` | Delay in ms |
| `type` | `'excitatory' \| 'inhibitory'` | `'excitatory'` | Synapse type |

### network.enableSTDP(config)

Enable Spike-Timing Dependent Plasticity.

```typescript
network.enableSTDP(config: STDPConfig): void
```

**STDPConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tauPlus` | `number` | `20` | Potentiation time constant |
| `tauMinus` | `number` | `20` | Depression time constant |
| `aPlus` | `number` | `0.01` | Potentiation magnitude |
| `aMinus` | `number` | `0.012` | Depression magnitude |
| `wMax` | `number` | `1.0` | Maximum weight |
| `wMin` | `number` | `0.0` | Minimum weight |

### network.simulate(input, steps)

Run the simulation.

```typescript
const result = network.simulate(input: Float32Array, steps: number): SimResult
```

**SimResult:**
| Field | Type | Description |
|-------|------|-------------|
| `outputSpikes` | `number` | Total output layer spikes |
| `firingRate` | `number` | Average firing rate (Hz) |
| `duration` | `number` | Simulation time (ms) |
| `totalSpikes` | `number` | All spikes across network |

### network.spikeTrains()

Get spike times for each neuron.

```typescript
network.spikeTrains(): number[][]  // Spike times per neuron
```

### network.membranePotentials()

Get current membrane potentials.

```typescript
network.membranePotentials(): Float32Array
```

### network.weights()

Get weight matrix.

```typescript
network.weights(from: string, to: string): Float32Array
```

### network.reset()

```typescript
network.reset(): void
```

## CLI Usage

```bash
# Run a benchmark simulation
npx @ruvector/spiking-neural sim --neurons 10000 --steps 1000

# Generate and simulate a random network
npx @ruvector/spiking-neural random --layers 3 --size 100 --steps 500

# Export spike data
npx @ruvector/spiking-neural sim --neurons 1000 --output spikes.json
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/spiking-neural)
