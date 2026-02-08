---
name: "CF Plugin Cognitive Kernel"
description: "Cognitive kernel plugin for LLM augmentation with working memory, attention control, meta-cognition, and scaffolding. Use when managing agent working memory, controlling attention across long contexts, enabling self-reflective reasoning, or structuring complex multi-step cognitive tasks."
---

# CF Plugin Cognitive Kernel

Cognitive kernel plugin for LLM augmentation providing working memory management, attention control, meta-cognition monitoring, and cognitive scaffolding for structured multi-step reasoning in agent workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable cognitive-kernel` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable cognitive-kernel` |
| Plugin info | `npx @claude-flow/cli@latest plugins info cognitive-kernel` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-cognitive-kernel@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable cognitive-kernel

# Verify activation
npx @claude-flow/cli@latest plugins info cognitive-kernel
```

## Plugin Capabilities

### Working Memory
Provides a structured working memory buffer for agents, supporting push/pop/query operations with capacity limits and priority-based eviction.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.working-memory \
  --action store --key "current-context" --value "refactoring auth module" \
  --ttl 300
```

### Attention Control
Directs agent focus to relevant portions of large contexts, reducing token waste and improving response quality on long documents or codebases.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.attention \
  --input context.json --focus "security vulnerabilities" --max-tokens 4000
```

### Meta-Cognition
Self-reflective monitoring layer that tracks confidence levels, detects reasoning loops, and flags when an agent should escalate or seek help.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.meta-cognition \
  --agent-id agent-1 --check confidence
```

### Scaffolding
Breaks complex cognitive tasks into structured sub-steps with checkpoints, enabling systematic reasoning through difficult problems.

```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.scaffold \
  --task "Design microservice architecture" --depth 3 --checkpoints true
```

## Common Patterns

### Enhance Agent Reasoning on Complex Tasks
```bash
npx @claude-flow/cli@latest plugins toggle --enable cognitive-kernel
npx @claude-flow/cli@latest mcp exec cognitive-kernel.scaffold \
  --task "Migrate monolith to microservices" --depth 4
npx @claude-flow/cli@latest mcp exec cognitive-kernel.attention \
  --input codebase-summary.json --focus "service boundaries"
```

### Monitor Agent Confidence and Escalate
```bash
npx @claude-flow/cli@latest mcp exec cognitive-kernel.meta-cognition \
  --agent-id agent-1 --check confidence --threshold 0.7 --on-low escalate
```

### Manage Working Memory Across Sessions
```bash
# Store context before session end
npx @claude-flow/cli@latest mcp exec cognitive-kernel.working-memory \
  --action store --key "progress" --value '{"step": 3, "findings": [...]}'

# Retrieve on session restore
npx @claude-flow/cli@latest mcp exec cognitive-kernel.working-memory \
  --action retrieve --key "progress"
```

## RAN DDD Context
**Bounded Context**: Coherence/Interpretability

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-cognitive-kernel)
