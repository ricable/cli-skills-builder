---
name: "CF Plugin Code Intelligence"
description: "Advanced code intelligence plugin with semantic search, architecture analysis, refactoring impact assessment, and module splitting. Use when searching code semantically, analyzing codebase architecture, assessing refactoring risk, splitting large modules, or learning code patterns."
---

# CF Plugin Code Intelligence

Advanced code intelligence plugin for Claude Flow V3 providing semantic code search, architecture analysis, refactoring impact assessment, module splitting recommendations, and pattern learning for continuous improvement.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable code-intelligence` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable code-intelligence` |
| Plugin info | `npx @claude-flow/cli@latest plugins info code-intelligence` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-code-intelligence@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable code-intelligence

# Verify activation
npx @claude-flow/cli@latest plugins info code-intelligence
```

## Plugin Capabilities

### Semantic Code Search
Searches codebase by meaning rather than text, using embeddings to find functionally similar code even when naming conventions differ.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.search \
  --query "user authentication with JWT" --path ./src --top-k 10
```

### Architecture Analysis
Maps module dependencies, identifies architectural patterns (layered, hexagonal, microservice), and detects violations of intended architecture.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.architecture \
  --path ./src --detect-pattern --report
```

### Refactoring Impact
Assesses the blast radius of proposed refactorings by tracing symbol usage, call chains, and test dependencies across the codebase.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.refactor-impact \
  --target src/auth/service.ts --change "extract-method login" --report
```

### Module Splitting
Analyzes large modules and recommends splitting strategies based on cohesion metrics, coupling analysis, and domain boundaries.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.split \
  --target src/core/engine.ts --threshold 500 --strategy cohesion
```

### Pattern Learning
Learns recurring code patterns from the codebase and suggests them during similar implementations, improving consistency.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.learn \
  --path ./src --patterns "error-handling,api-calls,validation"
```

## Common Patterns

### Pre-Refactoring Analysis
```bash
npx @claude-flow/cli@latest plugins toggle --enable code-intelligence
npx @claude-flow/cli@latest mcp exec code-intelligence.refactor-impact \
  --target src/auth/service.ts --change "rename-method" --report
npx @claude-flow/cli@latest mcp exec code-intelligence.architecture \
  --path ./src --check-violations
```

### Find and Consolidate Duplicate Logic
```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.search \
  --query "HTTP error handling" --path ./src --top-k 20
npx @claude-flow/cli@latest mcp exec code-intelligence.split \
  --target src/utils/http.ts --analyze-cohesion
```

### Codebase Architecture Audit
```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.architecture \
  --path ./src --detect-pattern --report --check-violations
npx @claude-flow/cli@latest mcp exec code-intelligence.split \
  --path ./src --scan-oversized --threshold 500
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-code-intelligence)
