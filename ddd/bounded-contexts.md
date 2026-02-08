# Bounded Contexts - Clawdbot RAN Platform

## Overview

This document defines the bounded contexts within the Clawdbot RAN Platform. Each context represents a cohesive area of the domain with its own model, language, and responsibilities.

---

## Context Diagram

```
+------------------------------------------------------------------+
|                     CLAWDBOT RAN PLATFORM                        |
+------------------------------------------------------------------+
|                                                                  |
|  +------------------------+      +------------------------+      |
|  |   TROUBLESHOOTING      |      |   RANO OPTIMIZATION   |      |
|  |    CONTEXT [CORE]      |      |    CONTEXT [CORE]     |      |
|  |                        |      |                        |      |
|  | - Cell diagnosis       |      | - Intent decomposition |      |
|  | - Root cause analysis  |      | - Multi-agent consensus|      |
|  | - Remediation          |      | - Change proposals     |      |
|  | - Validation           |      | - Closed-loop learning |      |
|  +----------+-------------+      +----------+-------------+      |
|             |                               |                    |
|             v                               v                    |
|  +------------------------+      +------------------------+      |
|  |      LEARNING          |      |    WORKFLOW EXECUTION  |      |
|  |       CONTEXT          |<---->|       CONTEXT          |      |
|  |                        |      |                        |      |
|  | - Pattern storage      |      | - Pipeline orchestration|     |
|  | - Confidence tracking  |      | - Approval gates       |      |
|  | - Pattern consolidation|      | - Step sequencing      |      |
|  +------------------------+      +------------------------+      |
|             ^                             ^                      |
|             |                             |                      |
|  +------------------------+      +------------------------+      |
|  |    API GATEWAY         |      |   AGENT ORCHESTRATION  |      |
|  |       CONTEXT          |      |       CONTEXT          |      |
|  |                        |      |                        |      |
|  | - ENM authentication   |      | - Multi-agent routing  |      |
|  | - CM queries           |      | - Broadcast groups     |      |
|  | - PM queries           |      | - Session management   |      |
|  | - FM queries           |      |                        |      |
|  +------------------------+      +------------------------+      |
|             ^                             |                      |
|             |                             v                      |
|  +------------------------+      +------------------------+      |
|  |   ALARM MANAGEMENT     |      |  DASHBOARD MONITORING  |      |
|  |       CONTEXT          |      |       CONTEXT          |      |
|  |                        |      |                        |      |
|  | - Alarm correlation    |      | - Real-time visibility |      |
|  | - Root cause mapping   |      | - Agent health display |      |
|  | - Suppression rules    |      | - Drift detection UI   |      |
|  +------------------------+      +------------------------+      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 1. Troubleshooting Context (Core Domain)

### Description

The Troubleshooting Context is the **core domain** of the platform. It handles the diagnosis, remediation, and validation of RAN cell issues. This is where the primary business value is delivered.

### Responsibilities

- Receive and parse troubleshooting requests
- Analyze cell state and KPI data
- Identify root causes of degradation
- Match symptoms to known patterns
- Generate and apply remediation actions
- Validate KPI improvement post-remediation

### Key Aggregates

- **Cell Aggregate** - Represents a RAN cell with its state
- **Resolution Aggregate** - Manages the troubleshooting lifecycle

### Domain Events Published

- `CellDegradationDetected`
- `DiagnosisCompleted`
- `RemediationApplied`
- `RemediationRolledBack`
- `KPIValidated`

### Domain Events Consumed

- `PatternMatched` (from Learning Context)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Cell | The target of troubleshooting |
| Symptom | Observable KPI degradation |
| Root Cause | Underlying parameter/config issue |
| Remediation | Parameter change to fix issue |

### Agents

- Orchestrator Agent
- 4G LTE Specialist Agent
- 5G NR Specialist Agent
- RRM Agent
- Mobility Agent

### PRD Use Cases

- UC1: RAN Troubleshooting
- UC6: RAN Category Agents

---

## 2. Learning Context (Supporting Domain)

### Description

The Learning Context manages the capture, storage, and retrieval of troubleshooting patterns. It enables the system to improve over time by learning from successful resolutions.

### Responsibilities

- Store patterns from successful resolutions
- Calculate and update confidence scores
- Provide pattern matching via vector search
- Consolidate patterns weekly
- Archive low-success patterns

### Key Aggregates

- **Pattern Aggregate** - Encapsulates a learned troubleshooting pattern

### Domain Events Published

- `PatternLearned`
- `PatternConfidenceUpdated`
- `PatternArchived`
- `PatternMatched`

### Domain Events Consumed

- `KPIValidated` (from Troubleshooting Context)
- `RemediationApplied` (from Troubleshooting Context)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Pattern | Symptom-solution template |
| Confidence | Success probability |
| Similarity | Vector distance metric |
| Consolidation | Weekly pattern merging |

### Agents

- Learning Agent
- Pattern Learner

### Data Structures

```
~/ran-agents/learning/
├── MEMORY.md                    # Curated learned patterns
├── memory/                      # Daily resolution logs
│   └── YYYY-MM-DD.md
├── patterns/                    # Pattern knowledge
│   ├── rach-failures.md
│   ├── handover-drops.md
│   └── alarm-correlations.md
└── solutions/
    ├── high-confidence/         # >85% success
    ├── medium-confidence/       # 70-85% success
    └── experimental/            # <70% success
