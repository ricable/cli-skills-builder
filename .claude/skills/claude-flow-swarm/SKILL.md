---
name: "Claude Flow Swarm"
description: "Multi-agent swarm coordination with 4 topologies, hive-mind consensus, scaling, and hierarchical mesh orchestration. Use when initializing swarms, coordinating multiple agents, managing hive-mind consensus, or scaling agent clusters."
---

# Claude Flow Swarm

Standalone swarm coordination supporting up to 100+ agents with 4 topologies (hierarchical, mesh, star, ring), hive-mind consensus, and V3 15-agent hierarchical mesh coordination.

## Quick Command Reference

| Task | Command |
|------|---------|
| Initialize swarm | `npx @claude-flow/cli@latest swarm init --topology hierarchical` |
| Start swarm | `npx @claude-flow/cli@latest swarm start` |
| Check status | `npx @claude-flow/cli@latest swarm status` |
| Stop swarm | `npx @claude-flow/cli@latest swarm stop` |
| Scale agents | `npx @claude-flow/cli@latest swarm scale --count 10` |
| V3 coordinate | `npx @claude-flow/cli@latest swarm coordinate` |
| Init hive-mind | `npx @claude-flow/cli@latest hive-mind init` |
| Spawn hive workers | `npx @claude-flow/cli@latest hive-mind spawn` |
| Hive status | `npx @claude-flow/cli@latest hive-mind status` |
| Submit hive task | `npx @claude-flow/cli@latest hive-mind task` |
| Hive consensus | `npx @claude-flow/cli@latest hive-mind consensus` |
| Broadcast to hive | `npx @claude-flow/cli@latest hive-mind broadcast` |
| Shutdown hive | `npx @claude-flow/cli@latest hive-mind shutdown` |

## Core Commands

### swarm init
Initialize a new swarm.
```bash
npx @claude-flow/cli@latest swarm init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--topology` | Swarm topology: `hierarchical`, `mesh`, `star`, `ring` |
| `--max-agents` | Maximum number of agents (default: 8) |
| `--strategy` | Coordination strategy: `specialized`, `generalist`, `adaptive` |

**Examples:**
```bash
# Hierarchical swarm for coding tasks
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8 --strategy specialized

# Mesh swarm for research
npx @claude-flow/cli@latest swarm init --topology mesh --max-agents 15

# V3 mode
npx @claude-flow/cli@latest swarm init --v3-mode
```

### swarm start
Start swarm execution.
```bash
npx @claude-flow/cli@latest swarm start
```

### swarm status
Show swarm status (agents, topology, task progress).
```bash
npx @claude-flow/cli@latest swarm status
```

### swarm stop
Stop swarm execution.
```bash
npx @claude-flow/cli@latest swarm stop
```

### swarm scale
Scale swarm agent count dynamically.
```bash
npx @claude-flow/cli@latest swarm scale --count <number>
```

### swarm coordinate
Execute V3 15-agent hierarchical mesh coordination.
```bash
npx @claude-flow/cli@latest swarm coordinate
```

## Hive-Mind Commands

### hive-mind init
Initialize a hive mind with Byzantine fault-tolerant consensus.
```bash
npx @claude-flow/cli@latest hive-mind init
```

### hive-mind spawn
Spawn worker agents into the hive.
```bash
npx @claude-flow/cli@latest hive-mind spawn
npx @claude-flow/cli@latest hive-mind spawn --claude    # Spawn Claude Code agents
```

### hive-mind status
Show hive mind status.
```bash
npx @claude-flow/cli@latest hive-mind status
```

### hive-mind task
Submit tasks to the hive for distributed execution.
```bash
npx @claude-flow/cli@latest hive-mind task
```

### hive-mind join
Join an agent to the hive mind.
```bash
npx @claude-flow/cli@latest hive-mind join
```

### hive-mind leave
Remove an agent from the hive mind.
```bash
npx @claude-flow/cli@latest hive-mind leave
```

### hive-mind consensus
Manage consensus proposals and voting.
```bash
npx @claude-flow/cli@latest hive-mind consensus
```

### hive-mind broadcast
Broadcast a message to all workers.
```bash
npx @claude-flow/cli@latest hive-mind broadcast
```

### hive-mind memory
Access hive shared memory.
```bash
npx @claude-flow/cli@latest hive-mind memory
```

### hive-mind optimize-memory
Optimize hive memory and patterns.
```bash
npx @claude-flow/cli@latest hive-mind optimize-memory
```

### hive-mind shutdown
Shutdown the hive mind.
```bash
npx @claude-flow/cli@latest hive-mind shutdown
```

## Common Patterns

### Coding Swarm Setup
```bash
# Initialize hierarchical swarm
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8 --strategy specialized

# Start execution
npx @claude-flow/cli@latest swarm start

# Monitor
npx @claude-flow/cli@latest swarm status
```

### Hive-Mind Consensus Workflow
```bash
# Initialize hive mind
npx @claude-flow/cli@latest hive-mind init

# Spawn workers
npx @claude-flow/cli@latest hive-mind spawn --claude

# Submit task
npx @claude-flow/cli@latest hive-mind task

# Check consensus
npx @claude-flow/cli@latest hive-mind consensus
```

### Dynamic Scaling
```bash
# Start with 4 agents
npx @claude-flow/cli@latest swarm init --max-agents 4

# Scale up as needed
npx @claude-flow/cli@latest swarm scale --count 8

# Scale back down
npx @claude-flow/cli@latest swarm scale --count 4
```

## Key Options

- `--topology`: `hierarchical`, `mesh`, `star`, `ring`
- `--max-agents`: Maximum agent count
- `--strategy`: `specialized`, `generalist`, `adaptive`
- `--v3-mode`: Enable V3 mode features
- `--claude`: Spawn Claude Code agents (hive-mind)
- `--verbose`: Enable verbose output

## Programmatic API
```typescript
import { SwarmCoordinator, HiveMind, Topology } from '@claude-flow/swarm';

// Initialize swarm
const swarm = new SwarmCoordinator({
  topology: Topology.Hierarchical,
  maxAgents: 8,
  strategy: 'specialized',
});

await swarm.init();
await swarm.start();

// Initialize hive mind
const hive = new HiveMind({ consensus: 'raft' });
await hive.init();
await hive.spawn({ type: 'coder', count: 3 });
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-hooks](../claude-flow-hooks/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/swarm)
