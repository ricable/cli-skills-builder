# RANO Ubiquitous Language - Intent-Based RAN Optimization

## Overview

This glossary defines the shared vocabulary specific to the RANO Optimization Context. These terms extend the platform-wide ubiquitous language defined in [ubiquitous-language.md](./ubiquitous-language.md) and must be used consistently across all RANO modules, documentation, and agent interactions.

---

## Pipeline Terms

### Intent

A natural language optimization request submitted by an operator. Intents describe a desired network outcome without specifying implementation details.

**Examples:**
- "Improve intra-frequency handover success rate"
- "Reduce DL PRB congestion during busy hour"

**Properties:**
- Intent ID (unique identifier)
- Intent text (natural language)
- Category (mobility, rrm, coverage, capacity, etc.)
- Scope (cell, cluster, site)

### GEPA Pipeline

The DSPy Genetic-Pareto optimizer pipeline adapted with RAN-specific signatures. GEPA provides multi-objective optimization across competing KPI targets. In RANO, the pipeline has 7 modules: Goal, Evidence, Plan, Consensus, Action, Evaluate, Adapt.

### Goal Module

The first pipeline module. Decomposes a natural language intent into structured objectives: KPI targets with direction and weight, relevant agent domains, network scope, and sub-objectives. Uses DSPy GoalSignature with Ollama (glm-4.7-flash) as the LLM backend.

**Inputs:** Intent text, RAN vocabulary context
**Outputs:** KPI targets, relevant domains, scope, decomposed objectives

### Evidence Module

The second pipeline module. Performs pure retrieval (no LLM) across the platform's 30K patterns and knowledge graph. Executes vector search using 384D embeddings (all-MiniLM-L6-v2), then expands results through knowledge graph cross-references: parameters to features, features to counters, features to KPIs, features to dependencies.

**Inputs:** Decomposed objectives, relevant namespaces
**Outputs:** Structured evidence context per agent domain

### Plan Module

The third pipeline module. Dispatches domain-specialized agents to generate parameter change proposals. Each agent is instantiated via RANAgentModule (a shared DSPy module parameterized by agent YAML config). Agents run in parallel via asyncio, each using Ollama via PlanSignature.

**Inputs:** Objectives, evidence context, playbook context
**Outputs:** List of AgentProposal objects

### Consensus Module

The fourth pipeline module. Resolves conflicts between agent proposals through a deterministic 4-layer process. Produces a merged change set that balances competing objectives.

**Layers:**
1. KPI-weighted voting
2. Domain priority hierarchy
3. Pareto optimization
4. LLM arbitration (Claude Opus 4.6)

**Inputs:** All agent proposals, priority hierarchy, historical examples
**Outputs:** Merged change set, conflict resolution explanations

### Action Module

The fifth pipeline module. Transforms the merged change set into executable cmedit commands with dependency ordering and rollback plans. Produces three variants (conservative, moderate, aggressive) and presents them for human approval.

**Inputs:** Merged change set, dependency graph
**Outputs:** Three ChangeProposal variants with cmedit/AMOS scripts

### Evaluate Module

The sixth pipeline module. Measures KPI deltas after changes are applied and computes a multi-objective reward signal. Supports configurable evaluation windows (15min, 30min, 1hr, 2hr) and human reward override.

**Inputs:** KPI snapshots before and after change, intent targets
**Outputs:** Reward signal (0.0-1.0), assessment, lessons learned

### Adapt Module

The seventh pipeline module. Updates pattern confidence based on the reward signal using dual update methods (EMA and Bayesian). Manages tiered confidence promotion/demotion. Records the complete trajectory and broadcasts learnings across agent namespaces.

**Inputs:** Reward signal, trajectory data
**Outputs:** Updated confidence scores, trajectory record, learning broadcast

---

## Proposal Terms

### Variant

One of three ranked change proposal alternatives produced by the Consensus and Action modules. Each variant represents a different risk-reward tradeoff.

| Variant | Characteristics |
|---------|----------------|
| Conservative | Minimal changes, lowest risk, smallest expected improvement |
| Moderate | Balanced changes, medium risk, moderate expected improvement |
| Aggressive | Maximum changes, highest risk, largest expected improvement |

### Pareto Front

The set of non-dominated solutions across multiple KPI objectives. A solution is non-dominated (Pareto-optimal) if no other solution improves one KPI without degrading another. Computed via scipy.optimize during Layer 3 of consensus.

### KPI-Weighted Voting

Layer 1 of the consensus process. Each agent's proposal is weighted by the agent's historical accuracy (success_count / applied_count from the patterns table). A conflict is resolved when one agent's weighted confidence exceeds all others by more than 20%.

### Domain Priority Hierarchy

Layer 2 of the consensus process. A predefined ordering of domain importance used to break ties when KPI-weighted voting is inconclusive. Default hierarchy: safety > coverage > capacity > throughput > efficiency. Per-intent overrides are supported via the intent catalog.

### Agent Proposal

A per-agent set of parameter changes generated by the Plan module. Contains the proposed changes, KPI predictions, confidence score, and references to supporting patterns from memory.db.

