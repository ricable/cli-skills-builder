---
name: "CF Plugin Agentic QE"
description: "Quality engineering plugin with 51 specialized agents across 12 DDD bounded contexts for comprehensive testing and validation. Use when running quality engineering workflows, orchestrating test agent swarms, performing domain-driven quality analysis, or automating QA across bounded contexts."
---

# CF Plugin Agentic QE

Quality Engineering plugin for Claude Flow V3 providing 51 specialized agents organized across 12 DDD bounded contexts for comprehensive automated testing, validation, and quality assurance workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable agentic-qe` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable agentic-qe` |
| Plugin info | `npx @claude-flow/cli@latest plugins info agentic-qe` |
| List agents | `npx @claude-flow/cli@latest mcp exec agentic-qe.list-agents` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-agentic-qe@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable agentic-qe

# Verify activation
npx @claude-flow/cli@latest plugins info agentic-qe
```

## Plugin Capabilities

### Agent Catalog (51 Agents, 12 Contexts)
Provides pre-configured specialized QE agents across bounded contexts: Unit Testing, Integration Testing, E2E Testing, Performance Testing, Security Testing, Accessibility Testing, API Testing, Data Validation, Compliance, Monitoring, Reporting, and Orchestration.

```bash
# List all available QE agents
npx @claude-flow/cli@latest mcp exec agentic-qe.list-agents

# List agents by context
npx @claude-flow/cli@latest mcp exec agentic-qe.list-agents --context security-testing
```

### QE Swarm Orchestration
Spawns coordinated swarms of QE agents tailored to a specific quality goal, with automatic agent selection and result aggregation.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.swarm \
  --goal "full regression" --path ./src --max-agents 12
```

### Domain-Driven Quality Analysis
Analyzes code changes through the lens of DDD bounded contexts, ensuring quality coverage maps to domain boundaries.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.analyze \
  --diff HEAD~1 --context-map domain-contexts.json
```

### Quality Gate Enforcement
Defines and enforces quality gates with configurable thresholds for coverage, security, performance, and accessibility.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.gate \
  --config quality-gates.json --check --fail-on-violation
```

### QE Reporting
Generates comprehensive quality reports aggregating results from all QE agent runs.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.report \
  --format html --output qa-report.html
```

## Common Patterns

### Full Quality Sweep Before Release
```bash
npx @claude-flow/cli@latest plugins toggle --enable agentic-qe
npx @claude-flow/cli@latest mcp exec agentic-qe.swarm \
  --goal "release-readiness" --path ./src --max-agents 15
npx @claude-flow/cli@latest mcp exec agentic-qe.gate \
  --config quality-gates.json --check --fail-on-violation
npx @claude-flow/cli@latest mcp exec agentic-qe.report \
  --format html --output release-qa.html
```

### Targeted Security QE
```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.swarm \
  --goal "security audit" --context security-testing --path ./src
```

### PR Quality Check
```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.analyze \
  --diff HEAD~1 --context-map domain-contexts.json
npx @claude-flow/cli@latest mcp exec agentic-qe.gate \
  --config pr-gates.json --check
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-agentic-qe)
