# Claude Flow Deployment Command Reference

Complete reference for `npx @claude-flow/cli@latest deployment` subcommands.

---

## deployment deploy
Deploy to target environment.
```bash
npx @claude-flow/cli@latest deployment deploy
```

## deployment status
Check deployment status across environments.
```bash
npx @claude-flow/cli@latest deployment status
```

## deployment rollback
Rollback to previous deployment.
```bash
npx @claude-flow/cli@latest deployment rollback
```

## deployment history
View deployment history.
```bash
npx @claude-flow/cli@latest deployment history
```

## deployment environments
Manage deployment environments.
```bash
npx @claude-flow/cli@latest deployment environments
npx @claude-flow/cli@latest deployment envs
```

## deployment logs
View deployment logs.
```bash
npx @claude-flow/cli@latest deployment logs
```

---

## Programmatic API

```typescript
import { DeploymentManager, Environment, DeploymentConfig } from '@claude-flow/deployment';

// Manager
const deployer = new DeploymentManager();

// Deploy
await deployer.deploy({
  environment: 'staging',
  version: '1.2.0',
});

// Status
const status = await deployer.status();
const envStatus = await deployer.status('production');

// Rollback
await deployer.rollback();
await deployer.rollback({ version: '1.1.0' });

// History
const history = await deployer.history();
const filtered = await deployer.history({ environment: 'production', limit: 10 });

// Environments
const envs = await deployer.listEnvironments();
await deployer.createEnvironment({ name: 'staging', config: {} });

// Logs
const logs = await deployer.logs();
const envLogs = await deployer.logs({ environment: 'production' });
```
