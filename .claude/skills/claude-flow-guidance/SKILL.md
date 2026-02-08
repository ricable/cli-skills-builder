---
name: "Claude Flow Guidance"
description: "Guidance Control Plane for compiling, retrieving, enforcing, and evolving CLAUDE.md rules with A/B testing and policy bundles. Use when compiling CLAUDE.md policies, retrieving task-relevant guidance, evaluating enforcement gates, or A/B testing behavioral rules."
---

# Claude Flow Guidance

Guidance Control Plane that compiles, retrieves, enforces, and evolves guidance rules for Claude Code sessions with policy bundling, enforcement gates, and A/B behavioral comparison.

## Quick Command Reference

| Task | Command |
|------|---------|
| Compile CLAUDE.md | `npx @claude-flow/cli@latest guidance compile` |
| Retrieve guidance | `npx @claude-flow/cli@latest guidance retrieve` |
| Evaluate gates | `npx @claude-flow/cli@latest guidance gates` |
| Check status | `npx @claude-flow/cli@latest guidance status` |
| Optimize CLAUDE.md | `npx @claude-flow/cli@latest guidance optimize` |
| A/B test | `npx @claude-flow/cli@latest guidance ab-test` |

## Core Commands

### guidance compile
Compile CLAUDE.md into a policy bundle.
```bash
npx @claude-flow/cli@latest guidance compile
```

### guidance retrieve
Retrieve task-relevant guidance shards.
```bash
npx @claude-flow/cli@latest guidance retrieve
```

### guidance gates
Evaluate enforcement gates against a command.
```bash
npx @claude-flow/cli@latest guidance gates
```

### guidance status
Show guidance control plane status.
```bash
npx @claude-flow/cli@latest guidance status
```

### guidance optimize
Analyze and optimize a CLAUDE.md file.
```bash
npx @claude-flow/cli@latest guidance optimize
```

### guidance ab-test
Run A/B behavioral comparison between two CLAUDE.md versions.
```bash
npx @claude-flow/cli@latest guidance ab-test
```

## Common Patterns

### Compile and Deploy Guidance
```bash
# Compile CLAUDE.md into policy bundle
npx @claude-flow/cli@latest guidance compile

# Check status
npx @claude-flow/cli@latest guidance status
```

### Optimize CLAUDE.md
```bash
# Analyze current CLAUDE.md
npx @claude-flow/cli@latest guidance optimize

# A/B test two versions
npx @claude-flow/cli@latest guidance ab-test
```

### Enforce During Execution
```bash
# Retrieve task-relevant rules
npx @claude-flow/cli@latest guidance retrieve

# Check gates before command execution
npx @claude-flow/cli@latest guidance gates
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { GuidanceEngine, PolicyBundle, EnforcementGate } from '@claude-flow/guidance';

// Compile CLAUDE.md
const engine = new GuidanceEngine();
const bundle = await engine.compile('CLAUDE.md');

// Retrieve relevant guidance
const shards = await engine.retrieve({ task: 'implement auth' });

// Evaluate gates
const gate = new EnforcementGate(bundle);
const allowed = await gate.evaluate('git push --force');

// Optimize
const suggestions = await engine.optimize('CLAUDE.md');
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-hooks](../claude-flow-hooks/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/guidance)
