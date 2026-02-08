# Domain-Driven Design for Clawdbot RAN Platform

## Overview

This document outlines the Domain-Driven Design (DDD) approach for the Clawdbot AI Cognitive RAN Platform. The platform enables multi-agent swarm-based troubleshooting, self-learning closed-loop automation, and intelligent RAN operations management.

## Domain Overview

The RAN (Radio Access Network) troubleshooting domain encompasses the following core activities:

1. **Cell Degradation Diagnosis** - Identifying root causes of performance issues
2. **Pattern-Based Resolution** - Applying learned patterns to known problems
3. **Automated Remediation** - Executing parameter changes with confidence-based approval
4. **Continuous Learning** - Capturing successful resolutions for future use
5. **Multi-Agent Coordination** - Orchestrating specialized agents for parallel analysis

## Strategic Design

### Core Domains

The platform has two core domains where the primary business value is delivered:

- **Troubleshooting Context** - Reactive diagnosis, remediation, and validation of cell degradation issues
- **RANO Optimization Context** - Proactive intent-based network optimization through multi-agent consensus and closed-loop learning (DSPy GEPA pipeline)

### Supporting Domains

- **Learning Context** - EWC++ (Rust, 1,512 lines), SONA (TypeScript, 629 lines), A3C actor-critic, Thompson sampling bandits, trajectory replay buffer with priority sampling
- **Optimization Context** - GNN (Rust, layer.rs 790 lines), Heuristic optimizer (4,387 lines), 4-tier confidence gates (95%/85%/70%/<70%)
- **Data Infrastructure Context** - Graph builder with delta updates (TOP_P, O(k) incremental), HNSW (Rust 966 lines, 150x-12,500x speedup), ENM API client with OAuth2/circuit breaker/connection pooling
- **RAN Domain Context** - 9 specialist agents, 593 features, 5,230+ parameters, Byzantine consensus (2/3)
- **Observability Context** - Prometheus metrics endpoint, multi-tier caching (L1/L2/L3), mock ENM server for testing

### Generic Domains

- **Workflow Execution Context** - Orchestrates multi-step remediation pipelines
- **Agent Orchestration** - Coordinates multi-agent communication
- **API Gateway Context** - Anti-corruption layer for ENM data (CM/PM/FM)

## Tactical Design

### Aggregates

The domain model is organized around the following aggregates:

1. **Cell Aggregate** - Represents a RAN cell with its state, parameters, and KPIs
2. **Pattern Aggregate** - Encapsulates learned troubleshooting patterns
3. **Resolution Aggregate** - Manages the lifecycle of a troubleshooting resolution
4. **Agent Aggregate** - Represents an AI agent with its workspace and capabilities
5. **GNN Model Aggregate** - Rust-native neural network for parameter prediction (layer.rs: 790 lines)
6. **Heuristic Optimizer Aggregate** - Rule-based baseline with ALPHA_LOOKUP_TABLE (heuristic.rs: 4,387 lines)
7. **HNSW Index Aggregate** - Vector similarity search (Rust: 966 lines, 150x-12,500x speedup)
8. **EWC Regularizer Aggregate** - Elastic Weight Consolidation for online learning (ewc.rs: 1,512 lines)
9. **Network Graph Aggregate** - TOP_P neighbor selection with 24D/10D features (fppc_data.rs: 3,088 lines)

### Domain Events

Key domain events drive the system behavior:

- `CellDegradationDetected` - Triggers troubleshooting workflow
- `PatternMatched` - Indicates a known pattern applies
- `RemediationApplied` - Records parameter changes
- `KPIValidated` - Confirms resolution success
- `PatternLearned` - Updates pattern knowledge base

## Document Structure

| Document | Purpose |
|----------|---------|
| [Ubiquitous Language](./ubiquitous-language.md) | Domain glossary and terminology |
| [Bounded Contexts](./bounded-contexts.md) | Context boundaries and responsibilities |
| [Aggregates](./aggregates.md) | Core aggregate definitions |
| [Domain Events](./domain-events.md) | Event catalog and flows |
| [Context Map](./context-map.md) | Integration patterns between contexts |
| [Optimization Context](./optimization-context.md) | GNN, Heuristic optimizer, Confidence gates |
| [Data Infrastructure Context](./data-infrastructure-context.md) | Graph builder, HNSW, ENM API |
| [Learning Context](./learning-context.md) | EWC++, SONA, A3C, Confidence tracking |
| [RAN Domain Context](./ran-domain-context.md) | 9 specialist agents, 593 features |
| [Dashboard Context](./dashboard-bounded-context.md) | Terminal monitoring UI |
| [RANO Optimization Context](./context-rano.md) | Intent-based RAN optimization (GEPA pipeline) |
| [RANO Domain Events](./rano-domain-events.md) | RANO event catalog and flows |
| [RANO Aggregates](./rano-aggregates.md) | RANO aggregate definitions |
| [RANO Ubiquitous Language](./rano-ubiquitous-language.md) | RANO domain glossary |

## Alignment with PRD Use Cases

| Use Case | DDD Context |
|----------|-------------|
| UC1: RAN Troubleshooting | Troubleshooting Context |
| UC2: Documentation Reading | API Gateway Context |
| UC3: Context Engineering | Agent Orchestration |
| UC4: Self-Learning Closed Loop | Learning Context |
| UC5: Multi-Agent Orchestration | Agent Orchestration |
| UC6: RAN Category Agents | Troubleshooting Context |
| UC7: API Access Agents | API Gateway Context |
| UC8: Logs and Alarms | Alarm Management Context |
| UC9: Operational Guides | API Gateway Context |
| UC10: Pattern Learning | Learning Context |
| UC11: Real-Time Monitoring | Dashboard Monitoring Context |
| UC12: Intent-Based Optimization | RANO Optimization Context |

## Design Principles

### 1. Explicit Boundaries

Each bounded context has clear ownership and responsibilities. Contexts communicate through well-defined integration patterns (events, APIs).

### 2. Rich Domain Model

Domain logic resides within aggregates, not in services or controllers. Aggregates enforce invariants and emit domain events.

### 3. Event-Driven Architecture

Domain events enable loose coupling between contexts. The Learning Context subscribes to resolution events to capture patterns.

### 4. Confidence-Based Decision Making

The domain model explicitly tracks confidence levels for patterns, enabling automated decisions above thresholds and human approval below.

### 5. Agent Isolation

Each specialized agent operates within its workspace, with clear boundaries between responsibilities (4G LTE vs. 5G NR vs. RRM).

## Implementation Notes

The DDD model maps to the Clawdbot architecture as follows:

- **Aggregates** map to agent workspaces and memory structures
- **Domain Events** map to Clawdbot hooks and inter-agent messages
- **Bounded Contexts** map to agent groups and broadcast configurations
- **Integration Patterns** map to `agent_send`, `sessions_spawn`, and Lobster workflows

## References

- PRD: `clawdbot-swarm-prd.md`
- Clawdbot Documentation: https://docs.clawd.bot/

## RAN Knowledge Base Integration

- Dual source of truth: `docs/ran` and `.claude/skills/elex-ran-features/references`.
- Fast indexes live in `docs/ran/index` and RuVector embeddings in `docs/ran/embeddings`.
- Clawdbot patterns and RAN swarm agents consume these assets for self-learning.
