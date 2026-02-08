---
name: "@ruvector/server"
description: "HTTP/gRPC server for RuVector with REST API, streaming, and authentication. Use when the user needs to deploy a vector database server, expose vector search over HTTP or gRPC, configure server authentication, manage collections via REST endpoints, or set up a production vector search service."
---

# @ruvector/server

HTTP and gRPC server for the RuVector vector database, providing a full REST API with streaming support, authentication, collection management, and production-grade deployment features.

## Quick Command Reference

| Task | Code / Command |
|------|---------------|
| Start server | `npx @ruvector/server@latest --port 8080` |
| Create server (API) | `const server = createServer({ port: 8080 })` |
| Insert via REST | `POST /api/v1/collections/:name/vectors` |
| Search via REST | `POST /api/v1/collections/:name/search` |
| Health check | `GET /api/v1/health` |
| List collections | `GET /api/v1/collections` |
| Start with TLS | `npx @ruvector/server@latest --tls --cert c.pem --key k.pem` |
| Start with auth | `npx @ruvector/server@latest --auth-token $TOKEN` |

## Installation

**Hub install** (recommended): `npx ruvector@latest` includes this package.
**Standalone**: `npx @ruvector/server@latest`
See [Installation Guide](../_shared/installation-guide.md) for the full ecosystem.

## Core API

### Programmatic Server

```typescript
import { createServer } from '@ruvector/server';

const server = createServer({
  port: 8080,
  grpcPort: 50051,        // Optional gRPC
  persistPath: './data',
  authToken: process.env.RV_TOKEN,
  cors: true,
  tls: { cert: 'cert.pem', key: 'key.pem' },
});

await server.start();
```

**Server Options:**
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `port` | `number` | HTTP port | `8080` |
| `grpcPort` | `number` | gRPC port | Disabled |
| `host` | `string` | Bind address | `0.0.0.0` |
| `persistPath` | `string` | Data persistence directory | In-memory |
| `authToken` | `string` | Bearer token for auth | - |
| `cors` | `boolean` | Enable CORS | `false` |
| `tls` | `{ cert, key }` | TLS configuration | - |
| `maxConnections` | `number` | Max concurrent connections | `1000` |

### REST API Endpoints

#### Collections
```bash
GET    /api/v1/collections                          # List all collections
POST   /api/v1/collections                          # Create collection
GET    /api/v1/collections/:name                    # Get collection info
DELETE /api/v1/collections/:name                    # Delete collection
```

#### Vectors
```bash
POST   /api/v1/collections/:name/vectors            # Insert vector(s)
GET    /api/v1/collections/:name/vectors/:id         # Get vector by ID
DELETE /api/v1/collections/:name/vectors/:id         # Delete vector
PUT    /api/v1/collections/:name/vectors/:id         # Update vector
POST   /api/v1/collections/:name/vectors/batch       # Batch insert
```

#### Search
```bash
POST   /api/v1/collections/:name/search             # Vector search
POST   /api/v1/collections/:name/search/batch       # Batch search
```

#### Management
```bash
GET    /api/v1/health                                # Health check
GET    /api/v1/metrics                               # Prometheus metrics
POST   /api/v1/collections/:name/index/build         # Build HNSW index
GET    /api/v1/collections/:name/index/status        # Index status
```

### Request/Response Examples

**Create Collection:**
```bash
curl -X POST http://localhost:8080/api/v1/collections \
  -H "Content-Type: application/json" \
  -d '{"name":"docs","dimensions":384,"metric":"cosine"}'
```

**Insert Vector:**
```bash
curl -X POST http://localhost:8080/api/v1/collections/docs/vectors \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"id":"v1","vector":[0.1,0.2,0.3],"metadata":{"title":"Hello"}}'
```

**Search:**
```bash
curl -X POST http://localhost:8080/api/v1/collections/docs/search \
  -d '{"vector":[0.1,0.2,0.3],"topK":5,"filter":{"category":"ai"}}'
```

## Common Patterns

### Production Deployment
```bash
npx @ruvector/server@latest \
  --port 8080 \
  --persist ./vector-data \
  --auth-token $RV_AUTH_TOKEN \
  --tls --cert /etc/ssl/cert.pem --key /etc/ssl/key.pem \
  --cors
```

### Docker Deployment
```typescript
import { createServer } from '@ruvector/server';

const server = createServer({
  port: parseInt(process.env.PORT || '8080'),
  persistPath: '/data/vectors',
  authToken: process.env.AUTH_TOKEN,
  cors: true,
});
await server.start();
```

### Multi-Collection Setup
```bash
# Create multiple collections for different embedding models
curl -X POST localhost:8080/api/v1/collections -d '{"name":"mini","dimensions":384}'
curl -X POST localhost:8080/api/v1/collections -d '{"name":"large","dimensions":1536}'
```

## Key Options

| Feature | Value |
|---------|-------|
| Protocols | HTTP/1.1, HTTP/2, gRPC |
| Authentication | Bearer token |
| TLS | Automatic with cert/key |
| Streaming | Server-sent events for bulk operations |
| Metrics | Prometheus-compatible `/metrics` |

## RAN DDD Context
**Bounded Context**: Data Infrastructure

## References
- **API reference**: See [references/commands.md](references/commands.md)
- [Full README](references/npm-readme.md)
- [npm](https://www.npmjs.com/package/@ruvector/server)
