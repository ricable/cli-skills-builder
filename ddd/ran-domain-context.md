# RAN Domain Bounded Context

## Overview

The RAN Domain Context encapsulates all telecom-specific knowledge for Ericsson 4G LTE and 5G NR networks. It provides the domain model for cell troubleshooting and optimization.

**Key Discovery**: 9 RAN agents are **config-only** - YAML routing definitions, not separate processes.

---

## Context Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│                   RAN DOMAIN CONTEXT                        │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              9 Specialist Agents (YAML Config)         │ │
│  │                                                        │ │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐      │ │
│  │  │ 4G-LTE  │ │ 5G-NR   │ │  RRM    │ │Mobility │      │ │
│  │  │  Agent  │ │  Agent  │ │  Agent  │ │  Agent  │      │ │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘      │ │
│  │                                                        │ │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐      │ │
│  │  │LoadBal- │ │Admission│ │ Alarm   │ │Learning │      │ │
│  │  │  ance   │ │ Control │ │ Analyst │ │  Agent  │      │ │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘      │ │
│  │                                                        │ │
│  │  ┌─────────┐                                          │ │
│  │  │ENM API  │                                          │ │
│  │  │  Agent  │                                          │ │
│  │  └─────────┘                                          │ │
│  │                                                        │ │
│  │  Total: 7,102 lines of domain knowledge               │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              Domain Knowledge Base                     │ │
│  │                                                        │ │
│  │  - 593 Ericsson Features                              │ │
│  │  - 14 Categories                                      │ │
│  │  - 5,230+ Parameters                                  │ │
│  │  - 384D MiniLM Embeddings (HNSW indexed)              │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Domain Model

### Aggregates

#### 1. Cell Aggregate

**Root Entity**: `Cell`

```typescript
export interface Cell {
  id: CellId;
  technology: Technology;       // 'LTE' | 'NR'
  band: FrequencyBand;
  sector: Sector;
  parameters: CellParameters;
  kpis: CellKPIs;
  alarms: Alarm[];
  neighbors: NeighborRelation[];
  status: CellStatus;
}

export interface CellParameters {
  // Physical layer
  prachConfigIndex: number;
  rsrpThresholdSSS: number;
  a3OffsetEutran: number;

  // Power control
  p0NominalPusch: number;
  alpha: number;                // 0.3 - 1.0

  // Mobility
  qRxLevMin: number;
  cellReselectionPriority: number;
  tReselection: number;
}

export interface CellKPIs {
  sinrP10: number;
  sinrP50: number;
  sinrP90: number;
  prbUtilizationDL: number;
  prbUtilizationUL: number;
  hoSuccessRate: number;
  rrcSetupSuccessRate: number;
  erabDropRate: number;
}
```

**Invariants**:
- Alpha must be in [0.3, 1.0]
- SINR values must be in valid range (-20 to +40 dB)
- HO success rate must be in [0, 1]

#### 2. Feature Aggregate

**Root Entity**: `Feature`

```typescript
export interface Feature {
  id: FeatureId;                // e.g., 'FAJ_121_3094'
  name: string;
  description: string;
  category: FeatureCategory;
  parameters: ParameterDefinition[];
  prerequisites: FeatureId[];
  impacts: Impact[];
  embedding: number[];          // 384D vector
}

export type FeatureCategory =
  | 'PRACH'
  | 'PUSCH'
  | 'PUCCH'
  | 'PDSCH'
  | 'Carrier Aggregation'
  | 'Mobility'
  | 'Load Balancing'
  | 'Admission Control'
  | 'Power Control'
  | 'Interference Management'
  | 'Beam Management'
  | 'NSA/SA'
  | 'QoS'
  | 'Security';
```

#### 3. Alarm Aggregate

**Root Entity**: `Alarm`

```typescript
export interface Alarm {
  id: AlarmId;
  alarmType: AlarmType;
  perceivedSeverity: Severity;
  probableCause: string;
  specificProblem: string;
  affectedCell: CellId;
  raisedAt: Date;
  clearedAt?: Date;
  correlationGroup?: CorrelationGroupId;
  rootCause?: RootCause;
}

export type Severity = 'Critical' | 'Major' | 'Minor' | 'Warning';

export interface RootCause {
  category: RootCauseCategory;
  description: string;
  recommendedActions: string[];
  relatedParameters: string[];
}
```

