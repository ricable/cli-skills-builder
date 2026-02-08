# RANO Optimization Context (Core Domain)

## Overview

The RANO (RAN Optimization) Context is a **core domain** context that provides intent-based network optimization through a DSPy GEPA pipeline. It decomposes natural language optimization intents into multi-agent coordinated parameter change proposals, with a closed-loop learning system that improves over time.

RANO bridges the gap between the platform's existing knowledge assets (30K patterns, 384D embeddings, 13K parameters, 7.8K counters, 5K cross-refs, 3.4K KPIs) and actionable network changes, producing Pareto-optimal change proposals that go through human approval before network execution.

---

## Description

RANO is an intent-based optimization engine using a 7-module pipeline: Goal, Evidence, Plan, Consensus, Action, Evaluate, Adapt. The pipeline uses a hybrid LLM strategy: Ollama (glm-4.7-flash) for agent reasoning and intent decomposition, and Claude Opus 4.6 for consensus arbitration. Each optimization run produces three ranked change proposal variants (conservative, moderate, aggressive) with full cmedit/AMOS script generation and rollback plans.

---

## Responsibilities

- Receive and decompose natural language optimization intents into structured objectives
- Retrieve relevant evidence via vector search (30K patterns) and knowledge graph traversal
- Dispatch domain-specialized agents to generate per-agent parameter change proposals
- Resolve conflicts across agent proposals through 4-layer consensus (KPI-weighted voting, domain priority hierarchy, Pareto optimization, LLM arbitration)
- Generate three ranked change proposal variants with dependency-ordered cmedit commands
- Manage human approval gates for change execution
- Evaluate KPI outcomes post-change and compute multi-objective reward signals
- Update pattern confidence via EMA and Bayesian updates with tiered promotion
- Record full optimization trajectories for learning and replay

---

## Key Aggregates

- **Intent Aggregate** - Represents a decomposed optimization intent with KPI targets, scope, and domain assignments
- **ChangeProposal Aggregate** - Manages a set of three ranked variants (conservative/moderate/aggressive) with parameter changes, cmedit commands, and rollback plans
- **Trajectory Aggregate** - Captures the full lifecycle from intent submission through evaluation and learning
- **Consensus Aggregate** - Manages multi-agent voting, conflict resolution, and Pareto front computation

See [rano-aggregates.md](./rano-aggregates.md) for detailed aggregate definitions.

---

## Domain Events Published

| Event | Description |
|-------|-------------|
| `IntentSubmitted` | User submits an optimization intent |
| `IntentDecomposed` | Goal module decomposes intent into structured objectives |
| `EvidenceRetrieved` | Evidence module completes vector search and KG traversal |
| `AgentProposalCreated` | Individual agent generates parameter change proposal |
| `ConflictDetected` | Multiple agents propose conflicting parameter values |
| `ConsensusReached` | 4-layer consensus produces merged change set |
| `ChangeProposalGenerated` | Action module produces variant with cmedit commands |
| `HumanApprovalRequested` | Change proposal awaits operator approval |
| `ChangeApproved` | Operator approves a change proposal variant |
| `ChangeRejected` | Operator rejects a change proposal |
| `KPIMeasured` | Post-change KPI measurements collected |
| `RewardComputed` | Multi-objective reward signal calculated |
| `ConfidenceUpdated` | Pattern confidence updated via EMA/Bayesian update |
| `TrajectoryCompleted` | Full optimization lifecycle recorded |
| `LearningBroadcast` | Learnings shared across agent namespaces |

See [rano-domain-events.md](./rano-domain-events.md) for detailed event interfaces.

---

## Domain Events Consumed

| Event | Source Context | Description |
|-------|---------------|-------------|
| `PatternMatched` | Learning Context | Pattern confidence data for KPI-weighted voting |
| `PatternConfidenceUpdated` | Learning Context | Updated confidence scores for agent accuracy |
| `CMDataRetrieved` | API Gateway Context | Configuration management data for baseline state |
| `PMDataRetrieved` | API Gateway Context | Performance management counters for KPI evaluation |

---

## Language

| Term | Meaning in This Context |
|------|------------------------|
| Intent | Natural language optimization request (e.g., "Improve handover success rate") |
| GEPA Pipeline | DSPy Genetic-Pareto optimizer pipeline with RAN-specific signatures |
| Goal Module | Decomposes intent into KPI targets, domains, and scope |
| Evidence Module | Retrieves patterns and knowledge graph context (no LLM) |
| Plan Module | Dispatches domain agents to generate parameter change proposals |
| Consensus Module | 4-layer conflict resolution across agent proposals |
| Action Module | Generates dependency-ordered cmedit commands and rollback plans |
| Evaluate Module | Measures KPI deltas and computes multi-objective reward |
| Adapt Module | Updates pattern confidence and records trajectories |
| Variant | One of three ranked proposals: conservative, moderate, or aggressive |
| Pareto Front | Set of non-dominated solutions across multiple KPI objectives |
| Domain Priority Hierarchy | Ordered priority for conflict resolution (safety > coverage > capacity > throughput > efficiency) |
| Confidence Tier | Promotion level: candidate (0.5-0.7), validated (0.7-0.85), proven (0.85-0.95), expert (0.95+) |
| Trajectory | Full lifecycle record of an optimization run from intent through evaluation |
| Activation Planner | Component that orders changes by dependency graph and generates scripts |

See [rano-ubiquitous-language.md](./rano-ubiquitous-language.md) for the complete glossary.

---

## Agents

