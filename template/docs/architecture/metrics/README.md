# Modularity metrics

These metrics are evidence that the code stays highly cohesive and loosely coupled (ADR-0005). They are computed per **logical component** as declared in [../components.json](../components.json), not per file, so they line up with the diagrams in `architecture.md`.

## Metrics and thresholds

Changing a threshold requires an ADR.

| Metric | Definition | Level | Pass | Warn | Fail |
|--------|------------|-------|------|------|------|
| **Cyclomatic complexity (CC)** | Number of independent paths through a function (McCabe): 1 + the number of decision points | function | ≤ 10 | 11–15 | > 15 |
| **Efferent coupling (Ce)** | Number of *other components* this component depends on | component | ≤ 4 | 5–7 | > 7 |
| **Afferent coupling (Ca)** | Number of *other components* that depend on this component | component | (no limit, shown for context) | | |
| **Instability (I)** | Ce / (Ca + Ce); 0 = maximally stable, 1 = maximally unstable | component | | | |
| **Stable Dependencies violations** | Dependencies A → B where I(B) > I(A), i.e. depending on something less stable | edge | 0 | ≥ 1 | |
| **Dependency cycles** | Cycles in the component dependency graph | graph | 0 | | ≥ 1 |
| **Boundary violations** | Dependencies A → B where B is not in A's `mayDependOn` | edge | 0 | | ≥ 1 |
| **Relational cohesion (H)** | (R + 1) / N, where R = internal references between the component's N modules or types | component | 1.5–4.0 | outside that range | |
| **Abstractness (A)** and **distance (D)** | A = abstract types / all types; D = \|A + I − 1\| | component | D ≤ 0.5 | D > 0.5 | |

Notes:
- Ce and Ca count components, not files. Third-party libraries are reported separately (`externalDeps`) and do not count towards Ce.
- Abstractness and distance are reported only for languages with interfaces or traits (Go, Rust, TypeScript, Python ABCs or Protocols). Otherwise they are shown as `n/a`.
- A function between 11 and 15 needs a one-line justification in the code review. Anything over 15 must be split.

## Components file

`components.json` declares the logical components. Boundary linters, the collector and the diagrams are all derived from it.

```json
{
  "components": [
    {
      "name": "retrieval",
      "responsibility": "Fetches and normalises source documents.",
      "paths": ["src/retrieval/**"],
      "mayDependOn": ["core"],
      "public": ["src/retrieval/__init__.py"]
    }
  ]
}
```

`public` (optional) lists the entry points other components may import. Anything else counts as internal.

## Snapshot schema

Each language collector emits this JSON shape. Collectors for different languages are merged into one dated file at `history/YYYY-MM-DD.json`.

```json
{
  "date": "YYYY-MM-DD",
  "commit": "<git sha>",
  "languages": ["python"],
  "functions": {
    "count": 0, "ccAvg": 0.0, "ccMax": 0,
    "overWarn": [{ "file": "", "function": "", "cc": 0 }]
  },
  "components": [
    { "name": "", "ca": 0, "ce": 0, "instability": 0.0,
      "relationalCohesion": 0.0, "abstractness": null, "distance": null,
      "externalDeps": [] }
  ],
  "dependencies": [{ "from": "", "to": "", "count": 0 }],
  "cycles": [["a", "b", "a"]],
  "violations": [{ "kind": "boundary|cycle|sdp|cc", "detail": "" }],
  "result": "pass|warn|fail"
}
```

## Outputs

| File | Written by | Contents |
|------|------------|----------|
| `history/YYYY-MM-DD.json` | `/arch-metrics` | The full snapshot (a later snapshot on the same day replaces the earlier one) |
| [latest.md](latest.md) | `/arch-metrics` | Human-readable tables, the change since the previous snapshot, and the pass/warn/fail result |
| `architecture.md` §4 | `/arch-metrics` | Generated Mermaid coupling diagram: edges labelled with reference counts, nodes with Ca/Ce/I, boundary violations in red |

The per-language tools that produce these numbers are listed in [.claude/skills/add-language/playbook.md](../../../.claude/skills/add-language/playbook.md).
