# Claude Flow Shared API Reference

Library-only module. No CLI subcommands.

---

## Types

```typescript
// Agent types
type AgentType = 'coder' | 'reviewer' | 'tester' | 'planner' | 'researcher' | /* 60+ more */;

// Task status
type TaskStatus = 'pending' | 'in_progress' | 'completed' | 'failed' | 'cancelled';

// Swarm topology
type SwarmTopology = 'hierarchical' | 'mesh' | 'star' | 'ring';

// Memory entry
interface MemoryEntry {
  key: string;
  value: string;
  namespace?: string;
  tags?: string[];
  ttl?: number;
  createdAt: Date;
  updatedAt: Date;
}
```

## Utilities

```typescript
import { validateInput, sanitizePath, Logger, EventEmitter } from '@claude-flow/shared';

// Input validation
const safe = validateInput(untrustedInput);

// Path sanitization
const safePath = sanitizePath(userPath);

// Logging
const log = new Logger('module-name');
log.info('message');
log.warn('warning');
log.error('error', { details });
log.debug('debug info');

// Events
const events = new EventEmitter();
events.on('event', handler);
events.off('event', handler);
events.emit('event', data);
events.once('event', handler);
```
