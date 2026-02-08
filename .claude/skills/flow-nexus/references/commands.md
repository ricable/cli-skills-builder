# Flow Nexus CLI Command Reference

Complete reference for all `flow-nexus` CLI commands and options.

## Table of Contents

- [init](#init)
- [swarm](#swarm)
- [challenge](#challenge)
- [check / system](#check--system)
- [sandbox](#sandbox)
- [credits](#credits)
- [deploy](#deploy)
- [auth](#auth)
- [template](#template)
- [store](#store)
- [leaderboard](#leaderboard)
- [storage](#storage)
- [workflow](#workflow)
- [monitor](#monitor)
- [profile](#profile)
- [achievements](#achievements)
- [seraphina / chat](#seraphina--chat)
- [mcp](#mcp)

---

## init

Initialize a new Flow Nexus project.

```bash
npx flow-nexus@latest init [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--template <name>` | Project template |
| `--force` | Overwrite existing config |
| `--name <string>` | Project name |

---

## swarm

Manage AI agent swarms.

```bash
npx flow-nexus@latest swarm [options] [action] [topology]
```

**Actions:** `init`, `start`, `stop`, `status`, `scale`, `list`

**Options:**
| Option | Description |
|--------|-------------|
| `--topology <type>` | Swarm topology (mesh, hierarchical, star, ring) |
| `--agents <n>` | Number of agents |
| `--strategy <name>` | Orchestration strategy |

**Examples:**
```bash
npx flow-nexus@latest swarm init --topology mesh --agents 5
npx flow-nexus@latest swarm start
npx flow-nexus@latest swarm status
npx flow-nexus@latest swarm scale --agents 10
npx flow-nexus@latest swarm stop
```

---

## challenge

Browse and complete gamified challenges.

```bash
npx flow-nexus@latest challenge [options] [action]
```

**Actions:** `list`, `start`, `submit`, `info`, `hint`

**Options:**
| Option | Description |
|--------|-------------|
| `--difficulty <level>` | Filter by difficulty |
| `--category <name>` | Filter by category |

**Examples:**
```bash
npx flow-nexus@latest challenge list
npx flow-nexus@latest challenge list --difficulty beginner
npx flow-nexus@latest challenge start mcp-basics
npx flow-nexus@latest challenge submit --solution ./solution.ts
npx flow-nexus@latest challenge hint
```

---

## check / system

System check and validation.

```bash
npx flow-nexus@latest check [options]
npx flow-nexus@latest system [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--fix` | Auto-fix issues |
| `--verbose` | Detailed output |

---

## sandbox

Manage cloud sandboxes for isolated development.

```bash
npx flow-nexus@latest sandbox [options] [action]
```

**Actions:** `create`, `list`, `destroy`, `connect`, `status`

**Options:**
| Option | Description |
|--------|-------------|
| `--runtime <type>` | Runtime environment |
| `--timeout <min>` | Auto-destroy timeout |

---

## credits

Check rUv credit balance.

```bash
npx flow-nexus@latest credits [options] [action]
```

**Actions:** `balance`, `history`, `purchase`

---

## deploy

Deploy to production.

```bash
npx flow-nexus@latest deploy [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--target <env>` | Target environment |
| `--dry-run` | Preview deployment |
| `--force` | Skip confirmations |

---

## auth

Authentication management.

```bash
npx flow-nexus@latest auth [options] [action]
```

**Actions:** `login`, `logout`, `status`, `token`, `refresh`

---

## template

Manage deployment templates.

```bash
npx flow-nexus@latest template [options] [action] [name]
```

**Actions:** `list`, `create`, `info`, `delete`, `export`, `import`

**Examples:**
```bash
npx flow-nexus@latest template list
npx flow-nexus@latest template create my-template
npx flow-nexus@latest template info my-template
npx flow-nexus@latest template export my-template --output ./template.json
```

---

## store

App marketplace.

```bash
npx flow-nexus@latest store [options] [action] [app]
```

**Actions:** `list`, `search`, `install`, `uninstall`, `info`, `rate`

**Examples:**
```bash
npx flow-nexus@latest store list
npx flow-nexus@latest store search "vector database"
npx flow-nexus@latest store install code-reviewer
npx flow-nexus@latest store info code-reviewer
npx flow-nexus@latest store rate code-reviewer --stars 5
```

---

## leaderboard

View rankings and scores.

```bash
npx flow-nexus@latest leaderboard [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--timeframe <period>` | Time period (daily, weekly, monthly, all-time) |
| `--category <name>` | Category filter |
| `--limit <n>` | Number of entries |

---

## storage

File storage management.

```bash
npx flow-nexus@latest storage [options] [action] [file]
```

**Actions:** `upload`, `download`, `list`, `delete`, `info`

---

## workflow

Automation workflow management.

```bash
npx flow-nexus@latest workflow [action] [name]
```

**Actions:** `list`, `create`, `run`, `stop`, `status`, `delete`, `export`

---

## monitor

System monitoring.

```bash
npx flow-nexus@latest monitor [options] [action]
```

**Actions:** `start`, `stop`, `status`, `dashboard`, `alerts`

---

## profile

Manage user profile and settings.

```bash
npx flow-nexus@latest profile [options] [action]
```

**Actions:** `view`, `edit`, `settings`, `export`

---

## achievements

View achievements and badges.

```bash
npx flow-nexus@latest achievements [options]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--unlocked` | Show only unlocked |
| `--locked` | Show only locked |
| `--category <name>` | Filter by category |

---

## seraphina / chat

Seek audience with Queen Seraphina AI assistant.

```bash
npx flow-nexus@latest seraphina [options] [question]
npx flow-nexus@latest chat [options] [question]
```

**Options:**
| Option | Description |
|--------|-------------|
| `--mode <type>` | Interaction mode (chat, guide, review) |
| `--context <path>` | Additional context file |

**Examples:**
```bash
npx flow-nexus@latest seraphina "How do I configure MCP servers?"
npx flow-nexus@latest chat "Review my swarm configuration"
npx flow-nexus@latest seraphina --mode guide "Set up first project"
```

---

## mcp

MCP server management.

```bash
npx flow-nexus@latest mcp [options] [action]
```

**Actions:** `start`, `stop`, `status`, `list`, `tools`

**Options:**
| Option | Description |
|--------|-------------|
| `--port <n>` | Server port |
| `--host <string>` | Bind host |
