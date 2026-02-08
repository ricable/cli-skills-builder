# Gastown Bridge Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable gastown-bridge` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable gastown-bridge` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info gastown-bridge` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade gastown-bridge` | Upgrade to latest version |

## Plugin Tools

### parse
WASM-accelerated formula parsing and evaluation.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.parse \
  --formula <string>                     # Single formula to parse
  --formulas <file>                      # Batch formulas (JSON array)
  --context <file>                       # Variable context (JSON)
  --output <file>                        # Output evaluation results
```

### graph
Workflow dependency graph analysis.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.graph \
  --workflow <file>                      # Workflow definition
  --analyze <critical-path|bottleneck|all> # Analysis type
  --detect-cycles                        # Detect circular dependencies
  --output <file>                        # Output graph analysis
  --visualize <dot|json>                 # Output format for visualization
```

### orchestrate
Hybrid workflow orchestration bridging Claude Flow and Gas Town.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.orchestrate \
  --workflow <file>                      # Workflow definition
  --agents <n>                           # Number of agents
  --bridge-mode <hybrid|gastown|claude-flow> # Execution mode
  --timeout <seconds>                    # Execution timeout
```

### translate
Workflow format translation.

```bash
npx @claude-flow/cli@latest mcp exec gastown-bridge.translate \
  --input <file>                         # Input workflow file
  --output <file>                        # Output translated workflow
  --format <gastown|claude-flow>         # Target format
  --validate                             # Validate translation
```
