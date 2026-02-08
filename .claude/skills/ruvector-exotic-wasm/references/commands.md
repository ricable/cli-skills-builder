# @ruvector/exotic-wasm API Reference

Complete API reference for `@ruvector/exotic-wasm`.

## Table of Contents

- [Initialization](#initialization)
- [NeuralAutonomousOrg](#neuralautonomousorg)
- [MorphogeneticNetwork](#morphogeneticnetwork)
- [TimeCrystal](#timecrystal)
- [Types](#types)

---

## Initialization

```typescript
import init from '@ruvector/exotic-wasm';
await init();
```

---

## NeuralAutonomousOrg

### Constructor

```typescript
import { NeuralAutonomousOrg } from '@ruvector/exotic-wasm';
const org = new NeuralAutonomousOrg(config: NAOConfig);
```

**NAOConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `agentCount` | `number` | `0` | Starting agents |
| `votingThreshold` | `number` | `0.5` | Pass threshold |
| `proposalCooldown` | `number` | `0` | Cooldown steps |
| `delegationEnabled` | `boolean` | `false` | Vote delegation |
| `quorumRequired` | `number` | `0.3` | Min participation |

### org.addAgent(id, config)

```typescript
org.addAgent(id: string, config: { role: string; weight: number }): void
```

### org.removeAgent(id)

```typescript
org.removeAgent(id: string): void
```

### org.propose(agentId, action)

```typescript
org.propose(agentId: string, action: Record<string, unknown>): Proposal
```

**Proposal:** `{ id: string; proposer: string; action: Record<string, unknown>; timestamp: number }`

### org.vote(proposalId, agentId, approve)

```typescript
org.vote(proposalId: string, agentId: string, approve: boolean): void
```

### org.delegate(from, to)

```typescript
org.delegate(from: string, to: string): void
```

### org.tally(proposalId)

```typescript
org.tally(proposalId: string): TallyResult
```

**TallyResult:** `{ passed: boolean; votesFor: number; votesAgainst: number; votesTotal: number; quorumMet: boolean }`

### org.execute(proposalId)

```typescript
org.execute(proposalId: string): ExecutionResult
```

### org.agents()

```typescript
org.agents(): AgentInfo[]
```

### org.free()

```typescript
org.free(): void
```

---

## MorphogeneticNetwork

### Constructor

```typescript
import { MorphogeneticNetwork } from '@ruvector/exotic-wasm';
const morpho = new MorphogeneticNetwork(config: MorphoConfig);
```

**MorphoConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialCells` | `number` | `4` | Starting cells |
| `growthRate` | `number` | `0.1` | Division rate |
| `maxCells` | `number` | `1000` | Max cells |
| `morphogenGradient` | `string` | `'turing'` | Pattern type |
| `diffusionRate` | `number` | `0.05` | Diffusion constant |
| `decayRate` | `number` | `0.01` | Decay constant |

### morpho.step()

```typescript
morpho.step(): void
```

### morpho.stepN(n)

```typescript
morpho.stepN(n: number): void
```

### morpho.getTopology()

```typescript
morpho.getTopology(): Topology
```

**Topology:** `{ cellCount: number; edgeCount: number; cells: CellInfo[]; edges: [number, number][] }`

### morpho.getMorphogenField()

```typescript
morpho.getMorphogenField(): Float64Array
```

### morpho.addMorphogen(cellId, amount)

```typescript
morpho.addMorphogen(cellId: number, amount: number): void
```

### morpho.getState() / MorphogeneticNetwork.fromState(data)

```typescript
morpho.getState(): Uint8Array
const restored = MorphogeneticNetwork.fromState(data: Uint8Array): MorphogeneticNetwork
```

### morpho.free()

```typescript
morpho.free(): void
```

---

## TimeCrystal

### Constructor

```typescript
import { TimeCrystal } from '@ruvector/exotic-wasm';
const crystal = new TimeCrystal(config: CrystalConfig);
```

**CrystalConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | `3` | Spatial dims |
| `frequency` | `number` | `0.5` | Base frequency |
| `coupling` | `number` | `0.1` | Coupling strength |
| `numOscillators` | `number` | `64` | Oscillator count |
| `damping` | `number` | `0.01` | Energy damping |

### crystal.evolve(steps)

```typescript
crystal.evolve(steps: number): Float64Array
```

### crystal.coherence()

```typescript
crystal.coherence(): number  // 0.0 to 1.0
```

### crystal.phases()

```typescript
crystal.phases(): Float64Array
```

### crystal.energy()

```typescript
crystal.energy(): number
```

### crystal.perturb(oscillatorId, amount)

```typescript
crystal.perturb(oscillatorId: number, amount: number): void
```

### crystal.reset()

```typescript
crystal.reset(): void
```

### crystal.free()

```typescript
crystal.free(): void
```

---

## Types

### AgentInfo

```typescript
interface AgentInfo {
  id: string;
  role: string;
  weight: number;
  delegateTo?: string;
}
```

### CellInfo

```typescript
interface CellInfo {
  id: number;
  position: [number, number];
  morphogenLevel: number;
  age: number;
}
```

### ExecutionResult

```typescript
interface ExecutionResult {
  success: boolean;
  proposalId: string;
  action: Record<string, unknown>;
}
```
