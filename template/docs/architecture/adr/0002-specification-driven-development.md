# ADR-0002: Develop through specifications

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude)

## Context
The project is built largely with Claude Code. Anthropic's Claude Code best practices recommend having Claude interview the user to produce a written spec, planning before coding, giving Claude a way to verify its own work (tests), working in fresh sessions with files carrying the context, and reviewing with an independent subagent.

## Decision
We will follow the pipeline idea → spec → plan → tasks → implement → review, driven by the `/idea`, `/spec`, `/plan`, `/implement` and `/review-spec` skills.
- Original ideas are stored verbatim, together with a log of every question asked and answered.
- Every acceptance criterion maps to a test. Implementation is test-first.
- The spec is the source of truth. When the code needs to differ from it, the spec is updated first.

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| Ad-hoc prompting | Context is lost between sessions and there is no shared definition of done |
| An external spec framework (e.g. GitHub Spec Kit) | Adds a dependency; the needs here are covered by a few small skills |

## Consequences
- **Positive:** the requirements, the reasons behind them and the verification are all written down; sessions can be reset freely.
- **Negative:** there is some overhead even for small changes.
- **Follow-up:** none.
