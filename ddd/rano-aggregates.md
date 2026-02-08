# RANO Aggregates - Intent-Based RAN Optimization

## Overview

This document defines the aggregates within the RANO Optimization Context. Aggregates are clusters of domain objects treated as a single unit for data changes. RANO has four aggregates that manage the lifecycle of intent-based optimization.

---

## 1. Intent Aggregate

### Description

The Intent Aggregate represents a decomposed optimization intent with its structured objectives, KPI targets, domain assignments, and scope. It is the entry point for every RANO optimization run. The aggregate ensures that intents are properly decomposed before downstream processing begins.

### Aggregate Root

`IntentDefinition`

### Entities

- **IntentDefinition** (Root) - The optimization intent with decomposed objectives
- **IntentMatch** - Catalog match result for known intent templates

### Value Objects

- **IntentId** - Unique identifier (e.g., `rano-intent-20260208-001`)
- **KPITarget** - Target metric with direction, weight, and optional target value
- **IntentScope** - Network scope: cell, cluster, or site
- **IntentCategory** - Domain category: mobility, rrm, coverage, capacity, etc.

### Structure

```
IntentDefinition (Aggregate Root)
+-- id: IntentId
+-- text: string                         # Original natural language intent
+-- category: IntentCategory
+-- domains: string[]                    # Agent domains to consult
+-- seedParameters: string[]             # Starter parameter names from catalog
+-- kpiTargets: KPITarget[]
|   +-- name: string                     # e.g., "pmHoExeSucc"
|   +-- direction: "increase" | "decrease" | "stabilize"
|   +-- targetValue: number | null
|   +-- currentValue: number | null
|   +-- weight: number
+-- decomposedObjectives: string[]       # Sub-objectives from Goal module
+-- scope: IntentScope
+-- priorityHierarchy: string[]          # Domain priority for conflicts
+-- kpiWindowMinutes: number             # Evaluation window
+-- catalogMatch: IntentMatch | null
|   +-- catalogId: string
|   +-- similarityScore: number
+-- status: IntentStatus
+-- submittedAt: DateTime
+-- decomposedAt: DateTime | null
```

### Invariants

1. Intent text must be non-empty
2. At least one KPI target must be defined after decomposition
3. At least one domain must be assigned
4. Priority hierarchy must include all assigned domains
5. KPI window must be a positive integer (15, 30, 60, or 120 minutes)
6. Status transitions must follow: `submitted` -> `decomposed` -> `processing` -> `completed` | `failed`

### Domain Events

| Event | Trigger |
|-------|---------|
| `IntentSubmitted` | User submits optimization intent |
| `IntentDecomposed` | Goal module completes decomposition |

### Repository Interface

```typescript
interface IntentRepository {
  findById(intentId: IntentId): Promise<IntentDefinition | null>;
  findByCategory(category: IntentCategory): Promise<IntentDefinition[]>;
  findActive(): Promise<IntentDefinition[]>;
  save(intent: IntentDefinition): Promise<void>;
}
```

### Example

```typescript
const intent = new IntentDefinition({
  id: IntentId.from("rano-intent-20260208-001"),
  text: "Improve intra-frequency handover success rate",
  category: IntentCategory.MOBILITY,
  domains: ["mobility", "rrm"],
  seedParameters: ["a3offset", "hysteresisA3", "timeToTriggerA3", "cellIndOffNeigh"],
  kpiTargets: [
    new KPITarget({ name: "pmHoExeSucc", direction: "increase", weight: 1.0 }),
    new KPITarget({ name: "pmHoPingPongRate", direction: "decrease", weight: 0.8 })
  ],
  scope: IntentScope.CLUSTER,
  priorityHierarchy: ["safety", "mobility", "capacity"],
  kpiWindowMinutes: 60
});
```

---

## 2. ChangeProposal Aggregate

### Description

The ChangeProposal Aggregate manages a set of three ranked variants (conservative, moderate, aggressive) with parameter changes, cmedit commands, and rollback plans. It is produced by the Action module after consensus resolution and represents the actionable output of an optimization run.

### Aggregate Root

`ChangeProposalSet`

### Entities

- **ChangeProposalSet** (Root) - Container for three ranked variants
- **ChangeProposal** - Individual variant with changes and commands