| Agent | Domain | YAML Config | Namespace |
|-------|--------|-------------|-----------|
| Mobility Agent | Handover and cell reselection | `agents/mobility-agent.yaml` | `mobility-patterns` |
| RRM Agent | Radio Resource Management | `agents/rrm-agent.yaml` | `rrm-patterns` |
| Load Balance Agent | Inter-frequency load balancing | `agents/loadbalance-agent.yaml` | `loadbalance-patterns` |
| Admission Agent | Admission control | `agents/admission-agent.yaml` | `admission-patterns` |

MVP scope includes Mobility Agent and RRM Agent. Phase 2 expands to all domain agents.

---

## Module Breakdown

```
Intent: "Improve intra-frequency handover success rate"
         |
         v
+----------------------+
|  GOAL Module (DSPy)  | --> Decompose intent into KPI targets + domains + scope
|  Ollama local LLM    |
+----------+-----------+
           v
+----------------------+
|  EVIDENCE Module     | --> Vector search (30K patterns) + knowledge graph traversal
|  No LLM (retrieval)  | --> Cross-ref expansion: params->features->counters->KPIs
+----------+-----------+
           v
+--------------------------------------+
|  PLAN Module (per-agent proposals)   |
|  mobility-agent -> A3 offset, TTT    |
|  rrm-agent     -> PRB allocation     |
|  Ollama local LLM per agent          |
+----------+---------------------------+
           v
+--------------------------------------+
|  CONSENSUS (4-layer resolution)      |
|  1. KPI-weighted voting              |
|  2. Domain priority hierarchy        |
|  3. Pareto optimization              |
|  4. LLM-arbitrated (Claude Opus 4.6) |
|  -> 3 variants: conservative/moderate/aggressive |
+----------+---------------------------+
           v
+--------------------------------------+
|  ACTION Module                       |
|  Activation planner (dep ordering)   |
|  cmedit/AMOS script generation       |
|  JSON + Markdown output              |
|  Human approval gate                 |
+----------+---------------------------+
           v
+--------------------------------------+
|  EVALUATE Module                     |
|  KPI delta (configurable window)     |
|  Auto reward + human override        |
+----------+---------------------------+
           v
+--------------------------------------+
|  ADAPT Module                        |
|  EMA + Bayesian + tiered promotion   |
|  Update pattern confidence           |
|  Record trajectory in memory.db      |
+--------------------------------------+
```

---

## Relationship to Other Contexts

### Consumes From

| Context | Relationship | Data |
|---------|-------------|------|
| Learning Context | Shared Kernel | Pattern confidence scores, historical success rates |
| API Gateway Context | Customer-Supplier | CM data (baseline parameters), PM data (KPI counters) |
| Agent Orchestration | Partnership | Agent dispatch, broadcast routing |

### Produces For

| Context | Relationship | Data |
|---------|-------------|------|
| Workflow Execution | Customer-Supplier | Change proposals, cmedit commands, rollback plans |
| Learning Context | Shared Kernel | Updated pattern confidence, trajectory records, learning broadcasts |

---

## Consensus Resolution Layers

| Layer | Mechanism | Description |
|-------|-----------|-------------|
| 1 | KPI-Weighted Voting | Weight = agent historical success_count / applied_count |
| 2 | Domain Priority Hierarchy | Default: safety > coverage > capacity > throughput > efficiency |
| 3 | Pareto Optimization | Multi-objective optimization via scipy for conflicting parameters |
| 4 | LLM Arbitration | Claude Opus 4.6 with few-shot consensus prompt for final resolution |

---

## Delivery Phases

| Phase | Scope | Status |
|-------|-------|--------|
| MVP (Phase 1) | 2 intents (Mobility HO success + RRM PRB congestion), full pipeline | Planned |
| Phase 2 | Add remaining 6 domains, what-if alternatives | Planned |
| Phase 3 | GEPA training, optimized DSPy signatures | Planned |
| Phase 4 | Batch campaigns, V2 features | Planned |

---

## File Structure

```
.claude/skills/elex-ran-features/optimizer/
├── __init__.py                    # Package init, version
├── models.py                      # Pydantic domain models (~300 lines)
├── signatures.py                  # DSPy Signatures for GEPA modules (~250 lines)
├── modules/
│   ├── __init__.py
│   ├── goal.py                    # Goal module: intent -> objectives (~200 lines)
│   ├── evidence.py                # Evidence module: vector search + KG (~350 lines)
│   ├── plan.py                    # Plan module: per-agent proposals (~300 lines)
│   ├── consensus.py               # 4-layer consensus resolution (~400 lines)
│   ├── action.py                  # Activation planner + script gen (~350 lines)
│   ├── evaluate.py                # KPI measurement + reward (~200 lines)
│   └── adapt.py                   # Learning loop + confidence updates (~250 lines)
├── retrieval.py                   # Vector search + KG traversal engine (~300 lines)
├── agent_wrapper.py               # Shared DSPy module for specialist agents (~200 lines)
├── intent_catalog.py              # Intent catalog management (~200 lines)
├── db.py                          # Database operations (memory.db) (~250 lines)
├── cli.py                         # Rich CLI entry point (~300 lines)
├── config.py                      # Configuration + constants (~100 lines)
├── pipeline.py                    # End-to-end GEPA pipeline orchestration (~250 lines)
├── intents/
│   ├── catalog.json               # 8-10 seed intents with templates
│   └── mobility_templates.json    # MVP: mobility intent templates
├── prompts/
│   └── consensus_prompt.txt       # Few-shot consensus prompt for Opus 4.6
└── tests/
    ├── test_models.py
    ├── test_goal.py
    ├── test_evidence.py
    ├── test_consensus.py
    └── test_pipeline.py
```

---

## PRD Use Cases

- UC12: Intent-Based Optimization
