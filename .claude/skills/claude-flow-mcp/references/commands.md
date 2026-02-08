# Claude Flow MCP Command Reference

Complete reference for `npx @claude-flow/cli@latest mcp` subcommands.

---

## mcp start
Start the MCP server.
```bash
npx @claude-flow/cli@latest mcp start
```

## mcp stop
Stop the MCP server.
```bash
npx @claude-flow/cli@latest mcp stop
```

## mcp status
Show MCP server status (transport, connections, tools).
```bash
npx @claude-flow/cli@latest mcp status
```

## mcp health
Check MCP server health.
```bash
npx @claude-flow/cli@latest mcp health
```

## mcp restart
Restart the MCP server.
```bash
npx @claude-flow/cli@latest mcp restart
```

## mcp tools
List all available MCP tools.
```bash
npx @claude-flow/cli@latest mcp tools
```

## mcp toggle
Enable or disable an MCP tool.
```bash
npx @claude-flow/cli@latest mcp toggle <tool-name>
```

## mcp exec
Execute an MCP tool directly.
```bash
npx @claude-flow/cli@latest mcp exec <tool-name> [arguments]
```

## mcp logs
Show MCP server logs.
```bash
npx @claude-flow/cli@latest mcp logs
```

---

## Programmatic API

```typescript
import { MCPServer, MCPTransport, ToolRegistry } from '@claude-flow/mcp';

// Create and start MCP server
const server = new MCPServer({
  transport: 'stdio',   // 'stdio' | 'http' | 'websocket'
  tools: myTools,
  poolSize: 5,
});

await server.start();

// Register custom tools
server.registerTool({
  name: 'custom_tool',
  description: 'My custom tool',
  handler: async (args) => ({ result: 'done' }),
});
```

## MCP Configuration

Add to Claude Code via:
```bash
claude mcp add claude-flow -- npx -y @claude-flow/cli@latest
```

Or manually in `.mcp.json`:
```json
{
  "mcpServers": {
    "claude-flow": {
      "command": "npx",
      "args": ["-y", "@claude-flow/cli@latest"]
    }
  }
}
```
