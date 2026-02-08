---
name: "Claude Flow Security"
description: "Security scanning with CVE detection, threat modeling, audit logging, secrets detection, and AI manipulation defense. Use when running security scans, checking for CVEs, modeling threats, auditing compliance, or detecting secrets in code."
---

# Claude Flow Security

Security module providing CVE detection, threat modeling, audit logging, secrets detection, input validation, path security, and AI manipulation defense.

## Quick Command Reference

| Task | Command |
|------|---------|
| Run security scan | `npx @claude-flow/cli@latest security scan` |
| Check CVEs | `npx @claude-flow/cli@latest security cve` |
| Threat modeling | `npx @claude-flow/cli@latest security threats` |
| Security audit | `npx @claude-flow/cli@latest security audit` |
| Detect secrets | `npx @claude-flow/cli@latest security secrets` |
| AI defense | `npx @claude-flow/cli@latest security defend` |

## Core Commands

### security scan
Run a security scan on the target project.
```bash
npx @claude-flow/cli@latest security scan
```

### security cve
Check and manage CVE vulnerabilities.
```bash
npx @claude-flow/cli@latest security cve
```

### security threats
Threat modeling and analysis.
```bash
npx @claude-flow/cli@latest security threats
```

### security audit
Security audit logging and compliance checking.
```bash
npx @claude-flow/cli@latest security audit
```

### security secrets
Detect and manage secrets in the codebase.
```bash
npx @claude-flow/cli@latest security secrets
```

### security defend
AI manipulation defense - detect prompt injection, jailbreaks, PII. See [claude-flow-aidefence](../claude-flow-aidefence/) for details.
```bash
npx @claude-flow/cli@latest security defend
```

## Common Patterns

### Full Security Audit
```bash
# Run comprehensive scan
npx @claude-flow/cli@latest security scan

# Check for known CVEs
npx @claude-flow/cli@latest security cve

# Detect leaked secrets
npx @claude-flow/cli@latest security secrets

# Run threat model
npx @claude-flow/cli@latest security threats
```

### Pre-Commit Security Check
```bash
# Quick scan before committing
npx @claude-flow/cli@latest security scan
npx @claude-flow/cli@latest security secrets
```

### Compliance Audit
```bash
# Run audit
npx @claude-flow/cli@latest security audit

# Check AI defense posture
npx @claude-flow/cli@latest security defend
```

## Key Options

- `--verbose`: Enable verbose output
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { SecurityScanner, CVEChecker, ThreatModel, SecretsDetector } from '@claude-flow/security';

// Run scan
const scanner = new SecurityScanner();
const results = await scanner.scan('./src');

// Check CVEs
const cve = new CVEChecker();
const vulnerabilities = await cve.check();

// Detect secrets
const secrets = new SecretsDetector();
const found = await secrets.detect('./');

// Threat modeling
const threats = new ThreatModel();
const model = await threats.analyze();
```

## RAN DDD Context
**Bounded Context**: Security
**Related Skills**: [claude-flow-aidefence](../claude-flow-aidefence/), [claude-flow](../claude-flow/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/security)
