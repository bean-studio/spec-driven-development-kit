---
name: submit-pr
description: >-
  Validate a completed change's decision, release, and verification evidence
  and open a pull request from the repository template. Use for explicit
  pull-request submission after implementation. Does not edit repository
  content, decide product scope, or close a work item.
---
{{GENERATED_NOTICE}}

# Submit Pull Request

Start only after implementation is complete and submission is requested. Own
final diff and evidence validation, template completion, and pull-request
creation. Do not refine scope (that is `refine-ticket`) or edit repository
content (that is `implement-change`); do not invent decisions or close a work
item.

## 1. Establish The Pull-Request Boundary

- Determine the base branch from the project profile.
- Inspect worktree state, commits relative to the base, changed-file summary,
  and substantive hunks.
- Reconcile any existing pull request for the branch.
- If intended work is uncommitted, surface it and obtain any required commit or
  branch approval.

## 2. Confirm Decision Evidence

Require the decision evidence `POLICY.md` §9 defines for every implementation
change. Do not use the no-decision-edit route to avoid recording a material
decision. Apply the configured label only when its rationale is present in the
pull-request body.

## 3. Validate Release Evidence

Validate release bookkeeping against the final diff per `POLICY.md` §8: if a
trigger is met, require aligned delivery status, changelog, manifests, and
lockfiles; if not, require its rationale. Do not edit release files here —
missing or contradictory bookkeeping returns implementation to that stage.

## 4. Verify Before Submission

Reuse recorded checks when the change has not moved since they ran. Run only
missing, affected, or submission-specific checks appropriate to the actual
diff and release impact. Do not submit a change that fails required
verification without explicit exception handling defined by team policy.

## 5. Build And Open The Pull Request

Use the repository pull-request template, not an ad hoc body. Complete:

- summary and motivation;
- work-item, feature-contract, and delivery-plan links;
- decision files or valid no-decision-edit rationale;
- release record or no-release rationale;
- verification evidence;
- known limitations and follow-up work.

Open the pull request against the configured base and return its URL. When the
change belongs to a tracked item, link the pull request once, update the stable
lifecycle record, and move the item to an available review state.
