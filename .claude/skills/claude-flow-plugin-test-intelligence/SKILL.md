---
name: "CF Plugin Test Intelligence"
description: "AI-powered test intelligence plugin with predictive test selection, flaky test detection, and coverage optimization. Use when selecting which tests to run for a code change, detecting flaky tests, optimizing test coverage, or reducing CI pipeline time."
---

# CF Plugin Test Intelligence

AI-powered test intelligence plugin providing predictive test selection, flaky test detection, and coverage optimization to accelerate development feedback loops and improve test suite reliability.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable test-intelligence` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable test-intelligence` |
| Plugin info | `npx @claude-flow/cli@latest plugins info test-intelligence` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-test-intelligence@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable test-intelligence

# Verify activation
npx @claude-flow/cli@latest plugins info test-intelligence
```

## Plugin Capabilities

### Predictive Test Selection
Analyzes code changes and predicts which tests are most likely to fail, enabling targeted test runs that catch regressions faster.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.predict \
  --diff HEAD~1 --confidence 0.8 --output selected-tests.json
```

### Flaky Test Detection
Identifies tests with non-deterministic behavior by analyzing historical pass/fail patterns, timing variance, and environmental dependencies.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.flaky \
  --path ./tests --history 100 --threshold 0.05
```

### Coverage Optimization
Identifies gaps in test coverage, suggests new test cases for uncovered code paths, and prioritizes coverage improvements by risk.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.coverage \
  --path ./src --report gaps --prioritize risk
```

### Test Impact Analysis
Maps code changes to affected tests, showing which test files cover modified code and their historical reliability.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.impact \
  --diff HEAD~1 --include-transitive
```

## Common Patterns

### Fast CI: Run Only Relevant Tests
```bash
npx @claude-flow/cli@latest plugins toggle --enable test-intelligence
npx @claude-flow/cli@latest mcp exec test-intelligence.predict \
  --diff HEAD~1 --confidence 0.8 --output selected-tests.json
# Run only predicted tests
npx jest --testPathPattern "$(cat selected-tests.json | jq -r '.tests | join("|")')"
```

### Quarantine Flaky Tests
```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.flaky \
  --path ./tests --history 200 --threshold 0.03 --output flaky-report.json
```

### Improve Coverage Where It Matters
```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.coverage \
  --path ./src --report gaps --prioritize risk --top 10
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-test-intelligence)
