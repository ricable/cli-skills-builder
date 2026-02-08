---
name: "CF Plugin Gastown Bridge"
description: "Gas Town orchestrator integration with WASM-accelerated formula parsing, graph analysis, and Gas Town workflow orchestration. Use when parsing formulas with WASM acceleration, analyzing dependency graphs, orchestrating Gas Town workflows, or bridging Claude Flow with Gas Town systems."
---

# CF Plugin Gastown Bridge

Gas Town orchestrator integration for Claude Flow V3 with WASM-accelerated formula parsing, dependency graph analysis, and Gas Town workflow orchestration for bridging Claude Flow agents with Gas Town infrastructure.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable gastown-bridge` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable gastown-bridge` |
| Plugin info | `npx @claude-flow/cli@latest plugins info gastown-bridge` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-gastown-bridge@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable gastown-bridge

# Verify activation
npx @claude-flow/cli@latest plugins info gastown-bridge
```

## Plugin Capabilities

### WASM Formula Parsing
High-performance formula parsing and evaluation using WebAssembly, supporting mathematical, logical, and domain-specific expressions with near-native speed.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.parse \
  --formula "SUM(A1:A10) * DISCOUNT_RATE" --context variables.json
```

### Graph Analysis
Analyzes dependency graphs within Gas Town workflows, identifying critical paths, cycles, and optimization opportunities.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.graph \
  --workflow workflow.json --analyze critical-path
```

### Gas Town Orchestration
Bridges Claude Flow agent swarms with Gas Town orchestration infrastructure, enabling hybrid workflow execution.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.orchestrate \
  --workflow workflow.json --agents 8 --bridge-mode hybrid
```

### Workflow Translation
Translates between Claude Flow workflow definitions and Gas Town workflow formats for interoperability.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.translate \
  --input claude-flow-workflow.json --output gastown-workflow.json --format gastown
```

## Common Patterns

### Execute Hybrid Workflow
```bash
npx @claude-flow/cli@latest plugins toggle --enable gastown-bridge
npx @claude-flow/cli@latest mcp exec gastown-bridge.translate \
  --input workflow.json --format gastown --output gt-workflow.json
npx @claude-flow/cli@latest mcp exec gastown-bridge.orchestrate \
  --workflow gt-workflow.json --agents 8 --bridge-mode hybrid
```

### Analyze Workflow Dependencies
```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.graph \
  --workflow workflow.json --analyze critical-path
npx @claude-flow/cli@latest mcp exec gastown-bridge.graph \
  --workflow workflow.json --detect-cycles
```

### Evaluate Formulas in Batch
```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.parse \
  --formulas formulas.json --context variables.json --output results.json
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-gastown-bridge)
