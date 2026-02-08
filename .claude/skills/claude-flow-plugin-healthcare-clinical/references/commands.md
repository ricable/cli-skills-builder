# Healthcare Clinical Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable healthcare-clinical` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable healthcare-clinical` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info healthcare-clinical` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade healthcare-clinical` | Upgrade to latest version |

## Plugin Tools

### patient-similarity
Find patients with similar clinical profiles.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.patient-similarity \
  --patient <file>                       # Patient profile (JSON, de-identified)
  --index <name>                         # Patient database index
  --top-k <n>                            # Number of similar patients (default: 5)
  --features <comma-separated>           # Features to compare (demographics,diagnoses,medications,labs)
```

### drug-interactions
Check drug-drug interactions.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.drug-interactions \
  --medications <file>                   # Current medication list (JSON)
  --proposed-med <string>                # Proposed new medication
  --severity <minor|moderate|major|all>  # Minimum severity to report
  --include-food                         # Include food-drug interactions
  --output <file>                        # Output interaction report
```

### pathways
Clinical pathway recommendations.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.pathways \
  --diagnosis <string>                   # Primary diagnosis
  --patient <file>                       # Patient profile for personalization
  --guidelines <standard>               # Guideline source (default: latest evidence-based)
  --output <file>                        # Output pathway recommendations
```

### hipaa-check
HIPAA compliance validation.

```bash
npx @claude-flow/cli@latest mcp exec healthcare-clinical.hipaa-check \
  --workflow <file>                      # Workflow definition to validate
  --report                               # Generate compliance report
  --fail-on-violation                    # Exit with error on violations
  --output <file>                        # Output compliance report
```
