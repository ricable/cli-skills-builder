# Test Intelligence Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable test-intelligence` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable test-intelligence` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info test-intelligence` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade test-intelligence` | Upgrade to latest version |

## Plugin Tools

### predict
Predictive test selection based on code changes.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.predict \
  --diff <ref>                           # Git diff reference (e.g., HEAD~1)
  --confidence <float>                   # Minimum confidence threshold (default: 0.8)
  --max-tests <n>                        # Maximum tests to select
  --output <file>                        # Output selected test list
```

### flaky
Flaky test detection and analysis.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.flaky \
  --path <directory>                     # Test directory to analyze
  --history <n>                          # Number of historical runs to analyze
  --threshold <float>                    # Flakiness threshold (default: 0.05)
  --output <file>                        # Output flaky test report
  --quarantine                           # Generate quarantine config
```

### coverage
Test coverage optimization.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.coverage \
  --path <directory>                     # Source directory to analyze
  --report <gaps|summary|full>           # Report type
  --prioritize <risk|frequency|lines>    # Prioritization strategy
  --top <n>                              # Show top N gaps
  --suggest                              # Suggest new test cases
```

### impact
Test impact analysis for code changes.

```bash
npx @claude-flow/cli@latest mcp exec test-intelligence.impact \
  --diff <ref>                           # Git diff reference
  --include-transitive                   # Include transitive dependencies
  --output <file>                        # Output impact map
```
