---
name: ruvector-exotic-wasm
description: "Exotic AI mechanisms for emergent behavior in WASM: Neural Autonomous Orgs, Morphogenetic Networks, and Time Crystals. Use when building self-organizing agent collectives, simulating biological growth patterns, or implementing temporal oscillation patterns in AI systems."
---

# @ruvector/exotic-wasm

Exotic AI primitives compiled to WebAssembly for emergent behavior and self-organization. Includes Neural Autonomous Organizations (decentralized agent governance), Morphogenetic Networks (biological growth simulation), and Time Crystals (temporal oscillation patterns).

## Quick Reference

| Task | Code |
|------|------|
| Import | `import { NeuralAutonomousOrg, MorphogeneticNetwork, TimeCrystal } from '@ruvector/exotic-wasm';` |
| Initialize | `await init();` |
| Create DAO | `new NeuralAutonomousOrg(config)` |
| Grow network | `new MorphogeneticNetwork(config)` |
| Time crystal | `new TimeCrystal(config)` |

## Installation

```bash
npx @ruvector/exotic-wasm@latest
```

## Node.js Usage

```typescript
import init, {
  NeuralAutonomousOrg,
  MorphogeneticNetwork,
  TimeCrystal,
} from '@ruvector/exotic-wasm';

await init();

// Neural Autonomous Org: self-governing agent collective
const org = new NeuralAutonomousOrg({
  agentCount: 10,
  votingThreshold: 0.6,
  proposalCooldown: 100,
});

org.addAgent('coder-1', { role: 'developer', weight: 1.0 });
org.addAgent('reviewer-1', { role: 'reviewer', weight: 1.5 });

const proposal = org.propose('coder-1', { action: 'refactor-auth', priority: 'high' });
org.vote(proposal.id, 'reviewer-1', true);
const result = org.tally(proposal.id);
console.log(`Proposal ${result.passed ? 'passed' : 'failed'}: ${result.votesFor}/${result.votesTotal}`);

// Morphogenetic Network: biological growth patterns
const morpho = new MorphogeneticNetwork({
  initialCells: 4,
  growthRate: 0.1,
  maxCells: 1000,
  morphogenGradient: 'turing',
});

for (let step = 0; step < 100; step++) {
  morpho.step();
}
const topology = morpho.getTopology();
console.log(`Cells: ${topology.cellCount}, Connections: ${topology.edgeCount}`);

// Time Crystal: periodic oscillation patterns
const crystal = new TimeCrystal({
  dimensions: 3,
  frequency: 0.5,
  coupling: 0.1,
  numOscillators: 64,
});

const phase = crystal.evolve(100);  // 100 timesteps
console.log(`Phase coherence: ${crystal.coherence()}`);
```

## Browser Usage

```html
<script type="module">
  import init, { TimeCrystal } from '@ruvector/exotic-wasm';
  await init();

  const crystal = new TimeCrystal({ dimensions: 2, numOscillators: 32 });
  crystal.evolve(50);
  console.log('Coherence:', crystal.coherence());
</script>
```

## Key API

### NeuralAutonomousOrg

Decentralized governance for agent collectives with weighted voting.

```typescript
const org = new NeuralAutonomousOrg(config: NAOConfig);
```

**NAOConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `agentCount` | `number` | `0` | Initial agent count |
| `votingThreshold` | `number` | `0.5` | Pass threshold (0-1) |
| `proposalCooldown` | `number` | `0` | Min steps between proposals |
| `delegationEnabled` | `boolean` | `false` | Allow vote delegation |
| `quorumRequired` | `number` | `0.3` | Minimum participation |

```typescript
org.addAgent(id: string, config: { role: string; weight: number }): void
org.removeAgent(id: string): void
org.propose(agentId: string, action: Record<string, unknown>): Proposal
org.vote(proposalId: string, agentId: string, approve: boolean): void
org.delegate(from: string, to: string): void
org.tally(proposalId: string): TallyResult
org.execute(proposalId: string): ExecutionResult
```

### MorphogeneticNetwork

Biological growth simulation using reaction-diffusion patterns.

```typescript
const morpho = new MorphogeneticNetwork(config: MorphoConfig);
```

**MorphoConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialCells` | `number` | `4` | Starting cell count |
| `growthRate` | `number` | `0.1` | Division rate |
| `maxCells` | `number` | `1000` | Growth cap |
| `morphogenGradient` | `'turing' \| 'linear' \| 'radial'` | `'turing'` | Pattern type |
| `diffusionRate` | `number` | `0.05` | Morphogen diffusion |
| `decayRate` | `number` | `0.01` | Morphogen decay |

```typescript
morpho.step(): void                            // Advance one timestep
morpho.stepN(n: number): void                  // Advance N timesteps
morpho.getTopology(): Topology                 // Get cell graph
morpho.getMorphogenField(): Float64Array        // Morphogen concentrations
morpho.addMorphogen(cellId: number, amount: number): void
morpho.getState(): Uint8Array                  // Serializable state
```

### TimeCrystal

Temporal oscillation patterns with phase synchronization.

```typescript
const crystal = new TimeCrystal(config: CrystalConfig);
```

**CrystalConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | `3` | Spatial dimensions |
| `frequency` | `number` | `0.5` | Base oscillation frequency |
| `coupling` | `number` | `0.1` | Inter-oscillator coupling |
| `numOscillators` | `number` | `64` | Number of oscillators |
| `damping` | `number` | `0.01` | Energy dissipation |

```typescript
crystal.evolve(steps: number): Float64Array     // Advance and return phases
crystal.coherence(): number                      // Phase coherence (0-1)
crystal.phases(): Float64Array                   // Current oscillator phases
crystal.energy(): number                         // Total system energy
crystal.perturb(oscillatorId: number, amount: number): void
crystal.reset(): void
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/exotic-wasm)
