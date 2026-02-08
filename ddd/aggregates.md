# Aggregates - Clawdbot RAN Platform

## Overview

This document defines the core aggregates in the Clawdbot RAN Platform domain model. Aggregates are clusters of domain objects that are treated as a single unit for data changes.

---

## 1. Cell Aggregate

### Description

The Cell Aggregate represents a RAN cell with its current state, configuration parameters, and performance metrics. It is the primary entity being diagnosed and remediated.

### Aggregate Root

`Cell`

### Entities

- **Cell** (Root) - The radio cell itself
- **CellParameters** - Configuration settings
- **CellKPIs** - Performance metrics

### Value Objects

- **CellId** - Unique identifier (e.g., `NR_Cell_123`)
- **Technology** - LTE or NR
- **OperationalState** - Active, Blocked, Degraded
- **GeoLocation** - Coordinates and radius

### Structure

```
Cell (Aggregate Root)
├── cellId: CellId
├── technology: Technology
├── operationalState: OperationalState
├── location: GeoLocation
├── nodeId: string
├── parameters: CellParameters
│   ├── prachConfigIndex: number
│   ├── rsrpThreshold: number
│   ├── a3Offset: number
│   ├── cellRadius: number
│   └── [other parameters...]
└── kpis: CellKPIs
    ├── rachSuccessRate: Percentage
    ├── handoverSuccessRate: Percentage
    ├── throughputDL: number
    ├── throughputUL: number
    ├── dropRate: Percentage
    └── timestamp: DateTime
```

### Invariants

1. Cell ID must follow naming convention (`{TECH}_Cell_{ID}`)
2. Operational state transitions must be valid (Active -> Degraded -> Blocked)
3. Parameter values must be within allowed ranges
4. KPIs must have a timestamp within acceptable staleness threshold

### Domain Events

| Event | Trigger |
|-------|---------|
| `CellDegradationDetected` | KPI falls below threshold |
| `CellStateChanged` | Operational state transition |
| `ParameterChanged` | CM parameter modified |
| `KPIImproved` | KPI rises above threshold |

### Repository Interface

```typescript
interface CellRepository {
  findById(cellId: CellId): Promise<Cell | null>;
  findByNode(nodeId: string): Promise<Cell[]>;
  findDegraded(): Promise<Cell[]>;
  save(cell: Cell): Promise<void>;
}
```

### Example

```typescript
const cell = new Cell({
  cellId: CellId.from("NR_Cell_123"),
  technology: Technology.NR,
  operationalState: OperationalState.DEGRADED,
  location: new GeoLocation(59.3293, 18.0686, 12.0), // km radius
  nodeId: "gNodeB_Stockholm_01",
  parameters: new CellParameters({
    prachConfigIndex: 3,
    rsrpThreshold: -130,
    a3Offset: 2,
    cellRadius: 12.0
  }),
  kpis: new CellKPIs({
    rachSuccessRate: Percentage.from(85),
    handoverSuccessRate: Percentage.from(92),
    timestamp: new Date()
  })
});

// Check for degradation
if (cell.isDegraded()) {
  cell.raiseEvent(new CellDegradationDetected(cell.cellId, cell.kpis));
}
```

---

## 2. Pattern Aggregate

### Description

The Pattern Aggregate encapsulates a learned troubleshooting pattern, including its symptom signature, solution steps, confidence score, and application history.

### Aggregate Root

`Pattern`

### Entities

- **Pattern** (Root) - The learned pattern
- **ApplicationRecord** - History of pattern applications

### Value Objects

- **PatternId** - Unique identifier (e.g., `P-001`)
- **Symptom** - Observable problem signature
- **RootCause** - Identified underlying issue
- **Solution** - Parameter changes to apply
- **Confidence** - Success probability (0-100%)
- **SimilarityVector** - Embedding for HNSW search

### Structure