### Value Objects

- **ProposalId** - Unique identifier (e.g., `rano-proposal-20260208-001-moderate`)
- **ParameterChange** - Single parameter modification with MO path and rollback
- **CmeditCommand** - Generated cmedit/AMOS command with rollback
- **RiskLevel** - Assessed risk: low, medium, or high
- **VariantType** - conservative, moderate, or aggressive
- **ManagedObject** - Target MO with class, path, and technology

### Structure

```
ChangeProposalSet (Aggregate Root)
+-- intentId: IntentId
+-- variants: ChangeProposal[3]
|   +-- proposalId: ProposalId
|   +-- variant: VariantType
|   +-- agentsConsulted: string[]
|   +-- changes: ParameterChange[]
|   |   +-- mo: ManagedObject
|   |   |   +-- moClass: string             # e.g., "EUtranCellFDD"
|   |   |   +-- moPath: string              # e.g., "ENodeBFunction=1,EUtranCellFDD=Cell1"
|   |   |   +-- technology: "LTE" | "NR"
|   |   +-- paramName: string               # e.g., "a3offset"
|   |   +-- currentValue: any
|   |   +-- proposedValue: any
|   |   +-- confidence: number
|   |   +-- rationale: string
|   |   +-- requiresLock: boolean
|   |   +-- rollbackValue: any
|   +-- commands: CmeditCommand[]
|   |   +-- command: string                 # Full cmedit command
|   |   +-- moPath: string
|   |   +-- operation: "set" | "action"
|   |   +-- rollbackCommand: string
|   +-- rollbackCommands: CmeditCommand[]
|   +-- kpiTargets: KPITarget[]
|   +-- riskLevel: RiskLevel
|   +-- confidence: number
|   +-- scope: "cell" | "cluster" | "site"
+-- dependencyOrder: string[]               # Topological sort of changes
+-- selectedVariant: VariantType | null
+-- approvalStatus: "pending" | "approved" | "rejected" | "modified"
+-- approvedBy: string | null
+-- generatedAt: DateTime
```

### Invariants

1. Exactly three variants must be present (conservative, moderate, aggressive)
2. Conservative variant must have lowest risk level and fewest changes
3. Aggressive variant must have highest change count
4. Every ParameterChange must have a non-null rollbackValue
5. Commands must be ordered by dependency (topological sort)
6. Only one variant can be selected for approval
7. Approval status transitions: `pending` -> `approved` | `rejected` | `modified`

### Domain Events

| Event | Trigger |
|-------|---------|
| `ChangeProposalGenerated` | Action module produces variant |
| `HumanApprovalRequested` | Proposal presented for approval |
| `ChangeApproved` | Operator approves variant |
| `ChangeRejected` | Operator rejects proposal |

### Aggregate Methods

```typescript
class ChangeProposalSet {
  selectVariant(variant: VariantType): ChangeProposal {
    this.assertStatus("pending");
    this.selectedVariant = variant;
    return this.variants.find(v => v.variant === variant);
  }

  approve(userId: string, modifications?: ParameterModification[]): void {
    this.assertStatus("pending");
    if (modifications) {
      this.applyModifications(modifications);
      this.approvalStatus = "modified";
    } else {
      this.approvalStatus = "approved";
    }
    this.approvedBy = userId;
    this.raiseEvent(new ChangeApproved(this.intentId, this.selectedVariant));
  }

  reject(userId: string, reason: string): void {
    this.assertStatus("pending");
    this.approvalStatus = "rejected";
    this.raiseEvent(new ChangeRejected(this.intentId, reason));
  }

  getCommands(): CmeditCommand[] {
    const selected = this.getSelectedVariant();
    return selected.commands;
  }

  getRollbackCommands(): CmeditCommand[] {
    const selected = this.getSelectedVariant();
    return selected.rollbackCommands;
  }
}
```

### Repository Interface

```typescript
interface ChangeProposalRepository {
  findByIntentId(intentId: IntentId): Promise<ChangeProposalSet | null>;
  findPending(): Promise<ChangeProposalSet[]>;
  findByStatus(status: string): Promise<ChangeProposalSet[]>;
  save(proposalSet: ChangeProposalSet): Promise<void>;
}
```

---

## 3. Trajectory Aggregate

