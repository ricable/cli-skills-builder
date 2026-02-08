# Claude Flow Embeddings Command Reference

Complete reference for `npx @claude-flow/cli@latest embeddings` subcommands.

---

## embeddings init
Initialize embedding subsystem with ONNX model.
```bash
npx @claude-flow/cli@latest embeddings init
```

## embeddings generate
Generate embeddings for text.
```bash
npx @claude-flow/cli@latest embeddings generate --text <text>
```

## embeddings search
Semantic similarity search.
```bash
npx @claude-flow/cli@latest embeddings search --query <query>
```

## embeddings compare
Compare similarity between texts.
```bash
npx @claude-flow/cli@latest embeddings compare --texts <text1> <text2>
```

## embeddings collections
Manage embedding collections (namespaces).
```bash
npx @claude-flow/cli@latest embeddings collections
```

## embeddings index
Manage HNSW indexes.
```bash
npx @claude-flow/cli@latest embeddings index
```

## embeddings providers
List available embedding providers.
```bash
npx @claude-flow/cli@latest embeddings providers
```

## embeddings chunk
Chunk text for embedding with overlap.
```bash
npx @claude-flow/cli@latest embeddings chunk --text <text>
```

## embeddings normalize
Normalize embedding vectors.
```bash
npx @claude-flow/cli@latest embeddings normalize
```

## embeddings hyperbolic
Hyperbolic embedding operations (Poincare ball).
```bash
npx @claude-flow/cli@latest embeddings hyperbolic
```

## embeddings neural
Neural substrate features (RuVector integration).
```bash
npx @claude-flow/cli@latest embeddings neural
```

## embeddings models
List and download embedding models.
```bash
npx @claude-flow/cli@latest embeddings models
```

## embeddings cache
Manage embedding cache.
```bash
npx @claude-flow/cli@latest embeddings cache
```

## embeddings warmup
Preload embedding model.
```bash
npx @claude-flow/cli@latest embeddings warmup
```

## embeddings benchmark
Run embedding performance benchmarks.
```bash
npx @claude-flow/cli@latest embeddings benchmark
```

---

## Programmatic API

```typescript
import { EmbeddingService, HNSWIndex, HyperbolicSpace } from '@claude-flow/embeddings';

// Initialize
const service = new EmbeddingService({ provider: 'onnx', model: 'all-MiniLM-L6-v2' });
await service.init();

// Generate
const vector = await service.generate('text');

// Search
const results = await service.search('query', { limit: 10 });

// Compare
const similarity = await service.compare('a', 'b');

// HNSW index
const index = new HNSWIndex({ dimensions: 384, maxElements: 10000 });
index.add(vector, id);
const neighbors = index.search(queryVector, 5);

// Hyperbolic embeddings
const hyper = new HyperbolicSpace();
const poincare = hyper.embed(vector);
```