```
Pattern (Aggregate Root)
├── patternId: PatternId
├── name: string
├── symptom: Symptom
│   ├── description: string
│   ├── kpiThresholds: Map<string, Threshold>
│   └── parameterConditions: Map<string, Condition>
├── rootCause: RootCause
│   ├── description: string
│   └── category: RootCauseCategory
├── solution: Solution
│   ├── description: string
│   ├── parameterChanges: ParameterChange[]
│   └── prerequisites: string[]
├── confidence: Confidence
├── similarityVector: number[]
├── applications: ApplicationRecord[]
│   ├── cellId: CellId
│   ├── appliedAt: DateTime
│   ├── success: boolean
│   └── kpiImprovement: Percentage
├── createdAt: DateTime
└── lastAppliedAt: DateTime
```

### Invariants

1. Confidence must be between 0 and 100
2. At least one application required to have non-zero confidence
3. Pattern must have at least one symptom threshold
4. Solution must have at least one parameter change

### Domain Events

| Event | Trigger |
|-------|---------|
| `PatternLearned` | New pattern created |
| `PatternMatched` | Symptom matches pattern |
| `PatternConfidenceUpdated` | Application result recorded |
| `PatternArchived` | Confidence drops below threshold |

### Confidence Calculation

```typescript
class Pattern {
  calculateConfidence(): Confidence {
    const successful = this.applications.filter(a => a.success).length;
    const total = this.applications.length;

    if (total === 0) return Confidence.from(0);

    return Confidence.from((successful / total) * 100);
  }

  recordApplication(record: ApplicationRecord): void {
    this.applications.push(record);
    this.confidence = this.calculateConfidence();
    this.lastAppliedAt = record.appliedAt;

    this.raiseEvent(new PatternConfidenceUpdated(
      this.patternId,
      this.confidence
    ));
  }
}
```

### Repository Interface

```typescript
interface PatternRepository {
  findById(patternId: PatternId): Promise<Pattern | null>;
  findBySimilarity(vector: number[], threshold: number): Promise<Pattern[]>;
  findByConfidenceAbove(threshold: Confidence): Promise<Pattern[]>;
  save(pattern: Pattern): Promise<void>;
  archive(patternId: PatternId): Promise<void>;
}
```

### Example Pattern

```markdown
# Pattern P-001: RACH Failure - prachConfigIndex Mismatch

## Symptom
- RACH_SUCCESS_RATE < 90% for > 15 minutes
- cellRadius > 10 km
- prachConfigIndex < 5

## Root Cause
prachConfigIndex too low for cell coverage distance. PRACH preamble
propagation delay exceeds timing window.

## Solution
Change prachConfigIndex from current value to 5 for cells > 10km.

## Confidence: 92% (23/25 successful applications)

## Last Applied: 2026-01-25 on NR_Cell_456
```

---

## 3. Resolution Aggregate

### Description

The Resolution Aggregate manages the complete lifecycle of a troubleshooting case, from detection through diagnosis, remediation, and validation.

### Aggregate Root

`Resolution`

### Entities

- **Resolution** (Root) - The troubleshooting case
- **Diagnosis** - Root cause analysis result
- **Remediation** - Applied solution
- **Validation** - KPI verification result

### Value Objects

- **ResolutionId** - Unique identifier
- **ResolutionStatus** - Detected, Diagnosing, Remediating, Validating, Resolved, Failed
- **DiagnosisResult** - Analysis output
- **ValidationResult** - KPI comparison

### Structure

```
Resolution (Aggregate Root)
├── resolutionId: ResolutionId
├── cellId: CellId
├── status: ResolutionStatus
├── problemDescription: string
├── detectedAt: DateTime
├── diagnosis: Diagnosis | null
│   ├── rootCause: string
│   ├── matchedPattern: PatternId | null
│   ├── confidence: Confidence
│   ├── recommendedSolution: Solution
│   └── completedAt: DateTime
├── remediation: Remediation | null
│   ├── parameterChanges: ParameterChange[]
│   ├── appliedAt: DateTime
│   ├── appliedBy: AgentId
│   ├── approvalRequired: boolean
│   └── approvedBy: UserId | null
├── validation: Validation | null
│   ├── baselineKPIs: CellKPIs
│   ├── postChangeKPIs: CellKPIs
│   ├── improvement: Percentage
│   ├── success: boolean
│   └── validatedAt: DateTime
├── resolvedAt: DateTime | null
└── events: DomainEvent[]
```

