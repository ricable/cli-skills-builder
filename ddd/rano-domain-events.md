# RANO Domain Events - Intent-Based RAN Optimization

## Overview

This document catalogs the domain events specific to the RANO Optimization Context. These events trace the full lifecycle of an intent-based optimization run: from intent submission through evidence gathering, multi-agent planning, consensus, change execution, evaluation, and learning.

---

## Event Catalog

### Intent Lifecycle Events

#### IntentSubmitted

Raised when a user submits a natural language optimization intent.

```typescript
interface IntentSubmitted {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  intentText: string;
  userId: string;
  options: {
    scope?: "cell" | "cluster" | "site";
    agents?: string[];
    variantCount?: number;
  };
}
```

**Triggers:**
- User invokes CLI: `python -m optimizer "Improve handover success rate"`
- User invokes skill: `/rano "Reduce PRB congestion"`

**Consumers:**
- Goal Module (decomposes intent)

---

#### IntentDecomposed

Raised when the Goal module decomposes a natural language intent into structured objectives.

```typescript
interface IntentDecomposed {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  intentText: string;
  decomposition: {
    kpiTargets: KPITarget[];
    relevantDomains: string[];
    scope: "cell" | "cluster" | "site";
    decomposedObjectives: string[];
  };
  matchedCatalogIntent?: {
    catalogId: string;
    similarityScore: number;
  };
  llmBackend: string; // e.g., "ollama/glm-4.7-flash"
}

interface KPITarget {
  name: string;
  direction: "increase" | "decrease" | "stabilize";
  targetValue?: number;
  currentValue?: number;
  weight: number;
}
```

**Triggers:**
- Goal module completes intent parsing via DSPy GoalSignature
- Fallback vector search resolves ambiguous intent

**Consumers:**
- Evidence Module (scopes vector search to relevant namespaces)
- Plan Module (determines which agents to dispatch)

---

### Evidence Events

#### EvidenceRetrieved

Raised when the Evidence module completes vector search and knowledge graph traversal.

```typescript
interface EvidenceRetrieved {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  evidence: {
    vectorSearchResults: {
      patternKey: string;
      namespace: string;
      similarity: number;
      confidence: number;
    }[];
    knowledgeGraphExpansion: {
      parameters: string[];
      features: string[];
      counters: string[];
      kpis: string[];
      crossRefs: number;
    };
    playbookSections: {
      agentId: string;
      sectionCount: number;
    }[];
  };
  retrievalTimeMs: number;
  namespacesSearched: string[];
  totalPatternsMatched: number;
}
```

**Triggers:**
- Evidence module executes vector search across relevant namespaces
- Knowledge graph expansion follows cross-references (param -> feature -> counter -> KPI)
- Playbook retrieval loads agent-specific procedures

**Consumers:**
- Plan Module (provides context to each agent)

---

### Planning Events

#### AgentProposalCreated

Raised when an individual domain agent generates a parameter change proposal.

```typescript
interface AgentProposalCreated {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  agentId: string;
  namespace: string;
  proposal: {
    changes: ParameterChange[];
    kpiPredictions: KPITarget[];
    confidence: number;
    supportingPatterns: string[];
    risks: string[];
  };
  llmBackend: string;
  responseTimeMs: number;
}

interface ParameterChange {
  moClass: string;
  moPath: string;
  technology: "LTE" | "NR";
  paramName: string;
  currentValue: any;
  proposedValue: any;
  confidence: number;
  rationale: string;
  requiresLock: boolean;
  rollbackValue: any;
}
```

**Triggers:**
- Domain agent (e.g., mobility-agent, rrm-agent) completes PlanSignature via Ollama
- Agent wrapper loads YAML config and scopes retrieval to agent namespace

**Consumers:**
- Consensus Module (collects all agent proposals for conflict resolution)

---

### Consensus Events

#### ConflictDetected

Raised when multiple agents propose conflicting values for the same parameter.

```typescript
interface ConflictDetected {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  conflicts: {
    paramName: string;
    moPath: string;
    agentProposals: {
      agentId: string;
      proposedValue: any;
      confidence: number;
      rationale: string;
    }[];
  }[];
  totalConflicts: number;
}
```

**Triggers:**
- Consensus module detects two or more agents proposing different values for the same parameter on the same MO path

**Consumers:**
- Consensus Module (triggers 4-layer resolution)
- Trajectory Aggregate (records conflict for learning)

---

#### ConsensusReached

Raised when the 4-layer consensus process produces a merged change set.

```typescript
interface ConsensusReached {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  resolutionLayers: {
    kpiWeightedVoting: {
      resolved: number;
      remaining: number;
    };
    domainPriority: {
      resolved: number;
      remaining: number;
      priorityOrder: string[];
    };
    paretoOptimization: {
      resolved: number;
      remaining: number;
      paretoFrontSize: number;
    };
    llmArbitration: {
      resolved: number;
      llmBackend: string;
    };
  };
  totalConflictsResolved: number;
  mergedChangeCount: number;
}
```

