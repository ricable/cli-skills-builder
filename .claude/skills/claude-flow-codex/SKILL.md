---
name: "Claude Flow Codex"
description: "OpenAI Codex CLI integration adapter for Claude Flow, enabling dual-platform initialization and Codex-compatible workflows. Use when initializing Claude Flow for Codex CLI, setting up dual Claude Code + Codex environments, or adapting workflows for the Codex platform."
---

# Claude Flow Codex

Codex CLI integration adapter for Claude Flow, enabling initialization for OpenAI Codex CLI with dual-platform support alongside Claude Code.

## Quick Command Reference

| Task | Command |
|------|---------|
| Init for Codex | `npx @claude-flow/cli@latest init --codex` |
| Init for both | `npx @claude-flow/cli@latest init --dual` |
| Check init status | `npx @claude-flow/cli@latest init check` |

## Core Commands

### init --codex
Initialize Claude Flow for OpenAI Codex CLI.
```bash
npx @claude-flow/cli@latest init --codex
```

### init --dual
Initialize for both Claude Code and OpenAI Codex.
```bash
npx @claude-flow/cli@latest init --dual
```

## Common Patterns

### Codex-Only Setup
```bash
# Initialize for Codex
npx @claude-flow/cli@latest init --codex

# Verify
npx @claude-flow/cli@latest init check
```

### Dual Platform Setup
```bash
# Initialize for both Claude Code and Codex
npx @claude-flow/cli@latest init --dual

# Start system
npx @claude-flow/cli@latest start
```

### Full Dual Setup with Auto-Start
```bash
npx @claude-flow/cli@latest init --dual --full --start-all
npx @claude-flow/cli@latest doctor --fix
```

## Key Options

- `--codex`: Initialize for OpenAI Codex CLI
- `--dual`: Initialize for both Claude Code and Codex
- `--force`: Overwrite existing configuration
- `--full`: Full configuration with all components

## Programmatic API
```typescript
import { CodexAdapter, DualPlatformConfig } from '@claude-flow/codex';

// Initialize Codex adapter
const adapter = new CodexAdapter();
await adapter.init();

// Dual platform configuration
const config = new DualPlatformConfig({
  claudeCode: { enabled: true },
  codex: { enabled: true },
});

await config.apply();
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-cli](../claude-flow-cli/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/codex)
