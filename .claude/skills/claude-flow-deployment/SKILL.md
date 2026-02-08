---
name: "Claude Flow Deployment"
description: "Deployment management with environment configuration, rollback support, deployment history, and log viewing. Use when deploying to environments, rolling back releases, viewing deployment history, or managing deployment environments."
---

# Claude Flow Deployment

Deployment module providing environment management, release deployment, rollback support, deployment history, and log viewing for Claude Flow applications.

## Quick Command Reference

| Task | Command |
|------|---------|
| Deploy | `npx @claude-flow/cli@latest deployment deploy` |
| Check status | `npx @claude-flow/cli@latest deployment status` |
| Rollback | `npx @claude-flow/cli@latest deployment rollback` |
| View history | `npx @claude-flow/cli@latest deployment history` |
| Manage environments | `npx @claude-flow/cli@latest deployment environments` |
| View logs | `npx @claude-flow/cli@latest deployment logs` |

## Core Commands

### deployment deploy
Deploy to target environment.
```bash
npx @claude-flow/cli@latest deployment deploy
```

### deployment status
Check deployment status across environments.
```bash
npx @claude-flow/cli@latest deployment status
```

### deployment rollback
Rollback to previous deployment.
```bash
npx @claude-flow/cli@latest deployment rollback
```

### deployment history
View deployment history.
```bash
npx @claude-flow/cli@latest deployment history
```

### deployment environments
Manage deployment environments.
```bash
npx @claude-flow/cli@latest deployment environments
npx @claude-flow/cli@latest deployment envs    # alias
```

### deployment logs
View deployment logs.
```bash
npx @claude-flow/cli@latest deployment logs
```

## Common Patterns

### Deploy and Monitor
```bash
# Deploy to staging
npx @claude-flow/cli@latest deployment deploy

# Check status
npx @claude-flow/cli@latest deployment status

# View logs
npx @claude-flow/cli@latest deployment logs
```

### Rollback on Issues
```bash
# View deployment history
npx @claude-flow/cli@latest deployment history

# Rollback to previous version
npx @claude-flow/cli@latest deployment rollback
```

### Environment Management
```bash
# List environments
npx @claude-flow/cli@latest deployment environments

# Check status across all environments
npx @claude-flow/cli@latest deployment status
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { DeploymentManager, Environment } from '@claude-flow/deployment';

// Deploy
const deployer = new DeploymentManager();
await deployer.deploy({ environment: 'staging' });

// Rollback
await deployer.rollback();

// Status
const status = await deployer.status();

// History
const history = await deployer.history();
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools
**Related Skills**: [claude-flow](../claude-flow/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/deployment)
