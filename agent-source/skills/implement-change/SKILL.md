---
name: implement-change
description: >-
  Implement and verify a repository change, whether it comes from an approved
  work item or an ad-hoc request. Use for bugs, behavior or UX changes,
  enhancements, new capabilities, explicit-spec drift, and mechanical or
  tooling work. Reuses an approved Implementation Ready record when one
  exists. Does not submit a pull request.
---
{{GENERATED_NOTICE}}

# Implement Change

Own the verified repository change. Follow the SDD policy and project profile,
and read only the authority, code path, and checks needed for this change.

## 1. Establish The Boundary

If the change comes from a tracked work item, load the item and its stable
lifecycle record. Reuse a current approved Implementation Ready record instead
of repeating its diagnosis, decisions, scope, or acceptance criteria.

Otherwise capture enough to act safely:

- objective and expected behavior;
- classification under the shared policy;
- cited existing decision, exact proposed decision, or no-decision-edit
  rationale;
- scope and exclusions;
- measurable acceptance criteria and focused verification;
- expected release impact.

Use `refine-ticket` when a tracked item has material ambiguity or missing
decisions. For a clear request, present the boundary briefly and proceed when
the user's request already authorizes that implementation. Obtain explicit
approval for any new material decision or expanded scope.

## 2. Prepare The Change

- Reconcile the worktree, local and remote branch, and any existing pull
  request.
- Preserve unrelated work.
- Create or reuse a branch named according to the project profile.
- Never implement or commit on the default branch.
- Record approved material decisions in their owning documents before or with
  code, propagating only the affected downstream contracts.

## 3. Implement

Implement the smallest conforming change from the controlling code path while
preserving project architecture invariants.

If implementation reveals a material scope, acceptance, dependency, or
decision change, stop. Return a tracked item to refinement or obtain an updated
decision for an ad-hoc request.

Review feedback inside the approved boundary follows this same workflow.
Material review changes return to refinement.

## 4. Verify And Complete

- Run the cheapest focused acceptance check first, then broaden according to
  risk and blast radius.
- Apply required changelog, version, lockfile, documentation, and delivery-plan
  updates in the same change.
- Report passed, failed, and skipped checks faithfully.
- Record concise completion evidence using the lifecycle-evidence template.
- For a tracked item, update its stable lifecycle record and accurate active or
  blocked state.

Stop after the verified repository change. Pull-request submission is a
separate workflow.