```

### PRD Use Cases

- UC4: Self-Learning Closed Loop
- UC10: Pattern Learning

---

## 3. API Gateway Context (Supporting Domain)

### Description

The API Gateway Context provides a unified interface for accessing external systems, primarily ENM (Ericsson Network Manager). It handles authentication, query execution, and data transformation.

### Responsibilities

- Authenticate with ENM
- Execute CM (Configuration Management) queries
- Execute PM (Performance Management) queries
- Execute FM (Fault Management) queries
- Transform raw data into domain objects
- Parse Ericsson documentation (ELEX)

### Key Aggregates

- **ENM Session** - Manages authentication state

### Domain Events Published

- `CMDataRetrieved`
- `PMDataRetrieved`
- `FMDataRetrieved`
- `ParameterChangeApplied`

### Domain Events Consumed

- `RemediationApplied` (triggers CM write)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Query | ENM REST API call |
| Counter | PM metric value |
| Snapshot | Point-in-time CM state |
| Token | Authentication credential |

### Agents

- ENM API Gateway Agent
- Fast Lookup Agent (for simple queries)

### API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `/enm-nbi/cm/v1/data/...` | Configuration read/write |
| `/enm-nbi/pm/v1/counters` | Performance counters |
| `/enm-nbi/fm/v1/alarms` | Fault alarms |

### PRD Use Cases

- UC2: Documentation Reading
- UC7: API Access Agents
- UC9: Operational Guides

---

## 4. Alarm Management Context (Supporting Domain)

### Description

The Alarm Management Context handles the analysis, correlation, and processing of network alarms. It identifies root cause alarms and suppresses duplicates.

### Responsibilities

- Fetch and categorize alarms
- Correlate related alarms
- Identify root cause vs. symptom alarms
- Apply suppression rules
- Track alarm history

### Key Aggregates

- **Alarm Aggregate** - Represents an active alarm
- **Correlation Rule** - Defines alarm relationships

### Domain Events Published

- `AlarmRaised`
- `AlarmCleared`
- `AlarmCorrelated`
- `RootCauseIdentified`

### Domain Events Consumed

- `CellDegradationDetected` (triggers alarm check)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Root Cause Alarm | Primary fault |
| Symptom Alarm | Secondary effect |
| Correlation | Linked alarms |
| Suppression | Hiding duplicate alarms |

### Agents

- Alarm Agent
- Alarm Analyst

### Alarm Categories

- Hardware Alarms
- Software Alarms
- License Alarms
- External Alarms

### PRD Use Cases

- UC8: Logs and Alarms

---

## 5. Workflow Execution Context (Generic Domain)

### Description

The Workflow Execution Context manages multi-step remediation pipelines using the Lobster workflow engine. It handles step sequencing, conditional execution, and approval gates.

### Responsibilities

- Parse and execute workflow definitions
- Manage workflow state
- Handle approval gates
- Execute conditional steps
- Coordinate with other contexts

### Key Aggregates

- **Workflow Instance** - Running workflow with state
- **Workflow Step** - Individual action in pipeline

### Domain Events Published

- `WorkflowStarted`
- `StepCompleted`
- `ApprovalRequested`
- `ApprovalGranted`
- `WorkflowCompleted`

### Domain Events Consumed

- `DiagnosisCompleted` (triggers remediation workflow)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Workflow | Multi-step pipeline |
| Step | Single action |
| Approval Gate | Human checkpoint |
| Condition | Step guard |

### Workflows

```yaml
workflows/
├── cell-remediation.yaml       # Main remediation flow
├── alarm-resolution.yaml       # Alarm-based flow
├── parameter-tuning.yaml       # Optimization flow
└── rollback.yaml               # Reversion flow
```

### PRD Use Cases

- UC1: RAN Troubleshooting (remediation phase)
- UC4: Self-Learning (learning step)

---

## 6. Agent Orchestration Context (Generic Domain)

### Description

The Agent Orchestration Context manages the multi-agent swarm, including routing, broadcast groups, sessions, and inter-agent communication.

### Responsibilities

- Route requests to appropriate agents
- Manage broadcast groups for parallel analysis
- Handle session lifecycle
- Coordinate subagent spawning
- Manage agent workspaces

### Key Aggregates

- **Agent Aggregate** - Represents a configured agent
- **Session** - Active interaction context

### Domain Events Published

- `AgentSpawned`
- `SessionStarted`
- `SessionEnded`
- `MessageRouted`
- `BroadcastSent`

### Domain Events Consumed

- (External user requests)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Agent | AI worker instance |
| Workspace | Agent file context |
| Session | Interaction lifecycle |
| Broadcast | Parallel message delivery |

### Configuration

```json
{
  "agents": {
    "list": [
      { "id": "orchestrator", "model": "claude-opus-4-5" },
      { "id": "4g-lte-agent", "model": "qwen2.5-coder:32b" },
      // ...
    ]
  },
  "broadcast": {
    "ran-troubleshooting": [
      "4g-lte-agent",
      "5g-nr-agent",
      "rrm-agent"
    ]
  }
}
```

### PRD Use Cases

- UC3: Context Engineering
- UC5: Multi-Agent Orchestration
- UC6: RAN Category Agents

---

## 7. Dashboard Monitoring Context (Supporting Domain)

### Description

The Dashboard Monitoring Context provides real-time visibility into agent and swarm health. It consumes events from Agent Orchestration and Troubleshooting contexts and presents aggregated views for operators.

**Full Documentation**: See [dashboard-bounded-context.md](./dashboard-bounded-context.md)

### Responsibilities

- Aggregate agent status from AgentMonitor events
- Calculate swarm health summaries (healthy/degraded/critical counts)
- Maintain rolling metrics windows (60-second sparklines)
- Buffer event logs with configurable retention (500 entries)
- Provide keyboard-navigable interface for agent inspection
- Emit alerts when thresholds are breached

### Key Aggregates

- **Dashboard Aggregate** - The running dashboard instance with configuration
- **DataProvider Aggregate** - Event aggregator with state management
- **Widget Collection** - UI component lifecycle management

### Domain Events Published

- `DashboardStarted`
- `AgentSelected`
- `AlertTriggered`
- `DashboardStopped`

### Domain Events Consumed

- `AgentSpawned` (from Agent Orchestration)
- `AgentStatusChanged` (from Agent Orchestration)
- `SwarmHealthUpdated` (from Agent Orchestration)
- `MetricsUpdated` (from Agent Orchestration)
- `CellDegradationDetected` (from Troubleshooting)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Dashboard | The terminal monitoring application |
| Widget | A UI component displaying specific data |
| Health | Aggregate status of agent availability |
| Drift | Deviation score indicating agent divergence |

### Agents (Consumers)

- DashboardApp (blessed screen manager)
- DataProvider (event aggregator)

### PRD Use Cases

- UC11: Real-Time Monitoring

---

## 8. RANO Optimization Context (Core Domain)

### Description

The RANO Optimization Context is a **core domain** that provides intent-based network optimization through a DSPy GEPA pipeline. Unlike the Troubleshooting Context which is reactive (responding to detected degradation), RANO is proactive: operators submit natural language intents describing desired outcomes, and the system produces multi-agent coordinated parameter change proposals with full closed-loop learning.

**Full Documentation**: See [context-rano.md](./context-rano.md)

### Responsibilities

- Decompose natural language intents into structured optimization objectives
- Retrieve evidence via vector search (30K patterns) and knowledge graph traversal
- Dispatch domain-specialized agents to generate parameter change proposals
- Resolve conflicts through 4-layer consensus (KPI-weighted voting, domain priority, Pareto optimization, LLM arbitration)
- Generate three ranked change proposal variants (conservative/moderate/aggressive) with cmedit commands
- Manage human approval gates for change execution
- Evaluate KPI outcomes and compute multi-objective reward signals
- Update pattern confidence via EMA and Bayesian updates with tiered promotion
- Record full optimization trajectories for learning and replay

### Key Aggregates

- **Intent Aggregate** - Decomposed optimization intent with KPI targets and scope
- **ChangeProposal Aggregate** - Three ranked variants with commands and rollback plans
- **Trajectory Aggregate** - Full lifecycle record from intent through evaluation
- **Consensus Aggregate** - Multi-agent voting and conflict resolution

### Domain Events Published

- `IntentSubmitted`
- `IntentDecomposed`
- `EvidenceRetrieved`
- `AgentProposalCreated`
- `ConflictDetected`
- `ConsensusReached`
- `ChangeProposalGenerated`
- `HumanApprovalRequested`
- `ChangeApproved`
- `ChangeRejected`
- `KPIMeasured`
- `RewardComputed`
- `ConfidenceUpdated`
- `TrajectoryCompleted`
- `LearningBroadcast`

### Domain Events Consumed

- `PatternMatched` (from Learning Context)
- `PatternConfidenceUpdated` (from Learning Context)
- `CMDataRetrieved` (from API Gateway Context)
- `PMDataRetrieved` (from API Gateway Context)

### Language

| Term | Meaning in This Context |
|------|------------------------|
| Intent | Natural language optimization request |
| Variant | One of three ranked proposals (conservative/moderate/aggressive) |
| Consensus | 4-layer conflict resolution across agent proposals |
| Trajectory | Full lifecycle record of an optimization run |
| Confidence Tier | Pattern reliability level (candidate/validated/proven/expert) |

### Agents

- Mobility Agent
- RRM Agent
- Load Balance Agent
- Admission Agent

### PRD Use Cases

- UC12: Intent-Based Optimization

---

## Context Ownership

| Context | Owner | Deployment |
|---------|-------|------------|
| Troubleshooting | RAN Operations Team | Core Service |
| RANO Optimization | RAN Operations Team | Optimizer Service |
| Learning | AI Platform Team | Learning Service |
| API Gateway | Integration Team | Gateway Service |
| Alarm Management | NOC Team | Alarm Service |
| Workflow Execution | Automation Team | Workflow Engine |
| Agent Orchestration | Platform Team | Clawdbot Gateway |
| Dashboard Monitoring | Platform Team | Terminal Dashboard |

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
- **Severity Levels** - Critical/Major/Minor/Warning
- **Pattern Confidence** - Shared between Learning and RANO contexts (EMA/Bayesian updates)
- **MO Path** - Managed Object path format (e.g., ENodeBFunction=1,EUtranCellFDD=Cell1)
- **Agent Namespace** - Scoped pattern namespace per agent domain (e.g., mobility-patterns)
