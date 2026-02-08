# Context Map - Clawdbot RAN Platform

## Overview

This document describes the relationships and integration patterns between bounded contexts in the Clawdbot RAN Platform.

---

## Context Map Diagram

```
+------------------------------------------------------------------+
|                     CLAWDBOT RAN PLATFORM                        |
+------------------------------------------------------------------+

                      UPSTREAM
                         |
    +--------------------+--------------------+
    |                    |                    |
    v                    v                    v
+--------+         +----------+         +----------+
|  ENM   |         |  ELEX    |         |  Users   |
| (OHS)  |         |  (OHS)   |         |  (OHS)   |
+--------+         +----------+         +----------+
    |                    |                    |
    v                    v                    v
+------------------------------------------------------------------+
|                                                                  |
|   +-------------------+        +-------------------+             |
|   |    API GATEWAY    |        |      AGENT        |             |
|   |     CONTEXT       |        |   ORCHESTRATION   |             |
|   |                   |        |     CONTEXT       |             |
|   |  [ACL: ENM]       |        |                   |             |
|   |  [ACL: ELEX]      |        |  [ACL: User]      |             |
|   +--------+----------+        +--------+----------+             |
|            |                            |                        |
|            |    +---------------+       |                        |
|            |    |               |       |                        |
|            +--->| TROUBLESHOOT- |<------+                        |
|            |    |  ING CONTEXT  |       |                        |
|            |    |   [CORE]      |       |                        |
|            |    +-------+-------+       |                        |
|            |            |               |                        |
|            |    +-------+-------+       |                        |
|            |    |               |       |                        |
|            +--->|    RANO       |<------+                        |
|                 | OPTIMIZATION  |                                |
|            +--->|   [CORE]      +---+                            |
|            |    +-------+-------+   |                            |
|            |            |           |                            |
|   +--------+--------+  |  +--------v--------+                   |
|   |     ALARM       |  |  |    WORKFLOW     |                   |
|   |   MANAGEMENT    |  |  |    EXECUTION    |                   |
|   |    CONTEXT      |  |  |     CONTEXT     |                   |
|   |                 |  |  |                 |                   |
|   |  [Conformist]   |  |  |  [Conformist]   |                   |
|   +-----------------+  |  +-----------------+                   |
|                        v                                        |
|                +---------------+                                |
|                |    LEARNING   |                                |
|                |    CONTEXT    |                                |
|                |               |                                |
|                | [Shared       |                                |
|                |  Kernel]      |                                |
|                +---------------+                                |
|                                                                  |
+------------------------------------------------------------------+

LEGEND:
  --->  Upstream/Downstream relationship
  [ACL] Anti-Corruption Layer
  [OHS] Open Host Service
```

---

## Relationship Types

### 1. Troubleshooting <-> API Gateway

**Relationship Type:** Customer/Supplier

**Direction:** Troubleshooting (Customer) <- API Gateway (Supplier)

**Description:**
The Troubleshooting Context depends on the API Gateway Context to retrieve cell data (CM, PM, FM). The API Gateway provides data in a format suitable for troubleshooting.

**Integration Pattern:** Synchronous Request/Response

```typescript
// Troubleshooting Context requests data
interface CellDataRequest {
  cellId: CellId;
  dataTypes: ("CM" | "PM" | "FM")[];
  timeRange?: { start: DateTime; end: DateTime };
}

// API Gateway returns structured response
interface CellDataResponse {
  cellId: CellId;
  cm: CellParameters;
  pm: CellKPIs;
  fm: Alarm[];
  retrievedAt: DateTime;
}
```

**Anti-Corruption Layer:**
The API Gateway transforms ENM's raw REST responses into domain objects, shielding the Troubleshooting Context from ENM's data model.

```
ENM REST Response          API Gateway ACL           Domain Object
─────────────────          ───────────────           ─────────────
{                          CellParameters {          cell.parameters
  "attributes": {            prachConfigIndex: 3,
    "prachConfigIndex": 3,   rsrpThreshold: -130,
    "rsrpThresholdSSS": -130 ...
  }                        }
}
```

---

### 2. Troubleshooting <-> Learning

**Relationship Type:** Customer/Supplier (bidirectional)

**Direction:** Bidirectional data flow

**Description:**
- Troubleshooting requests pattern matches from Learning
- Learning receives resolution outcomes from Troubleshooting

**Integration Pattern:** Domain Events + Request/Response

```
Troubleshooting → Learning:
  - PatternSearchRequest (sync)
  - KPIValidated event (async)
  - RemediationApplied event (async)

Learning → Troubleshooting:
  - PatternMatched event (async)
  - PatternSearchResponse (sync)
```

**Shared Kernel:**
- CellId value object
- Confidence value object
- ParameterChange structure

---

