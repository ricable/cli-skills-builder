---
name: "Claude Flow Teammate Plugin"
description: "Native TeammateTool integration plugin bridging Claude Code v2.1.19+ multi-agent capabilities with Claude Flow swarm coordination. Use when configuring teammate-based agent teams, bridging Claude Code native teams with Claude Flow, or setting up multi-agent collaboration."
---

# Claude Flow Teammate Plugin

Native TeammateTool integration plugin for Claude Flow, bridging Claude Code v2.1.19+ multi-agent capabilities with Claude Flow's swarm coordination, memory, and hooks systems.

## Quick Command Reference

This is a library-only module with no direct CLI subcommands. The teammate plugin integrates with Claude Code's built-in teammate system.

| Task | Related Command |
|------|-----------------|
| Handle idle teammate | `npx @claude-flow/cli@latest hooks teammate-idle` |
| Handle task completion | `npx @claude-flow/cli@latest hooks task-completed` |

## Programmatic API
```typescript
import { TeammatePlugin, TeammateConfig, TeamBridge } from '@claude-flow/teammate-plugin';

// Initialize teammate plugin
const plugin = new TeammatePlugin({
  teamSize: 4,
  roles: ['coder', 'reviewer', 'tester', 'planner'],
  coordination: 'hierarchical',
});

// Register with Claude Flow
await plugin.register();

// Bridge Claude Code teammates with Claude Flow agents
const bridge = new TeamBridge({
  claudeCodeTeam: nativeTeammates,
  claudeFlowSwarm: swarmInstance,
});

await bridge.sync();
```

## Common Patterns

### Set Up Teammate Integration
```typescript
import { TeammatePlugin } from '@claude-flow/teammate-plugin';

// Create plugin
const plugin = new TeammatePlugin({
  teamSize: 4,
  roles: ['coder', 'reviewer', 'tester', 'planner'],
});

// Register with hooks
await plugin.register();
```

### Handle Teammate Events
```bash
# When a teammate becomes idle
npx @claude-flow/cli@latest hooks teammate-idle

# When a teammate completes a task
npx @claude-flow/cli@latest hooks task-completed
```

### Bridge Native Teams
```typescript
import { TeamBridge } from '@claude-flow/teammate-plugin';

const bridge = new TeamBridge({
  claudeCodeTeam: teammates,
  claudeFlowSwarm: swarm,
  syncInterval: 5000,  // Sync every 5s
});

await bridge.start();
```

## Key Exports

| Export | Description |
|--------|-------------|
| `TeammatePlugin` | Main plugin class |
| `TeamBridge` | Bridge between Claude Code and Claude Flow |
| `TeammateConfig` | Configuration types |
| `TeammateEventHandler` | Event handler for teammate lifecycle |

## RAN DDD Context
**Bounded Context**: Agent Orchestration
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-swarm](../claude-flow-swarm/), [claude-flow-hooks](../claude-flow-hooks/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/teammate-plugin)
