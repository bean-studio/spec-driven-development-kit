# Changelog

Newest first. Entries describe outcomes for adopting teams, not commit
subjects.

## 0.8.0 - 2026-08-18

### Added

- `refine-ticket` refines container work items such as epics, recording
  Decomposition Ready with a boundary and linked, separately deliverable
  children instead of an implementation handoff. Each child is refined on its
  own.
- The project profile marks which work-item types are containers. Add the
  marking; without it refinement treats an item that has or needs children as a
  container.
- Refined work items name the contract a user-visible change conforms to, state
  an absent capability where there is no observed behavior to contrast, and
  leave a parent's boundary to the parent.

### Changed

- Work items no longer carry person or team names in text. People are
  identified by the tracker's own fields, and an approval or answered question
  is recorded as the fact and its date with the owning repository file as the
  owner. The lifecycle record drops `Closed by:`.
- Changelog entries are now written at release-note altitude: one entry per
  outcome in one or two sentences, with rationale left to the commit and pull
  request.
- `refine-ticket` and its assets state each rule once, dropping 27 lines with no
  rule leaving the kit.

## 0.7.0 - 2026-08-18

### Added

- Refinement shapes the work item's own description to a template — Problem,
  Scope, Open questions, Acceptance criteria — instead of leaving intake shape
  to each item.
- Readiness requires that no open question remains, so open questions falling
  to zero is the visible readiness signal.

### Changed

- The Implementation Ready record no longer restates the description. It drops
  `Objective`, `Scope`, `Exclusions`, and `Acceptance criteria`, and records one
  resolved decision per line with its owning repository file. Existing records
  stay valid.
- The agent manual states each rule once, dropping 21 lines with no rule leaving
  the kit, and sets explanation depth as well as ordering: answer at the length
  the question needs, depth on request rather than by default.

## 0.6.0 - 2026-08-13

### Added

- The agent manual covers agent behavior beyond spec-driven development —
  conversation style, code quality, commands, dependency and install safety,
  and user override — so adopting repositories get those rules in the
  always-loaded instructions rather than from each agent product's defaults.
- `POLICY.md` §10 states where a new rule belongs and the precedence between the
  policy, the manual, and the project profile, so the routing rule can be cited
  in a review. `README.md` explains the same split for people.
- The project-profile template gains a `Dependencies And Tooling` section, so
  the manual's dependency rules resolve to concrete project values.
- `setup-sdd` audits pre-existing agent instruction files during adoption and
  routes their rules to the owning file.

### Changed

- The manual states each rule once and is 211 lines rather than 268, with no
  rule leaving the kit: what it stopped restating is owned by `POLICY.md` §8 or
  by the skill that reaches the step.
- `POLICY.md` §3 carries the read-upstream-first and grep-for-the-clause
  reading discipline, so it is citable rather than living only in the manual.
- `Canonical Sources` warns that a kit update replaces `.sdd/agent-source/`, so
  repository-specific edits belong in `.sdd/project-profile.md` or
  `.sdd/project-skills/`.

### Migration

- Run `sdd.sh update` then `sdd.sh sync`; rendered `CLAUDE.md`, `AGENTS.md`, and
  `.github/copilot-instructions.md` change.
- Add a `Dependencies And Tooling` section to existing profiles from the updated
  template, or the manual's dependency rules fall back to generic behavior.

## 0.5.0 - 2026-07-31

### Added

- `setup-sdd`, a fifth skill that owns kit adoption, guardrail installation,
  kit updates, and rendered-file drift repair. It bundles the project-profile
  template and both GitHub Actions guardrail workflows as supporting files.

### Changed

- Every kit resource ships inside the skill that uses it, following the Agent
  Skills `assets/` convention. The top-level `templates/`, `guardrails/`, and
  `project-profile.template.md` are gone, so skills are self-contained in each
  agent's rendered skill tree.
- `sdd.sh` recognizes a kit checkout by `VERSION` and a vendored copy by
  `KIT_VERSION`, and fresh installs always produce
  `.sdd/rendered-support.list`.

### Migration

- `sdd.sh update` removes the legacy `.sdd/templates/` and `.sdd/guardrails/`
  directories; workflows already copied to `.github/workflows/` are unaffected.
  Repoint any `.sdd/templates/` reference in a project-local skill at the
  bundled copy under the kit skill.

## 0.4.0 - 2026-07-30

### Added

- `implement-change`, one implementation workflow for both tracked and ad-hoc
  changes. It reuses an approved ticket handoff when present and handles
  in-scope review corrections without a separate workflow.

### Changed

- The default kit has four user-facing skills: bootstrap, optional ticket
  refinement, implementation, and pull-request submission. Repository-specific
  facts stay in one Markdown project profile, with no machine-readable
  configuration or workflow modes.
- Implementation exclusively owns pre-submission release and delivery
  bookkeeping; submission validates the final diff without becoming another
  implementation path. Review follow-up routes in-scope corrections back to
  implementation and material changes back to refinement.
- Implementation Ready and lifecycle evidence are short checklists again,
  without schemas, fingerprints, or invalidation records.
- `sdd.sh sync` preflights every generated destination before writing, and
  `update` restores kit-owned files if rendering fails.
- Adoption guidance preserves directory-scoped and vendor-specific agent rules
  instead of flattening existing instruction files.

### Migration

- `implement-ticket`, `spec-first-change`, and `manage-ticket` are replaced by
  `implement-change`. Running `sdd.sh update` and `sync` removes their old
  generated copies.

## 0.3.0 - 2026-07-28

### Added

- `sdd.sh sync` copies skill supporting files — anything in a skill directory
  besides `SKILL.md` — to every agent's skills tree, for kit and project-local
  skills alike. A generated manifest, `.sdd/rendered-support.list`, drives
  `check` and removal; a hand-placed copy identical to its source is adopted,
  and a differing unmanaged file is refused.

## 0.2.0 - 2026-07-28

### Added

- Repositories can own skills under `.sdd/project-skills/<skill-name>/SKILL.md`.
  `sdd.sh sync` renders them alongside the kit skills, `update` never modifies
  them, and a project skill that reuses a kit skill's name fails `sync`.

### Changed

- The generated-file marker names the canonical source generically. Files
  rendered by `0.1.0` are still recognized as managed, so `update` from `0.1.0`
  works unchanged.
- Every kit release is scaffold-tested in CI before it is tagged: `sdd.sh init`
  into a throwaway repository, then drift, repair, and project-skill assertions.

## 0.1.0 - 2026-07-28

### Added

- Shared spec-driven development policy (`POLICY.md`) with change
  classification, approval gates, Git safety, verification, release, and
  pull-request rules.
- Six workflow skills — `bootstrap-specs`, `spec-first-change`, `refine-ticket`,
  `implement-ticket`, `submit-pr`, `manage-ticket` — with a canonical agent
  routing manual (`agent-source/instructions.md`), plus authority-document and
  stage-record templates.
- Scaffolding tool `scripts/sdd.sh` (`init | update | sync | check`) that
  vendors the kit into an adopting repository under `.sdd/` and renders Claude
  Code, Codex, and GitHub Copilot discovery files from one canonical source.
- Optional GitHub Actions guardrails: generated-file drift check and
  decisions-move-with-code path check.

### Known Limitations

- Epic-level decomposition and periodic whole-codebase spec-drift audits are
  explicit non-goals; see the README.
- `sdd.sh update` overwrites kit-owned files under `.sdd/`; local edits there
  are not merged, by design.
