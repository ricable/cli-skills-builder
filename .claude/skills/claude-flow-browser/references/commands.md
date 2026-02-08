# Claude Flow Browser API Reference

This is a library-only module. Browser operations are accessed via MCP tools or the programmatic API.

## MCP Tools

| Tool | Description |
|------|-------------|
| `browser_open` | Open a URL |
| `browser_click` | Click an element |
| `browser_fill` | Fill an input field |
| `browser_type` | Type text character by character |
| `browser_screenshot` | Take a screenshot |
| `browser_get-text` | Get text content |
| `browser_get-title` | Get page title |
| `browser_get-url` | Get current URL |
| `browser_get-value` | Get input value |
| `browser_snapshot` | Get page DOM snapshot |
| `browser_back` | Navigate back |
| `browser_forward` | Navigate forward |
| `browser_reload` | Reload page |
| `browser_scroll` | Scroll page |
| `browser_hover` | Hover over element |
| `browser_select` | Select dropdown option |
| `browser_check` | Check checkbox |
| `browser_uncheck` | Uncheck checkbox |
| `browser_press` | Press keyboard key |
| `browser_eval` | Evaluate JavaScript |
| `browser_wait` | Wait for element |
| `browser_session-list` | List browser sessions |
| `browser_close` | Close browser |

## Programmatic API

```typescript
import { BrowserService, BrowserSession } from '@claude-flow/browser';

const browser = new BrowserService();
const session = await browser.open(url);

await session.click(selector);
await session.fill(selector, value);
await session.type(selector, text);
const text = await session.getText(selector);
const title = await session.getTitle();
const url = await session.getUrl();
await session.screenshot(path);
await session.back();
await session.forward();
await session.reload();
await session.scroll(direction, amount);
await session.hover(selector);
await session.select(selector, value);
await session.check(selector);
await session.uncheck(selector);
await session.press(key);
const result = await session.eval(expression);
await session.wait(selector, timeout);
const sessions = await browser.listSessions();
await session.close();
```
