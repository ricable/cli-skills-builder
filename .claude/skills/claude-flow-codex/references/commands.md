# Claude Flow Codex Command Reference

Codex integration uses the `init` command with specific flags.

---

## CLI Commands

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

### init check
Check if Claude Flow is initialized (works for both modes).
```bash
npx @claude-flow/cli@latest init check
```

---

## Programmatic API

```typescript
import { CodexAdapter, DualPlatformConfig, CodexWorkflow } from '@claude-flow/codex';

// Codex Adapter
const adapter = new CodexAdapter();
await adapter.init();
await adapter.configure({
  workingDir: process.cwd(),
  model: 'codex-latest',
});

// Dual Platform
const dual = new DualPlatformConfig({
  claudeCode: { enabled: true, config: '.claude/' },
  codex: { enabled: true, config: '.codex/' },
  shared: { memory: true, hooks: true },
});

await dual.apply();

// Codex Workflow
const workflow = new CodexWorkflow(adapter);
await workflow.run({
  task: 'implement feature',
  files: ['src/feature.ts'],
});
```