### State Machine

```
                   ┌──────────────────────────────────────────┐
                   │                                          │
                   ▼                                          │
[DETECTED] ──► [DIAGNOSING] ──► [REMEDIATING] ──► [VALIDATING]
                   │                   │               │
                   │                   │               ▼
                   │                   │          [RESOLVED]
                   │                   │               │
                   ▼                   ▼               ▼
              [FAILED]            [FAILED]        [FAILED]
                   │                   │               │
                   └───────────────────┴───────────────┘
                                   │
                                   ▼
                            (Rollback / Retry)
```

### Invariants

1. Status transitions must follow valid paths
2. Diagnosis required before remediation
3. Remediation required before validation
4. Approval required if confidence < 95%
5. Rollback must restore original parameters

### Domain Events

| Event | Trigger |
|-------|---------|
| `ResolutionStarted` | Problem detected |
| `DiagnosisCompleted` | Root cause identified |
| `ApprovalRequested` | Low confidence remediation |
| `RemediationApplied` | Parameters changed |
| `RemediationRolledBack` | Validation failed |
| `KPIValidated` | Improvement confirmed |
| `ResolutionCompleted` | Case closed successfully |
| `ResolutionFailed` | Case closed unsuccessfully |

### Aggregate Methods

```typescript
class Resolution {
  startDiagnosis(): void {
    this.assertStatus(ResolutionStatus.DETECTED);
    this.status = ResolutionStatus.DIAGNOSING;
  }

  completeDiagnosis(diagnosis: Diagnosis): void {
    this.assertStatus(ResolutionStatus.DIAGNOSING);
    this.diagnosis = diagnosis;
    this.raiseEvent(new DiagnosisCompleted(this.resolutionId, diagnosis));
  }

  applyRemediation(remediation: Remediation): void {
    this.assertStatus(ResolutionStatus.DIAGNOSING);

    if (remediation.requiresApproval && !remediation.approvedBy) {
      this.raiseEvent(new ApprovalRequested(this.resolutionId, remediation));
      return;
    }

    this.remediation = remediation;
    this.status = ResolutionStatus.REMEDIATING;
    this.raiseEvent(new RemediationApplied(this.resolutionId, remediation));
  }

  validateKPIs(validation: Validation): void {
    this.assertStatus(ResolutionStatus.REMEDIATING);
    this.validation = validation;
    this.status = ResolutionStatus.VALIDATING;

    if (validation.success) {
      this.status = ResolutionStatus.RESOLVED;
      this.resolvedAt = new Date();
      this.raiseEvent(new KPIValidated(this.resolutionId, validation));
      this.raiseEvent(new ResolutionCompleted(this.resolutionId));
    } else {
      this.raiseEvent(new ValidationFailed(this.resolutionId, validation));
    }
  }

  rollback(): void {
    this.assertStatus(ResolutionStatus.VALIDATING);
    // Revert parameter changes
    this.raiseEvent(new RemediationRolledBack(this.resolutionId));
    this.status = ResolutionStatus.FAILED;
  }
}
```

### Repository Interface

```typescript
interface ResolutionRepository {
  findById(resolutionId: ResolutionId): Promise<Resolution | null>;
  findByCell(cellId: CellId): Promise<Resolution[]>;
  findActive(): Promise<Resolution[]>;
  findByStatus(status: ResolutionStatus): Promise<Resolution[]>;
  save(resolution: Resolution): Promise<void>;
}
```

---

## 4. Agent Aggregate

### Description

The Agent Aggregate represents an AI agent with its workspace, configuration, capabilities, and current session state.

### Aggregate Root

`Agent`

### Entities

- **Agent** (Root) - The AI agent
- **Workspace** - File system context
- **Session** - Active interaction

### Value Objects

