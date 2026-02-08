# Learning Bounded Context

## Overview

The Learning Context manages continuous learning, pattern recognition, and confidence tracking across the FPPC platform. Components are currently scattered but functional.

**Key Discovery**: EWC is implemented in **Rust** (1,512 lines), while SONA/A3C are in **TypeScript** (2,759+ lines).

---

## Context Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│                   LEARNING CONTEXT                          │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   EWC++      │    │    SONA      │    │  Confidence  │  │
│  │  (Rust)      │    │  (TypeScript)│    │   Tracker    │  │
│  │              │    │              │    │              │  │
│  │ ewc.rs       │    │ sona-        │    │ confidence-  │  │
│  │ 1,512 lines  │    │ adapter.ts   │    │ gate-wf.ts   │  │
│  │              │    │ 629 lines    │    │ 426 lines    │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              TypeScript Learning System                │ │
│  │                                                        │ │
│  │  actor-critic.ts | reward-calculator.ts | neural-     │ │
│  │  thompson-sampling.ts | replay-buffer.ts              │ │
│  │                                                        │ │
│  │  Total: 2,759+ lines                                  │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Domain Model

### Aggregates

#### 1. EWC Regularizer Aggregate (Rust)

**Root Entity**: `EWCRegularizer`

```rust
// From src/ewc.rs
pub struct EWCRegularizer {
    id: RegularizerID,
    fisher_matrix: HashMap<String, Tensor>,  // F_i diagonal approximation
    optimal_params: HashMap<String, Tensor>, // θ*_A from task A
    lambda: f32,                              // Regularization strength (0.1-1.0)
    task_count: usize,                        // Number of tasks seen
}

impl EWCRegularizer {
    /// Compute Fisher Information Matrix from data
    pub fn compute_fisher(&mut self, model: &Model, data: &Dataset) {
        for (name, param) in model.parameters() {
            let grad = self.compute_gradient(param, data);
            // Diagonal Fisher approximation
            self.fisher_matrix.insert(name.clone(), grad.pow(2).mean());
        }
    }

    /// EWC regularization loss
    pub fn regularization_loss(&self, current_params: &Params) -> f32 {
        // L_ewc = (λ/2) * Σ_i F_i * (θ_i - θ*_i)²
        let mut loss = 0.0;
        for (name, param) in current_params.iter() {
            if let (Some(f), Some(theta_star)) = (
                self.fisher_matrix.get(name),
                self.optimal_params.get(name)
            ) {
                loss += (f * (param - theta_star).pow(2)).sum();
            }
        }
        self.lambda * 0.5 * loss
    }
}
```

**Invariants**:
- Fisher matrix must be positive semi-definite
- Lambda must be in [0.0, 1.0] range
- Optimal params must match model architecture

#### 2. SONA Adapter Aggregate (TypeScript)

**Root Entity**: `SONAAdapter`

```typescript
// From src/clawdbot/adapters/sona-adapter.ts
export class SONAAdapter {
  id: string;
  mode: SONAMode;
  config: SONAConfig;
  attentionHeads: number;
  layerCount: number;

  constructor(config: SONAConfig) {
    this.mode = config.defaultMode || 'BALANCED';
    this.attentionHeads = 4;
    this.layerCount = 4;
  }

  async adapt(context: TaskContext): Promise<void> {
    // Dynamic architecture adjustment
    if (context.latencyBudget < 1) {
      this.mode = 'REALTIME';
      this.attentionHeads = 2;
      this.layerCount = 2;
    } else if (context.accuracyRequired > 0.95) {
      this.mode = 'RESEARCH';
      this.attentionHeads = 8;
      this.layerCount = 6;
    }
  }
}

type SONAMode = 'REALTIME' | 'BALANCED' | 'RESEARCH' | 'EDGE' | 'BATCH';
```

**Operating Modes**:
| Mode | Latency | Accuracy | Attention Heads | Layers |
|------|---------|----------|-----------------|--------|
| REALTIME | <0.05ms | 85% | 2 | 2 |
| BALANCED | ~1ms | 92% | 4 | 4 |
| RESEARCH | ~10ms | 98% | 8 | 6 |
| EDGE | <0.1ms | 80% | 2 | 2 |
| BATCH | ~100ms | 99% | 8 | 8 |

#### 3. Pattern Aggregate

**Root Entity**: `Pattern`

```typescript
export interface Pattern {
  id: string;
  cellContext: CellContext;
  problem: ProblemDescription;
  solution: SolutionDescription;
  outcome: Outcome;
  confidence: number;        // 0.0 - 1.0
  successCount: number;
  failureCount: number;
  embedding: number[];       // 384D vector
  createdAt: Date;
  updatedAt: Date;
}

export interface Outcome {
  status: 'success' | 'failure' | 'partial';
  kpiDelta: KPIDelta;
  appliedAt: Date;
  validatedAt: Date;
}
```

#### 4. Actor-Critic Aggregate (A3C)

**Root Entity**: `ActorCritic`

```typescript
// From src/clawdbot/learning/actor-critic.ts
export class ActorCritic {
  id: string;
  actor: NeuralNetwork;      // Policy network
  critic: NeuralNetwork;     // Value network
  replayBuffer: ReplayBuffer;
  config: A3CConfig;

  async selectAction(state: State): Promise<Action> {
    const policy = await this.actor.forward(state);
    return this.sampleFromPolicy(policy);
  }

  async update(trajectory: Trajectory): Promise<void> {
    // Compute advantages
    const advantages = this.computeAdvantages(trajectory);

    // Update actor (policy gradient)
    await this.actor.update(trajectory.states, advantages);

    // Update critic (value regression)
    const values = trajectory.returns;
    await this.critic.update(trajectory.states, values);
  }
}
```

---

### Value Objects

