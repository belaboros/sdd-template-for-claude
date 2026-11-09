# ADR-0001: Record architecture decisions as ADRs

- **Status:** accepted
- **Date:** 2026-11-09
- **Origin:** foundation decision inherited from [sdd-template-for-claude](https://github.com/belaboros/sdd-template-for-claude)

## Context
The architecture document describes what the system looks like today, but not why. Without a record of why, later engineers (and Claude in a fresh session) tend to undo deliberate choices or repeat discussions that already happened. The goal is that someone who reads the ADRs in order understands every significant decision.

## Decision
We will record each architecturally significant decision as an ADR in `docs/architecture/adr/NNNN-slug.md`, using the template in `docs/templates/adr.md` (Michael Nygard's format plus a table of alternatives).
- A decision is significant if it affects structure, component boundaries, external dependencies, cross-cutting concerns, technology choice or quality thresholds.
- An ADR is immutable once accepted. A change in direction is a new ADR that supersedes the old one.
- `architecture.md` always shows the current state; the ADRs explain how it got there.

## Alternatives considered
| Option | Why not chosen |
|--------|----------------|
| Decisions recorded only in architecture.md | It loses history, and the document turns into a changelog |
| MADR (full template) | Heavier than this project needs; the Nygard core plus an alternatives table covers it |
| Wiki or issue tracker | Lives outside the repo, so it drifts from the code and Claude can't read it in a fresh session |

## Consequences
- **Positive:** the reasons for each decision survive turnover and context resets.
- **Negative:** writing an ADR takes a few minutes per decision.
- **Follow-up:** `/plan` creates an ADR whenever it makes a significant decision.
