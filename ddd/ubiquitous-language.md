# Ubiquitous Language - Clawdbot RAN Platform

## Overview

This glossary defines the shared vocabulary used across the Clawdbot RAN Platform. All stakeholders (engineers, operators, AI agents) must use these terms consistently to ensure clear communication.

---

## RAN Domain Terms

### Cell

A geographic coverage area served by a radio transmitter. In this platform, cells are identified by unique IDs (e.g., `NR_Cell_123`, `LTE_Cell_456`).

**Properties:**
- Cell ID (unique identifier)
- Technology (LTE/NR)
- Cell Radius (coverage distance in km)
- Operational State (active/blocked/degraded)

### ENodeB / gNodeB

- **ENodeB**: LTE base station serving 4G cells
- **gNodeB**: NR base station serving 5G cells

### RACH (Random Access Channel)

The channel used by UEs (User Equipment) to initiate connection with a cell. RACH failures indicate access problems.

**Key Metrics:**
- `pmRachPreambleAtt` - RACH preamble attempts
- `pmRachPreambleSucc` - Successful RACH preambles
- `RACH_SUCCESS_RATE` - Derived success percentage

### Handover

The process of transferring an active UE connection from one cell to another.

**Types:**
- **Intra-frequency** - Between cells on the same frequency
- **Inter-frequency** - Between cells on different frequencies
- **Inter-RAT** - Between different technologies (LTE to NR)

**Key Metrics:**
- `pmHoExeSucc` - Successful handover executions
- `HO_FAIL_RATE` - Handover failure percentage

### KPI (Key Performance Indicator)

Quantitative measure of cell or network performance.

**Common KPIs:**
- RACH Success Rate
- Handover Success Rate
- Throughput (UL/DL)
- Latency
- Drop Rate

### Alarm

A notification generated when a network element detects an abnormal condition.

**Categories:**
- **Hardware Alarms** - Physical component failures
- **Software Alarms** - Application or configuration issues
- **License Alarms** - Licensing problems
- **External Alarms** - Environmental or power issues

**Severity Levels:**
- Critical
- Major
- Minor
- Warning

### Parameter

A configurable value that affects cell behavior.

**Examples:**
- `prachConfigIndex` - PRACH configuration (affects RACH timing)
- `rsrpThreshold` - Reference Signal Received Power threshold
- `a3Offset` - Handover measurement offset

### MO (Managed Object)

A logical entity in the network management system representing a configurable element.

**Examples:**
- `EUtranCellFDD` - LTE FDD cell
- `NRCellDU` - NR cell (Distributed Unit)
- `ENodeBFunction` - eNodeB function container

### ENM (Ericsson Network Manager)

The network management platform providing CM/PM/FM interfaces.

**Interfaces:**
- **CM (Configuration Management)** - Read/write parameters
- **PM (Performance Management)** - Read KPI counters
- **FM (Fault Management)** - Read/acknowledge alarms

---

## Agent Terms

### Orchestrator

The central coordinating agent that receives user requests, dispatches tasks to specialists, and synthesizes results.

**Responsibilities:**
- Parse user intent
- Route to appropriate specialists
- Coordinate parallel data retrieval
- Present unified response

### Specialist Agent

A domain-expert agent focused on a specific RAN category.

**Types:**
- **4G LTE Agent** - LTE feature expertise
- **5G NR Agent** - NR feature expertise
- **RRM Agent** - Radio Resource Management
- **Mobility Agent** - Handover and cell reselection
- **Load Balance Agent** - Inter-frequency load balancing
- **Admission Agent** - Admission control

### Learning Agent

An agent responsible for capturing successful patterns and updating confidence scores.

**Responsibilities:**
- Extract resolution data from sessions
- Store patterns with metadata
- Calculate and update confidence
- Consolidate weekly learnings

### API Gateway Agent

An agent that interfaces with external systems (ENM) to retrieve data.

**Responsibilities:**
- Authenticate with ENM
- Execute CM/PM/FM queries
- Parse and return structured data

### Alarm Agent

An agent specialized in alarm analysis and correlation.

**Responsibilities:**
- Fetch active alarms
- Correlate related alarms
- Identify root cause alarms
- Suppress duplicate notifications

### Workspace

The isolated file system and context for an agent.

**Contents:**
- `AGENTS.md` - Operating instructions
- `SOUL.md` - Persona and boundaries
- `MEMORY.md` - Learned patterns
- `memory/` - Daily logs
- `skills/` - Agent-specific skills

