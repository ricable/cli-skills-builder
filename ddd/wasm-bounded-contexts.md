# WASM Migration - Bounded Contexts

## Overview

This document defines the bounded contexts affected by the TypeScript to Rust/WASM migration (ADR-020), their responsibilities, and integration patterns.

---

## New/Modified Bounded Contexts

### 1. Vector Search Context

**Responsibility:** High-performance similarity search for patterns, features, and memory retrieval.

**Domain Model:**

```
┌─────────────────────────────────────────────────────────────────┐
│                   VECTOR SEARCH CONTEXT                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │  HnswIndex    │    │  SearchQuery  │    │ SearchResult  │   │
│  │  (Aggregate)  │    │ (Value Obj)   │    │ (Value Obj)   │   │
│  └───────┬───────┘    └───────────────┘    └───────────────┘   │
│          │                                                       │
│          │ contains                                              │
│          ▼                                                       │
│  ┌───────────────┐    ┌───────────────┐                         │
│  │    Node       │    │   Vector      │                         │
│  │   (Entity)    │────│ (Value Obj)   │                         │
│  └───────────────┘    └───────────────┘                         │
│                                                                  │
│  Services:                                                       │
│  - VectorSearchService (WASM)                                   │
│  - PatternMatchingService                                       │
│  - EmbeddingService                                             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Aggregate: HnswIndex**

| Property | Type | Description |
|----------|------|-------------|
| `indexId` | IndexId | Unique identifier |
| `dimensions` | number | Vector dimensionality (384, 768) |
| `nodes` | Map<NodeId, Node> | Indexed vectors |
| `maxLayer` | number | HNSW max layer |
| `entryPoint` | NodeId | Entry point for search |

**Value Objects:**

```typescript
// Vector - immutable embedding
interface Vector {
  readonly data: Float32Array;
  readonly dimensions: number;
  normalize(): Vector;
  dot(other: Vector): number;
}

// SearchQuery - search parameters
interface SearchQuery {
  readonly vector: Vector;
  readonly k: number;
  readonly efSearch: number;
  readonly filter?: SearchFilter;
}

// SearchResult - search output
interface SearchResult {
  readonly id: string;
  readonly similarity: number;
  readonly distance: number;
  readonly metadata?: Record<string, unknown>;
}
```

**Domain Events:**

| Event | Triggered When | Consumers |
|-------|---------------|-----------|
| `VectorIndexed` | New vector added to index | Learning Context |
| `SearchPerformed` | Search completed | Monitoring Context |
| `IndexRebuilt` | Index reconstructed | Troubleshooting Context |

**Integration:**
- **Upstream:** Learning Context (provides patterns to index)
- **Downstream:** Troubleshooting Context (consumes search results)
- **Implementation:** Rust/WASM (ADR-021)

---

### 2. Validation Context

**Responsibility:** Normalize and validate ENM data, ensuring type safety and domain invariants.

**Domain Model:**

```
┌─────────────────────────────────────────────────────────────────┐
│                   VALIDATION CONTEXT                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │  Validator    │    │ ValidationRule│    │ ValidationErr │   │
│  │  (Service)    │    │ (Value Obj)   │    │ (Value Obj)   │   │
│  └───────┬───────┘    └───────────────┘    └───────────────┘   │
│          │                                                       │
│          │ uses                                                  │
│          ▼                                                       │
│  ┌───────────────┐    ┌───────────────┐                         │
│  │ FieldSchema   │    │ NormalizedData│                         │
│  │ (Value Obj)   │    │ (Value Obj)   │                         │
│  └───────────────┘    └───────────────┘                         │
│                                                                  │
│  Schemas:                                                        │
│  - CellConfigurationSchema                                      │
│  - AlarmSchema                                                  │
│  - CounterSchema                                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Value Objects:**

```typescript
// ValidationRule - single validation constraint
interface ValidationRule {
  readonly field: string;
  readonly type: 'range' | 'enum' | 'pattern' | 'required';
  readonly constraint: RangeConstraint | EnumConstraint | PatternConstraint;
  readonly message: string;
}

// ValidationError - validation failure
interface ValidationError {
  readonly field: string;
  readonly message: string;
  readonly value: string;
  readonly code: ValidationErrorCode;
}

// NormalizedData - validated and transformed data
interface NormalizedData<T> {
  readonly valid: boolean;
  readonly data?: T;
  readonly errors?: ValidationError[];
  readonly warnings?: ValidationWarning[];
}
```