```typescript
// Confidence with gate calculation
export class Confidence {
  constructor(public readonly value: number) {
    if (value < 0 || value > 1) {
      throw new Error('Confidence must be in [0, 1]');
    }
  }

  get gate(): ConfidenceGate {
    if (this.value >= 0.95) return 'AUTO';
    if (this.value >= 0.85) return 'FAST_TRACK';
    if (this.value >= 0.70) return 'APPROVE';
    return 'SIMULATE';
  }

  update(outcome: Outcome): Confidence {
    // Bayesian update
    const alpha = outcome.status === 'success' ? 1 : 0;
    const newValue = 0.9 * this.value + 0.1 * alpha;
    return new Confidence(newValue);
  }
}

export type ConfidenceGate = 'AUTO' | 'FAST_TRACK' | 'APPROVE' | 'SIMULATE';
```

---

## Domain Services

### LearningOrchestrator

```typescript
export interface LearningOrchestrator {
  // Record outcome and update confidence
  recordOutcome(pattern: Pattern, outcome: Outcome): Promise<void>;

  // Search for similar patterns
  findSimilarPatterns(context: CellContext, limit: number): Promise<Pattern[]>;

  // Update model with new data (respecting EWC)
  updateModel(data: TrainingData): Promise<void>;

  // Get confidence for a recommendation
  getConfidence(recommendation: Recommendation): Promise<Confidence>;
}
```

### ConfidenceTracker

```typescript
export class ConfidenceTracker implements ConfidenceTracking {
  private confidenceStore: Map<PatternId, Confidence>;

  async updateConfidence(patternId: PatternId, outcome: Outcome): Promise<void> {
    const current = this.confidenceStore.get(patternId) || new Confidence(0.5);
    const updated = current.update(outcome);
    this.confidenceStore.set(patternId, updated);

    // Emit domain event
    await this.publish(new ConfidenceUpdated(patternId, current, updated));
  }

  async getGate(patternId: PatternId): Promise<ConfidenceGate> {
    const confidence = this.confidenceStore.get(patternId);
    return confidence?.gate || 'SIMULATE';
  }
}
```

---

## Domain Events

| Event | Trigger | Consumers |
|-------|---------|-----------|
| `PatternLearned` | New pattern stored | All agents |
| `ConfidenceUpdated` | Outcome recorded | Optimization |
| `ModelUpdated` | Training completed | Inference |
| `EWCConsolidated` | Fisher matrix computed | Training |
| `SONAModeChanged` | Context adaptation | Inference |
| `ReplayBufferFull` | Buffer capacity reached | Training |
| `ThompsonArmPulled` | Bandit exploration | Monitoring |

---

## Implementation Status

| Component | Location | Lines | Status |
|-----------|----------|-------|--------|
| EWC Regularizer | `src/ewc.rs` | 1,512 | ✅ Implemented (Rust) |
| SONA Adapter | `sona-adapter.ts` | 629 | ✅ Implemented |
| Confidence Gates | `confidence-gate-workflow.ts` | 426 | ✅ Implemented |
| Actor-Critic (A3C) | `actor-critic.ts` | ~400 | ✅ Implemented |
| Thompson Sampling | `thompson-sampling.ts` | ~200 | ✅ Implemented |
| Replay Buffer | `replay-buffer.ts` | ~300 | ✅ Implemented |
| Reward Calculator | `reward-calculator.ts` | ~200 | ✅ Implemented |
| Neural Network | `neural-network.ts` | ~300 | ✅ Implemented |
| RuVector Adapter | `ruvector-adapter.ts` | 169 | ✅ Implemented |

**Total**: ~4,271+ lines (1,512 Rust + 2,759 TypeScript)

---

## Current File Locations (Scattered)

| Planned | Actual | Status |
|---------|--------|--------|
| `learning/ewc.ts` | `src/ewc.rs` (Rust) | ✅ Different lang |
| `learning/sona-tracker.ts` | `src/clawdbot/adapters/sona-adapter.ts` | ✅ Different path |
| `learning/confidence-manager.ts` | `confidence-gate-workflow.ts` | ✅ Different path |
| `learning/ruvector-adapter.ts` | `.claude/skills/.../ruvector-adapter.ts` | ✅ Different path |
| N/A | `src/clawdbot/learning/actor-critic.ts` | ✅ Bonus |
| N/A | `src/clawdbot/learning/thompson-sampling.ts` | ✅ Bonus |

---

## Consolidation Plan (5 story points)

1. Create unified `/src/learning/` directory structure
2. Add Rust-TypeScript bridge for EWC integration:
   ```typescript
   // Node.js native addon or WASM binding
   import { EWCRegularizer } from '@fppc/ewc-rs';
   ```
3. Unify confidence tracking API across components
4. Add SONA trajectory persistence to memory store
5. Document integration points between Rust and TypeScript

---

## Integration Points

### Upstream (Provides Data To This Context)

- **Optimization Context**: Recommendation outcomes
- **Data Infrastructure**: Pattern similarity search (HNSW)
- **Agent Orchestration**: Troubleshooting session data

### Downstream (Consumes Data From This Context)

- **Optimization Context**: Confidence scores for gates
- **Workflow Context**: Approval routing based on confidence
- **All Agents**: Pattern matches for decision support

---

## References

- ADR-010: Distributed Learning Architecture
- `src/ewc.rs` - Rust EWC implementation (1,512 lines)
- `src/clawdbot/adapters/sona-adapter.ts` - SONA (629 lines)
- `src/clawdbot/learning/` - TypeScript learning system (2,759 lines)
- [EWC Paper](https://arxiv.org/abs/1612.00796) - Elastic Weight Consolidation
- [A3C Paper](https://arxiv.org/abs/1602.01783) - Asynchronous Advantage Actor-Critic
