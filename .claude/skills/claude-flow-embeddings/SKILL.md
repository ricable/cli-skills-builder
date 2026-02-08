---
name: "Claude Flow Embeddings"
description: "Vector embedding service with ONNX models, HNSW indexing, semantic search, hyperbolic embeddings, and neural substrate integration. Use when generating embeddings, performing semantic search, comparing text similarity, or managing embedding collections."
---

# Claude Flow Embeddings

V3 Embedding Service supporting OpenAI, Transformers.js, and ONNX providers with HNSW indexing, semantic search, hyperbolic embeddings, and neural substrate integration.

## Quick Command Reference

| Task | Command |
|------|---------|
| Initialize embeddings | `npx @claude-flow/cli@latest embeddings init` |
| Generate embedding | `npx @claude-flow/cli@latest embeddings generate --text "query"` |
| Semantic search | `npx @claude-flow/cli@latest embeddings search --query "pattern"` |
| Compare texts | `npx @claude-flow/cli@latest embeddings compare --texts "a" "b"` |
| Manage collections | `npx @claude-flow/cli@latest embeddings collections` |
| Manage HNSW indexes | `npx @claude-flow/cli@latest embeddings index` |
| List providers | `npx @claude-flow/cli@latest embeddings providers` |
| Chunk text | `npx @claude-flow/cli@latest embeddings chunk --text "long text"` |
| Normalize vectors | `npx @claude-flow/cli@latest embeddings normalize` |
| Hyperbolic ops | `npx @claude-flow/cli@latest embeddings hyperbolic` |
| Neural substrate | `npx @claude-flow/cli@latest embeddings neural` |
| List models | `npx @claude-flow/cli@latest embeddings models` |
| Manage cache | `npx @claude-flow/cli@latest embeddings cache` |
| Warmup model | `npx @claude-flow/cli@latest embeddings warmup` |
| Benchmark | `npx @claude-flow/cli@latest embeddings benchmark` |

## Core Commands

### embeddings init
Initialize embedding subsystem with ONNX model.
```bash
npx @claude-flow/cli@latest embeddings init
```

### embeddings generate
Generate embeddings for text.
```bash
npx @claude-flow/cli@latest embeddings generate --text "query text"
```

### embeddings search
Semantic similarity search across stored embeddings.
```bash
npx @claude-flow/cli@latest embeddings search --query "search pattern"
```

### embeddings compare
Compare similarity between texts.
```bash
npx @claude-flow/cli@latest embeddings compare --texts "text a" "text b"
```

### embeddings collections
Manage embedding collections (namespaces).
```bash
npx @claude-flow/cli@latest embeddings collections
```

### embeddings index
Manage HNSW indexes for fast nearest-neighbor search.
```bash
npx @claude-flow/cli@latest embeddings index
```

### embeddings providers
List available embedding providers.
```bash
npx @claude-flow/cli@latest embeddings providers
```

### embeddings chunk
Chunk text for embedding with overlap.
```bash
npx @claude-flow/cli@latest embeddings chunk --text "long document text"
```

### embeddings normalize
Normalize embedding vectors.
```bash
npx @claude-flow/cli@latest embeddings normalize
```

### embeddings hyperbolic
Hyperbolic embedding operations (Poincare ball model).
```bash
npx @claude-flow/cli@latest embeddings hyperbolic
```

### embeddings neural
Neural substrate features (RuVector integration).
```bash
npx @claude-flow/cli@latest embeddings neural
```

### embeddings models
List and download embedding models.
```bash
npx @claude-flow/cli@latest embeddings models
```

### embeddings cache
Manage embedding cache.
```bash
npx @claude-flow/cli@latest embeddings cache
```

### embeddings warmup
Preload embedding model for faster first inference.
```bash
npx @claude-flow/cli@latest embeddings warmup
```

### embeddings benchmark
Run embedding performance benchmarks.
```bash
npx @claude-flow/cli@latest embeddings benchmark
```

## Common Patterns

### Initialize and Generate Embeddings
```bash
# Initialize with default ONNX model
npx @claude-flow/cli@latest embeddings init

# Warmup model
npx @claude-flow/cli@latest embeddings warmup

# Generate embedding
npx @claude-flow/cli@latest embeddings generate --text "authentication pattern"
```

### Semantic Search Workflow
```bash
# Search stored embeddings
npx @claude-flow/cli@latest embeddings search --query "error handling best practices"

# Compare similarity of two texts
npx @claude-flow/cli@latest embeddings compare --texts "JWT auth" "OAuth2 flow"
```

### Benchmark Embedding Performance
```bash
npx @claude-flow/cli@latest embeddings benchmark
```

## Key Options

- `--text`: Input text for embedding generation
- `--query`: Search query for semantic search
- `--texts`: Multiple texts for comparison
- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { EmbeddingService, HNSWIndex } from '@claude-flow/embeddings';

// Initialize with ONNX provider
const embeddings = new EmbeddingService({ provider: 'onnx' });
await embeddings.init();

// Generate embeddings
const vector = await embeddings.generate('query text');

// Semantic search
const results = await embeddings.search('pattern', { limit: 10 });

// Compare similarity
const similarity = await embeddings.compare('text a', 'text b');
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow-memory](../claude-flow-memory/), [claude-flow-neural](../claude-flow-neural/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/embeddings)