### Description

The Trajectory Aggregate captures the full lifecycle of an optimization run from intent submission through evaluation and learning. It serves as the primary record for learning and replay, storing state snapshots, outcomes, and reward signals.

### Aggregate Root

`TrajectoryRecord`

### Entities

- **TrajectoryRecord** (Root) - Full lifecycle record
- **StateSnapshot** - Point-in-time network state

### Value Objects

- **TrajectoryId** - Unique identifier (e.g., `rano-traj-20260208-001`)
- **Outcome** - Result classification: pending, success, partial, failure, rejected
- **RewardSignal** - Multi-component reward with optional human override

### Structure

```
TrajectoryRecord (Aggregate Root)
+-- trajectoryId: TrajectoryId
+-- intentId: IntentId
+-- intent: IntentDefinition
+-- proposal: ChangeProposal                # Selected variant
+-- stateBefore: StateSnapshot
|   +-- cellParameters: Map<string, any>
|   +-- kpiValues: Map<string, number>
|   +-- timestamp: DateTime
+-- stateAfter: StateSnapshot | null
+-- reward: RewardSignal | null
|   +-- total: number                       # 0.0 - 1.0
|   +-- targetKpiImprovement: number        # weight 0.5
|   +-- noRegressionScore: number           # weight 0.3
|   +-- complexityPenalty: number            # weight 0.2
+-- humanOverrideReward: number | null
+-- humanOverrideJustification: string | null
+-- outcome: Outcome
+-- agentsConsulted: string[]
+-- conflictsResolved: number
+-- evidenceStats: {
|   +-- patternsMatched: number
|   +-- crossRefsExpanded: number
|   +-- namespacesSearched: string[]
| }
+-- consensusStats: {
|   +-- layersUsed: number
|   +-- conflictsDetected: number
|   +-- paretoFrontSize: number
| }
+-- confidenceUpdates: {
|   +-- patternId: string
|   +-- previousConfidence: number
|   +-- newConfidence: number
|   +-- previousTier: ConfidenceTier
|   +-- newTier: ConfidenceTier
| }[]
+-- lessons: string[]
+-- createdAt: DateTime
+-- completedAt: DateTime | null
+-- durationMs: number | null
```

### Invariants

1. Trajectory ID must be unique
2. State before must be captured before any changes are applied
3. State after requires at least one KPI measurement
4. Reward can only be computed after state after is available
5. Outcome transitions: `pending` -> `success` | `partial` | `failure` | `rejected`
6. Completed trajectory must have a non-null completedAt timestamp
7. Human override reward must include justification

### Domain Events

| Event | Trigger |
|-------|---------|
| `KPIMeasured` | Post-change KPI measurements collected |
| `RewardComputed` | Multi-objective reward calculated |
| `ConfidenceUpdated` | Pattern confidence updated |
| `TrajectoryCompleted` | Full lifecycle recorded |
| `LearningBroadcast` | Learnings shared across namespaces |

### State Machine

```
[PENDING] --> [APPROVED] --> [EXECUTING] --> [MEASURING] --> [EVALUATED]
    |              |                                              |
    v              v                                              v
[REJECTED]    [FAILED]                                    [COMPLETED]
```

### Aggregate Methods

```typescript
class TrajectoryRecord {
  recordStateBefore(snapshot: StateSnapshot): void {
    this.assertOutcome("pending");
    this.stateBefore = snapshot;
  }

  recordApproval(variant: VariantType): void {
    this.assertOutcome("pending");
    this.outcome = "pending"; // Still pending until measured
  }

  recordRejection(): void {
    this.assertOutcome("pending");
    this.outcome = "rejected";
    this.completedAt = new Date();
    this.raiseEvent(new TrajectoryCompleted(this.trajectoryId, "rejected"));
  }

  recordStateAfter(snapshot: StateSnapshot): void {
    this.stateAfter = snapshot;
  }

  computeReward(kpiBefore: Map<string, number>, kpiAfter: Map<string, number>): RewardSignal {
    const targetImprovement = this.calculateTargetImprovement(kpiBefore, kpiAfter);
    const noRegression = this.calculateNoRegression(kpiBefore, kpiAfter);
    const complexity = this.calculateComplexityPenalty();

    this.reward = {
      total: 0.5 * targetImprovement + 0.3 * noRegression + 0.2 * (1 - complexity),
      targetKpiImprovement: targetImprovement,
      noRegressionScore: noRegression,
      complexityPenalty: complexity
    };

    this.raiseEvent(new RewardComputed(this.trajectoryId, this.reward));
    return this.reward;
  }

  overrideReward(adjustedReward: number, justification: string): void {
    this.humanOverrideReward = adjustedReward;
    this.humanOverrideJustification = justification;
  }

  complete(outcome: "success" | "partial" | "failure"): void {
    this.outcome = outcome;
    this.completedAt = new Date();
    this.durationMs = this.completedAt.getTime() - this.createdAt.getTime();
    this.raiseEvent(new TrajectoryCompleted(this.trajectoryId, outcome));
  }
}
```

