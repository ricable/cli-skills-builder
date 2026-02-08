---
name: "@ruvector/agentic-integration"
description: "Distributed agent coordination framework with shared vector memory, task routing, and claude-flow integration. Use when orchestrating multi-agent workflows with vector search, connecting AI agents to RuVector indexes, building agentic RAG pipelines, or dispatching tasks across agent pools with capability-based routing."
---

# @ruvector/agentic-integration

Distributed agent coordination layer connecting RuVector vector databases with AI agent frameworks. Provides task routing, shared vector memory, agent-to-agent communication, and integration with claude-flow orchestration.

## Quick Command Reference

| Task | Command / Code |
|------|----------------|
| Install | `npx @ruvector/agentic-integration@latest` |
| Create coordinator | `new AgentCoordinator(config)` |
| Register agent | `coordinator.registerAgent(agentConfig)` |
| Dispatch task | `await coordinator.dispatch(taskSpec)` |
| Search memory | `await coordinator.memory.search(query, k)` |
| Store knowledge | `await coordinator.memory.store(key, vec, meta)` |
| Connect claude-flow | `coordinator.connectClaudeFlow(config)` |
| List agents | `coordinator.agents()` |
| Broadcast message | `coordinator.broadcast(message)` |

## Installation

**Install**: `npx @ruvector/agentic-integration@latest`
See [Installation Guide](../_shared/installation-guide.md) for hub details.

## Core API

### AgentCoordinator

Central orchestration hub for multi-agent systems.

```typescript
import { AgentCoordinator, VectorMemory, TaskRouter } from '@ruvector/agentic-integration';

const coordinator = new AgentCoordinator({
  memory: { dimensions: 1536, metric: 'cosine' },
  maxAgents: 10,
  taskTimeout: 30_000,
  routingStrategy: 'capability',
});
```

**CoordinatorConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `memory` | `MemoryConfig` | - | Shared vector memory config |
| `maxAgents` | `number` | `10` | Maximum registered agents |
| `taskTimeout` | `number` | `30000` | Task timeout (ms) |
| `routingStrategy` | `'capability' \| 'round-robin' \| 'load-balanced'` | `'capability'` | Task routing |
| `retryPolicy` | `RetryConfig` | `{ maxRetries: 3 }` | Failure retry |

### Register Agents

```typescript
coordinator.registerAgent({
  id: 'researcher',
  capabilities: ['search', 'summarize'],
  model: 'claude-sonnet-4-5-20250929',
  maxConcurrent: 3,
  priority: 10,
});

coordinator.registerAgent({
  id: 'coder',
  capabilities: ['code', 'debug', 'test'],
  model: 'claude-sonnet-4-5-20250929',
});
```

### Dispatch Tasks

```typescript
const result = await coordinator.dispatch({
  description: 'Implement user authentication',
  requiredCapabilities: ['code'],
  context: relevantDocs,
  priority: 5,
});
console.log(`Assigned to: ${result.assignee}`);
console.log(`Duration: ${result.duration}ms`);
```

### Shared Vector Memory

```typescript
// Store knowledge
await coordinator.memory.store('auth-pattern', embedding, {
  text: 'JWT with refresh tokens for auth',
  source: 'coder',
});

// Search shared memory
const relevant = await coordinator.memory.search(queryEmbedding, 5);

// Get specific entry
const entry = await coordinator.memory.get('auth-pattern');

// Delete entry
await coordinator.memory.delete('auth-pattern');
```

### Task Router

```typescript
const router = new TaskRouter({
  strategy: 'capability',
  fallback: 'round-robin',
});

router.addRule({ capability: 'code', preferAgent: 'coder' });
router.addRule({ capability: 'search', preferAgent: 'researcher' });
```

### Claude Flow Integration

```typescript
coordinator.connectClaudeFlow({
  endpoint: 'http://localhost:3000',
  namespace: 'production',
});
```

## Common Patterns

### Agentic RAG Pipeline

```typescript
const coordinator = new AgentCoordinator({
  memory: { dimensions: 1536, metric: 'cosine' },
});

coordinator.registerAgent({ id: 'retriever', capabilities: ['search'] });
coordinator.registerAgent({ id: 'generator', capabilities: ['generate'] });

// Retriever finds context
const context = await coordinator.dispatch({
  description: 'Find authentication patterns',
  requiredCapabilities: ['search'],
});

// Generator uses context
const answer = await coordinator.dispatch({
  description: 'Generate auth implementation',
  requiredCapabilities: ['generate'],
  context: [context.output],
});
```

### Multi-Agent Code Review

```typescript
coordinator.registerAgent({ id: 'security', capabilities: ['security-audit'] });
coordinator.registerAgent({ id: 'style', capabilities: ['lint', 'format'] });
coordinator.registerAgent({ id: 'logic', capabilities: ['test', 'review'] });

const reviews = await Promise.all([
  coordinator.dispatch({ description: 'Security audit', requiredCapabilities: ['security-audit'] }),
  coordinator.dispatch({ description: 'Style check', requiredCapabilities: ['lint'] }),
  coordinator.dispatch({ description: 'Logic review', requiredCapabilities: ['review'] }),
]);
```

## Events

```typescript
coordinator.on('task:dispatched', (task, assignee) => { });
coordinator.on('task:completed', (task, result) => { });
coordinator.on('task:failed', (task, error) => { });
coordinator.on('agent:registered', (agentId) => { });
coordinator.on('agent:idle', (agentId) => { });
coordinator.on('memory:stored', (key) => { });
```

## RAN DDD Context

**Bounded Context**: Agent Orchestration

## References

- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/agentic-integration)
