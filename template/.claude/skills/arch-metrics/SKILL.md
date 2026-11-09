---
name: arch-metrics
description: Compute cyclomatic complexity, afferent/efferent coupling, instability, cohesion, cycles and boundary violations per logical component; store a dated snapshot; regenerate metrics/latest.md and the coupling diagram in architecture.md. Use when the user runs /arch-metrics or asks for proof of modularity.
---

1. Read `docs/architecture/metrics/README.md` (definitions, thresholds, schema), `docs/architecture/components.json` and `tools/quality/languages.json`.
2. If no language is registered, report that there is nothing to measure and stop.
3. Run the metrics command of every registered language (`metrics` field in `languages.json`). Each emits the snapshot schema. Merge them: sum the counts per component, union the dependency edges, and recompute I, the cycles and the violations on the merged graph.
4. Write `docs/architecture/metrics/history/<today>.json`, including the current commit sha.
5. Regenerate `docs/architecture/metrics/latest.md`: the overall result; a component table (Ca, Ce, I, H, A, D, status); functions over the warn threshold; violations; and the **change since the previous snapshot** (new violations, CC max, Ce changes).
6. Regenerate the Mermaid block between `<!-- coupling:begin -->` and `<!-- coupling:end -->` in `docs/architecture/architecture.md`. Each node is labelled `name<br/>Ca·Ce·I`. Each edge is labelled with its reference count. Boundary violations and cycle edges are drawn red with `linkStyle`. Also check that the measured edges match the declared component diagram (§3), and report any drift.
7. Report the result to the user. If it is `fail`, list exactly what has to change. Never adjust a threshold to make the result pass.
