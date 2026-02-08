# Domain Events - Clawdbot RAN Platform

## Overview

This document catalogs the domain events in the Clawdbot RAN Platform. Domain events represent significant occurrences within the domain that other parts of the system may need to react to.

---

## Event Catalog

### Troubleshooting Context Events

#### CellDegradationDetected

Raised when a cell's KPIs fall below acceptable thresholds.

```typescript
interface CellDegradationDetected {
  eventId: string;
  timestamp: DateTime;
  cellId: CellId;
  technology: Technology;
  degradationType: DegradationType;
  currentKPIs: {
    rachSuccessRate?: Percentage;
    handoverSuccessRate?: Percentage;
    throughputDL?: number;
    dropRate?: Percentage;
  };
  thresholdBreached: {
    metric: string;
    threshold: number;
    actual: number;
  };
  duration: Duration; // How long below threshold
}

enum DegradationType {
  RACH_FAILURE = "RACH_FAILURE",
  HANDOVER_FAILURE = "HANDOVER_FAILURE",
  THROUGHPUT_DEGRADATION = "THROUGHPUT_DEGRADATION",
  DROP_RATE_SPIKE = "DROP_RATE_SPIKE",
  COVERAGE_HOLE = "COVERAGE_HOLE"
}
```

**Triggers:**
- PM counter analysis detects KPI below threshold
- Scheduled health check identifies degradation
- Alarm correlation indicates performance issue

**Consumers:**
- Troubleshooting Context (starts resolution)
- Alarm Management Context (correlates with alarms)
- Learning Context (checks for matching patterns)

---

#### DiagnosisCompleted

Raised when root cause analysis finishes for a cell issue.

```typescript
interface DiagnosisCompleted {
  eventId: string;
  timestamp: DateTime;
  resolutionId: ResolutionId;
  cellId: CellId;
  diagnosis: {
    rootCause: string;
    rootCauseCategory: RootCauseCategory;
    confidence: Confidence;
    matchedPatternId?: PatternId;
    contributingFactors: string[];
  };
  recommendedSolution: {
    description: string;
    parameterChanges: ParameterChange[];
    estimatedImpact: string;
  };
  analysisDetails: {
    agentsConsulted: AgentId[];
    dataSourcesUsed: string[];
    analysisTimeMs: number;
  };
}

enum RootCauseCategory {
  PARAMETER_MISMATCH = "PARAMETER_MISMATCH",
  HARDWARE_FAULT = "HARDWARE_FAULT",
  SOFTWARE_BUG = "SOFTWARE_BUG",
  INTERFERENCE = "INTERFERENCE",
  CAPACITY_LIMITATION = "CAPACITY_LIMITATION",
  EXTERNAL_FACTOR = "EXTERNAL_FACTOR"
}
```

**Triggers:**
- Specialist agents complete parallel analysis
- Pattern matching identifies known root cause
- Manual diagnosis by orchestrator

**Consumers:**
- Workflow Execution Context (initiates remediation workflow)
- Learning Context (records diagnosis for pattern matching)

---

#### RemediationApplied

Raised when parameter changes are applied to a cell.

```typescript
interface RemediationApplied {
  eventId: string;
  timestamp: DateTime;
  resolutionId: ResolutionId;
  cellId: CellId;
  parameterChanges: {
    parameter: string;
    managedObject: string;
    previousValue: any;
    newValue: any;
  }[];
  appliedBy: {
    agentId: AgentId;
    automatic: boolean;
    approvedBy?: UserId;
  };
  confidence: Confidence;
  matchedPatternId?: PatternId;
  rollbackPossible: boolean;
}
```

**Triggers:**
- Workflow executes parameter change step
- High-confidence pattern auto-applies
- Human-approved change executes

**Consumers:**
- API Gateway Context (executes CM write)
- Learning Context (tracks application for confidence)
- Troubleshooting Context (transitions to validation)

---

#### RemediationRolledBack

Raised when a parameter change is reverted due to failed validation.

```typescript
interface RemediationRolledBack {
  eventId: string;
  timestamp: DateTime;
  resolutionId: ResolutionId;
  cellId: CellId;
  originalChanges: ParameterChange[];
  rollbackReason: RollbackReason;
  kpiStatus: {
    metric: string;
    expected: number;
    actual: number;
  }[];
}

enum RollbackReason {
  KPI_DEGRADED = "KPI_DEGRADED",
  NO_IMPROVEMENT = "NO_IMPROVEMENT",
  NEW_ALARM_RAISED = "NEW_ALARM_RAISED",
  MANUAL_REQUEST = "MANUAL_REQUEST"
}
```

**Triggers:**
- Validation detects KPI worsening
- New alarms raised after change
- Human requests rollback

**Consumers:**
- API Gateway Context (reverts CM changes)
- Learning Context (decreases pattern confidence)

---

#### KPIValidated

Raised when KPI improvement is confirmed after remediation.