---

### Agent Definitions (YAML Config)

```yaml
# Example: 4G-LTE Agent Configuration
agent:
  id: 4g-lte-agent
  name: LTE Feature Specialist
  role: PRACH, PUSCH, PUCCH, PDSCH, Carrier Aggregation
  workspace: ~/ran-agents/4g-lte
  autonomy: 85%
  specializations:
    - prach_optimization
    - pusch_scheduling
    - carrier_aggregation
    - lte_mobility
  confidence_gate: 0.85
  tools:
    - enm_api
    - pattern_search
    - parameter_lookup
```

**9 Agent Definitions**:

| Agent ID | Domain | Autonomy | Primary Responsibility |
|----------|--------|----------|------------------------|
| `4g-lte-agent` | LTE | 85% | E-UTRAN, PRACH, PUCCH |
| `5g-nr-agent` | NR | 85% | SSB, beam management, NR cells |
| `rrm-agent` | RRM | 85% | Load balancing, admission control |
| `mobility-agent` | Mobility | 85% | Handover, ANR optimization |
| `loadbalance-agent` | LoadBalance | 80% | Traffic steering, capacity |
| `admission-agent` | Admission | 80% | Congestion, overload |
| `alarm-agent` | Alarms | 75% | Correlation, root cause |
| `learning-agent` | ML | 70% | Pattern discovery, confidence |
| `enm-api-agent` | Integration | 90% | ENM API, cmedit, scripting |

---

### Value Objects

```typescript
export class CellId {
  constructor(
    public readonly mcc: string,      // Mobile Country Code
    public readonly mnc: string,      // Mobile Network Code
    public readonly enbId: number,    // eNodeB ID
    public readonly cellId: number    // Cell ID within eNodeB
  ) {}

  get fdn(): string {
    // Fully Distinguished Name for ENM
    return `MeContext=${this.enbId},ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=${this.cellId}`;
  }

  equals(other: CellId): boolean {
    return this.fdn === other.fdn;
  }
}

export class FrequencyBand {
  constructor(
    public readonly bandNumber: number,  // e.g., 1, 3, 7, 28, 41, 77, 78
    public readonly technology: 'LTE' | 'NR',
    public readonly duplexMode: 'FDD' | 'TDD'
  ) {}

  get frequencyRange(): { min: number; max: number } {
    // Return frequency range in MHz based on 3GPP spec
    return BAND_FREQUENCIES[this.bandNumber];
  }
}
```

---

## Domain Services

### CellDiagnosisService

```typescript
export interface CellDiagnosisService {
  // Diagnose cell issues using specialist agents
  diagnose(cell: Cell): Promise<Diagnosis>;

  // Get recommendations from appropriate agents
  getRecommendations(diagnosis: Diagnosis): Promise<Recommendation[]>;

  // Route problem to specialist agent
  routeToSpecialist(problem: Problem): AgentId;
}

export class CellDiagnosisServiceImpl implements CellDiagnosisService {
  async diagnose(cell: Cell): Promise<Diagnosis> {
    // Broadcast to relevant specialists
    const agents = this.selectAgents(cell);

    const findings = await Promise.all(
      agents.map(agent => this.queryAgent(agent, cell))
    );

    return this.synthesize(findings);
  }

  private selectAgents(cell: Cell): AgentId[] {
    const agents: AgentId[] = [];

    if (cell.technology === 'LTE') {
      agents.push('4g-lte-agent');
    } else {
      agents.push('5g-nr-agent');
    }

    if (cell.kpis.hoSuccessRate < 0.95) {
      agents.push('mobility-agent');
    }

    if (cell.kpis.prbUtilizationDL > 0.8) {
      agents.push('loadbalance-agent');
    }

    if (cell.alarms.length > 0) {
      agents.push('alarm-agent');
    }

    return agents;
  }
}
```

### FeatureSearchService

