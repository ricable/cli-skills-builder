# Claude Flow Hooks Command Reference

Complete reference for `npx @claude-flow/cli@latest hooks` subcommands.

---

## Lifecycle Hooks

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
npx @claude-flow/cli@latest hooks post-command --command <cmd> --exit-code <code>
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

---

## Routing

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

---

## Learning

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

---

## Intelligence

### hooks intelligence
RuVector intelligence system (SONA, MoE, HNSW).
```bash
npx @claude-flow/cli@latest hooks intelligence
```

### hooks worker
Background worker management (12 workers).
```bash
npx @claude-flow/cli@latest hooks worker
```

---

## Model Routing

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

---

## Coverage Analysis

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

---

## Utility

### hooks list
List all registered hooks.
```bash
npx @claude-flow/cli@latest hooks list
```

### hooks token-optimize
Token optimization via Agent Booster (30-50% savings).
```bash
npx @claude-flow/cli@latest hooks token-optimize
```

### hooks progress
Check V3 implementation progress.
```bash
npx @claude-flow/cli@latest hooks progress
```

### hooks statusline
Generate dynamic statusline.
```bash
npx @claude-flow/cli@latest hooks statusline
```

### hooks teammate-idle
Handle idle teammate in Agent Teams.
```bash
npx @claude-flow/cli@latest hooks teammate-idle
```

### hooks task-completed
Handle task completion in Agent Teams.
```bash
npx @claude-flow/cli@latest hooks task-completed
```