### 3. Troubleshooting <-> Alarm Management

**Relationship Type:** Conformist

**Direction:** Troubleshooting <- Alarm Management

**Description:**
The Troubleshooting Context conforms to the Alarm Management Context's model for alarm data. When analyzing a cell issue, Troubleshooting accepts the alarm correlation results as-is.

**Integration Pattern:** Domain Events

```
Alarm Management → Troubleshooting:
  - AlarmRaised event
  - AlarmCorrelated event
  - RootCauseIdentified event
```

**Why Conformist:**
Alarm correlation logic is well-established in the Alarm Management Context. Troubleshooting benefits from accepting this model rather than reimplementing correlation.

---

### 4. Troubleshooting <-> Workflow Execution

**Relationship Type:** Conformist

**Direction:** Troubleshooting <- Workflow Execution

**Description:**
The Troubleshooting Context initiates workflows but conforms to the Workflow Execution Context's step model and execution semantics.

**Integration Pattern:** Domain Events + Command

```
Troubleshooting → Workflow Execution:
  - StartWorkflowCommand (cell-remediation.yaml)

Workflow Execution → Troubleshooting:
  - WorkflowStarted event
  - ApprovalRequested event
  - WorkflowCompleted event
```

---

### 5. API Gateway <-> ENM (External)

**Relationship Type:** Open Host Service (ENM is OHS)

**Direction:** API Gateway <- ENM

**Description:**
ENM provides a well-documented REST API (Open Host Service) for CM/PM/FM operations. The API Gateway Context consumes this API and translates responses.

**Integration Pattern:** REST API

**Anti-Corruption Layer:**
```typescript
// ENM ACL transforms external to internal model
class EnmAntiCorruptionLayer {
  translateCellParameters(enmResponse: EnmCmResponse): CellParameters {
    return new CellParameters({
      prachConfigIndex: enmResponse.attributes.prachConfigIndex,
      rsrpThreshold: enmResponse.attributes.rsrpThresholdSSS,
      a3Offset: enmResponse.attributes.a3OffsetEutran,
      cellRadius: this.calculateRadius(enmResponse.attributes)
    });
  }

  translateAlarm(enmAlarm: EnmFmAlarm): Alarm {
    return new Alarm({
      alarmId: enmAlarm.alarmId,
      severity: this.mapSeverity(enmAlarm.perceivedSeverity),
      category: this.categorize(enmAlarm.alarmType),
      probableCause: enmAlarm.probableCause
    });
  }
}
```

---

### 6. API Gateway <-> ELEX Documentation (External)

**Relationship Type:** Open Host Service (ELEX is OHS)

**Direction:** API Gateway <- ELEX

**Description:**
ELEX provides Ericsson documentation in structured format. The API Gateway Context parses this for feature descriptions, parameter catalogs, and alarm resolution guides.

**Integration Pattern:** Document Parsing

```typescript
// ELEX ACL extracts structured data from documentation
class ElexAntiCorruptionLayer {
  parseFeatureDocument(elexDoc: ElexDocument): Feature {
    return this.llmTask({
      prompt: "Extract feature parameters from this document",
      input: elexDoc.content,
      schema: FeatureSchema
    });
  }
}
```

---

### 7. Agent Orchestration <-> Users (External)

**Relationship Type:** Open Host Service (Platform provides OHS)

**Direction:** Agent Orchestration <- Users

**Description:**
Users interact with the platform through various channels (WhatsApp, Telegram, Slack). The Agent Orchestration Context provides a unified interface.

**Integration Pattern:** Message Gateway

**Anti-Corruption Layer:**
```typescript
// User message ACL normalizes channel-specific formats
class UserMessageAcl {
  normalize(channelMessage: ChannelMessage): TroubleshootingRequest {
    return {
      cellId: this.extractCellId(channelMessage.text),
      problemDescription: channelMessage.text,
      userId: channelMessage.sender,
      channel: channelMessage.channel,
      priority: this.inferPriority(channelMessage)
    };
  }
}
```

---

### 8. RANO Optimization <-> Learning

**Relationship Type:** Shared Kernel

**Direction:** Bidirectional data flow

**Description:**
RANO and Learning share pattern confidence as a core concept. RANO reads pattern confidence scores for KPI-weighted voting in the consensus process. After evaluation, RANO updates pattern confidence via EMA and Bayesian methods and writes results back to the shared patterns table.

**Integration Pattern:** Shared Database (memory.db) + Domain Events

```
RANO -> Learning:
  - ConfidenceUpdated event (async)
  - LearningBroadcast event (async)
  - Direct DB writes to patterns, pattern_history, shared_learnings tables

Learning -> RANO:
  - PatternMatched event (async)
  - PatternConfidenceUpdated event (async)
  - Pattern confidence data via vector search
```

