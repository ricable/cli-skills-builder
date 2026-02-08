---
name: "Claude Flow MCP"
description: "MCP (Model Context Protocol) server for Claude Flow - stdio/http/websocket transports, tool registry, connection pooling. Use when starting or managing the MCP server, listing tools, or integrating MCP into applications."
---

# Claude Flow MCP

Standalone MCP (Model Context Protocol) server for Claude Flow with stdio/http/websocket transports, connection pooling, and tool registry.

## Quick Command Reference

| Task | Command |
|------|---------|
| Start MCP server | `npx @claude-flow/cli@latest mcp start` |
| Stop MCP server | `npx @claude-flow/cli@latest mcp stop` |
| Check status | `npx @claude-flow/cli@latest mcp status` |
| Health check | `npx @claude-flow/cli@latest mcp health` |
| Restart server | `npx @claude-flow/cli@latest mcp restart` |
| List tools | `npx @claude-flow/cli@latest mcp tools` |
| Toggle tool | `npx @claude-flow/cli@latest mcp toggle <tool>` |
| Execute tool | `npx @claude-flow/cli@latest mcp exec <tool> [args]` |
| View logs | `npx @claude-flow/cli@latest mcp logs` |

## Core Commands

### mcp start
Start the MCP server.
```bash
npx @claude-flow/cli@latest mcp start
```

### mcp stop
Stop the MCP server.
```bash
npx @claude-flow/cli@latest mcp stop
```

### mcp status
Show MCP server status including transport, connections, and tool count.
```bash
npx @claude-flow/cli@latest mcp status
```

### mcp health
Check MCP server health and responsiveness.
```bash
npx @claude-flow/cli@latest mcp health
```

### mcp restart
Restart the MCP server.
```bash
npx @claude-flow/cli@latest mcp restart
```

### mcp tools
List all available MCP tools with their descriptions and parameters.
```bash
npx @claude-flow/cli@latest mcp tools
```

### mcp toggle
Enable or disable a specific MCP tool.
```bash
npx @claude-flow/cli@latest mcp toggle <tool-name>
```

### mcp exec
Execute an MCP tool directly from the command line.
```bash
npx @claude-flow/cli@latest mcp exec <tool-name> [arguments]
```

### mcp logs
Show MCP server logs.
```bash
npx @claude-flow/cli@latest mcp logs
```

## Common Patterns

### Quick MCP Setup for Claude Code
```bash
# Add MCP server to Claude Code
claude mcp add claude-flow -- npx -y @claude-flow/cli@latest

# Start the server
npx @claude-flow/cli@latest mcp start

# Verify it's running
npx @claude-flow/cli@latest mcp health
```

### Manage MCP Tools
```bash
# List all tools
npx @claude-flow/cli@latest mcp tools

# Disable a tool
npx @claude-flow/cli@latest mcp toggle memory_store

# Execute a tool directly
npx @claude-flow/cli@latest mcp exec memory_search --query "pattern"
```

### Monitor MCP Server
```bash
# Check status
npx @claude-flow/cli@latest mcp status

# View logs
npx @claude-flow/cli@latest mcp logs

# Restart if needed
npx @claude-flow/cli@latest mcp restart
```

## Key Options

- `--verbose`: Enable verbose output for debugging
- `--format`: Output format (text, json, table)

## Programmatic API
```typescript
import { MCPServer, MCPTransport } from '@claude-flow/mcp';

// Create MCP server with stdio transport
const server = new MCPServer({
  transport: 'stdio',
  tools: registeredTools,
});

// Start serving
await server.start();
```

## RAN DDD Context
**Bounded Context**: Cross-Cutting
**Related Skills**: [claude-flow-cli](../claude-flow-cli/), [claude-flow](../claude-flow/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/mcp)
