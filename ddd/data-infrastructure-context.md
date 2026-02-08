# Data Infrastructure Bounded Context

## Overview

The Data Infrastructure Context handles all data acquisition, transformation, and storage for the FPPC platform. It provides the foundation for ML/optimization contexts.

**Key Discovery**: TypeScript `HNSWPatternStore` is **mislabeled** - uses O(n) linear scan, not HNSW algorithm.

---

## Context Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│              DATA INFRASTRUCTURE CONTEXT                    │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   Graph      │    │    HNSW      │    │   Pattern    │  │
│  │   Builder    │    │   Index      │    │   Store      │  │
│  │              │    │              │    │              │  │
│  │ fppc_data.rs │    │ hnsw.rs      │    │ pattern-     │  │
│  │ 3,088 lines  │    │ 966 lines    │    │ store.ts     │  │
│  │              │    │ (Rust)       │    │ ⚠️ O(n)      │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                  ENM API Client                       │  │
│  │                                                       │  │
│  │  enm_client/mod.rs (888 lines)                       │  │
│  │  - OAuth2 authentication                              │  │
│  │  - Circuit breaker (Closed/Open/HalfOpen)            │  │
│  │  - Connection pooling (20-50 connections)            │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Domain Model

### Aggregates

#### 1. Graph Aggregate

**Root Entity**: `NetworkGraph`

```rust
// Conceptual model from src/fppc_data.rs
pub struct NetworkGraph {
    id: GraphId,
    cells: Vec<Cell>,           // Nodes
    relations: Vec<CellRelation>, // Edges
    version: GraphVersion,
    built_at: DateTime,
    top_p_threshold: f32,       // 0.90 (90% HO flux coverage)
}

pub struct Cell {
    id: CellId,
    features: NodeFeatures,     // 24D vector
    neighbors: Vec<CellId>,     // TOP_P selected
    parameters: CellParameters,
}

pub struct CellRelation {
    source: CellId,
    target: CellId,
    features: EdgeFeatures,     // 10D vector
    ho_flux: f32,               // Handover volume
}
```

**Invariants**:
- All cells must have valid 24D feature vectors
- Edges must satisfy TOP_P threshold (90% HO flux coverage)
- Graph must be connected (no orphan cells)

#### 2. HNSW Index Aggregate

**Root Entity**: `HNSWIndex`

```rust
// From src/hnsw.rs (Rust - production implementation)
pub struct HNSWIndex {
    id: IndexId,
    layers: Vec<HNSWLayer>,
    entry_point: NodeId,
    config: HNSWConfig,
}

pub struct HNSWConfig {
    ef_construction: usize,  // 200 - build quality
    ef_search: usize,        // 50 - search quality
    m: usize,                // 16 - connections per node
    m_max: usize,            // 32 - max connections (layer 0)
}

pub struct HNSWLayer {
    level: usize,
    nodes: HashMap<NodeId, HNSWNode>,
}
```

**Invariants**:
- M must be power of 2
- ef_search >= k for k-nearest search
- Entry point must be in highest layer

#### 3. Pattern Store Aggregate (⚠️ NEEDS FIX)

**Root Entity**: `PatternStore`

```typescript
// Current implementation (MISLABELED)
// .claude/skills/elex-ran-features/pattern-store.ts

// ⚠️ WARNING: This is NOT HNSW - uses O(n) linear scan
export class HNSWPatternStore {  // Should be: LinearPatternStore
  private patterns: Map<string, Pattern>;

  // O(n) brute-force search - NOT HNSW!
  findBySimilarity(embedding: number[], limit: number): Pattern[] {
    const results = [];
    for (const pattern of this.patterns.values()) {  // ← Linear scan
      const score = this.cosineSimilarity(embedding, pattern.embedding);
      results.push({ pattern, score });
    }
    return results.sort((a, b) => b.score - a.score).slice(0, limit);
  }
}
```

**Known Issues**:
1. Class name misleading (`HNSWPatternStore` but uses O(n) scan)
2. Embeddings use hash fallback: `Math.sin(hash * (i + 1)) * 0.5`
3. Not using MiniLM 384D model as documented

---

### Value Objects

```rust
// Node features (24D)
pub struct NodeFeatures {
    prb_utilization: [f32; 4],   // UL/DL avg/peak
    sinr_stats: [f32; 4],        // p10, p50, p90, mean
    ho_success: [f32; 4],        // intra/inter-freq rates
    load_indicators: [f32; 4],   // RRC, active UE
    interference: [f32; 4],      // metrics
    cell_config: [f32; 4],       // band, BW, power
}

// Edge features (10D)
pub struct EdgeFeatures {
    ho_flux: [f32; 2],           // A→B, B→A
    distance_bearing: [f32; 2],  // meters, degrees
    freq_relation: [f32; 2],     // same/different band
    rsrp_diff: [f32; 2],         // boundary RSRP
    timing_advance: [f32; 2],    // TA statistics
}

pub struct Embedding(Vec<f32>);  // Typically 384D (MiniLM)
```

---

## Domain Services

### GraphBuilder Service

```rust
pub trait GraphBuilder {
    /// Build graph from CSV/ENM data
    fn build(&self, data: &RawData) -> Result<NetworkGraph, Error>;

    /// Select TOP_P neighbors for a cell
    fn select_neighbors(&self, cell: &Cell, p: f32) -> Vec<CellId>;

    /// Extract features for a cell
    fn extract_features(&self, cell: &Cell) -> NodeFeatures;
}
```

