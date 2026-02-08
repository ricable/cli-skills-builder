---
name: "Claude Flow Plugins"
description: "Plugin SDK with IPFS-based decentralized registry for installing, creating, and managing worker, hook, and provider plugins. Use when installing plugins, searching the registry, creating custom plugins, or managing plugin lifecycle."
---

# Claude Flow Plugins

Unified Plugin SDK for Claude Flow V3 with IPFS-based decentralized registry, supporting Worker, Hook, and Provider plugin types.

## Quick Command Reference

| Task | Command |
|------|---------|
| List plugins | `npx @claude-flow/cli@latest plugins list` |
| Search plugins | `npx @claude-flow/cli@latest plugins search <query>` |
| Install plugin | `npx @claude-flow/cli@latest plugins install <name>` |
| Uninstall plugin | `npx @claude-flow/cli@latest plugins uninstall <name>` |
| Upgrade plugin | `npx @claude-flow/cli@latest plugins upgrade <name>` |
| Toggle plugin | `npx @claude-flow/cli@latest plugins toggle <name>` |
| Plugin info | `npx @claude-flow/cli@latest plugins info <name>` |
| Create plugin | `npx @claude-flow/cli@latest plugins create <name>` |
| Rate plugin | `npx @claude-flow/cli@latest plugins rate <name>` |

## Core Commands

### plugins list
List installed and available plugins from IPFS registry.
```bash
npx @claude-flow/cli@latest plugins list
```

### plugins search
Search plugins in the IPFS registry.
```bash
npx @claude-flow/cli@latest plugins search <query>
```

### plugins install
Install a plugin from IPFS registry or local path.
```bash
npx @claude-flow/cli@latest plugins install <name>
```

### plugins uninstall
Uninstall a plugin.
```bash
npx @claude-flow/cli@latest plugins uninstall <name>
```

### plugins upgrade
Upgrade an installed plugin.
```bash
npx @claude-flow/cli@latest plugins upgrade <name>
```

### plugins toggle
Enable or disable a plugin.
```bash
npx @claude-flow/cli@latest plugins toggle <name>
```

### plugins info
Show detailed plugin information.
```bash
npx @claude-flow/cli@latest plugins info <name>
```

### plugins create
Scaffold a new plugin project.
```bash
npx @claude-flow/cli@latest plugins create <name>
```

### plugins rate
Rate a plugin (1-5 stars).
```bash
npx @claude-flow/cli@latest plugins rate <name>
```

## Common Patterns

### Discover and Install Plugins
```bash
# Search for plugins
npx @claude-flow/cli@latest plugins search "performance"

# View details
npx @claude-flow/cli@latest plugins info perf-optimizer

# Install
npx @claude-flow/cli@latest plugins install perf-optimizer
```

### Create a Custom Plugin
```bash
# Scaffold plugin project
npx @claude-flow/cli@latest plugins create my-plugin

# After development, share via IPFS
npx @claude-flow/cli@latest hooks transfer
```

### Manage Plugin Lifecycle
```bash
# List installed plugins
npx @claude-flow/cli@latest plugins list

# Disable a plugin
npx @claude-flow/cli@latest plugins toggle my-plugin

# Upgrade
npx @claude-flow/cli@latest plugins upgrade my-plugin

# Uninstall
npx @claude-flow/cli@latest plugins uninstall my-plugin
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { PluginManager, PluginSDK } from '@claude-flow/plugins';

// Manage plugins
const manager = new PluginManager();
await manager.install('plugin-name');
await manager.uninstall('plugin-name');
const plugins = await manager.list();

// Create a plugin
const sdk = new PluginSDK();
const plugin = sdk.createWorkerPlugin({
  name: 'my-plugin',
  handler: async (task) => { /* ... */ },
});
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-hooks](../claude-flow-hooks/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugins)
