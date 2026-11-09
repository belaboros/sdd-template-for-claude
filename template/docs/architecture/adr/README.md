# Architecture Decision Records

Read them in order. Each ADR records one decision: its context, the options considered and the consequences. An accepted ADR is never edited. To change a decision, write a new ADR that supersedes it, and update the old one's status line only.

New ADRs are created with `/adr` from [../../templates/adr.md](../../templates/adr.md).

| ADR | Decision | Status | Date |
|-----|----------|--------|------|
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions as ADRs | accepted | 2026-11-09 |
| [0002](0002-specification-driven-development.md) | Develop through specifications | accepted | 2026-11-09 |
| [0003](0003-documentation-layout.md) | Keep all project documentation under `docs/` | accepted | 2026-11-09 |
| [0004](0004-diagrams-as-mermaid.md) | Write diagrams as Mermaid in Markdown | accepted | 2026-11-09 |
| [0005](0005-modularity-metrics.md) | Measure modularity with complexity and coupling metrics and store snapshots | accepted | 2026-11-09 |
| [0006](0006-enforce-modularity-per-language.md) | Enforce modularity rules per language, gated at the language's introduction | accepted | 2026-11-09 |
| [0007](0007-session-history-as-curated-transcripts.md) | Save session history as curated transcripts in `docs/sessions/` | accepted | 2026-11-09 |
| [0008](0008-security-checks-for-a-public-repository.md) | Layered security checks for a public repository | accepted | 2026-11-09 |
| [0009](0009-github-repository-protection.md) | Protect `main` and enable GitHub's security features | accepted | 2026-11-09 |