### VectorSearch Service

```rust
pub trait VectorSearch {
    /// Search for k nearest neighbors
    fn knn(&self, query: &Embedding, k: usize) -> Vec<SearchResult>;

    /// Insert vector into index
    fn insert(&mut self, id: NodeId, vector: &Embedding);

    /// Batch search for multiple queries
    fn batch_knn(&self, queries: &[Embedding], k: usize) -> Vec<Vec<SearchResult>>;
}
```

---

## Domain Events

| Event | Trigger | Consumers |
|-------|---------|-----------|
| `GraphBuilt` | CSV processed, graph ready | Optimization |
| `GraphUpdated` | Incremental update applied | Optimization |
| `IndexRebuilt` | HNSW index reconstructed | Learning |
| `PatternStored` | New pattern added to store | Learning agents |
| `ENMDataRefreshed` | PM/CM data fetched | Graph Builder |
| `ConnectionPoolExhausted` | All ENM connections in use | Monitoring |

---

## Anti-Corruption Layer

### ENM API → Data Infrastructure

```rust
// src/clawdbot/enm_client/mod.rs
pub struct ENMAntiCorruptionLayer {
    client: ENMClient,
}

impl ENMAntiCorruptionLayer {
    /// Transform ENM REST response to domain Cell
    pub fn to_cell(&self, enm_response: EnmCmResponse) -> Cell {
        Cell {
            id: CellId::from(enm_response.fdn),
            features: self.extract_features(&enm_response.attributes),
            parameters: CellParameters {
                prach_config_index: enm_response.attributes.prachConfigIndex,
                rsrp_threshold: enm_response.attributes.rsrpThresholdSSS,
                alpha: enm_response.attributes.alpha,
                // ...
            },
            neighbors: vec![],  // Populated by graph builder
        }
    }
}
```

### External CSV → Graph

```rust
// src/fppc_data.rs
impl GraphBuilder for FPPCGraphBuilder {
    fn build(&self, csv_path: &Path) -> Result<NetworkGraph, Error> {
        let records = self.parse_csv(csv_path)?;

        let cells: Vec<Cell> = records.iter()
            .map(|r| self.record_to_cell(r))
            .collect();

        let relations: Vec<CellRelation> = self.build_relations(&cells);

        Ok(NetworkGraph {
            cells,
            relations,
            top_p_threshold: 0.90,
            // ...
        })
    }
}
```

---

## Implementation Status

| Component | Location | Lines | Status |
|-----------|----------|-------|--------|
| Graph Builder | `src/fppc_data.rs` | 3,088 | ✅ Implemented |
| Rust HNSW | `src/hnsw.rs` | 966 | ✅ Implemented (150x faster) |
| ENM Client | `src/clawdbot/enm_client/mod.rs` | 888 | ✅ Implemented |
| TS Pattern Store | `pattern-store.ts` | 224 | ⚠️ Mislabeled (O(n)) |
| TS HNSW Index | `hnsw-index.ts` | 860 | ✅ Implemented (<5ms p50) |
| Credential Provider | `credential_provider.rs` | 200+ | ✅ Implemented |

---

## Performance Characteristics

### Rust HNSW (Production)

| Metric | Target | Actual |
|--------|--------|--------|
| Search latency p50 | <5ms | ✅ <5ms |
| Search latency p95 | <10ms | ✅ <10ms |
| Recall@10 | >99% | ✅ ~99% |
| Speedup vs brute-force | 100x | ✅ 150x-12,500x |

### TypeScript Pattern Store (⚠️ NEEDS FIX)

| Metric | Current | Target |
|--------|---------|--------|
| Search complexity | O(n) | O(log n) |
| Latency (1K patterns) | ~50ms | <5ms |
| Algorithm | Brute-force | HNSW |

---

## Known Issues & Remediation

### Issue 1: TypeScript HNSW Mislabeled

**Current State**: `HNSWPatternStore` class uses linear scan
**Impact**: O(n) instead of O(log n) for pattern search
**Remediation**:
1. Rename to `LinearPatternStore`
2. Add WASM binding to Rust `hnsw.rs`
3. Or integrate `hnswlib-node`

### Issue 2: Hash-based Embeddings

**Current State**: `Math.sin(hash * (i + 1)) * 0.5` at `pattern-store.ts:420`
**Impact**: Non-semantic embeddings, poor similarity search
**Remediation**:
1. Integrate ONNX MiniLM model
2. Add embedding cache in SQLite

---

## Integration Points

### Upstream (Provides Data To This Context)

- **ENM External System**: PM counters, CM parameters, alarms
- **ELEX Documentation**: Feature definitions, parameter catalogs

### Downstream (Consumes Data From This Context)

- **Optimization Context**: Graph structure, cell features
- **Learning Context**: Pattern storage, similarity search
- **Agent Orchestration**: Cell data for troubleshooting

---

## References

- ADR-008: HNSW Dual Implementation Strategy
- ADR-009: TOP_P Neighbor Selection
- `src/fppc_data.rs` - Graph construction (3,088 lines)
- `src/hnsw.rs` - Rust HNSW (966 lines)
- `src/clawdbot/enm_client/mod.rs` - ENM API client (888 lines)
