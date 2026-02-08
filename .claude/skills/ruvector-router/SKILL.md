---
name: "@ruvector/router"
description: "Semantic router with HNSW SIMD-accelerated intent matching for AI agent task routing. Use when the user needs semantic intent routing, vector-based route matching, AI agent task dispatch, utterance classification, or building intent-based APIs with sub-millisecond routing decisions."
---

# @ruvector/router

Semantic router for AI agents providing vector-based intent matching with HNSW indexing and SIMD acceleration for sub-millisecond routing decisions across task categories.

## Quick Command Reference

| Task | Code |
|------|------|
| Create router | `const router = new SemanticRouter()` |
| Add route | `await router.addRoute('greeting', ['hello', 'hi'])` |
| Route input | `const match = await router.route('hello there')` |
| Add route (vectors) | `await router.addRouteVectors('name', vectors)` |
| Remove route | `router.removeRoute('greeting')` |
| List routes | `router.getRoutes()` |
| Set threshold | `router.setThreshold(0.7)` |
| Export config | `router.export()` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/router@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### SemanticRouter Constructor

```typescript
import { SemanticRouter } from '@ruvector/router';

const router = new SemanticRouter({
  dimensions: 384,
  metric: 'cosine',
  threshold: 0.7,
  embeddingModel: 'all-MiniLM-L6-v2',
  defaultRoute: 'fallback',
  efSearch: 100,
});
```

**Constructor Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `dimensions` | `number` | Vector dimensions | `384` |
| `metric` | `string` | Distance metric | `'cosine'` |
| `threshold` | `number` | Minimum match score | `0.7` |
| `embeddingModel` | `string` | Embedding model name | `'all-MiniLM-L6-v2'` |
| `defaultRoute` | `string` | Fallback route name | `undefined` |
| `efSearch` | `number` | HNSW search quality | `100` |

### Route Management

```typescript
// Add route with example utterances (auto-embedded)
await router.addRoute('greeting', ['hello', 'hi', 'good morning', 'hey there']);
await router.addRoute('farewell', ['goodbye', 'bye', 'see you later']);
await router.addRoute('help', ['I need help', 'can you assist me', 'support']);

// Add route with pre-computed vectors
await router.addRouteVectors('custom', vectors, { metadata: { priority: 1 } });

// Remove a route
router.removeRoute('greeting');

// List all routes
const routes = router.getRoutes();
// [{ name: 'greeting', utterances: 4 }, { name: 'farewell', utterances: 3 }]
```

### Routing

```typescript
// Route a single input
const match = await router.route('hello there');
// { route: 'greeting', score: 0.92, metadata: {} }

// Route with top-K candidates
const matches = await router.routeTopK('can you help me', 3);
// [{ route: 'help', score: 0.89 }, { route: 'greeting', score: 0.45 }]

// Route with raw vector
const match = await router.routeVector(queryVector);

// Batch route multiple inputs
const results = await router.routeBatch(['hello', 'bye', 'help me']);
```

**Route Result:**
```typescript
interface RouteMatch {
  route: string;
  score: number;
  metadata?: Record<string, any>;
}
```

### Configuration

```typescript
router.setThreshold(0.8);                          // Adjust threshold
router.setDefaultRoute('unknown');                 // Set fallback
router.setEfSearch(200);                           // Adjust accuracy
```

## Common Patterns

### Intent-Based Chatbot Router
```typescript
const router = new SemanticRouter({ threshold: 0.75 });
await router.addRoute('greeting', ['hello', 'hi', 'hey']);
await router.addRoute('order_status', ['where is my order', 'track package']);
await router.addRoute('complaint', ['problem with order', 'wrong item']);
await router.addRoute('general', ['tell me about', 'what is']);

const match = await router.route(userMessage);
switch (match.route) {
  case 'greeting': return handleGreeting();
  case 'order_status': return handleOrderStatus();
  case 'complaint': return handleComplaint();
  default: return handleGeneral();
}
```

### Agent Task Dispatch
```typescript
const router = new SemanticRouter({ threshold: 0.6 });
await router.addRoute('code_review', ['review this code', 'check for bugs']);
await router.addRoute('testing', ['write tests', 'unit test', 'test coverage']);
await router.addRoute('docs', ['write documentation', 'update readme']);

const match = await router.route(taskDescription);
dispatchToAgent(match.route, task);
```

### Multi-Language Support
```typescript
await router.addRoute('greeting', [
  'hello', 'hi',           // English
  'bonjour', 'salut',      // French
  'hola', 'buenos dias',   // Spanish
]);
// Multilingual embedding model handles cross-language matching
```

## Key Options

| Feature | Value |
|---------|-------|
| Routing latency | < 1ms (SIMD) |
| Embedding support | ONNX, OpenAI, custom |
| Max routes | Unlimited |
| Multilingual | Yes (with multilingual model) |
| Threshold tuning | Per-route configurable |

## RAN DDD Context
**Bounded Context**: RANO Optimization

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/router)
