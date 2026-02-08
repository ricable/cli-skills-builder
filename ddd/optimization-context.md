# Optimization Bounded Context

## Overview

The Optimization Context is responsible for generating parameter recommendations for RAN cells. It encapsulates both ML-based (GNN) and rule-based (heuristic) optimization strategies.

**Key Discovery**: GNN is implemented in **Rust** (not Python) as an architectural decision for performance.

---

## Context Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│                  OPTIMIZATION CONTEXT                       │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   GNN Model  │    │  Heuristic   │    │  Confidence  │  │
│  │   (Rust)     │    │  Optimizer   │    │    Gates     │  │
│  │              │    │              │    │              │  │
│  │ layer.rs     │    │ heuristic.rs │    │ confidence-  │  │
│  │ training.rs  │    │ 4,387 lines  │    │ gate-wf.ts   │  │
│  │ 2,164 lines  │    │              │    │ 426 lines    │  │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘  │
│         │                   │                   │          │
│         └───────────────────┴───────────────────┘          │
│                             │                              │
│                     ┌───────▼───────┐                      │
│                     │ Recommendation│                      │
│                     │   Aggregate   │                      │
│                     └───────────────┘                      │
└─────────────────────────────────────────────────────────────┘
```

---

## Domain Model

### Aggregates

#### 1. GNN Model Aggregate

**Root Entity**: `GNNModel`

```rust
// Conceptual model from src/layer.rs
pub struct GNNModel {
    id: ModelId,
    layers: Vec<RuvectorLayer>,
    attention: MultiHeadAttention,  // 8 heads
    gru: GRUCell,
    norm: LayerNorm,
    version: ModelVersion,
    trained_at: DateTime,
}

pub struct RuvectorLayer {
    linear: Linear,
    attention_weights: Tensor,
    dropout_rate: f32,
}
```

**Invariants**:
- Model must have at least 2 layers
- Attention heads must be power of 2
- Input dimension must match graph node features (24D)

#### 2. Heuristic Optimizer Aggregate

**Root Entity**: `HeuristicOptimizer`

```rust
// Conceptual model from src/heuristic.rs
pub struct HeuristicOptimizer {
    config: HeuristicConfig,
    lookup_table: AlphaLookupTable,  // 350 buckets, 0.1dB resolution
}

pub struct HeuristicConfig {
    sinr_target_p10: f32,       // -3.0 dB
    sinr_target_p50: f32,       // 5.0 dB
    hysteresis_db: f32,         // 3.0 dB
    alpha_min: f32,             // 0.3
    alpha_max: f32,             // 1.0
}

pub struct AlphaLookupTable {
    buckets: HashMap<SINRBucket, AlphaValue>,  // 350 entries
}
```

**Invariants**:
- Alpha values must be within [alpha_min, alpha_max]
- SINR targets must be physically valid (-20dB to +40dB)
- Lookup table must cover full SINR range

#### 3. Recommendation Aggregate

**Root Entity**: `Recommendation`

```rust
pub struct Recommendation {
    id: RecommendationId,
    cell_id: CellId,
    source: RecommendationSource,  // GNN | Heuristic
    parameters: Vec<ParameterChange>,
    confidence: Confidence,
    rationale: String,
    created_at: DateTime,
    status: RecommendationStatus,
}

pub struct ParameterChange {
    parameter_name: String,  // e.g., "alpha", "p0"
    current_value: f32,
    recommended_value: f32,
    delta: f32,
}

pub enum RecommendationStatus {
    Pending,
    Approved,
    Applied,
    Rejected,
    RolledBack,
}
```

---

### Value Objects

```rust
pub struct Confidence(f32);  // 0.0 - 1.0

impl Confidence {
    pub fn gate(&self) -> ConfidenceGate {
        match self.0 {
            c if c >= 0.95 => ConfidenceGate::Auto,
            c if c >= 0.85 => ConfidenceGate::FastTrack,
            c if c >= 0.70 => ConfidenceGate::Approve,
            _ => ConfidenceGate::Simulate,
        }
    }
}