**Shared Kernel:**
- Pattern Confidence Score (float 0.0-1.0)
- Confidence Tier (candidate/validated/proven/expert)
- Pattern ID format
- Agent Namespace conventions
- memory.db schema (patterns, pattern_history, shared_learnings tables)

---

### 9. RANO Optimization -> API Gateway

**Relationship Type:** Customer/Supplier

**Direction:** RANO (Customer) <- API Gateway (Supplier)

**Description:**
RANO depends on the API Gateway Context to retrieve baseline CM data (current parameter values) and PM data (current KPI counters) for the Evidence and Evaluate modules. The API Gateway provides data in a format suitable for optimization.

**Integration Pattern:** Synchronous Request/Response

```typescript
// RANO requests baseline data for optimization
interface OptimizationDataRequest {
  scope: "cell" | "cluster" | "site";
  cellIds?: string[];
  parameters: string[];    // Parameter names to retrieve current values
  counters: string[];      // KPI counter names to retrieve
  timeRange?: { start: DateTime; end: DateTime };
}

// API Gateway returns structured response
interface OptimizationDataResponse {
  cells: {
    cellId: string;
    parameters: Map<string, any>;
    kpis: Map<string, number>;
  }[];
  retrievedAt: DateTime;
}
```

**Anti-Corruption Layer:**
The API Gateway transforms ENM responses into RANO domain objects (ManagedObject, KPITarget), shielding the optimization pipeline from ENM data model details.

---

### 10. RANO Optimization -> Workflow Execution

**Relationship Type:** Customer/Supplier

**Direction:** RANO (Customer) -> Workflow Execution (Supplier)

**Description:**
RANO produces approved ChangeProposal variants with cmedit commands that are executed by the Workflow Execution Context. RANO supplies the commands and rollback plan; Workflow Execution manages the step sequencing, execution, and rollback if needed.

**Integration Pattern:** Command + Domain Events

```
RANO -> Workflow Execution:
  - ExecuteChangeProposalCommand (cmedit commands, rollback commands)

Workflow Execution -> RANO:
  - WorkflowStarted event
  - StepCompleted event
  - WorkflowCompleted event (triggers RANO Evaluate module)
```

---

### 11. RANO Optimization <-> Agent Orchestration

**Relationship Type:** Partnership

**Direction:** Bidirectional (tight collaboration)

**Description:**
RANO and Agent Orchestration work as partners. RANO requests that specific domain agents (mobility-agent, rrm-agent, etc.) be dispatched for the Plan module. Agent Orchestration manages the agent lifecycle, broadcast groups, and parallel execution. Both contexts evolve together as new agent types are added.

**Integration Pattern:** Command + Callback

```
RANO -> Agent Orchestration:
  - DispatchAgentsCommand (agent IDs, objectives, context)

Agent Orchestration -> RANO:
  - AgentProposal results (per-agent change proposals)
  - Agent availability and health status
```

**Why Partnership:**
Adding a new domain agent (e.g., coverage-agent) requires coordinated changes in both contexts: RANO must register the new domain in its intent catalog, and Agent Orchestration must configure the new agent's workspace and broadcast group membership.

---

## Integration Patterns

### Event-Driven Integration

Most cross-context communication uses domain events for loose coupling:

```
┌──────────────────┐     Event Bus     ┌──────────────────┐
│   Publisher      │    ─────────►    │   Subscriber     │
│   Context        │                   │   Context        │
└──────────────────┘                   └──────────────────┘

Events flow through:
- Clawdbot hooks (internal event handlers)
- Memory system (event persistence)
- Agent messages (inter-agent communication)
```

### Synchronous Request/Response

For immediate data needs:

```
┌──────────────────┐                   ┌──────────────────┐
│   Troubleshooting│    ◄─────────►   │   API Gateway    │
│   Context        │   getCellData()   │   Context        │
└──────────────────┘                   └──────────────────┘
```

### Saga Pattern (Workflow)

For multi-step operations across contexts:

```
Troubleshooting         Workflow           API Gateway        Learning
     │                    │                    │                 │
     │ StartWorkflow      │                    │                 │
     │───────────────────►│                    │                 │
     │                    │                    │                 │
     │                    │ FetchCellState     │                 │
     │                    │───────────────────►│                 │
     │                    │◄───────────────────│                 │
     │                    │                    │                 │
     │                    │ ApplyChange        │                 │
     │                    │───────────────────►│                 │
     │                    │◄───────────────────│                 │
     │                    │                    │                 │
     │                    │ RecordOutcome      │                 │
     │                    │────────────────────────────────────►│
     │                    │                    │                 │
     │ WorkflowCompleted  │                    │                 │
     │◄───────────────────│                    │                 │
```

---

## Data Flow Summary

### Troubleshooting Request Flow

