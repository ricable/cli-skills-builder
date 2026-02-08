# Claude Flow Guidance Command Reference

Complete reference for `npx @claude-flow/cli@latest guidance` subcommands.

---

## guidance compile
Compile CLAUDE.md into a policy bundle.
```bash
npx @claude-flow/cli@latest guidance compile
```

## guidance retrieve
Retrieve task-relevant guidance shards.
```bash
npx @claude-flow/cli@latest guidance retrieve
```

## guidance gates
Evaluate enforcement gates against a command.
```bash
npx @claude-flow/cli@latest guidance gates
```

## guidance status
Show guidance control plane status.
```bash
npx @claude-flow/cli@latest guidance status
```

## guidance optimize
Analyze and optimize a CLAUDE.md file.
```bash
npx @claude-flow/cli@latest guidance optimize
```

## guidance ab-test
Run A/B behavioral comparison between two CLAUDE.md versions.
```bash
npx @claude-flow/cli@latest guidance ab-test
```

---

## Programmatic API

```typescript
import { GuidanceEngine, PolicyBundle, EnforcementGate, ABTester } from '@claude-flow/guidance';

// Compile
const engine = new GuidanceEngine();
const bundle = await engine.compile('CLAUDE.md');

// Retrieve
const shards = await engine.retrieve({
  task: 'implement authentication',
  context: { file: 'src/auth.ts' },
});

// Gates
const gate = new EnforcementGate(bundle);
const result = await gate.evaluate('git push --force');
// result: { allowed: false, rule: 'no force push', severity: 'block' }

// Optimize
const suggestions = await engine.optimize('CLAUDE.md');

// A/B test
const tester = new ABTester();
const comparison = await tester.compare('CLAUDE-v1.md', 'CLAUDE-v2.md', {
  tasks: ['implement auth', 'fix bug', 'add tests'],
});
```
