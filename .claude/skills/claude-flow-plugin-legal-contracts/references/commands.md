# Legal Contracts Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable legal-contracts` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable legal-contracts` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info legal-contracts` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade legal-contracts` | Upgrade to latest version |

## Plugin Tools

### extract
Extract clauses from contracts.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.extract \
  --input <file>                         # Contract document (PDF, DOCX, TXT)
  --clauses <comma-separated|all>        # Clause types to extract
  --output <file>                        # Output extracted clauses
```

**Clause types**: `indemnification`, `termination`, `liability`, `confidentiality`, `ip-assignment`, `non-compete`, `non-solicitation`, `warranty`, `force-majeure`, `governing-law`, `dispute-resolution`, `payment-terms`

### risk
Contract risk assessment.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.risk \
  --input <file>                         # Contract document
  --perspective <buyer|seller|neutral>   # Risk assessment perspective
  --output <file>                        # Output risk report
  --threshold <low|medium|high>          # Minimum risk level to report
```

### compare
Compare two contracts or contract vs template.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.compare \
  --base <file>                          # Base/template contract
  --revised <file>                       # Revised/new contract
  --output <file>                        # Output comparison report
  --focus <clauses>                      # Focus on specific clause types
```

### obligations
Extract and track contractual obligations.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.obligations \
  --input <file|directory>               # Contract(s) to analyze
  --output <file>                        # Output obligations list
  --timeline                             # Generate obligation timeline
  --alert-days <n>                       # Flag obligations due within N days
```

### playbook
Match clauses against legal playbook.

```bash
npx @claude-flow/cli@latest mcp exec legal-contracts.playbook \
  --input <file>                         # Contract to review
  --playbook <file>                      # Company playbook definition
  --suggest-alternatives                 # Suggest preferred language
  --output <file>                        # Output playbook match report
```
