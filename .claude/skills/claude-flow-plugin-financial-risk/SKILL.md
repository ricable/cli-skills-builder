---
name: "CF Plugin Financial Risk"
description: "Financial risk analysis plugin with portfolio risk scoring, anomaly detection, market regime classification, and compliance reporting. Use when scoring portfolio risk, detecting financial anomalies, classifying market regimes, generating compliance reports, or stress-testing portfolios."
---

# CF Plugin Financial Risk

High-performance financial risk analysis plugin providing portfolio risk scoring, anomaly detection, market regime classification, and compliance reporting for financial applications and regulatory workflows.

## Quick Command Reference

| Task | Command |
|------|---------|
| Enable plugin | `npx @claude-flow/cli@latest plugins toggle --enable financial-risk` |
| Disable plugin | `npx @claude-flow/cli@latest plugins toggle --disable financial-risk` |
| Plugin info | `npx @claude-flow/cli@latest plugins info financial-risk` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Check status | `npx @claude-flow/cli@latest plugins list` |

## Installation

**Via claude-flow**: Already included with `npx @claude-flow/cli@latest init`
**Standalone**: `npx @claude-flow/plugin-financial-risk@latest`

## Activation

```bash
# Enable the plugin
npx @claude-flow/cli@latest plugins toggle --enable financial-risk

# Verify activation
npx @claude-flow/cli@latest plugins info financial-risk
```

## Plugin Capabilities

### Portfolio Risk Scoring
Computes VaR (Value at Risk), CVaR, Sharpe ratio, and composite risk scores for portfolio positions using historical simulation and parametric methods.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.score \
  --portfolio positions.json --method historical --confidence 0.99
```

### Anomaly Detection
Detects unusual trading patterns, price movements, and volume spikes using statistical and ML-based anomaly detection.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.anomaly \
  --data market-data.json --method isolation-forest --sensitivity high
```

### Market Regime Classification
Classifies current market conditions (bull, bear, sideways, high-volatility) using regime-switching models to adjust risk parameters.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.regime \
  --data market-data.json --lookback 252 --output regime-report.json
```

### Compliance Reporting
Generates regulatory compliance reports (Basel III, Dodd-Frank, MiFID II) with automated threshold checking and exception flagging.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.compliance \
  --framework basel3 --portfolio positions.json --output compliance-report.json
```

### Stress Testing
Runs portfolio stress tests under historical and hypothetical scenarios to assess potential losses under adverse conditions.

```bash
npx @claude-flow/cli@latest mcp exec financial-risk.stress-test \
  --portfolio positions.json --scenarios "2008-crisis,rate-shock,pandemic"
```

## Common Patterns

### Daily Risk Report
```bash
npx @claude-flow/cli@latest plugins toggle --enable financial-risk
npx @claude-flow/cli@latest mcp exec financial-risk.score \
  --portfolio positions.json --method historical --confidence 0.99
npx @claude-flow/cli@latest mcp exec financial-risk.regime \
  --data market-data.json --lookback 252
npx @claude-flow/cli@latest mcp exec financial-risk.anomaly \
  --data market-data.json --method isolation-forest
```

### Regulatory Compliance Check
```bash
npx @claude-flow/cli@latest mcp exec financial-risk.compliance \
  --framework basel3 --portfolio positions.json --check-thresholds --fail-on-breach
```

### Pre-Trade Risk Assessment
```bash
npx @claude-flow/cli@latest mcp exec financial-risk.score \
  --portfolio positions.json --proposed-trade trade.json --impact-analysis
npx @claude-flow/cli@latest mcp exec financial-risk.stress-test \
  --portfolio positions.json --proposed-trade trade.json --scenarios worst-case
```

## RAN DDD Context
**Bounded Context**: RANO Optimization

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/plugin-financial-risk)
