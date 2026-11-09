# Quality-gate playbook per language

Starting points, not mandates. The final choice for each language is recorded in its ADR. Pin versions when you set them up.

The same structure applies to every language: a **complexity linter**, a **boundary checker** generated from `components.json`, a **metrics collector** that emits the snapshot schema, and **hooks** (Claude PostToolUse → pre-commit → CI).

## Security, for every language (ADR-0008)
Each new language also adds:
- **Dependency audit:** `pip-audit` (Python), `npm audit --audit-level=high` (JS/TS), `govulncheck` (Go), `cargo audit` / `cargo deny` (Rust), as a pre-commit hook and in CI.
- **Static security analysis:** `bandit` or ruff's `S` rules (Python), `eslint-plugin-security` (JS/TS), `gosec` via golangci-lint (Go), clippy (Rust). Optionally a GitHub CodeQL workflow for the language.
- **Dependabot:** a `package-ecosystem` entry in `.github/dependabot.yml` with the same 7-day cooldown.
- A lockfile, committed.

## Python (`python`)
| Need | Tool |
|------|------|
| Lint + CC | `ruff`: rule `C901` with `max-complexity = 10`; also `PLR0912` (branches), `PLR0913` (arguments), `PLR0915` (statements) |
| CC report | `radon cc -j` or `lizard` (functions with CC 11–15 are warnings in the report) |
| Boundaries / cycles | `import-linter`: `layers`, `independence` and `forbidden` contracts generated from `components.json`; runs as `lint-imports` |
| Ca / Ce graph | `grimp` (the import-graph library behind import-linter): build the graph, then map modules to components |
| Types | `mypy` or `pyright` (strict), which keeps interfaces honest |
| Abstractness | count `abc.ABC` and `typing.Protocol` classes |

## JavaScript / TypeScript (`js-ts`)
| Need | Tool |
|------|------|
| Lint + CC | ESLint: `complexity: ["error", 15]` plus warn at 10, `max-depth`, `max-params`, `max-lines-per-function` |
| Boundaries / cycles | `dependency-cruiser`: `no-circular`, plus `forbidden` / `allowed` rules generated from `components.json`; optionally `eslint-plugin-boundaries` for in-editor feedback |
| Ca / Ce graph | `depcruise --output-type json`; its `--metrics` option also reports Ca/Ce/I per folder |
| Abstractness | count TS `interface`s and abstract classes |
| Hooks | `pre-commit` (preferred, shared across languages), or `husky` + `lint-staged` |

## Go (`go`)
| Need | Tool |
|------|------|
| Lint + CC | `golangci-lint` with `gocyclo` / `cyclop` (max 10/15) and `gocognit` |
| Boundaries | `depguard` rules per component generated from `components.json`; Go itself forbids import cycles between packages |
| Ca / Ce graph | `go list -json ./...` → the `Imports` of each package, mapped to components |
| Abstractness | count interface types |

## Rust (`rust`)
| Need | Tool |
|------|------|
| Lint + CC | `clippy` with `cognitive_complexity` enabled (`clippy.toml`: `cognitive-complexity-threshold`); `lizard` for McCabe CC |
| Boundaries / cycles | map each component to a **workspace crate**; Cargo forbids cycles between crates and `[dependencies]` makes the allowed edges explicit. Within a crate: `cargo-modules` |
| Ca / Ce graph | `cargo metadata --format-version 1` (between crates) plus `cargo modules dependencies` (within a crate) |
| Abstractness | count traits |

## Any other language
- `lizard` computes CC for most mainstream languages (C/C++, Java, C#, Kotlin, Swift, Ruby, PHP, Scala, …).
- For the dependency graph, use the language's own import or dependency tooling, or a parser-based script; map files to components through the `paths` globs.
- If there is no boundary checker, write a small script that checks the graph against `mayDependOn` and fails on violations or cycles.
