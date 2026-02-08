---
name: "CF Plugin Healthcare Clinical"
description: "HIPAA-compliant clinical decision support plugin with patient similarity search, drug interaction detection, and clinical pathway recommendations. Use when building clinical decision support, checking drug interactions, finding similar patient cases, or recommending clinical pathways."
---

# CF Plugin Healthcare Clinical

HIPAA-compliant clinical decision support plugin providing patient similarity search, drug interaction detection, and clinical pathway recommendations for healthcare applications requiring regulatory compliance.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable healthcare-clinical` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable healthcare-clinical` |
| Plugin info | `npx @claude-flow/cli@latest plugins info healthcare-clinical` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-healthcare-clinical@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable healthcare-clinical

# Verify activation
npx @claude-flow/cli@latest plugins info healthcare-clinical
```

## Plugin Capabilities

### Patient Similarity Search
Finds patients with similar clinical profiles using embedding-based similarity over demographics, diagnoses, medications, and lab results. All data stays local; HIPAA-compliant by design.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.patient-similarity \
  --patient patient-profile.json --top-k 5 --index patient-db
```

### Drug Interaction Detection
Checks for known and predicted drug-drug interactions, contraindications, and dosage conflicts across a patient's medication list.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.drug-interactions \
  --medications medications.json --severity moderate --include-food
```

### Clinical Pathway Recommendations
Recommends evidence-based clinical pathways for given diagnoses, considering patient history, comorbidities, and current guidelines.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.pathways \
  --diagnosis "Type 2 Diabetes" --patient patient-profile.json
```

### HIPAA Compliance Validation
Validates that data handling workflows meet HIPAA requirements, checking for PHI exposure, audit trail completeness, and access controls.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.hipaa-check \
  --workflow workflow-definition.json --report
```

## Common Patterns

### Clinical Decision Support Workflow
```bash
npx @claude-flow/cli@latest plugins toggle --enable healthcare-clinical
npx @claude-flow/cli@latest mcp exec healthcare-clinical.drug-interactions \
  --medications patient-meds.json --severity all
npx @claude-flow/cli@latest mcp exec healthcare-clinical.pathways \
  --diagnosis "Hypertension" --patient patient-profile.json
npx @claude-flow/cli@latest mcp exec healthcare-clinical.patient-similarity \
  --patient patient-profile.json --top-k 3
```

### Medication Review
```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.drug-interactions \
  --medications current-meds.json --proposed-med "Warfarin 5mg" \
  --severity all --include-food
```

### HIPAA Audit
```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.hipaa-check \
  --workflow data-pipeline.json --report --fail-on-violation
```

## RAN DDD Context
**Bounded Context**: Scientific

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-healthcare-clinical)