- **AgentId** - Unique identifier (e.g., `5g-nr-agent`)
- **AgentType** - Orchestrator, Specialist, Gateway, Learning
- **ModelConfig** - AI model settings
- **ToolPermissions** - Allowed/denied tools
- **WorkspacePath** - Directory location

### Structure

```
Agent (Aggregate Root)
├── agentId: AgentId
├── name: string
├── type: AgentType
├── modelConfig: ModelConfig
│   ├── provider: string (anthropic, ollama, openai)
│   ├── model: string
│   └── fallback: string[]
├── workspace: Workspace
│   ├── path: WorkspacePath
│   ├── agentsMd: string (AGENTS.md content)
│   ├── soulMd: string (SOUL.md content)
│   ├── memoryMd: string (MEMORY.md content)
│   └── skills: Skill[]
├── toolPermissions: ToolPermissions
│   ├── allow: string[]
│   └── deny: string[]
├── currentSession: Session | null
│   ├── sessionId: string
│   ├── startedAt: DateTime
│   ├── messages: Message[]
│   └── subagents: AgentId[]
├── status: AgentStatus (idle, busy, error)
└── metrics: AgentMetrics
    ├── tasksCompleted: number
    ├── averageResponseTime: Duration
    └── successRate: Percentage
```

### Invariants

1. Agent must have valid model configuration
2. Workspace path must exist and be accessible
3. Only one active session per agent
4. Tool permissions cannot overlap (allow vs. deny)

### Domain Events

| Event | Trigger |
|-------|---------|
| `AgentSpawned` | Agent created |
| `AgentSessionStarted` | Session begins |
| `AgentSessionEnded` | Session completes |
| `AgentMessageReceived` | Input received |
| `AgentResponseGenerated` | Output produced |
| `SubagentSpawned` | Background task created |

### Agent Types

| Type | Responsibility | Example Agents |
|------|----------------|----------------|
| `Orchestrator` | Coordinate and synthesize | `orchestrator` |
| `Specialist` | Domain expertise | `4g-lte-agent`, `5g-nr-agent`, `rrm-agent` |
| `Gateway` | External API access | `enm-api-agent` |
| `Learning` | Pattern capture | `learning-agent` |
| `Alarm` | Alarm analysis | `alarm-agent` |

### Repository Interface

```typescript
interface AgentRepository {
  findById(agentId: AgentId): Promise<Agent | null>;
  findByType(type: AgentType): Promise<Agent[]>;
  findAvailable(): Promise<Agent[]>;
  save(agent: Agent): Promise<void>;
}
```

### Example Configuration

```json
{
  "id": "5g-nr-agent",
  "name": "5G NR Specialist",
  "type": "specialist",
  "modelConfig": {
    "provider": "ollama",
    "model": "qwen2.5-coder:32b",
    "fallback": ["ollama/llama3.3"]
  },
  "workspace": {
    "path": "~/ran-agents/5g-nr"
  },
  "toolPermissions": {
    "allow": ["read", "write", "agent_send"],
    "deny": ["exec", "gateway"]
  }
}
```

---

## Aggregate Relationships

```
+----------------+         +----------------+
|     Cell       |◄────────|   Resolution   |
| (target of     |         | (diagnoses     |
|  diagnosis)    |         |  cell issues)  |
+----------------+         +----------------+
        │                         │
        │                         │ matches
        │                         ▼
        │                  +----------------+
        │                  |    Pattern     |
        │                  | (learned from  |
        │                  |  resolutions)  |
        │                  +----------------+
        │                         ▲
        │                         │ learns from
        │                         │
        │                  +----------------+
        └──────────────────|     Agent      |
                           | (performs      |
                           |  diagnosis)    |
                           +----------------+
```

---

## Cross-Aggregate References

Aggregates reference each other by ID only, not by direct object reference:

- Resolution references Cell by `CellId`
- Resolution references Pattern by `PatternId`
- Agent spawns subagents by `AgentId`
- Pattern tracks applications by `CellId`

This ensures aggregates remain independent and can be persisted/retrieved separately.
