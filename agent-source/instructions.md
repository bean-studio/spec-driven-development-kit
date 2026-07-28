{{GENERATED_NOTICE}}
# Spec-Driven Development Agent Instructions

Read `.sdd/POLICY.md` for shared policy and `.sdd/project-profile.md` for this
repository's authorities, paths, commands, and invariants. The project profile
wins for project-specific facts; it may not weaken the shared approval,
traceability, verification, or Git-safety rules without an explicit team policy
decision.

## Start Here

- Treat work items as intake, not repository authority.
- Locate the owning product, UX, architecture, feature-contract, and delivery
  documents from the project profile.
- Classify the implicated change before editing implementation.
- Trace only the behavior needed to identify the controlling decision, code path,
  and cheapest discriminating check.
- Record approved material decisions before or with code.
- Implement the smallest conforming change and verify its acceptance criteria.

## Workflow Routing

- Use `bootstrap-specs` when a required authority document or the project
  profile is missing or incomplete.
- Use `spec-first-change` for bugs, behavior changes, UX changes, enhancements,
  net-new capabilities, explicit-spec drift, and mechanical/tooling
  classification.
- Use `refine-ticket` to turn a work item into an approved Implementation Ready
  record.
- Use `implement-ticket` only when a current approved Implementation Ready
  record exists.
- Use `submit-pr` only after implementation is complete and submission is
  explicitly requested by the user or coordinating workflow.
- Use `manage-ticket` for broad, resume, cross-stage, review-follow-up, and
  closure requests.

Focused skills own their stage. Do not refine inside implementation, implement
inside submission, or submit automatically after implementation.

## Shared Workflow Rules

These rules apply to every ticket-lifecycle skill; skills state only their
stage-specific additions:

- Follow the SDD policy and project profile for authority, issue-provider
  access, Git, releases, and verification.
- Discover work-item transitions and required fields from provider metadata;
  never assume status names or transition identifiers are stable.
- Reconcile work-item, local and remote branch, and pull-request state before
  writing to any of them.
- Reuse valid lifecycle records, branches, links, and pull requests instead of
  duplicating them; update the one stable lifecycle record rather than adding
  new comments per stage.
- Preserve unrelated work-item content, worktree changes, and existing user
  work.
- A broad request does not waive scope, implementation, material-decision, or
  submission approvals.

## Decision And Specification Discipline

Use the authority and propagation rules in the project profile. Apply the four
classifications from `POLICY.md`:

- explicit-spec drift uses the existing cited decision;
- existing-behavior changes require an approved owning-document update;
- net-new capabilities require upstream grounding, a feature contract,
  measurable acceptance criteria, and delivery-plan placement;
- mechanical/tooling work requires a no-decision-edit rationale.

When implementation changes but no decision file does, document either the
existing clause whose conformance was restored or why the work has no behavior
or contract impact.

## Implementation And Verification

- Follow the architecture invariants and repository conventions in the project
  profile.
- Never implement or commit on the default branch.
- Use measurable acceptance criteria to select tests and manual checks.
- Report failed and skipped verification without concealment.
- Return material scope changes to refinement before continuing.

## Releases And Pull Requests

Assess release impact after implementation; before submission, re-confirm that
assessment against the final diff rather than re-deriving it. Apply the project
release policy in the same change when its trigger is met, including the
changelog, every version-bearing manifest, and every corresponding lockfile.

Build pull-request bodies from the repository template. Identify decision files
or a valid no-decision-edit rationale, release impact, and verification evidence.
Automated guardrails are backstops and do not replace review of decision quality.

## External Systems

Use only the approved integrations and fallbacks in the project profile.

## Canonical Sources

Rendered agent files are generated; edit only their canonical sources.
Kit-owned sources live under `.sdd/agent-source/` and are replaced by kit
updates; repository-owned skills live under `.sdd/project-skills/`. Regenerate
vendor-specific discovery files with `./.sdd/scripts/sdd.sh sync` and run
`./.sdd/scripts/sdd.sh check` before completion.
