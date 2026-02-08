---
name: "CF Plugin Legal Contracts"
description: "Legal contract analysis plugin with clause extraction, risk assessment, contract comparison, obligation tracking, and playbook matching. Use when extracting contract clauses, assessing contract risk, comparing contract versions, tracking obligations, or matching against legal playbooks."
---

# CF Plugin Legal Contracts

Legal contract analysis plugin for Claude Flow V3 providing clause extraction, risk assessment, contract comparison, obligation tracking, and playbook matching for legal document review workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable legal-contracts` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable legal-contracts` |
| Plugin info | `npx @claude-flow/cli@latest plugins info legal-contracts` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-legal-contracts@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable legal-contracts

# Verify activation
npx @claude-flow/cli@latest plugins info legal-contracts
```

## Plugin Capabilities

### Clause Extraction
Identifies and extracts key clauses from contracts including indemnification, limitation of liability, termination, confidentiality, IP assignment, and non-compete provisions.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.extract \
  --input contract.pdf --clauses "indemnification,termination,liability"
```

### Risk Assessment
Scores contract clauses on a risk scale, flagging unfavorable terms, missing protections, and deviations from standard positions.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.risk \
  --input contract.pdf --perspective buyer --output risk-report.json
```

### Contract Comparison
Compares two contract versions or a contract against a template, highlighting additions, deletions, and materially changed terms.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.compare \
  --base template.pdf --revised contract-v2.pdf --output diff-report.json
```

### Obligation Tracking
Extracts and tracks contractual obligations (deadlines, deliverables, payment terms) with automatic timeline generation.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.obligations \
  --input contract.pdf --output obligations.json --timeline
```

### Playbook Matching
Matches contract clauses against a legal playbook to identify deviations from preferred positions and suggest alternative language.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.playbook \
  --input contract.pdf --playbook company-playbook.json --suggest-alternatives
```

## Common Patterns

### Full Contract Review
```bash
npx @claude-flow/cli@latest plugins toggle --enable legal-contracts
npx @claude-flow/cli@latest mcp exec legal-contracts.extract \
  --input contract.pdf --clauses all
npx @claude-flow/cli@latest mcp exec legal-contracts.risk \
  --input contract.pdf --perspective buyer
npx @claude-flow/cli@latest mcp exec legal-contracts.playbook \
  --input contract.pdf --playbook company-playbook.json --suggest-alternatives
```

### Contract Renewal Comparison
```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.compare \
  --base original-contract.pdf --revised renewal-contract.pdf
npx @claude-flow/cli@latest mcp exec legal-contracts.obligations \
  --input renewal-contract.pdf --timeline
```

### Obligation Dashboard
```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.obligations \
  --input contracts/ --output all-obligations.json --timeline \
  --alert-days 30
```

## RAN DDD Context
**Bounded Context**: Legal/Compliance

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-legal-contracts)