### Repository Interface

```typescript
interface TrajectoryRepository {
  findById(trajectoryId: TrajectoryId): Promise<TrajectoryRecord | null>;
  findByIntentId(intentId: IntentId): Promise<TrajectoryRecord[]>;
  findByOutcome(outcome: string): Promise<TrajectoryRecord[]>;
  findRecent(limit: number): Promise<TrajectoryRecord[]>;
  save(trajectory: TrajectoryRecord): Promise<void>;
}
```

---

## 4. Consensus Aggregate

### Description

The Consensus Aggregate manages multi-agent voting, conflict resolution, and Pareto front computation. It collects proposals from all dispatched agents, identifies conflicts, and resolves them through a deterministic 4-layer process.

### Aggregate Root

`ConsensusSession`

### Entities

- **ConsensusSession** (Root) - The consensus process for a single intent
- **AgentVote** - Individual agent's vote on a parameter change

### Value Objects

- **ConsensusId** - Unique identifier
- **AgentProposal** - Per-agent change set with confidence and supporting patterns
- **ConflictRecord** - Detected conflict between agent proposals
- **ParetoPoint** - Point on the Pareto front for multi-objective optimization
- **ResolutionRecord** - How a specific conflict was resolved

### Structure

```
ConsensusSession (Aggregate Root)
+-- consensusId: ConsensusId
+-- intentId: IntentId
+-- agentProposals: AgentProposal[]
|   +-- agentId: string
|   +-- namespace: string
|   +-- changes: ParameterChange[]
|   +-- kpiPredictions: KPITarget[]
|   +-- confidence: number
|   +-- supportingPatterns: string[]
|   +-- historicalAccuracy: number          # success_count / applied_count
+-- conflicts: ConflictRecord[]
|   +-- paramName: string
|   +-- moPath: string
|   +-- competingValues: { agentId: string; value: any; confidence: number }[]
|   +-- resolvedBy: "kpi_voting" | "domain_priority" | "pareto" | "llm_arbitration"
|   +-- resolvedValue: any
|   +-- resolution: ResolutionRecord
+-- paretoFront: ParetoPoint[]
|   +-- objectiveValues: Map<string, number>
|   +-- changes: ParameterChange[]
|   +-- dominatedBy: number                 # 0 = non-dominated
+-- mergedChanges: ParameterChange[]        # Final merged change set
+-- priorityHierarchy: string[]
+-- votes: AgentVote[]
|   +-- agentId: string
|   +-- paramName: string
|   +-- vote: any
|   +-- confidence: number
|   +-- reasoning: string
+-- status: "collecting" | "resolving" | "completed"
+-- createdAt: DateTime
+-- completedAt: DateTime | null
```

### Invariants

1. At least one agent proposal required. When only one agent proposal exists, consensus is bypassed (no conflicts to resolve) and the single proposal passes through directly. When two or more proposals exist, full 4-layer resolution is triggered.
2. Conflicts can only be resolved by one of the four layers
3. Pareto front must contain at least one non-dominated point (when Layer 3 is invoked)
4. Merged changes must not contain conflicting values for the same parameter
5. All conflicts must be resolved before status transitions to "completed"
6. Priority hierarchy must be provided before domain priority resolution

### Domain Events

| Event | Trigger |
|-------|---------|
| `ConflictDetected` | Multiple agents propose different values for same parameter |
| `ConsensusReached` | All conflicts resolved, merged change set produced |

### 4-Layer Resolution Process

