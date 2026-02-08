---
name: agentic-jujutsu
description: "AI agent coordination for Jujutsu VCS with quantum-ready architecture, QuantumDAG consensus, and AgentDB learning. Use when managing Jujutsu repositories with AI agents, resolving merge conflicts automatically, running AI-powered code reviews on jj changes, or coordinating multi-agent VCS workflows."
---

# Agentic Jujutsu

AI agent coordination layer for Jujutsu VCS (jj) with quantum-ready architecture, QuantumDAG consensus, and AgentDB self-learning. Provides AI-powered conflict resolution, automated code review, and multi-agent VCS workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx agentic-jujutsu@latest --help` |
| Initialize | `npx agentic-jujutsu@latest init` |
| Agent review | `npx agentic-jujutsu@latest review` |
| Resolve conflicts | `npx agentic-jujutsu@latest resolve` |
| Status | `npx agentic-jujutsu@latest status` |
| Swarm review | `npx agentic-jujutsu@latest swarm-review` |
| Learn patterns | `npx agentic-jujutsu@latest learn` |
| Merge assist | `npx agentic-jujutsu@latest merge` |
| History analysis | `npx agentic-jujutsu@latest analyze` |

## Installation

**Install**: `npx agentic-jujutsu@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### init
Initialize agentic-jujutsu in a Jujutsu repository.
```bash
npx agentic-jujutsu@latest init [--force] [--config <path>]
```

### review
Run AI-powered code review on current changes.
```bash
npx agentic-jujutsu@latest review [--depth <level>] [--agents <n>]
```

### resolve
AI-assisted conflict resolution.
```bash
npx agentic-jujutsu@latest resolve [--strategy <name>] [--auto]
```
**Strategies:** `semantic`, `syntactic`, `llm-assisted`, `consensus`

### swarm-review
Run multi-agent swarm code review.
```bash
npx agentic-jujutsu@latest swarm-review [--agents <n>] [--perspectives <list>]
```
**Perspectives:** `security`, `performance`, `style`, `logic`, `architecture`

### merge
AI-assisted merge operations.
```bash
npx agentic-jujutsu@latest merge [--source <branch>] [--strategy <name>]
```

### analyze
Analyze repository history with AI.
```bash
npx agentic-jujutsu@latest analyze [--depth <n>] [--output <path>]
```

### learn
Train AgentDB on repository patterns.
```bash
npx agentic-jujutsu@latest learn [--iterations <n>]
```

## Common Patterns

### AI Code Review
```bash
npx agentic-jujutsu@latest init
npx agentic-jujutsu@latest review --depth deep --agents 3
```

### Conflict Resolution
```bash
npx agentic-jujutsu@latest resolve --strategy llm-assisted --auto
```

## Programmatic API

```typescript
import { AgenticJujutsu, ReviewAgent } from 'agentic-jujutsu';

const ajj = new AgenticJujutsu({ repoPath: '.', model: 'claude-sonnet-4-5-20250929' });
const review = await ajj.review({ depth: 'deep', perspectives: ['security', 'logic'] });
console.log(review.findings);
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/agentic-jujutsu)
