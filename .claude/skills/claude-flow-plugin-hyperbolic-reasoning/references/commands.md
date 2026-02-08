# Hyperbolic Reasoning Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable hyperbolic-reasoning` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable hyperbolic-reasoning` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info hyperbolic-reasoning` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade hyperbolic-reasoning` | Upgrade to latest version |

## Plugin Tools

### embed
Generate Poincare ball embeddings for hierarchical data.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.embed \
  --input <file>                         # Input data (JSON with hierarchy)
  --dimensions <n>                       # Embedding dimensions (default: 64)
  --curvature <float>                    # Hyperbolic curvature (default: -1.0)
  --epochs <n>                           # Training epochs (default: 100)
  --output <file>                        # Output embeddings file
```

### taxonomy
Taxonomic reasoning over hierarchical concepts.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.taxonomy \
  --query <string>                       # Is-a or subsumption query
  --classify <concept>                   # Classify a new concept
  --ontology <file>                      # Ontology definition
  --depth <n>                            # Maximum traversal depth
```

### search
Hierarchical search with hyperbolic geometry.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.search \
  --query <string>                       # Search query
  --index <name>                         # Index name
  --top-k <n>                            # Number of results (default: 10)
  --threshold <float>                    # Minimum similarity threshold
```

### entailment
Entailment graph construction and querying.

```bash
npx @claude-flow/cli@latest mcp exec hyperbolic-reasoning.entailment \
  --premises <file>                      # Premise statements
  --check <conclusion>                   # Check if conclusion follows
  --ontology <file>                      # Background ontology
  --check-consistency                    # Check ontology consistency
  --report                               # Generate detailed report
```