pub struct AlphaValue(f32);  // 0.3 - 1.0
pub struct P0Value(f32);     // -10 to +23 dBm
pub struct SINRBucket(i32);  // -100 to +250 (0.1dB resolution)
```

---

## Domain Services

### RecommendationService

```rust
pub trait RecommendationService {
    /// Generate recommendation for a cell
    fn recommend(&self, context: &CellContext) -> Result<Recommendation, Error>;

    /// Validate recommendation against safety bounds
    fn validate(&self, rec: &Recommendation) -> ValidationResult;

    /// Apply recommendation (via ENM API)
    fn apply(&self, rec: &Recommendation) -> Result<ApplyResult, Error>;
}
```

### FallbackStrategy

```rust
impl RecommendationService for OptimizationContext {
    fn recommend(&self, context: &CellContext) -> Result<Recommendation, Error> {
        // Try GNN first
        let gnn_result = self.gnn_model.predict(context);

        if gnn_result.confidence >= 0.70 {
            Ok(Recommendation::from_gnn(gnn_result))
        } else {
            // Fallback to heuristic
            let alpha = self.heuristic.lookup(context.sinr_p10);
            Ok(Recommendation::from_heuristic(alpha, "low_gnn_confidence"))
        }
    }
}
```

---

## Domain Events

| Event | Trigger | Consumers |
|-------|---------|-----------|
| `RecommendationGenerated` | GNN/Heuristic produces output | Learning, Workflow |
| `RecommendationApproved` | Human approves | Workflow Execution |
| `RecommendationApplied` | ENM API confirms change | Learning, Monitoring |
| `RecommendationRejected` | Human rejects | Learning (negative sample) |
| `RecommendationRolledBack` | KPI degradation detected | Learning, Alarm |
| `GNNConfidenceLow` | Confidence < 70% | Heuristic fallback |
| `HeuristicFallbackUsed` | GNN unavailable | Monitoring |

---

## Anti-Corruption Layer

### Graph Context → Optimization Context

```rust
// Optimization Context's view of graph data
pub struct OptimizationGraphView {
    node_features: Vec<[f32; 24]>,  // 24D features per node
    edge_features: Vec<[f32; 10]>,  // 10D features per edge
    adjacency: SparseMatrix,
}

impl From<GraphSnapshot> for OptimizationGraphView {
    fn from(snapshot: GraphSnapshot) -> Self {
        // Transform graph representation for GNN consumption
        Self {
            node_features: snapshot.nodes.iter()
                .map(|n| n.features.to_tensor())
                .collect(),
            edge_features: snapshot.edges.iter()
                .map(|e| e.features.to_tensor())
                .collect(),
            adjacency: snapshot.build_adjacency_matrix(),
        }
    }
}
```

---

## Implementation Status

| Component | Location | Lines | Status |
|-----------|----------|-------|--------|
| GNN Layers | `src/layer.rs` | 790 | ✅ Implemented |
| GNN Training | `src/training.rs` | 1,374 | ✅ Implemented |
| Heuristic Optimizer | `src/heuristic.rs` | 4,387 | ✅ Implemented |
| Confidence Gates | `confidence-gate-workflow.ts` | 426 | ✅ Implemented |
| LoRA Adapters | `src/lora/` | 400+ | ✅ Implemented |

**Total**: ~7,400+ lines of optimization code

---

## Integration Points

### Upstream (Provides Data To This Context)

- **Topology Context**: Graph structure, node/edge features
- **ENM API Context**: Current cell parameters, PM counters

### Downstream (Consumes Data From This Context)

- **Workflow Context**: Executes approved recommendations
- **Learning Context**: Records outcomes for model improvement
- **Monitoring Context**: Tracks recommendation success rates

---

## Key Architectural Decisions

1. **Rust over Python for GNN** (ADR-007): 10x faster inference, no Python runtime
2. **Heuristic as fallback** (ADR-011): Always-available baseline
3. **4-tier confidence gates**: Human-in-loop for safety
4. **Single-file heuristic**: `heuristic.rs` consolidates all rules

---

## References

- ADR-007: Rust GNN Implementation
- ADR-011: Heuristic Optimizer Baseline
- `src/layer.rs` - GNN layer implementations
- `src/heuristic.rs` - Heuristic optimizer
