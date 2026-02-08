# Code Intelligence Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable code-intelligence` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable code-intelligence` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info code-intelligence` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade code-intelligence` | Upgrade to latest version |

## Plugin Tools

### search
Semantic code search using embeddings.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.search \
  --query <string>                       # Natural language search query
  --path <directory>                     # Codebase path to search
  --top-k <n>                            # Number of results (default: 10)
  --language <lang>                      # Filter by language
  --threshold <float>                    # Minimum similarity score
```

### architecture
Codebase architecture analysis.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.architecture \
  --path <directory>                     # Codebase path
  --detect-pattern                       # Detect architectural patterns
  --check-violations                     # Check for architecture violations
  --report                               # Generate report
  --output <file>                        # Output file
```

### refactor-impact
Refactoring impact assessment.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.refactor-impact \
  --target <file>                        # File being refactored
  --change <description>                 # Change description
  --report                               # Generate impact report
  --include-tests                        # Include test impact
```

### split
Module splitting recommendations.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.split \
  --target <file>                        # File to analyze for splitting
  --path <directory>                     # Or scan entire directory
  --threshold <lines>                    # Line count threshold (default: 500)
  --strategy <cohesion|coupling|domain>  # Splitting strategy
  --scan-oversized                       # Find all oversized modules
  --analyze-cohesion                     # Show cohesion metrics
```

### learn
Code pattern learning.

```bash
npx @claude-flow/cli@latest mcp exec code-intelligence.learn \
  --path <directory>                     # Codebase to learn from
  --patterns <comma-separated>           # Pattern categories to learn
  --output <file>                        # Output learned patterns
  --suggest                              # Suggest patterns for current context
```
