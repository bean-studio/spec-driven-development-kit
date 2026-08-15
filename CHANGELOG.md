# Changelog

Newest first. Entries describe outcomes for adopting teams, not commit
subjects.

## 0.6.0 - 2026-08-13

### Added

- The agent manual (`agent-source/instructions.md`) now covers agent behavior
  beyond spec-driven development: `Conversation Style`, `Code Quality`,
  `Commands`, `Dependencies And Install Safety`, and `User Override`. Adopting
  repositories get response-style, code-craft, command-safety, and
  supply-chain rules in the always-loaded instructions instead of relying on
  each agent product's defaults.
- `Specification Dependencies` states the one-way flow, read-upstream-first,
  and propagation rules as a named section pointing at the profile's
  authorities table, so the chain is discoverable from the manual.
- `Issues, Pull Requests, And Releases` adds guidance for creating a work item
  and for reviewing someone else's pull request, which no skill previously
  covered, alongside the existing follow-up, closure, changelog, and release
  bookkeeping rules.
- The project-profile template gains a `Dependencies And Tooling` section
  (package managers and runners, install commands, approved registries and
  proxy or certificate requirements, and the dependency-approval rule) so the
  manual's dependency rules resolve to concrete project values.
- `POLICY.md` §10 now states where a new rule belongs (concrete values to the
  project profile, universal principles to the policy, agent behavior and
  navigation to the shared instructions, multi-step procedures to a skill) and
  the precedence between those files: the profile is authoritative for project
  facts, the policy for approval, traceability, verification, and Git-safety
  guarantees, and a profile may not silently weaken a guarantee. That
  precedence rule previously existed only as prose in the agent manual, so it
  could not be cited in a review.
- `README.md` gains `Three Files, Three Roles`, comparing the policy, agent
  manual, and project profile by scope, ownership, update behavior, and read
  frequency, with a four-question test for routing a new rule. Adoption
  guidance for people, deliberately kept out of the always-loaded manual.
- `setup-sdd` now audits pre-existing agent instruction files during adoption
  and routes their rules to the owning file per §10 instead of leaving them in
  place.

### Changed

- The manual states each rule once. `Git` and `Verification` split out of the
  former combined section and keep the clauses an agent must act on without a
  second read; changelog, release bookkeeping, and issue and pull-request
  procedure collapse into one `Issues, Pull Requests, And Releases` section
  that names `POLICY.md` §8 and §9 as the authority instead of restating them.
  No rule left the kit: the clauses the manual stopped restating are the ones
  `POLICY.md` §8 or the reaching skill already owned — pull-request linking and
  the review transition in `submit-pr`, changelog and lockfile bookkeeping in
  `implement-change`, parent and link loading in `refine-ticket`. The manual is
  211 lines rather than 268, with nothing an agent needs mid-turn removed.
- `POLICY.md` §3 now carries the read-upstream-first and grep-for-the-clause
  reading discipline, so it is citable rather than living only in the manual
  and in individual project profiles. §7 states the test-ordering rule without
  the previous "when risk warrants" hedge, matching the manual's wording.
- The project-profile template stops inviting the duplication that §3 now
  owns: the specification-chain prompt asks for this project's documents and
  their order only, and the documentation-paths prompt asks for one sub-bullet
  per audience-owning document instead of a single run-on line.
