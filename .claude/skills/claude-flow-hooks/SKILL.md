---
name: "Claude Flow Hooks"
description: "Event-driven lifecycle hooks with ReasoningBank learning, agent routing, pretraining, model routing, coverage analysis, and 12 background workers. Use when setting up self-learning workflows, routing tasks to agents, pretraining from repositories, or managing hook-based automation."
---

# Claude Flow Hooks

V3 Hooks System providing event-driven lifecycle hooks with ReasoningBank learning integration, intelligent agent routing, pretraining pipelines, model routing, coverage analysis, and 12 background workers.

## Quick Command Reference

| Task | Command |
|------|---------|
| Pre-edit hook | `npx @claude-flow/cli@latest hooks pre-edit --file <path>` |
| Post-edit hook | `npx @claude-flow/cli@latest hooks post-edit --file <path>` |
| Pre-command hook | `npx @claude-flow/cli@latest hooks pre-command --command <cmd>` |
| Post-command hook | `npx @claude-flow/cli@latest hooks post-command --command <cmd>` |
| Pre-task hook | `npx @claude-flow/cli@latest hooks pre-task --task <desc>` |
| Post-task hook | `npx @claude-flow/cli@latest hooks post-task --task <desc>` |
| Route task | `npx @claude-flow/cli@latest hooks route --task <desc>` |
| Explain routing | `npx @claude-flow/cli@latest hooks explain` |
| Pretrain from repo | `npx @claude-flow/cli@latest hooks pretrain` |
| Build agent configs | `npx @claude-flow/cli@latest hooks build-agents` |
| View metrics | `npx @claude-flow/cli@latest hooks metrics` |
| List hooks | `npx @claude-flow/cli@latest hooks list` |
| Model routing | `npx @claude-flow/cli@latest hooks model-route` |
| Model stats | `npx @claude-flow/cli@latest hooks model-stats` |
| Coverage gaps | `npx @claude-flow/cli@latest hooks coverage-gaps` |

## Core Commands

### hooks pre-edit
Get context and agent suggestions before editing a file.
```bash
npx @claude-flow/cli@latest hooks pre-edit --file <path>
```

### hooks post-edit
Record editing outcome for learning.
```bash
npx @claude-flow/cli@latest hooks post-edit --file <path> --success
```

### hooks pre-command
Assess risk before executing a command.
```bash
npx @claude-flow/cli@latest hooks pre-command --command <cmd>
```

### hooks post-command
Record command execution outcome.
```bash
npx @claude-flow/cli@latest hooks post-command --command <cmd> --exit-code 0
```

### hooks pre-task
Record task start and get agent suggestions.
```bash
npx @claude-flow/cli@latest hooks pre-task --task <description>
```

### hooks post-task
Record task completion for learning.
```bash
npx @claude-flow/cli@latest hooks post-task --task <description> --success
```

### hooks session-end
End current session and persist state.
```bash
npx @claude-flow/cli@latest hooks session-end
```

### hooks session-restore
Restore a previous session.
```bash
npx @claude-flow/cli@latest hooks session-restore
```

### hooks route
Route task to optimal agent using learned patterns.
```bash
npx @claude-flow/cli@latest hooks route --task <description>
```

### hooks explain
Explain routing decision with transparency.
```bash
npx @claude-flow/cli@latest hooks explain
```

### hooks pretrain
Bootstrap intelligence from repository (4-step pipeline + embeddings).
```bash
npx @claude-flow/cli@latest hooks pretrain
```

### hooks build-agents
Generate optimized agent configs from pretrain data.
```bash
npx @claude-flow/cli@latest hooks build-agents
```

### hooks metrics
View learning metrics dashboard.
```bash
npx @claude-flow/cli@latest hooks metrics
```

### hooks transfer
Transfer patterns and plugins via IPFS-based decentralized registry.
```bash
npx @claude-flow/cli@latest hooks transfer
```

### hooks list
List all registered hooks.
```bash
npx @claude-flow/cli@latest hooks list
npx @claude-flow/cli@latest hooks ls    # alias
```

### hooks intelligence
RuVector intelligence system (SONA, MoE, HNSW 150x faster).
```bash
npx @claude-flow/cli@latest hooks intelligence
```

### hooks worker
Background worker management (12 workers).
```bash
npx @claude-flow/cli@latest hooks worker
```

### hooks model-route
Route task to optimal Claude model (haiku/sonnet/opus).
```bash
npx @claude-flow/cli@latest hooks model-route
```

### hooks model-outcome
Record model routing outcome for learning.
```bash
npx @claude-flow/cli@latest hooks model-outcome
```

### hooks model-stats
View model routing statistics.
```bash
npx @claude-flow/cli@latest hooks model-stats
```

### hooks coverage-route
Route task based on test coverage gaps.
```bash
npx @claude-flow/cli@latest hooks coverage-route
```

### hooks coverage-suggest
Suggest coverage improvements.
```bash
npx @claude-flow/cli@latest hooks coverage-suggest
```

### hooks coverage-gaps
List all coverage gaps with priority scoring.
```bash
npx @claude-flow/cli@latest hooks coverage-gaps
```

### hooks token-optimize
Token optimization via Agent Booster (30-50% savings).
```bash
npx @claude-flow/cli@latest hooks token-optimize
```

### hooks progress
Check V3 implementation progress via hooks.
```bash
npx @claude-flow/cli@latest hooks progress
```

### hooks statusline
Generate dynamic statusline.
```bash
npx @claude-flow/cli@latest hooks statusline
```

## Common Patterns

### Self-Learning Workflow
```bash
# Before editing
npx @claude-flow/cli@latest hooks pre-edit --file src/auth.ts

# After editing
npx @claude-flow/cli@latest hooks post-edit --file src/auth.ts --success

# View what was learned
npx @claude-flow/cli@latest hooks metrics
```

### Pretrain from Repository
```bash
# Bootstrap intelligence
npx @claude-flow/cli@latest hooks pretrain

# Generate agent configs
npx @claude-flow/cli@latest hooks build-agents
```

### Model Routing
```bash
# Route to optimal model
npx @claude-flow/cli@latest hooks model-route

# Record outcome
npx @claude-flow/cli@latest hooks model-outcome

# View stats
npx @claude-flow/cli@latest hooks model-stats
```

## Key Options

- `--file`: File path for edit hooks
- `--command`: Command string for command hooks
- `--task`: Task description for task hooks
- `--success`: Mark outcome as successful
- `--exit-code`: Command exit code
- `--verbose`: Enable verbose output

## Programmatic API
```typescript
import { HooksSystem, ReasoningBank } from '@claude-flow/hooks';

// Initialize hooks
const hooks = new HooksSystem();

// Pre-task hook
const suggestions = await hooks.preTask({ task: 'implement auth' });

// Post-task learning
await hooks.postTask({ task: 'implement auth', success: true });

// Route task
const agent = await hooks.route({ task: 'fix performance bug' });
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-swarm](../claude-flow-swarm/), [claude-flow-neural](../claude-flow-neural/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/hooks)
