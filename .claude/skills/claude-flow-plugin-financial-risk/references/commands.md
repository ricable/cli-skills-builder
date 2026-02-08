# Financial Risk Plugin - Command Reference

## Plugin Management

| Command | Description |
|---------|-------------|
| `npx @claude-flow/cli@latest plugins toggle --enable financial-risk` | Enable the plugin |
| `npx @claude-flow/cli@latest plugins toggle --disable financial-risk` | Disable the plugin |
| `npx @claude-flow/cli@latest plugins info financial-risk` | Show plugin details and status |
| `npx @claude-flow/cli@latest plugins upgrade financial-risk` | Upgrade to latest version |

## Plugin Tools

### score
Portfolio risk scoring.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.score \
  --portfolio <file>                     # Portfolio positions (JSON)
  --method <historical|parametric|monte-carlo> # Calculation method
  --confidence <float>                   # Confidence level (default: 0.95)
  --horizon <days>                       # Risk horizon in days (default: 1)
  --proposed-trade <file>                # Optional trade to assess impact
  --impact-analysis                      # Show marginal impact of proposed trade
```

### anomaly
Financial anomaly detection.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.anomaly \
  --data <file>                          # Market/trading data (JSON/CSV)
  --method <isolation-forest|z-score|mad> # Detection method
  --sensitivity <low|medium|high>        # Sensitivity level
  --output <file>                        # Output anomaly report
```

### regime
Market regime classification.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.regime \
  --data <file>                          # Market data (JSON/CSV)
  --lookback <days>                      # Lookback period (default: 252)
  --output <file>                        # Output regime report
```

### compliance
Regulatory compliance reporting.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.compliance \
  --framework <basel3|dodd-frank|mifid2> # Regulatory framework
  --portfolio <file>                     # Portfolio data
  --check-thresholds                     # Check against regulatory thresholds
  --fail-on-breach                       # Exit with error on threshold breach
  --output <file>                        # Output compliance report
```

### stress-test
Portfolio stress testing.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.stress-test \
  --portfolio <file>                     # Portfolio positions
  --scenarios <comma-separated>          # Scenario names or file
  --proposed-trade <file>                # Optional proposed trade
  --output <file>                        # Output stress test results
```