```typescript
class ConsensusSession {
  resolve(): ParameterChange[] {
    // Layer 1: KPI-weighted voting
    const remaining1 = this.resolveByKpiVoting(this.conflicts);

    // Layer 2: Domain priority hierarchy
    const remaining2 = this.resolveByDomainPriority(remaining1);

    // Layer 3: Pareto optimization
    const remaining3 = this.resolveByParetoOptimization(remaining2);

    // Layer 4: LLM arbitration (Claude Opus 4.6)
    const remaining4 = this.resolveByLlmArbitration(remaining3);

    this.mergedChanges = this.buildMergedChangeSet();
    this.status = "completed";
    this.completedAt = new Date();
    this.raiseEvent(new ConsensusReached(this.consensusId));

    return this.mergedChanges;
  }

  private resolveByKpiVoting(conflicts: ConflictRecord[]): ConflictRecord[] {
    // Weight = agent's historical success_count / applied_count
    // Each change gets a weighted confidence score
    // Resolve if one agent's weighted score exceeds others by >20%
  }

  private resolveByDomainPriority(conflicts: ConflictRecord[]): ConflictRecord[] {
    // Use priority hierarchy (e.g., safety > coverage > capacity)
    // Higher-priority domain agent's value wins
  }

  private resolveByParetoOptimization(conflicts: ConflictRecord[]): ConflictRecord[] {
    // Multi-objective optimization via scipy
    // Find values that satisfy most KPI targets simultaneously
  }

  private resolveByLlmArbitration(conflicts: ConflictRecord[]): ConflictRecord[] {
    // Claude Opus 4.6 via ConsensusSignature
    // Few-shot examples from consensus_prompt.txt
    // Returns merged values with explanation
  }
}
```

### Repository Interface

```typescript
interface ConsensusRepository {
  findById(consensusId: ConsensusId): Promise<ConsensusSession | null>;
  findByIntentId(intentId: IntentId): Promise<ConsensusSession | null>;
  save(session: ConsensusSession): Promise<void>;
}
```

---

## Aggregate Relationships

```
+-------------------+         +---------------------+
| IntentDefinition  |-------->| ConsensusSession    |
| (decomposes       |         | (resolves conflicts |
|  intent)          |         |  across agents)     |
+-------------------+         +---------------------+
        |                              |
        |                              | produces
        |                              v
        |                     +---------------------+
        |                     | ChangeProposalSet   |
        |                     | (3 ranked variants  |
        |                     |  with commands)     |
        |                     +---------------------+
        |                              |
        |                              | records
        |                              v
        +-------------------->+---------------------+
                              | TrajectoryRecord    |
                              | (full lifecycle     |
                              |  with reward)       |
                              +---------------------+
```

---

## Cross-Aggregate References

Aggregates reference each other by ID only, following the same pattern as the rest of the platform:

- ConsensusSession references IntentDefinition by `IntentId`
- ChangeProposalSet references IntentDefinition by `IntentId`
- TrajectoryRecord references IntentDefinition by `IntentId`
- TrajectoryRecord references ChangeProposal by `ProposalId`
- ConfidenceUpdated references Pattern by `PatternId` (cross-context reference to Learning)

---

## Database Mapping

| Aggregate | Primary Table | Supporting Tables |
|-----------|--------------|-------------------|
| IntentDefinition | `patterns` (pattern_type='intent') | - |
| ChangeProposalSet | `trajectories` | `consensus_votes` |
| TrajectoryRecord | `trajectories` | `trajectory_summaries` |
| ConsensusSession | `consensus_votes` | `pattern_history` |

All data persisted to `.swarm/memory.db`.

---

## Confidence Scale Convention

RANO uses **0.0-1.0 float** for confidence internally (matching DSPy output ranges and EMA/Bayesian computation). The platform shared kernel defines confidence as **0-100 percentage**. Conversion occurs at the context boundary:

- **RANO internal**: `0.0-1.0` float (used in all aggregates, signatures, and modules)
- **Platform boundary**: `int(confidence * 100)` when writing to shared tables consumed by non-RANO contexts
- **From platform**: `confidence / 100.0` when reading patterns written by the Learning Context

This mapping is handled in `db.py` at the read/write boundary, not within domain logic.
