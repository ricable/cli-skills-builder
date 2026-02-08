# Agentic QE Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable agentic-qe` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable agentic-qe` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info agentic-qe` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade agentic-qe` | Upgrade to latest version |

## Plugin Tools

### list-agents
List available QE agents.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.list-agents \
  --context <bounded-context>            # Filter by DDD context (optional)
  --format <table|json>                  # Output format (default: table)
```

**Bounded Contexts**: `unit-testing`, `integration-testing`, `e2e-testing`, `performance-testing`, `security-testing`, `accessibility-testing`, `api-testing`, `data-validation`, `compliance`, `monitoring`, `reporting`, `orchestration`

### swarm
Orchestrate QE agent swarms.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.swarm \
  --goal <description>                   # Quality goal (e.g., "full regression")
  --path <directory>                     # Target codebase
  --context <bounded-context>            # Limit to specific context
  --max-agents <n>                       # Maximum agents to spawn (default: 12)
  --timeout <seconds>                    # Swarm timeout
```

### analyze
Domain-driven quality analysis.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.analyze \
  --diff <ref>                           # Git diff reference
  --context-map <file>                   # DDD context map definition
  --output <file>                        # Output analysis report
```

### gate
Quality gate enforcement.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.gate \
  --config <file>                        # Quality gates configuration
  --check                                # Run gate checks
  --fail-on-violation                    # Exit with error on violation
  --report <file>                        # Output gate results
```

### report
Generate quality reports.

```bash
npx @claude-flow/cli@latest mcp exec agentic-qe.report \
  --format <html|json|markdown>          # Report format
  --output <file>                        # Output file path
  --include <contexts>                   # Contexts to include (comma-separated)
```