```
User Request
     |
     v
Agent Orchestration (normalize, route)
     |
     v
Troubleshooting (diagnose)
     |
     +---> API Gateway (fetch CM/PM/FM) ---> ENM
     |
     +---> Learning (pattern search) ---> HNSW
     |
     +---> Alarm Management (correlate alarms)
     |
     v
Troubleshooting (remediation decision)
     |
     v
Workflow Execution (execute steps)
     |
     +---> API Gateway (apply change) ---> ENM
     |
     +---> Troubleshooting (validate KPIs)
     |
     v
Learning (store pattern, update confidence)
     |
     v
Agent Orchestration (respond to user)
```

### RANO Optimization Flow

```
Operator Intent (natural language)
     |
     v
RANO: Goal Module (decompose intent)
     |
     v
RANO: Evidence Module (vector search + KG traversal)
     |
     +---> Learning (pattern search, 30K patterns)
     |
     +---> API Gateway (fetch baseline CM/PM)
     |
     v
RANO: Plan Module (dispatch agents)
     |
     +---> Agent Orchestration (spawn mobility-agent, rrm-agent, ...)
     |
     v
RANO: Consensus Module (4-layer conflict resolution)
     |
     v
RANO: Action Module (3 variants + cmedit commands)
     |
     v
Human Approval Gate
     |
     v
Workflow Execution (execute cmedit commands)
     |
     +---> API Gateway (apply CM changes) ---> ENM
     |
     v
RANO: Evaluate Module (KPI delta + reward)
     |
     +---> API Gateway (fetch post-change PM)
     |
     v
RANO: Adapt Module (confidence update + trajectory)
     |
     +---> Learning (update patterns, broadcast learnings)
     |
     v
Trajectory recorded in memory.db
```

---

## Conflict Resolution

### Ownership Conflicts

| Data | Owner | Consumers |
|------|-------|-----------|
| Cell Parameters | API Gateway | Troubleshooting, Learning, RANO |
| Patterns | Learning | Troubleshooting, RANO |
| Pattern Confidence | Learning + RANO (shared kernel) | Troubleshooting, RANO |
| Alarms | Alarm Management | Troubleshooting |
| Workflows | Workflow Execution | Troubleshooting, RANO |
| Agent State | Agent Orchestration | All contexts |
| Intents | RANO | - |
| Change Proposals | RANO | Workflow Execution |
| Trajectories | RANO | Learning, Dashboard |
| Consensus Votes | RANO | Learning |

### Version Conflicts

When multiple contexts modify related data:

1. **Cell Parameters**: API Gateway is source of truth (from ENM)
2. **Pattern Confidence**: Shared kernel between Learning and RANO; both may update via different mechanisms (Learning uses success rate, RANO uses EMA/Bayesian)
3. **Resolution State**: Troubleshooting owns the aggregate
4. **Trajectory State**: RANO owns the trajectory aggregate; Learning reads for replay

---

## Team Boundaries

| Context | Team | Responsibilities |
|---------|------|------------------|
| Troubleshooting | RAN Operations Team | Core diagnosis logic |
| RANO Optimization | RAN Operations Team | Intent-based optimization pipeline |
| Learning | AI Platform Team | Pattern management |
| API Gateway | Integration Team | ENM/ELEX interfaces |
| Alarm Management | NOC Team | Alarm correlation |
| Workflow Execution | Automation Team | Pipeline engine |
| Agent Orchestration | Platform Team | Multi-agent infrastructure |

---

## Anti-Corruption Layers

### ENM to API Gateway

The API Gateway Context translates ENM's raw REST responses into domain-friendly objects:

```
ENM Response (JSON) --> API Gateway ACL --> Domain Object (Cell, Counter, Alarm)
```

### External Models to Learning Context

The Learning Context normalizes different AI model outputs into consistent pattern formats:

```
Claude/Qwen/Llama Output --> Learning ACL --> Pattern Object
```

---

## Shared Kernel

The following concepts are shared across contexts and maintained as a shared kernel:

- **Cell ID** - Unique cell identifier format
- **Confidence Score** - Percentage (0-100) or float (0.0-1.0)
- **KPI Names** - Standard counter names (e.g., pmHoExeSucc, pmPrbUtilDl)
- **Parameter Names** - Standard MO attribute names (e.g., a3offset, dlPrbLoadThreshold)
- **MO Path** - Managed Object path format (e.g., ENodeBFunction=1,EUtranCellFDD=Cell1)
- **Severity Levels** - Critical/Major/Minor/Warning
- **Pattern Confidence** - Shared between Learning and RANO (both read and write)
- **Agent Namespace** - Scoped pattern namespace per agent domain (e.g., mobility-patterns)
- **Confidence Tier** - Tiered reliability classification (candidate/validated/proven/expert)
