# ADR-0005: Measure modularity with complexity and coupling metrics and store snapshots

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude)

## Context
The goal is high cohesion and low coupling, and we want evidence that we have them, not just an opinion. Evidence needs metrics that are defined independently of any language, thresholds that can be checked, and a stored history so trends are visible.

## Decision
We will measure, at the level of the logical components declared in `components.json`:
- **Cyclomatic complexity (CC)** per function.
- **Efferent coupling (Ce)**, **afferent coupling (Ca)** and **instability I = Ce / (Ca + Ce)** per component (Robert C. Martin's package metrics).
- **Dependency cycles** between components, and **boundary violations** (dependencies not listed in `mayDependOn`).
- **Relational cohesion H** per component, and abstractness/distance where the language supports it.

Definitions, thresholds and the snapshot schema are in [metrics/README.md](../metrics/README.md). A snapshot is stored at `metrics/history/YYYY-MM-DD.json`, and `metrics/latest.md` is regenerated each time a spec is reviewed (`/review-spec`), or on demand with `/arch-metrics`.

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| Maintainability Index only | One opaque number that is hard to act on |
| A hosted service (SonarQube, CodeClimate) | External dependency; results live outside the repo |
| File-level metrics only | Says nothing about coupling between logical components, which is the actual goal |

## Consequences
- **Positive:** modularity can be checked and compared over time; regressions show up in review.
- **Negative:** each language needs a collector that emits the common schema (see ADR-0006).
- **Follow-up:** changing a threshold requires a new ADR.
