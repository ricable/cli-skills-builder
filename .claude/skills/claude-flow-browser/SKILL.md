---
name: "Claude Flow Browser"
description: "Browser automation for AI agents with Playwright integration, page snapshots, form filling, and navigation. Use when automating browser interactions, scraping web content, filling forms, or testing web applications from within agent workflows."
---

# Claude Flow Browser

Browser automation module integrating agent-browser with Claude Flow swarms. Provides headless and headed browser control via Playwright for web scraping, form automation, testing, and interactive browsing.

## Quick Command Reference

This is a library-only module with no direct CLI subcommands. Browser operations are accessed via the MCP tools or programmatic API.

| Task | MCP Tool |
|------|----------|
| Open URL | `browser_open` |
| Click element | `browser_click` |
| Fill input | `browser_fill` |
| Type text | `browser_type` |
| Take screenshot | `browser_screenshot` |
| Get page text | `browser_get-text` |
| Get page title | `browser_get-title` |
| Get current URL | `browser_get-url` |
| Page snapshot | `browser_snapshot` |
| Navigate back | `browser_back` |
| Navigate forward | `browser_forward` |
| Reload page | `browser_reload` |
| Scroll page | `browser_scroll` |
| Hover element | `browser_hover` |
| Select option | `browser_select` |
| Check checkbox | `browser_check` |
| Uncheck checkbox | `browser_uncheck` |
| Press key | `browser_press` |
| Evaluate JS | `browser_eval` |
| Wait for element | `browser_wait` |
| List sessions | `browser_session-list` |
| Close browser | `browser_close` |

## MCP Tool Usage

### browser_open
Open a URL in the browser.
```
Tool: browser_open
Args: { "url": "https://example.com" }
```

### browser_click
Click an element on the page.
```
Tool: browser_click
Args: { "selector": "#submit-button" }
```

### browser_fill
Fill an input field with text.
```
Tool: browser_fill
Args: { "selector": "#email", "value": "user@example.com" }
```

### browser_type
Type text character by character.
```
Tool: browser_type
Args: { "selector": "#search", "text": "query" }
```

### browser_screenshot
Take a screenshot of the current page.
```
Tool: browser_screenshot
Args: { "path": "screenshot.png" }
```

### browser_get-text
Get text content from the page.
```
Tool: browser_get-text
Args: { "selector": ".content" }
```

### browser_snapshot
Get a structured snapshot of the page DOM.
```
Tool: browser_snapshot
Args: {}
```

### browser_eval
Evaluate JavaScript in the browser context.
```
Tool: browser_eval
Args: { "expression": "document.title" }
```

### browser_wait
Wait for an element to appear.
```
Tool: browser_wait
Args: { "selector": ".loaded", "timeout": 5000 }
```

## Common Patterns

### Web Scraping Workflow
```
1. browser_open -> { "url": "https://example.com" }
2. browser_wait -> { "selector": ".content" }
3. browser_get-text -> { "selector": ".content" }
4. browser_close -> {}
```

### Form Filling Workflow
```
1. browser_open -> { "url": "https://example.com/form" }
2. browser_fill -> { "selector": "#name", "value": "John" }
3. browser_fill -> { "selector": "#email", "value": "john@example.com" }
4. browser_click -> { "selector": "#submit" }
5. browser_wait -> { "selector": ".success" }
```

### Screenshot Testing
```
1. browser_open -> { "url": "https://example.com" }
2. browser_wait -> { "selector": ".loaded" }
3. browser_screenshot -> { "path": "test.png" }
```

## Programmatic API
```typescript
import { BrowserService, BrowserSession } from '@claude-flow/browser';

// Create browser session
const browser = new BrowserService();
const session = await browser.open('https://example.com');

// Interact with page
await session.click('#button');
await session.fill('#input', 'text');
const text = await session.getText('.content');
await session.screenshot('output.png');

// Close
await session.close();
```

## RAN DDD Context
**Bounded Context**: DevOps/Tools
**Related Skills**: [claude-flow](../claude-flow/), [claude-flow-mcp](../claude-flow-mcp/)

## References
- **Complete command reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@claude-flow/browser)
