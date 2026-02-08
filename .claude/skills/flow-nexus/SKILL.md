---
name: flow-nexus
description: "Gamified swarm intelligence platform with 70+ MCP tools, cloud sandboxes, challenges, and Queen Seraphina AI. Use when initializing Flow Nexus projects, managing AI agent swarms, deploying to cloud sandboxes, completing gamified challenges, browsing the app marketplace, or interacting with Seraphina for guided assistance."
---

# Flow Nexus

AI-powered swarm intelligence platform with gamified MCP development, 70+ tools, cloud sandboxes, challenges, achievements, and the Queen Seraphina AI assistant. Supports swarm orchestration, template deployment, workflow automation, and app marketplace.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx flow-nexus@latest --help` |
| Initialize project | `npx flow-nexus@latest init` |
| Manage swarms | `npx flow-nexus@latest swarm [action]` |
| Browse challenges | `npx flow-nexus@latest challenge` |
| System check | `npx flow-nexus@latest check` |
| Cloud sandbox | `npx flow-nexus@latest sandbox [action]` |
| Check credits | `npx flow-nexus@latest credits` |
| Deploy | `npx flow-nexus@latest deploy` |
| Auth management | `npx flow-nexus@latest auth [action]` |
| Templates | `npx flow-nexus@latest template [action]` |
| App store | `npx flow-nexus@latest store [action]` |
| Leaderboard | `npx flow-nexus@latest leaderboard` |
| File storage | `npx flow-nexus@latest storage [action]` |
| Workflows | `npx flow-nexus@latest workflow [action]` |
| Monitoring | `npx flow-nexus@latest monitor [action]` |
| Profile | `npx flow-nexus@latest profile [action]` |
| Achievements | `npx flow-nexus@latest achievements` |
| Chat Seraphina | `npx flow-nexus@latest seraphina [question]` |
| MCP server | `npx flow-nexus@latest mcp [action]` |

## Installation

**Install**: `npx flow-nexus@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### init
Initialize a new Flow Nexus project.
```bash
npx flow-nexus@latest init [options]
```

### swarm
Manage AI agent swarms.
```bash
npx flow-nexus@latest swarm [action] [topology]
npx flow-nexus@latest swarm init --topology mesh
npx flow-nexus@latest swarm start
npx flow-nexus@latest swarm status
```

### challenge
Browse and complete gamified challenges.
```bash
npx flow-nexus@latest challenge [action]
npx flow-nexus@latest challenge list
npx flow-nexus@latest challenge start <id>
```

### sandbox
Manage cloud sandboxes for isolated development.
```bash
npx flow-nexus@latest sandbox [action]
npx flow-nexus@latest sandbox create
npx flow-nexus@latest sandbox list
npx flow-nexus@latest sandbox destroy <id>
```

### store
Browse and install apps from the marketplace.
```bash
npx flow-nexus@latest store [action] [app]
npx flow-nexus@latest store list
npx flow-nexus@latest store install <app>
npx flow-nexus@latest store info <app>
```

### seraphina / chat
Interact with Queen Seraphina AI assistant.
```bash
npx flow-nexus@latest seraphina "How do I set up a swarm?"
npx flow-nexus@latest chat "Explain MCP tools"
```

### workflow
Automation workflow management.
```bash
npx flow-nexus@latest workflow [action] [name]
npx flow-nexus@latest workflow create my-workflow
npx flow-nexus@latest workflow run my-workflow
```

### monitor
System monitoring dashboards.
```bash
npx flow-nexus@latest monitor [action]
npx flow-nexus@latest monitor start
npx flow-nexus@latest monitor status
```

## Common Patterns

### Quick Start
```bash
npx flow-nexus@latest init
npx flow-nexus@latest check
npx flow-nexus@latest swarm init --topology hierarchical
npx flow-nexus@latest swarm start
```

### Challenge Workflow
```bash
npx flow-nexus@latest challenge list
npx flow-nexus@latest challenge start beginner-1
npx flow-nexus@latest achievements
npx flow-nexus@latest leaderboard
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/flow-nexus)
