---
name: ruv-swarm
description: "Neural swarm orchestration with WebAssembly-accelerated agent coordination, topology management, and distributed task execution. Use when orchestrating multi-agent swarms, coordinating distributed AI workloads, managing swarm topologies (mesh, hierarchical, ring), running parallel agent tasks, or building self-organizing agent systems."
---

# ruv-swarm

Neural swarm orchestration engine with WebAssembly-accelerated agent coordination, topology management, and distributed task execution. Orchestrate multi-agent swarms with configurable topologies, consensus protocols, load balancing, and self-healing capabilities.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx ruv-swarm@latest --help` |
| Init swarm | `npx ruv-swarm@latest init` |
| Spawn agents | `npx ruv-swarm@latest spawn --count 5` |
| Start swarm | `npx ruv-swarm@latest start` |
| Swarm status | `npx ruv-swarm@latest status` |
| Run task | `npx ruv-swarm@latest task run --file task.json` |
| List agents | `npx ruv-swarm@latest agents list` |
| Set topology | `npx ruv-swarm@latest topology set mesh` |
| Benchmark | `npx ruv-swarm@latest bench` |
| Stop swarm | `npx ruv-swarm@latest stop` |

## Installation

**Install**: `npx ruv-swarm@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### init
Initialize a swarm configuration in the current directory.
```bash
npx ruv-swarm@latest init [--topology <type>] [--max-agents <n>] [--force]
```
**Options:** `--topology <type>` (mesh, hierarchical, ring, star), `--max-agents <n>`, `--strategy <name>` (specialized, generalist, adaptive), `--force`

### spawn
Spawn agents into the swarm.
```bash
npx ruv-swarm@latest spawn --count <n> [--type <agent-type>] [--gpu]
```
**Options:** `--count <n>`, `--type <agent-type>`, `--model <name>`, `--gpu`, `--memory <mb>`

### start
Start the swarm orchestrator.
```bash
npx ruv-swarm@latest start [--config <path>] [--daemon]
```

### status
Show current swarm status including agent health, task progress, and topology.
```bash
npx ruv-swarm@latest status [--format json] [--watch]
```

### task
Task management for the swarm.
```bash
npx ruv-swarm@latest task run --file <path>
npx ruv-swarm@latest task list [--status <type>]
npx ruv-swarm@latest task cancel <task-id>
```

### agents
Agent management.
```bash
npx ruv-swarm@latest agents list [--format json]
npx ruv-swarm@latest agents info <agent-id>
npx ruv-swarm@latest agents terminate <agent-id>
npx ruv-swarm@latest agents scale --count <n>
```

### topology
Swarm topology management.
```bash
npx ruv-swarm@latest topology set <type>
npx ruv-swarm@latest topology info
npx ruv-swarm@latest topology optimize
```

### bench
Benchmark swarm performance.
```bash
npx ruv-swarm@latest bench [--iterations <n>] [--agents <n>]
```

### stop
Stop the swarm and all agents.
```bash
npx ruv-swarm@latest stop [--graceful] [--timeout <ms>]
```

## Programmatic API

```typescript
import { Swarm, Agent, Topology } from 'ruv-swarm';

// Create swarm
const swarm = new Swarm({
  topology: 'mesh',
  maxAgents: 10,
  strategy: 'specialized',
  consensus: 'raft',
});

// Spawn agents
await swarm.spawn({ count: 5, type: 'coder' });

// Submit task
const result = await swarm.submit({
  type: 'code-review',
  payload: { files: ['src/auth.ts'] },
  timeout: 30000,
});

// Get status
const status = await swarm.status();
console.log(`Active agents: ${status.agents.length}`);
console.log(`Pending tasks: ${status.tasks.pending}`);

// Coordinate with consensus
const consensus = await swarm.consensus({
  proposal: 'merge-branch',
  threshold: 0.67,
});

// Shutdown
await swarm.stop({ graceful: true });
```

## Common Patterns

### Hierarchical Code Review Swarm
```bash
npx ruv-swarm@latest init --topology hierarchical --max-agents 8
npx ruv-swarm@latest spawn --count 3 --type reviewer
npx ruv-swarm@latest spawn --count 1 --type coordinator
npx ruv-swarm@latest task run --file review-task.json
```

### Adaptive Scaling
```bash
npx ruv-swarm@latest start --daemon
npx ruv-swarm@latest agents scale --count 10
npx ruv-swarm@latest topology optimize
npx ruv-swarm@latest status --watch
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/ruv-swarm)
