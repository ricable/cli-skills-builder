# Claude Flow Plugins Command Reference

Complete reference for `npx @claude-flow/cli@latest plugins` subcommands.

---

## plugins list
List installed and available plugins from IPFS registry.
```bash
npx @claude-flow/cli@latest plugins list
```

## plugins search
Search plugins in the IPFS registry.
```bash
npx @claude-flow/cli@latest plugins search <query>
```

## plugins install
Install a plugin from IPFS registry or local path.
```bash
npx @claude-flow/cli@latest plugins install <name>
```

## plugins uninstall
Uninstall a plugin.
```bash
npx @claude-flow/cli@latest plugins uninstall <name>
```

## plugins upgrade
Upgrade an installed plugin.
```bash
npx @claude-flow/cli@latest plugins upgrade <name>
```

## plugins toggle
Enable or disable a plugin.
```bash
npx @claude-flow/cli@latest plugins toggle <name>
```

## plugins info
Show detailed plugin information.
```bash
npx @claude-flow/cli@latest plugins info <name>
```

## plugins create
Scaffold a new plugin project.
```bash
npx @claude-flow/cli@latest plugins create <name>
```

## plugins rate
Rate a plugin (1-5 stars).
```bash
npx @claude-flow/cli@latest plugins rate <name>
```

---

## Programmatic API

```typescript
import { PluginManager, PluginSDK, WorkerPlugin, HookPlugin, ProviderPlugin } from '@claude-flow/plugins';

// Plugin Manager
const manager = new PluginManager();
await manager.install('name');
await manager.uninstall('name');
await manager.upgrade('name');
await manager.toggle('name');
const info = await manager.info('name');
const list = await manager.list();
const results = await manager.search('query');

// Plugin SDK - Create Worker Plugin
const worker = PluginSDK.createWorkerPlugin({
  name: 'my-worker',
  handler: async (task) => ({ result: 'done' }),
});

// Plugin SDK - Create Hook Plugin
const hook = PluginSDK.createHookPlugin({
  name: 'my-hook',
  events: ['pre-task', 'post-task'],
  handler: async (event) => {},
});

// Plugin SDK - Create Provider Plugin
const provider = PluginSDK.createProviderPlugin({
  name: 'my-provider',
  type: 'llm',
  handler: async (request) => ({ response: 'text' }),
});
```