```typescript
interface KPIValidated {
  eventId: string;
  timestamp: DateTime;
  resolutionId: ResolutionId;
  cellId: CellId;
  validation: {
    success: boolean;
    waitDurationMinutes: number;
    baselineKPIs: Map<string, number>;
    postChangeKPIs: Map<string, number>;
    improvements: {
      metric: string;
      baseline: number;
      current: number;
      improvementPercent: number;
    }[];
  };
  thresholdMet: boolean;
  requiredImprovement: Percentage;
  actualImprovement: Percentage;
}
```

**Triggers:**
- Scheduled KPI check after wait period
- Manual validation trigger

**Consumers:**
- Learning Context (updates pattern confidence)
- Troubleshooting Context (completes resolution)

---

### Learning Context Events

#### PatternMatched

Raised when a symptom matches a known pattern via vector search.

```typescript
interface PatternMatched {
  eventId: string;
  timestamp: DateTime;
  resolutionId: ResolutionId;
  cellId: CellId;
  matchedPattern: {
    patternId: PatternId;
    name: string;
    similarityScore: number; // 0.0 - 1.0
    confidence: Confidence;
  };
  symptomVector: number[]; // Embedding
  alternativePatterns: {
    patternId: PatternId;
    similarityScore: number;
  }[];
}
```

**Triggers:**
- HNSW vector search finds match above threshold
- Threshold typically 0.70 for consideration

**Consumers:**
- Troubleshooting Context (uses pattern for diagnosis)
- Workflow Context (may auto-apply if high confidence)

---

#### PatternLearned

Raised when a new pattern is created from a successful resolution.

```typescript
interface PatternLearned {
  eventId: string;
  timestamp: DateTime;
  patternId: PatternId;
  sourceResolutionId: ResolutionId;
  pattern: {
    name: string;
    symptomDescription: string;
    rootCause: string;
    solution: Solution;
    initialConfidence: Confidence;
  };
  derivedFrom: {
    cellId: CellId;
    problemType: DegradationType;
    parameterChanges: ParameterChange[];
    kpiImprovement: Percentage;
  };
}
```

**Triggers:**
- Successful resolution with no matching pattern
- Resolution improves KPI significantly (>10%)

**Consumers:**
- Pattern Repository (stores new pattern)
- Notification service (alerts team of new learning)

---

#### PatternConfidenceUpdated

Raised when a pattern's confidence score changes.

```typescript
interface PatternConfidenceUpdated {
  eventId: string;
  timestamp: DateTime;
  patternId: PatternId;
  previousConfidence: Confidence;
  newConfidence: Confidence;
  updateReason: ConfidenceUpdateReason;
  applicationRecord: {
    resolutionId: ResolutionId;
    cellId: CellId;
    success: boolean;
    kpiImprovement?: Percentage;
  };
  totalApplications: number;
  successfulApplications: number;
}

enum ConfidenceUpdateReason {
  SUCCESSFUL_APPLICATION = "SUCCESSFUL_APPLICATION",
  FAILED_APPLICATION = "FAILED_APPLICATION",
  MANUAL_ADJUSTMENT = "MANUAL_ADJUSTMENT",
  DECAY_OVER_TIME = "DECAY_OVER_TIME"
}
```

**Triggers:**
- Pattern applied and validated
- Manual confidence adjustment
- Weekly consolidation decay

**Consumers:**
- Pattern Repository (updates stored confidence)
- Alerting (if confidence crosses threshold)

---

#### PatternArchived

Raised when a pattern is archived due to low confidence.

```typescript
interface PatternArchived {
  eventId: string;
  timestamp: DateTime;
  patternId: PatternId;
  patternName: string;
  finalConfidence: Confidence;
  archiveReason: ArchiveReason;
  totalApplications: number;
  successfulApplications: number;
  lastApplied: DateTime;
}

enum ArchiveReason {
  LOW_CONFIDENCE = "LOW_CONFIDENCE", // Below 50%
  SUPERSEDED = "SUPERSEDED", // Better pattern exists
  OBSOLETE = "OBSOLETE", // No longer applicable
  MANUAL = "MANUAL"
}
```

**Triggers:**
- Weekly consolidation identifies low performers
- New pattern supersedes old
- Manual archive by operator

**Consumers:**
- Pattern Repository (moves to archive)
- Reporting (tracks pattern lifecycle)

---

### Alarm Management Context Events

#### AlarmRaised

Raised when an alarm is detected from the network.

```typescript
interface AlarmRaised {
  eventId: string;
  timestamp: DateTime;
  alarmId: string;
  cellId?: CellId;
  nodeId: string;
  alarm: {
    alarmType: string;
    severity: AlarmSeverity;
    probableCause: string;
    specificProblem: string;
    additionalText: string;
  };
  category: AlarmCategory;
}

enum AlarmSeverity {
  CRITICAL = "CRITICAL",
  MAJOR = "MAJOR",
  MINOR = "MINOR",
  WARNING = "WARNING"
}

enum AlarmCategory {
  HARDWARE = "HARDWARE",
  SOFTWARE = "SOFTWARE",
  LICENSE = "LICENSE",
  EXTERNAL = "EXTERNAL"
}
```

**Triggers:**
- FM polling detects new alarm
- ENM pushes alarm notification

**Consumers:**
- Alarm Management Context (correlation)
- Troubleshooting Context (may trigger diagnosis)