### Session

An interaction context between a user and one or more agents.

**Properties:**
- Session ID
- Transcript history
- Active subagents
- Memory state

### Subagent

A background agent spawned to perform a parallel task.

**Example:** Orchestrator spawns subagents for PM, CM, and FM data retrieval simultaneously.

### Broadcast Group

A collection of agents that receive the same message simultaneously for parallel analysis.

**Example:** `ran-troubleshooting` group includes 4G, 5G, RRM, Mobility, and Alarm agents.

---

## Pattern Terms

### Pattern

A reusable troubleshooting template linking symptoms to solutions.

**Structure:**
- Pattern ID (e.g., `P-001`)
- Symptom description
- Root cause
- Solution steps
- Confidence score
- Application history

### Confidence

A percentage indicating the reliability of a pattern based on historical success rate.

**Calculation:**
```
Confidence = (Successful Applications / Total Applications) * 100
```

**Thresholds:**
- **High Confidence** (>85%): Auto-apply without approval
- **Medium Confidence** (70-85%): Apply with monitoring
- **Low Confidence** (<70%): Require human approval

### Resolution

The complete lifecycle of addressing a cell issue.

**Phases:**
1. Detection (problem identified)
2. Diagnosis (root cause analysis)
3. Remediation (solution applied)
4. Validation (KPI improvement confirmed)
5. Learning (pattern updated)

### Remediation

The action taken to resolve a detected problem.

**Types:**
- Parameter change (CM update)
- Software restart
- Hardware replacement recommendation
- Configuration rollback

### Diagnosis

The process of identifying the root cause of a symptom.

**Inputs:**
- KPI data (PM)
- Current parameters (CM)
- Active alarms (FM)
- Historical patterns

**Output:**
- Root cause identification
- Confidence level
- Recommended solution

### Validation

The verification step after remediation to confirm improvement.

**Process:**
1. Wait for KPI stabilization (typically 5 minutes)
2. Compare post-change KPIs to baseline
3. Determine if improvement meets threshold (e.g., >10%)

### Rollback

Reverting parameter changes if validation fails.

**Trigger:** KPI degradation after remediation

### Similarity Score

A measure (0.0 to 1.0) of how closely a current symptom matches a stored pattern.

**Calculation:** Vector similarity using HNSW (Hierarchical Navigable Small World) index.

---

## Workflow Terms

### Lobster Workflow

A multi-step deterministic pipeline with approval gates.

**Example:** `cell-remediation.yaml`

### Approval Gate

A conditional checkpoint requiring human confirmation before proceeding.

**Trigger:** Confidence below threshold (e.g., <95%)

### LLM Task

A structured AI call with JSON schema validation.

**Use:** Extracting parameters from documentation, generating diagnoses.

### Cron Job

A scheduled task running at specified intervals.

**Examples:**
- Daily network health scan (6 AM)
- Hourly alarm correlation
- Weekly pattern consolidation

### Hook

An event-driven automation triggered by system events.

**Types:**
- Session hooks (start/end)
- Command hooks (pre/post)
- Learning hooks (pattern capture)

---

## Integration Terms

### HNSW (Hierarchical Navigable Small World)

A vector index algorithm enabling fast similarity search for pattern matching.

**Performance:** 150x-12,500x faster than brute force search.

### Vector Search

Semantic search using embeddings to find similar patterns.

**Provider:** `nomic-embed-text` via Ollama

### RuVector

The intelligence system providing pattern matching and confidence tracking.

**Components:**
- HNSW index for fast search
- Confidence calculator
- Pattern consolidation

---

## Abbreviations

| Abbreviation | Full Form |
|--------------|-----------|
| RAN | Radio Access Network |
| LTE | Long Term Evolution (4G) |
| NR | New Radio (5G) |
| UE | User Equipment |
| KPI | Key Performance Indicator |
| CM | Configuration Management |
| PM | Performance Management |
| FM | Fault Management |
| ENM | Ericsson Network Manager |
| RACH | Random Access Channel |
| PRACH | Physical Random Access Channel |
| RRM | Radio Resource Management |
| HO | Handover |
| IFLB | Inter-Frequency Load Balancing |
| MLB | Mobility Load Balancing |
| MO | Managed Object |
| HNSW | Hierarchical Navigable Small World |
| ELEX | Ericsson Library Explorer (documentation system) |
