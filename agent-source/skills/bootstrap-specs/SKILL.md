---
name: bootstrap-specs
description: >-
  Establish the spec-driven development foundation in a repository that lacks
  it: authority documents, release and pull-request conventions, and a
  completed project profile. Use when adopting the SDD kit in a new or existing
  codebase, or when a required foundation document is missing. Does not
  implement product changes.
---
{{GENERATED_NOTICE}}

# Bootstrap Specs

Own the creation of the repository's authority and operational documents and
project profile. Do not implement features, refactor code, or invent product
intent. Every statement written into an authority document must come from the
user, an existing document, or observed current behavior labeled as such.

## 1. Inventory What Exists

- Read `.sdd/project-profile.md` and note incomplete sections.
- Locate existing product, UX, architecture, roadmap, and feature documents,
  including informal ones (README sections, wikis, design docs).
- For an existing codebase, survey the implementation enough to name the major
  capabilities, external boundaries, and data stores. Observed behavior is
  evidence of what the system does, not authority for what it should do.

Report the inventory: which authorities exist, which are missing, and which
existing documents can be promoted or referenced instead of rewritten.

## 2. Establish Each Missing Authority

Work through missing documents in dependency order — product specification,
architecture record, feature-contract convention, delivery roadmap, and
release policy — using the templates bundled with this skill under
`assets/`:

- **Product specification** (`product-spec.md` template): capture purpose,
  users, scope, and intended behavior from the user. For an existing codebase,
  record current behavior as the baseline and mark it as observed; record
  intended deviations from the baseline as explicit decisions.
- **Architecture record** (`architecture.md` template): record only hard,
  cross-cutting technical decisions and invariants. Leave feature-local detail
  to feature contracts.
- **Delivery roadmap** (`roadmap.md` template): record phases or milestones,
  their completion criteria, and current status.
- **Release policy** (`releases.md` template): define triggers, version
  interpretation, bookkeeping, verification, and post-merge actions.

Establish a changelog and repository pull-request template from the bundled
`changelog-entry.md` and `pull-request-template.md` when the configured paths
do not exist. Establish the feature-
contract directory and naming convention; create a feature brief only for a
feature whose intent is approved.

For each document: draft from the template, present the draft, and obtain
explicit approval before committing it as an authority. Record unresolved
points as open questions with owners — never as invented decisions.

## 3. Complete The Project Profile

Fill every section of `.sdd/project-profile.md` with authoritative values:
authority paths and propagation, implementation and decision paths, issue
tracking, Git and pull-request conventions, release settings, architecture
invariants, verification commands, and external systems. Use an explicit `N/A`
with rationale for optional authorities or integrations. Obtain approval for
values that are choices rather than facts.

## 4. Verify The Foundation

- Every authority path resolves to an existing document or carries an approved
  `N/A` rationale.
- The feature-contract convention resolves to an existing directory.
- The specification chain and propagation rule are stated.
- The configured release policy, changelog, and pull-request template exist.
- Verification commands run (or the profile records why they cannot yet).
- Rendered agent files are current per the kit's sync check.

Finish with a summary of created and promoted authorities, open questions, and
the recommended first change to run through `implement-change`. Stop before any
product implementation.