- The manual's title is `Agent Instructions` rather than `Spec-Driven
  Development Agent Instructions`, and it opens by naming what each of the
  three files holds.
- `Canonical Sources` now warns that a kit update replaces
  `.sdd/agent-source/`, so repository-specific edits belong in
  `.sdd/project-profile.md` or `.sdd/project-skills/`.

### Migration

- Run `sdd.sh update` then `sdd.sh sync` to pick up the new manual; rendered
  `CLAUDE.md`, `AGENTS.md`, and `.github/copilot-instructions.md` change.
- Existing profiles have no `Dependencies And Tooling` section. Add one from
  the updated template, or the manual's dependency rules fall back to generic
  behavior.

## 0.5.0 - 2026-07-31

### Added

- `setup-sdd`, a fifth skill that owns kit adoption, guardrail installation,
  kit updates, and rendered-file drift repair. It bundles the project-profile
  template and both GitHub Actions guardrail workflows as supporting files.

### Changed

- Every kit resource now ships inside the skill that uses it, following the
  Agent Skills `assets/` convention: the specification, architecture, roadmap,
  release, feature-brief, changelog, and pull-request skeletons moved into
  `bootstrap-specs/assets/`; the Implementation Ready record template into
  `refine-ticket/assets/`; the lifecycle-evidence template into
  `implement-change/assets/`. The
  top-level `templates/`, `guardrails/`, and `project-profile.template.md`
  are gone, so skills are self-contained in each agent's rendered skill tree.
- `sdd.sh` recognizes a kit checkout by `VERSION` (and a vendored copy by
  `KIT_VERSION`) instead of the removed top-level profile template, and no
  longer vendors `templates/` or `guardrails/` as top-level `.sdd/` paths.
- Fresh installs always produce `.sdd/rendered-support.list`, since kit
  skills now carry supporting files.

### Migration

- `sdd.sh update` removes the legacy `.sdd/templates/` and `.sdd/guardrails/`
  directories from repositories initialized with older kits; guardrail
  workflows already copied to `.github/workflows/` are unaffected. References
  to `.sdd/templates/` in project-local skills should point at the bundled
  copies under the kit skills instead.

## 0.4.0 - 2026-07-30

### Added

- `implement-change`, one implementation workflow for both tracked and ad-hoc
  changes. It reuses an approved ticket handoff when present and handles
  in-scope review corrections without a separate workflow.

### Changed

- The default kit now has four user-facing skills: bootstrap, optional ticket
  refinement, implementation, and pull-request submission.
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
- `sdd.sh sync` preflights all generated destinations before writing,
  validates skill names and placeholders, and avoids partial conflict writes.
  `update` stages and backs up kit-owned files and restores them if rendering
  fails.
- Adoption guidance preserves directory-scoped and vendor-specific agent rules
  instead of recommending that existing instruction files be flattened and
  removed.

### Migration

- `implement-ticket`, `spec-first-change`, and `manage-ticket` are replaced by
  `implement-change` plus concise routing in the generated agent instructions.
  Running `sdd.sh update` and `sync` removes their old generated copies.

## 0.3.0 - 2026-07-28

### Added

- Skill supporting files: any file inside a skill directory besides
  `SKILL.md` (references, scripts, agent-specific metadata such as a Codex
  `agents/openai.yaml`) is now copied verbatim to every agent's skills tree
  by `sdd.sh sync`, for both kit skills and project-local skills. The copies
  are tracked in a generated manifest, `.sdd/rendered-support.list`, which
  `check` verifies and which drives removal when a source file disappears. A
  hand-placed copy identical to its source is adopted into the manifest; a
  differing unmanaged file is refused. Supporting-file paths may not collide
  between kit and project skill sources.

### Changed

- The CI self-test now also covers supporting files: render to all agents,
  manifest creation, adoption of an identical hand-placed copy, refusal of a
  differing unmanaged copy, and removal (including the manifest) when the
  source is deleted.

## 0.2.0 - 2026-07-28

### Added

- Project-local skills: repositories can now own skills under
  `.sdd/project-skills/<skill-name>/SKILL.md`. `sdd.sh sync` renders them to
  every configured agent alongside the kit skills, `sdd.sh update` never
  modifies them, and a project skill that reuses a kit skill's name fails
  `sync` explicitly. `sdd.sh init` creates the directory with a README
  describing the format.

### Changed

- The generated-file marker now names the canonical source generically
  (`agent-source/` or `project-skills/`) instead of pointing every file at
  `agent-source/`. Files rendered by kit `0.1.0` with the old marker are
  still recognized as managed, so `sdd.sh update` from `0.1.0` works
  unchanged.
- Every kit release is now scaffold-tested in CI before it is tagged: a
  self-test workflow runs `sdd.sh init` into a throwaway repository and
  asserts that `check` reports current output, detects drift, that `sync`
  repairs it, that `init` refuses an existing `.sdd`, that `update`
  preserves `.sdd/project-profile.md`, and that project-local skills render,
  survive `update`, and cannot shadow kit skills.

### Added

- Shared spec-driven development policy (`POLICY.md`) with change
  classification, approval gates, Git safety, verification, release, and
  pull-request rules.
- Six workflow skills: `bootstrap-specs`, `spec-first-change`,
  `refine-ticket`, `implement-ticket`, `submit-pr`, and `manage-ticket`, with
  a canonical agent routing manual (`agent-source/instructions.md`).
- Authority-document and stage-record templates: product spec, architecture
  record, roadmap, feature brief, implementation-ready record, lifecycle
  evidence, release policy, pull-request template, and changelog entry.
- Scaffolding tool `scripts/sdd.sh` (`init | update | sync | check`) that
  vendors the kit into an adopting repository under `.sdd/` and renders
  Claude Code, Codex, and GitHub Copilot discovery files from one canonical
  source.
- Optional GitHub Actions guardrails: generated-file drift check and
  decisions-move-with-code path check.

### Known Limitations

- Epic-level decomposition and periodic whole-codebase spec-drift audits are
  explicit non-goals; see the README.
- `sdd.sh update` overwrites kit-owned files under `.sdd/`; local edits there
  are not merged, by design.
