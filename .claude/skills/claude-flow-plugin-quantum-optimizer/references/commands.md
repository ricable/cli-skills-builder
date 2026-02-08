# Quantum Optimizer Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable quantum-optimizer` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable quantum-optimizer` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info quantum-optimizer` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade quantum-optimizer` | Upgrade to latest version |

## Plugin Tools

### anneal
Simulated annealing optimization.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.anneal \
  --problem <file|json>                  # Problem definition
  --temperature <float>                  # Initial temperature (default: 1.0)
  --cooling-rate <float>                 # Cooling rate (default: 0.95)
  --iterations <n>                       # Max iterations (default: 10000)
  --seed <n>                             # Random seed for reproducibility
```

### qaoa
Quantum Approximate Optimization Algorithm.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.qaoa \
  --problem <file|json>                  # Problem definition (graph, max-cut, etc.)
  --layers <n>                           # QAOA circuit depth (default: 3)
  --iterations <n>                       # Variational optimization iterations
  --optimizer <cobyla|nelder-mead>       # Classical optimizer
```

### grover
Grover-style quadratic speedup search.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.grover \
  --oracle <file|json>                   # Oracle/constraint definition
  --search-space <n>                     # Size of search space
  --max-iterations <n>                   # Maximum Grover iterations
```

### resolve-deps
Dependency graph resolution.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.resolve-deps \
  --graph <file>                         # Dependency graph (JSON/YAML)
  --strategy <optimal|parallel|serial>   # Resolution strategy
  --detect-circular                      # Flag circular dependencies
  --output <file>                        # Output resolved order
```

### schedule
Task schedule optimization.

```bash
npx @claude-flow/cli@latest mcp exec quantum-optimizer.schedule \
  --tasks <file>                         # Task definitions with durations
  --agents <n>                           # Number of available agents
  --optimize <makespan|cost|balanced>    # Optimization target
  --constraints <file>                   # Resource/precedence constraints
  --output <file>                        # Output schedule
```