```typescript
export interface FeatureSearchService {
  // Semantic search for features
  searchByQuery(query: string, limit: number): Promise<Feature[]>;

  // Find similar features
  findSimilar(featureId: FeatureId, limit: number): Promise<Feature[]>;

  // Get feature by ID
  getFeature(featureId: FeatureId): Promise<Feature | null>;

  // List features by category
  listByCategory(category: FeatureCategory): Promise<Feature[]>;
}
```

---

## Domain Events

| Event | Trigger | Consumers |
|-------|---------|-----------|
| `CellDiagnosed` | Diagnosis completed | Learning, Workflow |
| `AlarmRaised` | New alarm from ENM | Alarm Agent |
| `AlarmCleared` | Alarm cleared in ENM | Troubleshooting |
| `AlarmCorrelated` | Root cause identified | Troubleshooting |
| `ParameterChanged` | CM change applied | Learning, Monitoring |
| `KPIDegraded` | KPI drops below threshold | Rollback trigger |
| `KPIImproved` | KPI improves after change | Learning (positive) |
| `AgentConsensusReached` | Multiple agents agree | Workflow |

---

## Implementation Status

| Component | Location | Lines | Status |
|-----------|----------|-------|--------|
| Cell Model | `src/clawdbot/domain/cell.ts` | ~200 | ✅ Implemented |
| Feature Model | `src/clawdbot/domain/feature.ts` | ~150 | ✅ Implemented |
| Alarm Model | `src/clawdbot/domain/alarm.ts` | ~100 | ✅ Implemented |
| Agent Configs | `src/clawdbot/agents/*.yaml` | ~500 | ✅ 9 agents defined |
| Feature Store | `.claude/skills/elex-ran-features/` | 5,000+ | ✅ 593 features |
| Embeddings | `embeddings/*.json` | ~384K dims | ✅ HNSW indexed |
| Agent Tests | `tests/clawdbot/agents/` | 108 tests | ✅ All passing |

**Total**: ~7,102 lines of RAN domain knowledge

---

## Feature Knowledge Base

### Coverage

| Metric | Count |
|--------|-------|
| Total Features | 593 |
| Categories | 14 |
| Parameters | 5,230+ |
| Embeddings | 384D MiniLM |
| Search Latency | <5ms p50 |
| Recall | ~99% |

### Category Distribution

| Category | Features | % |
|----------|----------|---|
| Mobility | 89 | 15% |
| Load Balancing | 67 | 11% |
| PRACH | 54 | 9% |
| Power Control | 48 | 8% |
| Carrier Aggregation | 45 | 8% |
| QoS | 42 | 7% |
| Interference | 38 | 6% |
| Beam Management (NR) | 36 | 6% |
| Other | 174 | 30% |

---

## Confidence Gates (Self-Learning)

| Confidence | Gate | Behavior |
|------------|------|----------|
| 95-100% | 🟢 AUTO | Apply without human approval |
| 70-94% | 🟡 APPROVE | Requires human approval |
| <70% | 🔴 SIMULATE | Simulation only, no real apply |

**Agent Autonomy Levels**:
- 90%: ENM API Agent (well-defined operations)
- 85%: Technology specialists (4G, 5G, RRM, Mobility)
- 80%: Traffic management (LoadBalance, Admission)
- 75%: Alarm Agent (correlation has uncertainty)
- 70%: Learning Agent (experimental by nature)

---

## Integration Points

### Upstream (Provides Data To This Context)

- **ENM External System**: CM/PM/FM data
- **ELEX Documentation**: Feature definitions

### Downstream (Consumes Data From This Context)

- **Troubleshooting Context**: Cell diagnosis, recommendations
- **Optimization Context**: Cell context for GNN
- **Learning Context**: Troubleshooting outcomes

---

## References

- ADR-001: Multi-Agent Swarm Architecture
- ADR-032: RAN Agents Swarm
- `.claude/skills/elex-ran-features/` - Feature knowledge base
- `src/clawdbot/agents/` - Agent configurations
- 3GPP TS 36.xxx - LTE specifications
- 3GPP TS 38.xxx - NR specifications