**Validation Rules (RAN-specific):**

| Field | Rule Type | Constraint | Source |
|-------|-----------|------------|--------|
| `cellId` | required | Non-empty string | ENM |
| `dLChannelBandwidth` | enum | [5, 10, 15, 20] MHz | 3GPP |
| `transmissionPower` | range | -30 to 46 dBm | 3GPP |
| `prachConfigIndex` | range | 0-63 | 3GPP |
| `tddConfig` | enum | sa0-sa6 | 3GPP |
| `ssbPeriodicity` | enum | [5, 10, 20, 40, 80, 160] ms | 3GPP |
| `beamCount` | range | 1-64 | Vendor |

**Integration:**
- **Upstream:** API Gateway Context (raw ENM data)
- **Downstream:** Troubleshooting Context (validated data)
- **Implementation:** Rust/WASM (ADR-022)

---

### 3. Parsing Context

**Responsibility:** Parse and transform ELEX documentation into structured feature data.

**Domain Model:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     PARSING CONTEXT                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │  ElexParser   │    │ ParsedFeature │    │  ParseError   │   │
│  │  (Service)    │    │  (Entity)     │    │ (Value Obj)   │   │
│  └───────┬───────┘    └───────────────┘    └───────────────┘   │
│          │                                                       │
│          │ produces                                              │
│          ▼                                                       │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │ FeatureParam  │    │ FeaturePrereq │    │  FeatureTag   │   │
│  │ (Value Obj)   │    │ (Value Obj)   │    │ (Value Obj)   │   │
│  └───────────────┘    └───────────────┘    └───────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Entity: ParsedFeature**

```typescript
interface ParsedFeature {
  readonly featureId: FeatureId;    // e.g., "FAJ_121_3094"
  readonly name: string;             // "ESS - Energy Saving Support"
  readonly category: FeatureCategory;
  readonly description: string;
  readonly parameters: FeatureParameter[];
  readonly prerequisites: FeaturePrereq[];
  readonly tags: FeatureTag[];
  readonly version: string;
  readonly sourceDocument: DocumentRef;
}

interface FeatureParameter {
  readonly name: string;
  readonly moClass: string;          // ManagedObject class
  readonly attribute: string;
  readonly type: ParameterType;
  readonly defaultValue?: string;
  readonly range?: ParameterRange;
}
```

**Integration:**
- **Upstream:** ELEX documentation (external)
- **Downstream:** Vector Search Context (feature embeddings), Learning Context
- **Implementation:** Rust/WASM (ADR-020)

---

### 4. Secrets Context

**Responsibility:** Secure management of API keys, credentials, and sensitive configuration.

**Domain Model:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     SECRETS CONTEXT                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │ SecretStore   │    │    Secret     │    │  SecretRef    │   │
│  │ (Aggregate)   │    │   (Entity)    │    │ (Value Obj)   │   │
│  └───────┬───────┘    └───────────────┘    └───────────────┘   │
│          │                                                       │
│          │ manages                                               │
│          ▼                                                       │
│  ┌───────────────┐    ┌───────────────┐                         │
│  │ SecretProvider│    │ SecretPolicy  │                         │
│  │  (Service)    │    │ (Value Obj)   │                         │
│  └───────────────┘    └───────────────┘                         │
│                                                                  │
│  Providers:                                                      │
│  - EnvironmentProvider                                          │
│  - VaultProvider                                                │
│  - FileProvider                                                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Security Properties:**

| Property | Implementation |
|----------|---------------|
| Zeroization | Memory cleared after use (Rust `zeroize`) |
| Encryption | ChaCha20-Poly1305 at rest |
| Access Control | Claims-based (ADR-010) |
| Audit | All access logged |
| Rotation | Automatic expiry enforcement |

**Integration:**
- **Upstream:** Vault, Environment, Files (providers)
- **Downstream:** All contexts requiring credentials
- **Implementation:** Rust/WASM for security guarantees

---

