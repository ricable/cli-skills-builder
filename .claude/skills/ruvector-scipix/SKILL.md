---
name: ruvector-scipix
description: "OCR client for scientific documents - extracts LaTeX, MathML, and structured text from equations, papers, and technical diagrams. Use when parsing mathematical equations from images, extracting formulas from research PDFs, or converting scientific figures to structured data."
---

# @ruvector/scipix

OCR client specialized for scientific documents. Extracts LaTeX, MathML, and structured text from mathematical equations, research papers, and technical diagrams with high accuracy.

## Quick Reference

| Task | Code |
|------|------|
| Install | `npx @ruvector/scipix@latest` |
| OCR image | `scipix.recognize(imagePath)` |
| Extract LaTeX | `scipix.toLatex(imagePath)` |
| Extract MathML | `scipix.toMathML(imagePath)` |
| Process PDF | `scipix.processPDF(pdfPath)` |
| Batch process | `scipix.batch(images)` |

## Installation

```bash
npx @ruvector/scipix@latest
```

## Quick Start

```typescript
import { Scipix, toLatex, toMathML } from '@ruvector/scipix';

const scipix = new Scipix({
  model: 'scientific-v2',
  device: 'cpu',
});

// Extract LaTeX from an equation image
const latex = await scipix.toLatex('./equation.png');
console.log(latex); // "E = mc^2"

// Get MathML representation
const mathml = await scipix.toMathML('./integral.png');
console.log(mathml); // <math>...</math>

// Full document OCR with structure
const result = await scipix.recognize('./paper-page.png');
console.log(result.text);       // Full text
console.log(result.equations);  // Detected equations as LaTeX
console.log(result.tables);     // Detected tables as structured data
console.log(result.figures);    // Figure bounding boxes

// Process entire PDF
const pages = await scipix.processPDF('./paper.pdf');
for (const page of pages) {
  console.log(`Page ${page.number}: ${page.equations.length} equations`);
}
```

## Core API

### Scipix

Main OCR client.

```typescript
const scipix = new Scipix(config?: ScipixConfig);
```

**ScipixConfig:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | `'scientific-v2' \| 'equation-only' \| 'handwriting'` | `'scientific-v2'` | OCR model |
| `device` | `'cpu' \| 'gpu'` | `'cpu'` | Compute device |
| `languages` | `string[]` | `['en']` | Document languages |
| `confidence` | `number` | `0.8` | Min confidence threshold |
| `dpi` | `number` | `300` | Image DPI assumption |

### scipix.recognize(input)

Full document recognition with structure extraction.

```typescript
await scipix.recognize(input: string | Buffer): Promise<RecognitionResult>
```

**RecognitionResult:**
| Field | Type | Description |
|-------|------|-------------|
| `text` | `string` | Full extracted text |
| `equations` | `Equation[]` | Detected equations |
| `tables` | `Table[]` | Detected tables |
| `figures` | `BoundingBox[]` | Figure regions |
| `confidence` | `number` | Overall confidence |
| `layout` | `LayoutBlock[]` | Document layout blocks |

**Equation:**
| Field | Type | Description |
|-------|------|-------------|
| `latex` | `string` | LaTeX representation |
| `mathml` | `string` | MathML representation |
| `bbox` | `BoundingBox` | Position in image |
| `confidence` | `number` | Recognition confidence |
| `type` | `'inline' \| 'display'` | Equation type |

### scipix.toLatex(input)

Extract equations as LaTeX only.

```typescript
await scipix.toLatex(input: string | Buffer): Promise<string[]>
```

### scipix.toMathML(input)

Extract equations as MathML only.

```typescript
await scipix.toMathML(input: string | Buffer): Promise<string[]>
```

### scipix.processPDF(path, options?)

Process a multi-page PDF.

```typescript
await scipix.processPDF(path: string, options?: PDFOptions): Promise<PageResult[]>
```

**PDFOptions:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `pages` | `number[] \| 'all'` | `'all'` | Pages to process |
| `dpi` | `number` | `300` | Render DPI |
| `extractImages` | `boolean` | `false` | Extract embedded images |

**PageResult:**
| Field | Type | Description |
|-------|------|-------------|
| `number` | `number` | Page number |
| `text` | `string` | Full page text |
| `equations` | `Equation[]` | Detected equations |
| `tables` | `Table[]` | Detected tables |

### scipix.batch(inputs)

Batch process multiple images.

```typescript
await scipix.batch(inputs: string[]): Promise<RecognitionResult[]>
```

### scipix.detectRegions(input)

Detect document regions without full OCR.

```typescript
await scipix.detectRegions(input: string | Buffer): Promise<Region[]>
```

**Region:** `{ type: 'text' | 'equation' | 'table' | 'figure'; bbox: BoundingBox; confidence: number }`

## Common Patterns

### Research Paper Pipeline

```typescript
const scipix = new Scipix({ model: 'scientific-v2' });

// Process paper and collect all equations
const pages = await scipix.processPDF('./arxiv-paper.pdf');
const allEquations = pages.flatMap(p => p.equations);

console.log(`Found ${allEquations.length} equations`);
for (const eq of allEquations) {
  console.log(`  ${eq.latex} (confidence: ${eq.confidence.toFixed(2)})`);
}
```

### Handwritten Equation Recognition

```typescript
const scipix = new Scipix({ model: 'handwriting' });
const latex = await scipix.toLatex('./whiteboard-photo.jpg');
console.log(`Recognized: ${latex.join(', ')}`);
```

## CLI Usage

```bash
# Recognize an image
npx @ruvector/scipix recognize ./equation.png

# Extract LaTeX from PDF
npx @ruvector/scipix pdf ./paper.pdf --format latex

# Batch process
npx @ruvector/scipix batch ./images/*.png --output results.json
```

## References

- [API Reference](references/commands.md)
- [npm](https://www.npmjs.com/package/@ruvector/scipix)
