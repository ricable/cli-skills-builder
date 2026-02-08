---
name: "Claude Flow Claims"
description: "Claims-based authorization with role management, policy enforcement, and permission control for agent workflows. Use when managing permissions, checking authorization, granting or revoking claims, or configuring role-based access control."
---

# Claude Flow Claims

Claims-based authorization system providing role management, policy enforcement, and granular permission control for agent workflows and multi-agent coordination.

## Quick Command Reference

| Task | Command |
|------|---------|
| List claims | `npx @claude-flow/cli@latest claims list` |
| Check claim | `npx @claude-flow/cli@latest claims check <claim>` |
| Grant claim | `npx @claude-flow/cli@latest claims grant <claim>` |
| Revoke claim | `npx @claude-flow/cli@latest claims revoke <claim>` |
| Manage roles | `npx @claude-flow/cli@latest claims roles` |
| Manage policies | `npx @claude-flow/cli@latest claims policies` |

## Core Commands

### claims list
List claims and permissions.
```bash
npx @claude-flow/cli@latest claims list
```

### claims check
Check if a specific claim is granted.
```bash
npx @claude-flow/cli@latest claims check <claim>
```

### claims grant
Grant a claim to a user or role.
```bash
npx @claude-flow/cli@latest claims grant <claim>
```

### claims revoke
Revoke a claim from a user or role.
```bash
npx @claude-flow/cli@latest claims revoke <claim>
```

### claims roles
Manage roles and their claims.
```bash
npx @claude-flow/cli@latest claims roles
```

### claims policies
Manage claim policies.
```bash
npx @claude-flow/cli@latest claims policies
```

## Common Patterns

### Set Up Role-Based Access
```bash
# List current claims
npx @claude-flow/cli@latest claims list

# Grant admin claims
npx @claude-flow/cli@latest claims grant admin:write

# Check specific permission
npx @claude-flow/cli@latest claims check agent:spawn
```

### Policy Management
```bash
# View policies
npx @claude-flow/cli@latest claims policies

# Manage roles
npx @claude-flow/cli@latest claims roles
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { ClaimsService, Role, Policy } from '@claude-flow/claims';

// Initialize claims
const claims = new ClaimsService();

// Check permission
const allowed = await claims.check('agent:spawn', userId);

// Grant claim
await claims.grant('admin:write', userId);

// Revoke claim
await claims.revoke('admin:write', userId);
```

## RAN DDD Context
**Bounded Context**: Agent Orchestration
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-security](../claude-flow-security/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/claims)
