# Claude Flow Teammate Plugin API Reference

Library-only module. No direct CLI subcommands.

## Related CLI Commands

```bash
# Teammate hooks
npx @claude-flow/cli@latest hooks teammate-idle
npx @claude-flow/cli@latest hooks task-completed
```

---

## Programmatic API

```typescript
import {
  TeammatePlugin,
  TeamBridge,
  TeammateConfig,
  TeammateEventHandler,
} from '@claude-flow/teammate-plugin';

// Plugin
const plugin = new TeammatePlugin({
  teamSize: 4,
  roles: ['coder', 'reviewer', 'tester', 'planner'],
  coordination: 'hierarchical',
  memory: memoryInstance,
  hooks: hooksInstance,
});

await plugin.register();
await plugin.start();
await plugin.stop();

// Team Bridge
const bridge = new TeamBridge({
  claudeCodeTeam: nativeTeammates,
  claudeFlowSwarm: swarmInstance,
  syncInterval: 5000,
});

await bridge.start();
await bridge.sync();
await bridge.stop();

// Event Handler
const handler = new TeammateEventHandler();
handler.onIdle((teammate) => { /* reassign work */ });
handler.onTaskComplete((teammate, task) => { /* handle completion */ });
handler.onError((teammate, error) => { /* handle error */ });
```
