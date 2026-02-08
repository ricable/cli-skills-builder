# @ruvector/spiking-neural API Reference

Complete API reference for `@ruvector/spiking-neural`.

## Table of Contents

- [SpikingNetwork](#spikingnetwork)
- [Layers](#layers)
- [Connections](#connections)
- [Learning Rules](#learning-rules)
- [Simulation](#simulation)
- [CLI Commands](#cli-commands)
- [Types](#types)

---

## SpikingNetwork

### Constructor

```typescript
import { SpikingNetwork } from '@ruvector/spiking-neural';
const network = new SpikingNetwork(config: NetworkConfig);
```

**NetworkConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dt` | `number` | `0.5` | Timestep (ms) |
| `simd` | `boolean` | `true` | SIMD accel |
| `recordSpikes` | `boolean` | `true` | Track spike times |
| `seed` | `number` | `42` | PRNG seed |
| `maxDelay` | `number` | `20` | Max delay (ms) |

---

## Layers

### network.addLayer(config)

```typescript
network.addLayer(config: LayerConfig): string
```

**LayerConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `size` | `number` | required | Neurons |
| `model` | `string` | `'izhikevich'` | Neuron model |
| `label` | `string` | auto | Name |
| `params` | `NeuronParams` | model defaults | Parameters |

### Neuron Model Parameters

**Izhikevich:**
| Parameter | Default | Description |
|-----------|---------|-------------|
| `a` | `0.02` | Time scale of recovery |
| `b` | `0.2` | Sensitivity of recovery |
| `c` | `-65` | After-spike reset potential |
| `d` | `8` | After-spike recovery increment |

**LIF (Leaky Integrate-and-Fire):**
| Parameter | Default | Description |
|-----------|---------|-------------|
| `tau` | `20` | Membrane time constant (ms) |
| `vThreshold` | `-55` | Spike threshold (mV) |
| `vReset` | `-70` | Reset potential |
| `vRest` | `-65` | Resting potential |
| `refractoryMs` | `2` | Refractory period |

**Hodgkin-Huxley:**
| Parameter | Default | Description |
|-----------|---------|-------------|
| `gNa` | `120` | Sodium conductance |
| `gK` | `36` | Potassium conductance |
| `gL` | `0.3` | Leak conductance |
| `cm` | `1.0` | Membrane capacitance |

### network.removeLayer(layerId)

```typescript
network.removeLayer(layerId: string): void
```

### network.getLayer(layerId)

```typescript
network.getLayer(layerId: string): LayerInfo
```

---

## Connections

### network.connect(from, to, config)

```typescript
network.connect(from: string, to: string, config: ConnectionConfig): void
```

**ConnectionConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `probability` | `number` | `0.1` | Connection prob |
| `weightRange` | `[number, number]` | `[0.1, 1.0]` | Weight bounds |
| `delayRange` | `[number, number]` | `[1, 5]` | Delay bounds (ms) |
| `type` | `'excitatory' \| 'inhibitory'` | `'excitatory'` | Synapse type |

### network.disconnect(from, to)

```typescript
network.disconnect(from: string, to: string): void
```

### network.weights(from, to)

```typescript
network.weights(from: string, to: string): Float32Array
```

### network.setWeight(from, to, preIdx, postIdx, weight)

```typescript
network.setWeight(from: string, to: string, preIdx: number, postIdx: number, weight: number): void
```

---

## Learning Rules

### network.enableSTDP(config)

```typescript
network.enableSTDP(config: STDPConfig): void
```

**STDPConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tauPlus` | `number` | `20` | Potentiation tau |
| `tauMinus` | `number` | `20` | Depression tau |
| `aPlus` | `number` | `0.01` | Potentiation rate |
| `aMinus` | `number` | `0.012` | Depression rate |
| `wMax` | `number` | `1.0` | Max weight |
| `wMin` | `number` | `0.0` | Min weight |

### network.disableSTDP()

```typescript
network.disableSTDP(): void
```

---

## Simulation

### network.simulate(input, steps)

```typescript
network.simulate(input: Float32Array, steps: number): SimResult
```

### network.step(input)

Single timestep.

```typescript
network.step(input: Float32Array): StepResult
```

### network.spikeTrains()

```typescript
network.spikeTrains(): number[][]
```

### network.membranePotentials()

```typescript
network.membranePotentials(): Float32Array
```

### network.firingRates()

```typescript
network.firingRates(): Float32Array
```

### network.reset()

```typescript
network.reset(): void
```

### network.save(path) / SpikingNetwork.load(path)

```typescript
await network.save(path: string): Promise<void>
const restored = await SpikingNetwork.load(path: string): Promise<SpikingNetwork>
```

---

## CLI Commands

```bash
# Simulate with parameters
npx @ruvector/spiking-neural sim --neurons <count> --steps <count> [--model izhikevich|lif] [--output spikes.json]

# Random network benchmark
npx @ruvector/spiking-neural random --layers <count> --size <neurons-per-layer> --steps <count>

# Info
npx @ruvector/spiking-neural --version
npx @ruvector/spiking-neural --help
```

---

## Types

### SimResult

```typescript
interface SimResult {
  outputSpikes: number;
  firingRate: number;
  duration: number;
  totalSpikes: number;
}
```

### StepResult

```typescript
interface StepResult {
  spikes: boolean[];
  potentials: Float32Array;
}
```
