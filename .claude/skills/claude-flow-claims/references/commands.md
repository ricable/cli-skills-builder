# Claude Flow Claims Command Reference

Complete reference for `npx @claude-flow/cli@latest claims` subcommands.

---

## claims list
List claims and permissions.
```bash
npx @claude-flow/cli@latest claims list
```

## claims check
Check if a specific claim is granted.
```bash
npx @claude-flow/cli@latest claims check <claim>
```

## claims grant
Grant a claim to user or role.
```bash
npx @claude-flow/cli@latest claims grant <claim>
```

## claims revoke
Revoke a claim from user or role.
```bash
npx @claude-flow/cli@latest claims revoke <claim>
```

## claims roles
Manage roles and their claims.
```bash
npx @claude-flow/cli@latest claims roles
```

## claims policies
Manage claim policies.
```bash
npx @claude-flow/cli@latest claims policies
```

---

## Programmatic API

```typescript
import { ClaimsService, Role, Policy } from '@claude-flow/claims';

const claims = new ClaimsService();

// Check
const allowed = await claims.check('agent:spawn', userId);

// Grant/Revoke
await claims.grant('admin:write', userId);
await claims.revoke('admin:write', userId);

// Roles
const role = await claims.createRole('admin', ['agent:spawn', 'swarm:init']);
await claims.assignRole(userId, role);

// Policies
await claims.createPolicy({
  name: 'agent-management',
  claims: ['agent:spawn', 'agent:stop'],
  conditions: { maxAgents: 10 },
});
```