**Triggers:**
- All four consensus layers have processed agent proposals
- Claude Opus 4.6 completes final arbitration via ConsensusSignature

**Consumers:**
- Action Module (generates three variants from merged change set)

---

### Change Proposal Events

#### ChangeProposalGenerated

Raised when the Action module produces a complete change proposal variant.

```typescript
interface ChangeProposalGenerated {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  proposalId: string;
  variant: "conservative" | "moderate" | "aggressive";
  proposal: {
    agentsConsulted: string[];
    changes: ParameterChange[];
    commands: CmeditCommand[];
    rollbackCommands: CmeditCommand[];
    kpiTargets: KPITarget[];
    riskLevel: "low" | "medium" | "high";
    confidence: number;
    scope: "cell" | "cluster" | "site";
  };
  dependencyOrder: string[];
}

interface CmeditCommand {
  command: string;
  moPath: string;
  operation: "set" | "action";
  rollbackCommand: string;
}
```

**Triggers:**
- Action module processes merged consensus output
- Activation planner queries dependency graph and performs topological sort
- cmedit generator produces commands for each variant

**Consumers:**
- CLI (presents variant comparison to operator)
- Workflow Execution Context (receives approved variant for execution)

---

#### HumanApprovalRequested

Raised when a change proposal is presented to an operator for approval.

```typescript
interface HumanApprovalRequested {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  proposalId: string;
  variant: "conservative" | "moderate" | "aggressive";
  summary: {
    changeCount: number;
    riskLevel: "low" | "medium" | "high";
    confidence: number;
    affectedCells: number;
    affectedParameters: string[];
  };
  availableActions: ("approve" | "reject" | "modify" | "switch_variant")[];
}
```

**Triggers:**
- Action module completes all three variants
- CLI presents side-by-side comparison

**Consumers:**
- CLI (displays approval prompt)
- Trajectory Aggregate (records approval request timestamp)

---

#### ChangeApproved

Raised when an operator approves a change proposal variant.

```typescript
interface ChangeApproved {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  proposalId: string;
  variant: "conservative" | "moderate" | "aggressive";
  approvedBy: string;
  modifications?: {
    paramName: string;
    originalValue: any;
    modifiedValue: any;
    reason: string;
  }[];
}
```

**Triggers:**
- Operator selects [A]pprove in CLI
- Operator selects [M]odify and confirms adjustments

**Consumers:**
- Workflow Execution Context (executes cmedit commands)
- Trajectory Aggregate (records approval)

---

#### ChangeRejected

Raised when an operator rejects a change proposal.

```typescript
interface ChangeRejected {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  proposalId: string;
  rejectedBy: string;
  reason: string;
}
```

**Triggers:**
- Operator selects [R]eject in CLI

**Consumers:**
- Trajectory Aggregate (records rejection, no reward computed)
- Adapt Module (may decrease confidence on supporting patterns)

---

### Evaluation Events

#### KPIMeasured

Raised when post-change KPI measurements are collected.

```typescript
interface KPIMeasured {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  trajectoryId: string;
  measurement: {
    windowMinutes: number;
    kpiBefore: Map<string, number>;
    kpiAfter: Map<string, number>;
    deltas: {
      kpiName: string;
      before: number;
      after: number;
      changePercent: number;
      direction: "improved" | "degraded" | "stable";
    }[];
  };
  collectedAt: DateTime;
}
```

**Triggers:**
- Configurable KPI window elapses (15min, 30min, 1hr, 2hr depending on intent)
- Manual KPI snapshot provided by operator

**Consumers:**
- Evaluate Module (computes reward signal)

---

#### RewardComputed

Raised when the Evaluate module calculates a multi-objective reward signal.

```typescript
interface RewardComputed {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  trajectoryId: string;
  reward: {
    total: number; // 0.0 - 1.0
    components: {
      targetKpiImprovement: number;  // weight 0.5
      noRegressionScore: number;     // weight 0.3
      complexityPenalty: number;     // weight 0.2
    };
  };
  humanOverride?: {
    adjustedReward: number;
    justification: string;
  };
  assessment: string;
  lessons: string[];
}
```

**Triggers:**
- KPI measurements collected and compared to targets
- Optional human override with justification

**Consumers:**
- Adapt Module (updates pattern confidence)
- Trajectory Aggregate (records reward)

---

### Learning Events

#### ConfidenceUpdated

Raised when pattern confidence is updated based on optimization outcome.

```typescript
interface ConfidenceUpdated {
  eventId: string;
  timestamp: DateTime;
  intentId: string;
  trajectoryId: string;
  updates: {
    patternId: string;
    previousConfidence: number;
    newConfidence: number;
    updateMethod: "ema" | "bayesian";
    previousTier: ConfidenceTier;
    newTier: ConfidenceTier;
    promoted: boolean;
    demoted: boolean;
  }[];
}

type ConfidenceTier = "candidate" | "validated" | "proven" | "expert";
```

