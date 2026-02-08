# Perf Optimizer Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable perf-optimizer` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable perf-optimizer` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info perf-optimizer` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade perf-optimizer` | Upgrade to latest version |

## Plugin Tools

### bottleneck
Identify performance bottlenecks.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.bottleneck \
  --target <path>                        # Target directory or file
  --profile <cpu|io|all>                 # Profile type
  --threshold <duration>                 # Minimum duration to flag (default: 100ms)
  --output <file>                        # Output report file
```

### memory
Memory analysis and leak detection.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.memory \
  --action <analyze|leak-check|snapshot> # Operation
  --target <path>                        # Target directory
  --pid <process-id>                     # Target process ID
  --duration <seconds>                   # Monitoring duration for leak-check
  --snapshots <n>                        # Number of heap snapshots
```

### tune
Configuration tuning recommendations.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.tune \
  --config <file>                        # Configuration file to tune
  --workload <low|medium|high-throughput|current> # Workload profile
  --focus <agent-pool|memory|concurrency|all>     # Tuning focus area
  --recommend                            # Output recommendations only
  --apply                                # Apply recommended changes
```

### profile
Resource profiling for processes and swarms.

```bash
npx @claude-flow/cli@latest mcp exec perf-optimizer.profile \
  --swarm-id <swarm-id>                  # Target swarm
  --pid <process-id>                     # Or target specific process
  --duration <seconds>                   # Profile duration
  --metrics <cpu|memory|io|all>          # Metrics to collect
  --output <file>                        # Output profile data
```
