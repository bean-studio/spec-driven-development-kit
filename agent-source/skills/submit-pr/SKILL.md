---
name: submit-pr
description: >-
  Review a completed change, apply required release bookkeeping, verify it, and
  open a pull request from the repository template. Use for explicit pull-
  request submission and coordinator handoffs. Does not decide product scope or
  change work-item state.
---
{{GENERATED_NOTICE}}

# Submit Pull Request

Start only after implementation is complete and submission is requested. Own
final diff review, release assessment, verification, template completion, and
pull-request creation. Do not refine scope, invent decisions, or change
work-item state.

## 1. Establish The Pull-Request Boundary

- Determine the base branch from the project profile.
- Inspect worktree state, commits relative to the base, changed-file summary,
  and substantive hunks.
- Reconcile any existing pull request for the branch.
- If intended work is uncommitted, surface it and obtain any required commit or
  branch approval. Never commit on the default branch.

## 2. Confirm Decision Evidence

For every implementation change, require one of:

- the changed decision files that own new or changed behavior;
- a cited existing authoritative clause when implementation restored explicit-
  spec conformance;
- a mechanical/tooling rationale showing no behavior or contract impact.

Do not use the no-decision-edit route to avoid recording a material decision.
Apply the configured label only when its rationale is present in the pull-request
body.

## 3. Assess Release Impact

Apply the project profile and release policy. When implementation already
produced a release assessment in the lifecycle evidence, re-confirm it against
the final diff instead of re-deriving it; revise it only when the diff no
longer matches the assessed scope.

- If a release trigger is met, choose the version according to project policy,
  confirm genuine ambiguity, add the changelog entry, and align every version-
  bearing manifest and corresponding lockfile.
- If no release trigger is met, record the reason in the pull-request template.

Verify version metadata before leaving this stage.

## 4. Verify Before Submission

Run the tests, builds, static checks, and manual checks appropriate to the actual
diff and release impact. Report failed and skipped checks faithfully. Do not
submit a change that fails required verification without explicit exception
handling defined by team policy.

## 5. Build And Open The Pull Request

Use the repository pull-request template, not an ad hoc body. Complete:

- summary and motivation;
- work-item, feature-contract, and delivery-plan links;
- decision files or valid no-decision-edit rationale;
- release record or no-release rationale;
- verification evidence;
- known limitations and follow-up work.

Open the pull request against the configured base and return its URL. Leave
work-item linking and review-state transitions to the coordinating workflow.
When the change belongs to a tracked work item and no coordinating workflow is
active, tell the user to run `manage-ticket` so the pull request is linked and
lifecycle state is updated.