## Context Map Updates

```
                        WASM LAYER
                            │
    ┌───────────────────────┼───────────────────────┐
    │                       │                       │
    ▼                       ▼                       ▼
┌────────┐           ┌──────────┐           ┌───────────┐
│ Vector │           │Validation│           │  Parsing  │
│ Search │◄─────────►│ Context  │◄─────────►│  Context  │
│Context │           │          │           │           │
└────┬───┘           └────┬─────┘           └─────┬─────┘
     │                    │                       │
     │                    │                       │
     │    ┌───────────────┼───────────────┐      │
     │    │               │               │      │
     ▼    ▼               ▼               ▼      ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Troubleshoot │    │ API Gateway │    │   Learning  │
│   Context   │◄───│   Context   │───►│   Context   │
└─────────────┘    └─────────────┘    └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │   Secrets   │
                   │   Context   │
                   └─────────────┘
```

**Relationship Types:**

| From | To | Relationship | Pattern |
|------|-----|--------------|---------|
| Vector Search | Learning | Customer/Supplier | Sync Request |
| Vector Search | Troubleshooting | Customer/Supplier | Sync Request |
| Validation | API Gateway | Conformist | ACL |
| Validation | Troubleshooting | Customer/Supplier | Sync Request |
| Parsing | Learning | Customer/Supplier | Async Event |
| Secrets | All | Shared Kernel | Service Lookup |

---

## Anti-Corruption Layers

### WASM ACL (TypeScript → Rust)

```typescript
// src/clawdbot/acl/wasm-acl.ts

/**
 * Transforms TypeScript domain objects to WASM-compatible format
 */
export class WasmAntiCorruptionLayer {
  /**
   * Convert TypeScript array to Float32Array for WASM
   */
  toWasmVector(vector: number[]): Float32Array {
    return new Float32Array(vector);
  }

  /**
   * Convert WASM search results to domain objects
   */
  fromWasmSearchResults(wasmResults: WasmSearchResult[]): SearchResult[] {
    return wasmResults.map(r => ({
      id: r.id,
      similarity: r.similarity,
      distance: r.distance,
      metadata: this.parseMetadata(r.metadata),
    }));
  }

  /**
   * Convert validation errors to domain format
   */
  fromWasmValidationErrors(wasmErrors: WasmValidationError[]): ValidationError[] {
    return wasmErrors.map(e => ({
      field: e.field,
      message: e.message,
      value: e.value,
      code: this.mapErrorCode(e.code),
    }));
  }
}
```

---

## Ubiquitous Language Additions

| Term | Definition | Context |
|------|------------|---------|
| **WASM Module** | Compiled Rust code running in browser/Node.js | All |
| **FFI Boundary** | Interface between TypeScript and WASM | All |
| **Feature Flag** | Runtime toggle for WASM/TypeScript selection | All |
| **Fallback** | TypeScript implementation used when WASM fails | All |
| **Bundle Size** | Total size of compiled WASM file | All |
| **Zeroization** | Secure memory clearing after secret use | Secrets |
| **HNSW** | Hierarchical Navigable Small World graph | Vector Search |
| **Recall@k** | Percentage of true nearest neighbors found | Vector Search |

---

## Domain Events (New)

| Event | Context | Payload | Triggered When |
|-------|---------|---------|----------------|
| `WasmModuleLoaded` | All | `{ module, version, loadTimeMs }` | WASM initialized |
| `WasmModuleFailed` | All | `{ module, error }` | WASM load failed |
| `FallbackActivated` | All | `{ module, reason }` | TypeScript fallback used |
| `ValidationCompleted` | Validation | `{ recordCount, errorCount, durationMs }` | Batch validation done |
| `FeatureParsed` | Parsing | `{ featureId, paramCount }` | ELEX doc parsed |
| `SecretAccessed` | Secrets | `{ secretId, accessor, purpose }` | Secret retrieved |

---

## References

- ADR-020: WASM Adoption Strategy
- ADR-021: HNSW WASM Migration
- ADR-022: Parameter Validation Consolidation
- ADR-023: Type Generation Strategy
- `docs/ddd/context-map.md` - Original context map
- `docs/ddd/aggregates.md` - Existing aggregates
