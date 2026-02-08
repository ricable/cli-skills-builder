# @ruvector/server API Reference

Complete reference for the `@ruvector/server` HTTP/gRPC server.

## Table of Contents
- [CLI Usage](#cli-usage)
- [Programmatic API](#programmatic-api)
- [REST API Endpoints](#rest-api-endpoints)
- [Collections API](#collections-api)
- [Vectors API](#vectors-api)
- [Search API](#search-api)
- [Index API](#index-api)
- [Management API](#management-api)
- [gRPC API](#grpc-api)
- [Authentication](#authentication)
- [Error Responses](#error-responses)

---

## CLI Usage

### Start Server
```bash
npx @ruvector/server@latest --port 8080
npx @ruvector/server@latest --port 8080 --grpc 50051
npx @ruvector/server@latest --port 8080 --persist ./data --auth-token $TOKEN
npx @ruvector/server@latest --tls --cert cert.pem --key key.pem --port 443
```

**CLI Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--port` | HTTP port | `8080` |
| `--grpc` | gRPC port | Disabled |
| `--host` | Bind address | `0.0.0.0` |
| `--persist` | Persistence directory | In-memory |
| `--auth-token` | Bearer authentication token | - |
| `--cors` | Enable CORS | `false` |
| `--tls` | Enable TLS | `false` |
| `--cert` | TLS certificate path | - |
| `--key` | TLS private key path | - |
| `--max-connections` | Max concurrent connections | `1000` |
| `--log-level` | Log level: `debug`, `info`, `warn`, `error` | `info` |
| `--metrics` | Enable Prometheus metrics | `true` |

---

## Programmatic API

### createServer()

```typescript
import { createServer } from '@ruvector/server';

const server = createServer(options: ServerOptions): RuVectorServer;
```

**ServerOptions:**
```typescript
interface ServerOptions {
  port?: number;               // HTTP port (default: 8080)
  grpcPort?: number;           // gRPC port (disabled by default)
  host?: string;               // Bind address (default: '0.0.0.0')
  persistPath?: string;        // Persistence directory
  authToken?: string;          // Bearer auth token
  cors?: boolean;              // Enable CORS (default: false)
  tls?: {
    cert: string;              // Certificate file path
    key: string;               // Private key file path
  };
  maxConnections?: number;     // Max connections (default: 1000)
  logLevel?: string;           // Log level (default: 'info')
  onRequest?: (req) => void;   // Request hook
  onError?: (err) => void;     // Error hook
}
```

### RuVectorServer Methods

```typescript
await server.start(): Promise<void>;          // Start listening
await server.stop(): Promise<void>;           // Graceful shutdown
server.address(): { port: number; host: string };  // Get bound address
```

---

## REST API Endpoints

### Base URL
All endpoints are prefixed with `/api/v1`.

---

## Collections API

### POST /api/v1/collections
Create a new vector collection.

**Request:**
```json
{
  "name": "documents",
  "dimensions": 384,
  "metric": "cosine",
  "efConstruction": 200,
  "m": 16
}
```

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `name` | `string` | Collection name | Yes |
| `dimensions` | `number` | Vector dimensionality | Yes |
| `metric` | `string` | `cosine`, `euclidean`, `dot` | No |
| `efConstruction` | `number` | HNSW build parameter | No |
| `m` | `number` | HNSW connections | No |

**Response:** `201 Created`
```json
{
  "name": "documents",
  "dimensions": 384,
  "metric": "cosine",
  "count": 0,
  "createdAt": "2026-01-15T10:00:00Z"
}
```

### GET /api/v1/collections
List all collections.

**Response:** `200 OK`
```json
{
  "collections": [
    { "name": "documents", "dimensions": 384, "count": 50000 }
  ]
}
```

### GET /api/v1/collections/:name
Get collection details.

**Response:** `200 OK`
```json
{
  "name": "documents",
  "dimensions": 384,
  "metric": "cosine",
  "count": 50000,
  "indexBuilt": true,
  "memoryUsageMB": 128
}
```

### DELETE /api/v1/collections/:name
Delete a collection and all its vectors.

**Response:** `204 No Content`

---

## Vectors API

### POST /api/v1/collections/:name/vectors
Insert a single vector.

**Request:**
```json
{
  "id": "doc-1",
  "vector": [0.1, 0.2, 0.3],
  "metadata": { "title": "Hello World", "category": "greeting" }
}
```

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| `id` | `string` | Vector identifier | No (auto-generated) |
| `vector` | `number[]` | Vector data | Yes |
| `metadata` | `object` | Arbitrary metadata | No |

**Response:** `201 Created`
```json
{ "id": "doc-1", "status": "inserted" }
```

### POST /api/v1/collections/:name/vectors/batch
Batch insert multiple vectors.

**Request:**
```json
{
  "vectors": [
    { "id": "doc-1", "vector": [0.1, 0.2], "metadata": {"tag": "a"} },
    { "id": "doc-2", "vector": [0.3, 0.4], "metadata": {"tag": "b"} }
  ]
}
```

**Response:** `200 OK`
```json
{ "inserted": 2, "failed": 0, "durationMs": 5 }
```

### GET /api/v1/collections/:name/vectors/:id
Get a vector by ID.

**Response:** `200 OK`
```json
{
  "id": "doc-1",
  "vector": [0.1, 0.2, 0.3],
  "metadata": { "title": "Hello World" }
}
```

### PUT /api/v1/collections/:name/vectors/:id
Update an existing vector.

**Request:**
```json
{
  "vector": [0.4, 0.5, 0.6],
  "metadata": { "title": "Updated" }
}
```

### DELETE /api/v1/collections/:name/vectors/:id
Delete a vector.

**Response:** `204 No Content`

---

## Search API

### POST /api/v1/collections/:name/search
Search for similar vectors.

**Request:**
```json
{
  "vector": [0.1, 0.2, 0.3],
  "topK": 10,
  "efSearch": 100,
  "filter": { "category": "science" },
  "threshold": 0.7,
  "includeMetadata": true,
  "includeVectors": false
}
```

| Field | Type | Description | Default |
|-------|------|-------------|---------|
| `vector` | `number[]` | Query vector | Required |
| `topK` | `number` | Results count | `10` |
| `efSearch` | `number` | Search quality | `50` |
| `filter` | `object` | Metadata filter | - |
| `threshold` | `number` | Min similarity | `0.0` |
| `includeMetadata` | `boolean` | Return metadata | `true` |
| `includeVectors` | `boolean` | Return vectors | `false` |

**Response:** `200 OK`
```json
{
  "results": [
    { "id": "doc-1", "score": 0.95, "metadata": {"title": "Hello"} },
    { "id": "doc-3", "score": 0.89, "metadata": {"title": "World"} }
  ],
  "durationMs": 2
}
```

### POST /api/v1/collections/:name/search/batch
Batch multiple search queries.

**Request:**
```json
{
  "queries": [
    { "vector": [0.1, 0.2], "topK": 5 },
    { "vector": [0.3, 0.4], "topK": 5 }
  ]
}
```

---

## Index API

### POST /api/v1/collections/:name/index/build
Build HNSW index.

**Request:**
```json
{ "efConstruction": 200, "m": 16 }
```

**Response:** `200 OK`
```json
{ "status": "built", "elements": 50000, "durationMs": 2500 }
```

### GET /api/v1/collections/:name/index/status
Get index status.

**Response:**
```json
{
  "built": true,
  "elements": 50000,
  "efConstruction": 200,
  "m": 16,
  "memoryUsageMB": 64
}
```

---

## Management API

### GET /api/v1/health
Health check endpoint.

**Response:** `200 OK`
```json
{ "status": "healthy", "uptime": 3600, "version": "1.0.0" }
```

### GET /api/v1/metrics
Prometheus-compatible metrics.

**Response:** `200 OK` (text/plain)
```
ruvector_requests_total{method="POST",path="/search"} 1234
ruvector_search_latency_seconds{quantile="0.99"} 0.005
ruvector_vectors_total{collection="documents"} 50000
```

---

## gRPC API

When `--grpc` port is configured, the following gRPC services are available:

```protobuf
service VectorService {
  rpc Insert(InsertRequest) returns (InsertResponse);
  rpc Search(SearchRequest) returns (SearchResponse);
  rpc BatchInsert(stream InsertRequest) returns (BatchResponse);
  rpc StreamSearch(SearchRequest) returns (stream SearchResult);
}
```

---

## Authentication

When `--auth-token` is set, all requests must include:

```
Authorization: Bearer <token>
```

Unauthenticated requests receive `401 Unauthorized`.

**Excluded endpoints:** `/api/v1/health` (always accessible).

---

## Error Responses

All errors follow this format:

```json
{
  "error": {
    "code": "COLLECTION_NOT_FOUND",
    "message": "Collection 'unknown' does not exist"
  }
}
```

| Status | Code | Description |
|--------|------|-------------|
| `400` | `INVALID_REQUEST` | Malformed request body |
| `401` | `UNAUTHORIZED` | Missing or invalid auth token |
| `404` | `COLLECTION_NOT_FOUND` | Collection does not exist |
| `404` | `VECTOR_NOT_FOUND` | Vector ID does not exist |
| `409` | `ALREADY_EXISTS` | Collection or vector already exists |
| `422` | `DIMENSION_MISMATCH` | Vector dimensions do not match |
| `500` | `INTERNAL_ERROR` | Server error |
