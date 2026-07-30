# Changelog

All notable releases for the spec-driven development kit are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] — 2026-07-30

Synchronized with the upstream `ops-ds-sdd-kit` 0.4.0 practice package. The
version jumps from `0.2.0` to `0.4.0` to keep numbering aligned with upstream;
upstream's `0.3.0` (skill supporting files) already shipped here in `0.1.0`.

### Added

- `implement-change`, one implementation workflow for both tracked and ad-hoc
  changes. It reuses an approved ticket handoff when present and handles
  in-scope review corrections without a separate workflow.

### Changed

- The kit now has four user-facing skills: `bootstrap-specs`, optional
  `refine-ticket`, `implement-change`, and `submit-pr`.
- Repository-specific facts remain in one Markdown project profile; no
  machine-readable configuration or workflow modes are required.
- Implementation Ready and lifecycle evidence are short checklists again,
  without schemas, fingerprints, or invalidation records.
- Implementation exclusively owns pre-submission release and delivery
  bookkeeping. Pull-request submission validates the final diff without
  becoming another implementation path.
- Review follow-up routes in-scope code corrections back to implementation and
  material changes back to refinement.
- The optional decision guardrail keeps four clearly marked local settings and
  requires one populated no-decision-edit rationale.
- `sdd.sh sync` preflights all generated destinations before writing, validates
  skill names against their directories, and requires exactly one
  `{{GENERATED_NOTICE}}` placeholder per source, so a conflict can no longer
  leave a partial write. `sdd.sh update` stages and backs up kit-owned files
  and restores them if rendering fails.
- Adoption guidance preserves directory-scoped and vendor-specific agent rules
  instead of recommending that existing instruction files be flattened and
  removed.

### Retained

- `.sdd/agents.conf` (this fork's `0.2.0` feature) is carried onto the
  rewritten `sdd.sh`: the enabled-agent list still drives preflight, sync, and
  removal, `update` still preserves the file, and its self-test coverage is
  unchanged.

### Migration

- `implement-ticket`, `spec-first-change`, and `manage-ticket` are replaced by
  `implement-change` plus concise routing in the generated agent instructions.
  Running `sdd.sh update` and `sync` removes their old generated copies.

## [0.2.0] — 2026-07-28

### Added

- `.sdd/agents.conf`: repository-owned list of the agents `sdd.sh sync`
  renders discovery files for. Dropping an agent removes the instructions,
  skills, and supporting files previously generated for it, and `check`
  reports any that reappear as drift. Only files carrying the generated-file
  marker are removed, so hand-owned files at the same paths survive. `init`
  and `update` create the file with every agent enabled; a repository adopted
  before it existed keeps rendering all agents.

### Fixed

- `sync` now prunes the directories left behind when it removes a rendered
  skill, instead of leaving empty skill folders in each agent's tree.

## [0.1.0] — 2026-07-28

### Changed

- **Replaced Qoder-native plugin packaging with a portable, agent-agnostic
  vendoring model.** The `plugins/` and `skills/` directories are gone;
  distribution now runs through `scripts/sdd.sh` (`init | update | sync |
  check`), which vendors this kit into an adopting repository under `.sdd/`
  and renders discovery files for Claude Code (`CLAUDE.md`,
  `.claude/skills/`), Codex (`AGENTS.md`, `.codex/skills/`), and GitHub
  Copilot (`.github/copilot-instructions.md`, `.github/skills/`) from one
  canonical source.
- Grew from three skills to six, splitting `jira-ticket-work` into
  `refine-ticket`, `implement-ticket`, and `manage-ticket`, and adding
  `bootstrap-specs` for one-time authority-document setup. `spec-first-change`
  and `submit-pr` carry forward as the development-engine and delivery
  skills.
- The issue tracker (e.g. Jira) is no longer baked into a skill; it is
  repository configuration declared in `.sdd/project-profile.md`.

### Added

- `POLICY.md`: shared engineering policy covering authority, change
  classification, decisions-before-code, workflow boundaries, approval
  gates, Git safety, verification, releases, and pull-request guardrails.
- `project-profile.template.md`: per-repository authorities, paths,
  issue-tracking, Git/PR, release, and verification configuration, kept
  separate from the shared policy.
- `agent-source/instructions.md`: canonical agent routing manual, rendered
  per agent by `sdd.sh sync`.
- `templates/`: authority-document skeletons (product spec, architecture
  record, roadmap, feature brief) and inter-stage records (implementation
  ready, lifecycle evidence, changelog entry, pull-request template,
  releases).
- `guardrails/`: optional GitHub Actions backstops — generated-file drift
  check (`agent-sync-check.yml`) and a decisions-move-with-code path check
  (`spec-decision-check.yml`).
- Project-local skills: repositories can own skills under
  `.sdd/project-skills/<skill-name>/SKILL.md`, rendered alongside kit
  skills and preserved across `sdd.sh update`.
- `VERSION` identifies the kit release vendored into adopting repositories.

## [0.0.1] — 2026-07-21

### Added

- **`spec-first-change`** (v0.0.1) — Enforces a spec-first development workflow,
  verifying that relevant spec files are reviewed, accurate, and updated before any
  implementation code is written.
- **`submit-pr`** (v0.0.1) — Enforces test passage and PR template usage before
  submitting a Pull Request. Validates that all configured tests have passed and
  assembles a standardised PR body from the project's template.
- **`jira-ticket-work`** (v0.0.1) — End-to-end JIRA ticket workflow orchestration.
  Takes a ticket from scope review through spec-driven implementation, acceptance
  criteria validation, PR submission, and ticket resolution. Composes the
  `spec-first-change` and `submit-pr` skills.
- `README.md` with kit overview, skill descriptions, and getting started guide.
- `LICENSE` (MIT) to clarify usage terms.

