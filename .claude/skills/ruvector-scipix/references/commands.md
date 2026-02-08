# @ruvector/scipix API Reference

Complete API reference for `@ruvector/scipix`.

## Table of Contents

- [Scipix Client](#scipix-client)
- [Recognition](#recognition)
- [LaTeX Extraction](#latex-extraction)
- [MathML Extraction](#mathml-extraction)
- [PDF Processing](#pdf-processing)
- [Region Detection](#region-detection)
- [CLI Commands](#cli-commands)
- [Types](#types)

---

## Scipix Client

### Constructor

```typescript
import { Scipix } from '@ruvector/scipix';
const scipix = new Scipix(config?: ScipixConfig);
```

**ScipixConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | `string` | `'scientific-v2'` | OCR model |
| `device` | `'cpu' \| 'gpu'` | `'cpu'` | Compute device |
| `languages` | `string[]` | `['en']` | Languages |
| `confidence` | `number` | `0.8` | Min confidence |
| `dpi` | `number` | `300` | Input DPI |
| `maxImageSize` | `number` | `4096` | Max dimension (px) |

---

## Recognition

### scipix.recognize(input)

```typescript
await scipix.recognize(input: string | Buffer): Promise<RecognitionResult>
```

**RecognitionResult:**
| Field | Type | Description |
|-------|------|-------------|
| `text` | `string` | Extracted text |
| `equations` | `Equation[]` | Equations |
| `tables` | `Table[]` | Tables |
| `figures` | `BoundingBox[]` | Figure boxes |
| `confidence` | `number` | Overall score |
| `layout` | `LayoutBlock[]` | Layout blocks |
| `processingMs` | `number` | Processing time |

---

## LaTeX Extraction

### scipix.toLatex(input)

```typescript
await scipix.toLatex(input: string | Buffer): Promise<string[]>
```

### toLatex(input)

Standalone function.

```typescript
import { toLatex } from '@ruvector/scipix';
const equations = await toLatex('./equation.png');
```

---

## MathML Extraction

### scipix.toMathML(input)

```typescript
await scipix.toMathML(input: string | Buffer): Promise<string[]>
```

### toMathML(input)

```typescript
import { toMathML } from '@ruvector/scipix';
const mathml = await toMathML('./equation.png');
```

---

## PDF Processing

### scipix.processPDF(path, options?)

```typescript
await scipix.processPDF(path: string, options?: PDFOptions): Promise<PageResult[]>
```

**PDFOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `pages` | `number[] \| 'all'` | `'all'` | Pages to process |
| `dpi` | `number` | `300` | Render DPI |
| `extractImages` | `boolean` | `false` | Extract figures |
| `parallel` | `number` | `4` | Parallel pages |

**PageResult:**
| Field | Type | Description |
|-------|------|-------------|
| `number` | `number` | Page number |
| `text` | `string` | Page text |
| `equations` | `Equation[]` | Equations |
| `tables` | `Table[]` | Tables |
| `figures` | `BoundingBox[]` | Figure regions |

---

## Region Detection

### scipix.detectRegions(input)

Detect regions without full OCR.

```typescript
await scipix.detectRegions(input: string | Buffer): Promise<Region[]>
```

### scipix.batch(inputs)

```typescript
await scipix.batch(inputs: string[]): Promise<RecognitionResult[]>
```

---

## CLI Commands

### recognize

```bash
npx @ruvector/scipix recognize <image> [--model scientific-v2] [--format text|json]
```

### pdf

```bash
npx @ruvector/scipix pdf <file.pdf> [--pages 1-5] [--format latex|mathml|json] [--output results.json]
```

### batch

```bash
npx @ruvector/scipix batch <glob-pattern> [--output results.json] [--parallel 4]
```

---

## Types

### Equation

```typescript
interface Equation {
  latex: string;
  mathml: string;
  bbox: BoundingBox;
  confidence: number;
  type: 'inline' | 'display';
}
```

### Table

```typescript
interface Table {
  rows: string[][];
  bbox: BoundingBox;
  confidence: number;
  headers: string[];
}
```

### BoundingBox

```typescript
interface BoundingBox {
  x: number;
  y: number;
  width: number;
  height: number;
}
```

### Region

```typescript
interface Region {
  type: 'text' | 'equation' | 'table' | 'figure';
  bbox: BoundingBox;
  confidence: number;
}
```

### LayoutBlock

```typescript
interface LayoutBlock {
  type: 'title' | 'abstract' | 'body' | 'heading' | 'reference' | 'caption';
  text: string;
  bbox: BoundingBox;
}
```
