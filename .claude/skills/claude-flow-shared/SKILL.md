---
name: "Claude Flow Shared"
description: "Shared utilities providing common types, events, interfaces, and helper functions used across all Claude Flow modules. Use when importing shared types, event definitions, utility functions, or core interfaces for Claude Flow development."
---

# Claude Flow Shared

Shared module providing common types, events, utilities, and core interfaces used across all Claude Flow V3 packages.

## Quick Command Reference

This is a library-only module with no direct CLI subcommands. It provides shared types and utilities for other Claude Flow packages.

## Programmatic API
```typescript
import {
  AgentType,
  TaskStatus,
  SwarmTopology,
  MemoryEntry,
  EventEmitter,
  Logger,
  validateInput,
  sanitizePath,
} from '@claude-flow/shared';

// Types
const agentType: AgentType = 'coder';
const status: TaskStatus = 'in_progress';
const topology: SwarmTopology = 'hierarchical';

// Event system
const emitter = new EventEmitter();
emitter.on('task:created', (task) => { /* handle */ });
emitter.emit('task:created', newTask);

// Logging
const logger = new Logger('my-module');
logger.info('Operation completed');
logger.error('Something failed', { context: 'details' });

// Validation
const safeInput = validateInput(userInput);
const safePath = sanitizePath(filePath);
```

## Key Exports

| Export | Description |
|--------|-------------|
| `AgentType` | Agent type enum (coder, reviewer, tester, etc.) |
| `TaskStatus` | Task status enum (pending, in_progress, completed, etc.) |
| `SwarmTopology` | Swarm topology type (hierarchical, mesh, star, ring) |
| `MemoryEntry` | Memory entry interface |
| `EventEmitter` | Cross-module event system |
| `Logger` | Structured logging utility |
| `validateInput` | Input validation at system boundaries |
| `sanitizePath` | Path sanitization for security |

## RAN DDD Context
**Bounded Context**: DevOps/Tools
**Related Skills**: [claude-flow](../claude-flow/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/shared)
