---
name: ruvbot
description: "Self-learning AI assistant CLI with multi-channel deployment, agent swarms, and plugin system. Use when initializing or configuring a RuvBot instance, managing bot skills and plugins, deploying to Slack/Discord/Teams channels, running diagnostics, or orchestrating AI agent templates."
---

# RuvBot

Self-learning AI assistant with enterprise security, HNSW vector search, multi-LLM support, and multi-channel deployment. Provides CLI for bot lifecycle management, agent orchestration, plugin management, and cloud deployment.

## Quick Command Reference

| Task | Command |
|------|---------|
| Show help | `npx ruvbot@latest --help` |
| Initialize | `npx ruvbot@latest init` |
| Start server | `npx ruvbot@latest start` |
| Check status | `npx ruvbot@latest status` |
| Run diagnostics | `npx ruvbot@latest doctor` |
| Manage config | `npx ruvbot@latest config` |
| Manage skills | `npx ruvbot@latest skills` |
| Manage plugins | `npx ruvbot@latest plugins` |
| Memory commands | `npx ruvbot@latest memory` |
| Security scan | `npx ruvbot@latest security` |
| Agent management | `npx ruvbot@latest agent` |
| Templates | `npx ruvbot@latest templates` |
| Deploy template | `npx ruvbot@latest deploy <template-id>` |
| Channel setup | `npx ruvbot@latest channels` |
| Webhooks | `npx ruvbot@latest webhooks` |
| Cloud deploy | `npx ruvbot@latest deploy-cloud` |
| Version info | `npx ruvbot@latest version` |

## Installation

**Install**: `npx ruvbot@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core Commands

### init
Initialize RuvBot in the current directory.
```bash
npx ruvbot@latest init [options]
```

### start
Start the RuvBot server.
```bash
npx ruvbot@latest start [options]
```
**Options:** `--port <n>`, `--host <string>`, `--daemon`, `--debug`

### config
Manage configuration settings.
```bash
npx ruvbot@latest config
npx ruvbot@latest config set <key> <value>
npx ruvbot@latest config get <key>
npx ruvbot@latest config list
```

### status
Show bot status and health metrics.
```bash
npx ruvbot@latest status [--format json]
```

### doctor
Run diagnostics and health checks.
```bash
npx ruvbot@latest doctor [--fix] [--verbose]
```

### skills
Manage bot skills and capabilities.
```bash
npx ruvbot@latest skills
npx ruvbot@latest skills list
npx ruvbot@latest skills add <skill-name>
npx ruvbot@latest skills remove <skill-name>
```

### memory
Memory management commands.
```bash
npx ruvbot@latest memory
npx ruvbot@latest memory search <query>
npx ruvbot@latest memory stats
```

### security
Security scanning and audit commands.
```bash
npx ruvbot@latest security
npx ruvbot@latest security scan
npx ruvbot@latest security audit
```

### plugins
Plugin management commands.
```bash
npx ruvbot@latest plugins list
npx ruvbot@latest plugins install <plugin>
npx ruvbot@latest plugins remove <plugin>
```

### agent
Agent and swarm management commands.
```bash
npx ruvbot@latest agent list
npx ruvbot@latest agent spawn --type <type>
npx ruvbot@latest agent status <id>
```

### templates / deploy
Manage and deploy agent templates.
```bash
npx ruvbot@latest templates list
npx ruvbot@latest deploy <template-id>
```

### channels
Manage channel integrations (Slack, Discord, Teams).
```bash
npx ruvbot@latest channels add <platform> --token $TOKEN
npx ruvbot@latest channels list
```

### webhooks
Configure webhook integrations.
```bash
npx ruvbot@latest webhooks add <url>
npx ruvbot@latest webhooks list
```

### deploy-cloud
Deploy RuvBot to cloud platforms.
```bash
npx ruvbot@latest deploy-cloud --provider aws
```

## Common Patterns

### Quick Setup
```bash
npx ruvbot@latest init --template chatbot
npx ruvbot@latest config set model claude-sonnet-4-5-20250929
npx ruvbot@latest start
```

### Production Deployment
```bash
npx ruvbot@latest init --template enterprise
npx ruvbot@latest security scan
npx ruvbot@latest doctor --fix
npx ruvbot@latest deploy-cloud --provider aws
```

### Multi-Channel Bot
```bash
npx ruvbot@latest channels add slack --token $SLACK_TOKEN
npx ruvbot@latest channels add discord --token $DISCORD_TOKEN
npx ruvbot@latest start --daemon
```

## RAN DDD Context
**Bounded Context**: Troubleshooting

## References
- **Command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/ruvbot)
