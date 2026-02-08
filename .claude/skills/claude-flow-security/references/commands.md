# Claude Flow Security Command Reference

Complete reference for `npx @claude-flow/cli@latest security` subcommands.

---

## security scan
Run security scan on target.
```bash
npx @claude-flow/cli@latest security scan
```

## security cve
Check and manage CVE vulnerabilities.
```bash
npx @claude-flow/cli@latest security cve
```

## security threats
Threat modeling and analysis.
```bash
npx @claude-flow/cli@latest security threats
```

## security audit
Security audit logging and compliance.
```bash
npx @claude-flow/cli@latest security audit
```

## security secrets
Detect and manage secrets in codebase.
```bash
npx @claude-flow/cli@latest security secrets
```

## security defend
AI manipulation defense - detect prompt injection, jailbreaks, PII.
```bash
npx @claude-flow/cli@latest security defend
```

---

## Programmatic API

```typescript
import { SecurityScanner, CVEChecker, ThreatModel, SecretsDetector } from '@claude-flow/security';

// Security scan
const scanner = new SecurityScanner();
const results = await scanner.scan(targetPath);

// CVE checking
const cve = new CVEChecker();
const vulns = await cve.check();
const critical = vulns.filter(v => v.severity === 'critical');

// Secrets detection
const detector = new SecretsDetector();
const secrets = await detector.detect(path);

// Threat modeling
const model = new ThreatModel();
const threats = await model.analyze();

// Audit logging
const audit = new AuditLogger();
await audit.log({ action: 'scan', result: 'pass' });
```