---

#### AlarmCorrelated

Raised when related alarms are identified.

```typescript
interface AlarmCorrelated {
  eventId: string;
  timestamp: DateTime;
  correlationId: string;
  rootCauseAlarm: {
    alarmId: string;
    alarmType: string;
  };
  symptomAlarms: {
    alarmId: string;
    alarmType: string;
    relationship: string;
  }[];
  suppressedCount: number;
  correlationRule: string;
}
```

**Triggers:**
- Correlation engine identifies relationship
- Multiple alarms with same root cause

**Consumers:**
- Troubleshooting Context (uses root cause alarm)
- Notification (reduces alarm noise)

---

### Workflow Execution Context Events

#### WorkflowStarted

Raised when a remediation workflow begins execution.

```typescript
interface WorkflowStarted {
  eventId: string;
  timestamp: DateTime;
  workflowId: string;
  workflowName: string;
  resolutionId: ResolutionId;
  cellId: CellId;
  initiatedBy: AgentId;
  steps: {
    stepId: string;
    action: string;
    hasApprovalGate: boolean;
  }[];
}
```

---

#### ApprovalRequested

Raised when a workflow step requires human approval.

```typescript
interface ApprovalRequested {
  eventId: string;
  timestamp: DateTime;
  workflowId: string;
  stepId: string;
  resolutionId: ResolutionId;
  cellId: CellId;
  approvalDetails: {
    reason: string;
    confidence: Confidence;
    proposedChange: ParameterChange[];
    riskAssessment: string;
  };
  timeout: Duration;
  notifyChannels: string[];
}
```

**Triggers:**
- Confidence below auto-approval threshold (95%)
- High-impact parameter change
- First application of new pattern

**Consumers:**
- Notification service (alerts operators)
- Workflow engine (pauses until approved)

---

#### WorkflowCompleted

Raised when a workflow finishes all steps.

```typescript
interface WorkflowCompleted {
  eventId: string;
  timestamp: DateTime;
  workflowId: string;
  workflowName: string;
  resolutionId: ResolutionId;
  outcome: WorkflowOutcome;
  stepResults: {
    stepId: string;
    status: StepStatus;
    output?: any;
    error?: string;
  }[];
  totalDurationMs: number;
}

enum WorkflowOutcome {
  SUCCESS = "SUCCESS",
  FAILED = "FAILED",
  ROLLED_BACK = "ROLLED_BACK",
  CANCELLED = "CANCELLED"
}
```

---

## Event Flow Diagrams

### Successful Resolution Flow

```
CellDegradationDetected
         │
         ▼
    ┌─────────┐
    │ Analyze │
    └────┬────┘
         │
         ▼
   PatternMatched (if found)
         │
         ▼
  DiagnosisCompleted
         │
         ▼
   WorkflowStarted
         │
         ▼
  ApprovalRequested (if low confidence)
         │
         ▼
  RemediationApplied
         │
         ▼
   ┌───────────┐
   │ Wait 5min │
   └─────┬─────┘
         │
         ▼
    KPIValidated
         │
         ▼
 PatternConfidenceUpdated
         │
         ▼
  WorkflowCompleted
```

### Failed Resolution Flow

```
CellDegradationDetected
         │
         ▼
  DiagnosisCompleted
         │
         ▼
  RemediationApplied
         │
         ▼
   ┌───────────┐
   │ Wait 5min │
   └─────┬─────┘
         │
         ▼
  KPIValidated (success: false)
         │
         ▼
 RemediationRolledBack
         │
         ▼
 PatternConfidenceUpdated (decreased)
         │
         ▼
  WorkflowCompleted (ROLLED_BACK)
```

### New Pattern Learning Flow

```
  KPIValidated (success: true)
         │
         ▼
  ┌─────────────────────┐
  │ No matching pattern │
  │ & improvement > 10% │
  └──────────┬──────────┘
             │
             ▼
      PatternLearned
             │
             ▼
  ┌───────────────────┐
  │ Store in HNSW     │
  │ Initial conf: 50% │
  └───────────────────┘
```

---

## Event Handling Guidelines

### Idempotency

All event handlers must be idempotent. Events may be delivered multiple times.

### Ordering

Events should be processed in order within a single aggregate. Cross-aggregate event ordering is not guaranteed.

### Persistence

All domain events are persisted to enable:
- Event replay for debugging
- Audit trail for compliance
- Analytics on patterns

### Versioning

Events include schema version for backward compatibility:

```typescript
interface DomainEvent {
  eventId: string;
  timestamp: DateTime;
  version: string; // "1.0", "1.1", etc.
  // ... specific fields
}
```

---

## Event Storage

Events are stored in the Learning Agent's memory structure:

```
~/ran-agents/learning/
├── events/
│   ├── 2026-01-26/
│   │   ├── cell-degradation-detected/
│   │   ├── pattern-matched/
│   │   ├── remediation-applied/
│   │   └── kpi-validated/
│   └── ...
└── memory/
    └── 2026-01-26.md  # Daily summary
```

Events are also indexed in the vector database for semantic search.
