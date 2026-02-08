---
name: "Claude Flow Integration"
description: "Integration module for agentic-flow deep integration, cross-platform adapters, and ADR-001 compliance bridges. Use when integrating Claude Flow with external systems, building cross-platform adapters, or bridging agentic-flow capabilities."
---

# Claude Flow Integration

Integration module providing agentic-flow@alpha deep integration, cross-platform adapters, and ADR-001 compliance bridges for connecting Claude Flow with external systems.

## Quick Command Reference

This is a library-only module with no direct CLI subcommands. It provides integration adapters and bridges for external systems.

## Programmatic API
```typescript
import { IntegrationManager, AgenticFlowBridge, Adapter } from '@claude-flow/integration';

// Initialize integration manager
const integration = new IntegrationManager();

// Bridge to agentic-flow
const bridge = new AgenticFlowBridge({
  endpoint: 'localhost:3000',
  protocol: 'quic',
});
await bridge.connect();

// Create custom adapter
const adapter = new Adapter({
  name: 'my-system',
  transform: (input) => ({ /* mapped output */ }),
  validate: (data) => true,
});

integration.register(adapter);
```

## Common Patterns

### Connect to Agentic Flow
```typescript
import { AgenticFlowBridge } from '@claude-flow/integration';

const bridge = new AgenticFlowBridge({ endpoint: 'localhost:3000' });
await bridge.connect();

// Proxy commands
const result = await bridge.execute('agent list');
```

### Cross-Platform Adapter
```typescript
import { Adapter } from '@claude-flow/integration';

const adapter = new Adapter({
  name: 'external-system',
  transform: (cfTask) => externalFormat(cfTask),
  reverseTransform: (extResult) => cfFormat(extResult),
});
```

## Key Exports

| Export | Description |
|--------|-------------|
| `IntegrationManager` | Central integration coordinator |
| `AgenticFlowBridge` | Bridge to agentic-flow system |
| `Adapter` | Custom adapter base class |
| `ProtocolHandler` | Protocol-level integration |

## RAN DDD Context
**Bounded Context**: DevOps/Tools
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-mcp](../claude-flow-mcp/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/integration)