**Properties:**
- Agent ID and namespace
- Parameter changes with MO paths
- KPI predictions
- Confidence score (0.0-1.0)
- Supporting pattern keys

---

## Confidence Terms

### Confidence Tier

A classification of pattern reliability based on accumulated evidence. Patterns are promoted after consecutive successes and demoted after consecutive failures.

| Tier | Confidence Range | Promotion Requirement | Demotion Trigger |
|------|-----------------|----------------------|-----------------|
| Candidate | 0.50 - 0.70 | 3 consecutive successes | N/A (archived below 0.50) |
| Validated | 0.70 - 0.85 | 3 consecutive successes | 2 consecutive failures |
| Proven | 0.85 - 0.95 | 3 consecutive successes | 2 consecutive failures |
| Expert | 0.95+ | Sustained performance | 2 consecutive failures |

### EMA Update

Exponential Moving Average confidence update method. Smooths confidence changes to prevent overreaction to individual results.

**Formula:** `new_confidence = alpha * reward + (1 - alpha) * old_confidence`

**Default alpha:** 0.1 (configurable via `EMA_ALPHA` in config.py)

### Bayesian Update

Beta distribution posterior update method. Uses success and failure counts to compute a posterior probability that is more statistically principled than simple ratios.

**Method:** Beta(alpha + successes, beta + failures) where alpha=1, beta=1 (uniform prior)

---

## Execution Terms

### Activation Planner

The component within the Action module that determines the correct order for applying parameter changes. It queries the dependency graph (dependencies-extended.json) to identify prerequisite features, conflicting features, and required activation sequences, then performs a topological sort.

### Dependency Ordering

The topological sort of parameter changes based on the feature dependency graph. Changes to prerequisite features must be applied before dependent features.

**Source:** `.claude/skills/elex-ran-features/references/dependencies-extended.json`

### Rollback Plan

A set of cmedit commands that reverse all proposed changes using the parameter values captured before optimization. Every ChangeProposal must include a complete rollback plan. Rollback commands are executed in reverse dependency order.

### cmedit Command

An ENM CLI command for modifying cell configuration parameters. Generated by the Action module from ParameterChange objects.

**Format:** `cmedit set <MO_path> <param>=<value>`

**Example:** `cmedit set ENodeBFunction=1,EUtranCellFDD=Cell1 a3offset=3`

### AMOS Script

An Advanced MO Scripting command set for bulk configuration changes across multiple cells. Generated by the Action module when the scope is "cluster" or "site".

### Human Approval Gate

The mandatory operator review step before any parameter changes are executed on the network. The operator can approve, reject, modify, or switch variants.

**Available Actions:**
- [A]pprove - Execute selected variant
- [R]eject - Cancel optimization
- [M]odify - Adjust specific parameter values
- [S]witch variant - Select a different variant

---

## Learning Terms

### Trajectory

A complete record of an optimization run from intent submission through evaluation and learning. Trajectories are stored in memory.db and serve as training data for future GEPA optimization.

**Lifecycle:** Intent -> Decompose -> Evidence -> Plan -> Consensus -> Action -> Approve -> Execute -> Evaluate -> Adapt

### Reward Signal

A multi-objective score (0.0-1.0) computed by the Evaluate module that measures the effectiveness of an applied change.

**Components:**

| Component | Weight | Description |
|-----------|--------|-------------|
| Target KPI improvement | 0.5 | How much the target KPIs improved |
| No-regression score | 0.3 | Absence of degradation on non-target KPIs |
| Complexity penalty | 0.2 | Inverse of change count (fewer changes = better) |

### Learning Broadcast

A mechanism for sharing learnings from one optimization run across multiple agent namespaces. When a pattern's confidence crosses a tier boundary or a significant lesson is identified, the Adapt module inserts a record into the shared_learnings table in memory.db.

### KPI Window

The configurable observation period after applying changes, during which KPI measurements are collected for evaluation. Different intents may require different observation windows.

| Window | Use Case |
|--------|----------|
| 15 minutes | Fast-changing metrics (e.g., RACH success rate) |
| 30 minutes | Medium-term metrics (e.g., PRB utilization) |
| 60 minutes | Standard metrics (e.g., handover success rate) |
| 120 minutes | Slow-changing metrics (e.g., daily averages) |

---

## Confidence Scale

RANO uses **0.0-1.0 float** for all confidence values internally. The platform shared kernel uses **0-100 integer percentage**. Conversion occurs at the context boundary in `db.py`:

| Direction | Conversion | Example |
|-----------|-----------|---------|
| RANO -> Platform | `int(confidence * 100)` | 0.85 -> 85 |
| Platform -> RANO | `confidence / 100.0` | 85 -> 0.85 |

All RANO modules, signatures, and aggregates use the 0.0-1.0 scale. The 0-100 scale only appears when crossing the RANO context boundary.

---

## Abbreviations

| Abbreviation | Full Form |
|--------------|-----------|
| RANO | RAN Optimization |
| GEPA | Genetic-Pareto (DSPy optimizer) |
| EMA | Exponential Moving Average |
| DSPy | Declarative Self-improving Python |
| PRB | Physical Resource Block |
| TTT | Time to Trigger |
| AMOS | Advanced MO Scripting |
| KG | Knowledge Graph |
