{{GENERATED_NOTICE}}
# Spec-Driven Development Agent Instructions

Read `.sdd/POLICY.md` for shared policy and `.sdd/project-profile.md` for this
repository's authorities, paths, commands, invariants, and external systems.
The profile may adapt project facts but may not silently weaken approval,
traceability, verification, or Git-safety rules.

## Start Here

- Treat work items as intake, not product authority.
- Locate only the product, UX, architecture, feature-contract, and delivery
  information needed for the requested change.
- Classify the change before editing implementation.
- Record approved material decisions before or with code.
- Implement the smallest conforming change and verify measurable acceptance
  criteria.

## Choose A Workflow

- Use `bootstrap-specs` when required authority documents or the project
  profile are missing or incomplete.
- Use `refine-ticket` when a tracked item has ambiguous scope, missing
  decisions, weak acceptance criteria, or needs an approved implementation
  handoff.
- Use `implement-change` for any repository change, tracked or ad hoc. Reuse a
  current approved Implementation Ready record when one exists.
- Use `submit-pr` after implementation is complete and pull-request submission
  is requested.

Do not invoke multiple implementation workflows for the same change. Keep
ticket updates inside the stage that owns them.

## Change Classification

Apply the four classifications from `POLICY.md`:

- explicit-spec drift uses the cited existing decision;
- existing-behavior changes require an approved owning-document update;
- net-new capabilities require upstream grounding, a feature contract,
  measurable acceptance criteria, and delivery-plan placement;
- mechanical/tooling work requires a no-decision-edit rationale.

When implementation changes but no decision file does, document either the
existing clause whose conformance was restored or why the work has no behavior
or contract impact.

## Avoid Repeated Work

- Reuse information already loaded in the current task.
- Reuse an approved handoff while its scope and decisions still match.
- Re-read only information that changed or is required for the next decision.
- Refresh issue, branch, and pull-request state immediately before writing to
  those systems.
- Reuse verification results when the tested change has not moved and project
  policy does not require a fresh run.

## Git, Verification, And Releases

- Never implement or commit on the default branch.
- Preserve unrelated work and reuse valid branches and pull requests.
- Start with the cheapest check that could disprove the implementation, then
  broaden according to risk and blast radius.
- Report failed and skipped verification faithfully.
- Implementation owns required decision, changelog, version, lockfile,
  documentation, and delivery-plan changes.
- Pull-request submission validates those records against the final diff; it
  does not create a second implementation path.

## Ticket Follow-Up And Closure

- In-scope review corrections return to `implement-change`.
- Material review changes return to `refine-ticket`.
- Link a submitted pull request once and move the item to review.
- Mark an item done only after the provider confirms the pull request merged.
- Perform or confirm required post-merge tag or publish work before closure.

## Canonical Sources

Rendered agent files are generated. Kit-owned sources live under
`.sdd/agent-source/`; repository-owned skills live under
`.sdd/project-skills/`. Regenerate vendor-specific files with
`./.sdd/scripts/sdd.sh sync` and run `./.sdd/scripts/sdd.sh check` before
completion.