**Triggers:**
- Adapt module applies EMA update: `new_conf = 0.1 * reward + 0.9 * old_conf`
- Adapt module applies Bayesian update: Beta distribution posterior from success/failure counts
- Tier promotion after 3 consecutive successes; demotion after 2 consecutive failures

**Consumers:**
- Learning Context (persists updated confidence to patterns table)
- Pattern History (records change in pattern_history table)

---

#### TrajectoryCompleted

Raised when the full optimization lifecycle has been recorded.

```typescript
interface TrajectoryCompleted {
  eventId: string;
  timestamp: DateTime;
  trajectoryId: string;
  intentId: string;
  summary: {
    intentText: string;
    variantSelected: "conservative" | "moderate" | "aggressive";
    outcome: "success" | "partial" | "failure" | "rejected";
    reward: number;
    changesApplied: number;
    kpiImprovements: number;
    kpiRegressions: number;
    durationMs: number;
    agentsConsulted: string[];
    conflictsResolved: number;
  };
  storedIn: {
    trajectories: boolean;
    trajectorySummaries: boolean;
    consensusVotes: boolean;
    patternHistory: boolean;
  };
}
```

**Triggers:**
- Adapt module completes all confidence updates and trajectory recording
- All database writes to memory.db succeed

**Consumers:**
- Dashboard Monitoring Context (displays optimization history)
- Learning Context (trajectory available for replay)

---

#### LearningBroadcast

Raised when learnings from one optimization run are shared across agent namespaces.

```typescript
interface LearningBroadcast {
  eventId: string;
  timestamp: DateTime;
  trajectoryId: string;
  sourceAgent: string;
  sourceNamespace: string;
  targetNamespaces: string[];
  broadcast: {
    patternId: string;
    confidenceUpdate: number;
    lesson: string;
    applicableDomains: string[];
  };
}
```

**Triggers:**
- Adapt module identifies cross-domain learnings
- Pattern confidence crosses tier boundary

**Consumers:**
- Learning Context (inserts into shared_learnings table)
- Other domain agents (receive updated confidence in their namespace)

---

## Event Flow Diagrams

### Successful Optimization Flow

```
IntentSubmitted
       |
       v
IntentDecomposed
       |
       v
EvidenceRetrieved
       |
       v
AgentProposalCreated (per agent, parallel)
       |
       v
ConflictDetected (if conflicts exist)
       |
       v
ConsensusReached
       |
       v
ChangeProposalGenerated (x3 variants)
       |
       v
HumanApprovalRequested
       |
       v
ChangeApproved
       |
       v
  +----------------+
  | Wait KPI window|
  +-------+--------+
          |
          v
     KPIMeasured
          |
          v
    RewardComputed
          |
          v
   ConfidenceUpdated
          |
          v
  TrajectoryCompleted
          |
          v
   LearningBroadcast
```

### Rejected Proposal Flow

```
IntentSubmitted
       |
       v
IntentDecomposed
       |
       v
EvidenceRetrieved
       |
       v
AgentProposalCreated (per agent)
       |
       v
ConsensusReached
       |
       v
ChangeProposalGenerated (x3 variants)
       |
       v
HumanApprovalRequested
       |
       v
ChangeRejected
       |
       v
TrajectoryCompleted (outcome: "rejected", no reward)
```

---

## Event Handling Guidelines

### Idempotency

All event handlers must be idempotent. The same optimization intent may be retried, and events may be replayed from trajectory records.

### Ordering

Events within a single optimization run (identified by `intentId`) are strictly ordered. Cross-intent event ordering is not guaranteed.

### Persistence

All RANO domain events are persisted to `memory.db` tables:
- `trajectories` - Full trajectory records
- `trajectory_summaries` - Aggregated outcome data
- `consensus_votes` - Per-agent voting records
- `pattern_history` - Confidence change log
- `shared_learnings` - Cross-namespace broadcasts

### Versioning

All RANO domain events extend the `RANODomainEvent` base interface, which includes a schema version for backward compatibility. Every event interface defined above implicitly includes these base fields:

```typescript
interface RANODomainEvent {
  eventId: string;       // UUID, unique per event instance
  timestamp: DateTime;   // ISO 8601 timestamp
  version: string;       // Schema version, currently "1.0"
  intentId: string;      // Links all events in a single optimization run
}
```

**Convention**: All event interfaces in this document extend `RANODomainEvent`. The `eventId`, `timestamp`, `version`, and `intentId` fields shown in each interface are inherited from this base. When the event schema changes in a backward-incompatible way, the version field is incremented (e.g., "1.0" -> "2.0") and both versions are supported during a migration window.

**Implementation note**: In Python (Pydantic), this maps to a `RANODomainEvent` base model class that all specific event models inherit from.
