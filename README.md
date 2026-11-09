# sdd-template-for-claude

A [Copier](https://copier.readthedocs.io/) template for starting a new repository with **specification-driven development in Claude Code**. It includes architecture documentation, enforced modularity, saved session history and layered security checks.

## What a new project gets

| Area | Contents |
|------|----------|
| **Workflow** | `CLAUDE.md` rules; skills `/idea` → `/spec` → `/plan` → `/implement` → `/review-spec`; a `spec-reviewer` subagent; templates for ideas, specs, plans, tasks and ADRs. Original ideas are stored verbatim with a Q&A log of every question asked. |
| **Architecture** | `docs/architecture/architecture.md` (context, component and coupling diagrams in Mermaid); `components.json` as the single source of truth for components; foundation ADRs 0001–0009 |
| **Modularity** | Defined metrics and thresholds (cyclomatic complexity, Ca/Ce/instability, cycles, boundary violations, cohesion); `/arch-metrics`; `/add-language`, which sets up linters, boundary rules and hooks per language. A hook blocks code in any language that has no quality gate yet. |
| **Session history** | A `SessionEnd` hook saves the summary, the user's requests and Claude's replies to `docs/sessions/YYYYMMDD-HHMMSS-<id>.md` |
| **Security** | pre-commit (gitleaks, private keys, large files, shellcheck, zizmor); a CI security workflow (full-history gitleaks, SHA-pinned least-privilege actions); Dependabot; `.gitignore` for secrets; Claude read-deny rules; `SECURITY.md`; `tools/bootstrap-github.sh` for branch protection and GitHub security settings |

## Start a new project

Prerequisites: `brew install copier gitleaks pre-commit gh jq` (or `uv tool install copier`), and `gh auth login`.

```bash
copier copy --trust gh:belaboros/sdd-template-for-claude my-project
cd my-project
git add -A && git commit -m "Initial project from sdd-template-for-claude"
gh repo create belaboros/my-project --public --source . --push
tools/bootstrap-github.sh          # branch protection + security settings (once)
```

Copier asks for the project name, repository name, description, GitHub owner, visibility and license. `--trust` lets it run its setup tasks: `git init`, `chmod`, `pre-commit install`.

Then open Claude Code in the project and run `/idea <your first idea>`.

## Pull template improvements into an existing project

```bash
git switch -c chore/template-update
copier update --trust              # to the latest tag; resolves conflicts as inline markers
pre-commit run --all-files
# review the diff, commit, open a PR
```

Copier remembers your answers and the template version in `.copier-answers.yml`. Projects created before this template existed can adopt it with `copier copy --trust gh:belaboros/sdd-template-for-claude .`, reviewing every overwrite.

## Developing the template

- Template files live in [template/](template/); files ending in `.jinja` are rendered, everything else is copied verbatim. Questions and tasks are defined in [copier.yml](copier.yml).
- Test locally: `copier copy --trust --defaults -d project_name=Demo . /tmp/demo && (cd /tmp/demo && git add -A && pre-commit run --all-files)`.
- CI (`template-test.yml`) generates a project and runs its hooks on every PR.
- Release: merge to `main`, then tag `vX.Y.Z` (semver). `copier update` uses the latest tag. A breaking change (renamed files, new required answers) is a major version.
- Changes to the foundation decisions go in `template/docs/architecture/adr/` as new, superseding ADRs.

## License

[Apache-2.0](LICENSE)
