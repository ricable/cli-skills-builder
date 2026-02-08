# @ruvector/agentic-integration API Reference

Complete API reference for `@ruvector/agentic-integration`.

## Table of Contents

- [AgentCoordinator](#agentcoordinator)
- [VectorMemory](#vectormemory)
- [TaskRouter](#taskrouter)
- [Events](#events)
- [Types](#types)

---

## AgentCoordinator

### Constructor

```typescript
import { AgentCoordinator } from '@ruvector/agentic-integration';
const coordinator = new AgentCoordinator(config: CoordinatorConfig);
```

**CoordinatorConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `memory` | `MemoryConfig` | - | Vector memory settings |
| `maxAgents` | `number` | `10` | Agent limit |
| `taskTimeout` | `number` | `30000` | Timeout (ms) |
| `routingStrategy` | `string` | `'capability'` | Routing mode |
| `retryPolicy` | `RetryConfig` | `{ maxRetries: 3 }` | Retry behavior |

**MemoryConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dimensions` | `number` | required | Vector dims |
| `metric` | `string` | `'cosine'` | Distance metric |
| `maxElements` | `number` | `100000` | Capacity |

### coordinator.registerAgent(agent)

```typescript
coordinator.registerAgent(agent: AgentConfig): void
```

### coordinator.unregisterAgent(id)

```typescript
coordinator.unregisterAgent(id: string): void
```

### coordinator.dispatch(task)

```typescript
await coordinator.dispatch(task: TaskSpec): Promise<TaskResult>
```

### coordinator.dispatchBatch(tasks)

```typescript
await coordinator.dispatchBatch(tasks: TaskSpec[]): Promise<TaskResult[]>
```

### coordinator.broadcast(message)

```typescript
coordinator.broadcast(message: string): void
```

### coordinator.agents()

```typescript
coordinator.agents(): AgentStatus[]
```

### coordinator.connectClaudeFlow(config)

```typescript
coordinator.connectClaudeFlow(config: { endpoint?: string; namespace?: string }): void
```

### coordinator.shutdown()

```typescript
await coordinator.shutdown(): Promise<void>
```

---

## VectorMemory

### memory.store(key, vector, metadata)

```typescript
await coordinator.memory.store(
  key: string,
  vector: Float32Array,
  metadata: Record<string, unknown>
): Promise<void>
```

### memory.search(query, k, filter?)

```typescript
await coordinator.memory.search(
  query: Float32Array,
  k: number,
  filter?: FilterExpr
): Promise<MemoryResult[]>
```

### memory.get(key)

```typescript
await coordinator.memory.get(key: string): Promise<MemoryEntry | null>
```

### memory.delete(key)

```typescript
await coordinator.memory.delete(key: string): Promise<void>
```

### memory.count()

```typescript
coordinator.memory.count(): number
```

### memory.list(options?)

```typescript
coordinator.memory.list(options?: { limit?: number; namespace?: string }): MemoryEntry[]
```

---

## TaskRouter

### Constructor

```typescript
import { TaskRouter } from '@ruvector/agentic-integration';
const router = new TaskRouter(config: RouterConfig);
```

**RouterConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `strategy` | `string` | `'capability'` | Primary strategy |
| `fallback` | `string` | `'round-robin'` | Fallback strategy |

### router.addRule(rule)

```typescript
router.addRule(rule: RoutingRule): void
```

**RoutingRule:**
| Field | Type | Description |
|-------|------|-------------|
| `capability` | `string` | Match capability |
| `preferAgent` | `string` | Preferred agent ID |
| `priority` | `number` | Rule priority |

### router.route(task, agents)

```typescript
router.route(task: TaskSpec, agents: AgentStatus[]): string  // Returns agent ID
```

---

## Events

```typescript
coordinator.on('task:dispatched', (task: TaskSpec, assignee: string) => void)
coordinator.on('task:completed', (task: TaskSpec, result: TaskResult) => void)
coordinator.on('task:failed', (task: TaskSpec, error: Error) => void)
coordinator.on('task:retry', (task: TaskSpec, attempt: number) => void)
coordinator.on('agent:registered', (agentId: string) => void)
coordinator.on('agent:unregistered', (agentId: string) => void)
coordinator.on('agent:idle', (agentId: string) => void)
coordinator.on('agent:busy', (agentId: string) => void)
coordinator.on('memory:stored', (key: string) => void)
coordinator.on('memory:searched', (query: string, results: number) => void)
```

---

## Types

### AgentConfig

```typescript
interface AgentConfig {
  id: string;
  capabilities: string[];
  model: string;
  maxConcurrent?: number;
  priority?: number;
  metadata?: Record<string, unknown>;
}
```

### AgentStatus

```typescript
interface AgentStatus {
  id: string;
  capabilities: string[];
  status: 'idle' | 'busy' | 'offline';
  activeTasks: number;
  totalCompleted: number;
}
```

### TaskSpec

```typescript
interface TaskSpec {
  description: string;
  requiredCapabilities: string[];
  context?: unknown[];
  priority?: number;
  assignTo?: string;
  timeout?: number;
}
```

### TaskResult

```typescript
interface TaskResult {
  assignee: string;
  output: unknown;
  duration: number;
  tokensUsed: number;
  success: boolean;
}
```

### MemoryEntry

```typescript
interface MemoryEntry {
  key: string;
  vector: Float32Array;
  metadata: Record<string, unknown>;
  timestamp: number;
}
```

### MemoryResult

```typescript
interface MemoryResult {
  key: string;
  score: number;
  metadata: Record<string, unknown>;
}
```

### RetryConfig

```typescript
interface RetryConfig {
  maxRetries: number;
  backoffMs?: number;
  backoffMultiplier?: number;
}
```
