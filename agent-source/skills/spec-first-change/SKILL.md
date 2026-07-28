---
name: spec-first-change
description: >-
  Drive an existing or net-new product change through classification, approved
  decisions, implementation, and verification. Use for bugs, behavior changes,
  UX changes, enhancements, new capabilities, explicit-spec drift, and
  mechanical or tooling work. Does not submit a pull request.
---
{{GENERATED_NOTICE}}

# Spec-First Change

Follow the repository's SDD policy, project profile, source precedence, and
architecture invariants.

Do not change implementation until the controlling decision is already explicit
or the user has approved the new decision for its owning document.

## 1. Capture The Request

For existing behavior, capture the observation, expected behavior, location, and
a reproducible example. For net-new work, capture the objective, users,
boundaries, dependencies, and measurable acceptance criteria. Ask only for
missing information that affects classification or implementation.

## 2. Diagnose And Classify

Trace only the implicated behavior to its controlling decision, code path, and
cheapest discriminating check. State the evidence for one classification:

- **Explicit-spec drift**: cite the authoritative clause contradicted by code.
  Use that clause as the decision basis and do not edit it merely to accompany
  the code change.
- **Existing-behavior gap or change**: identify the ambiguity or intended change
  and the document that owns the missing decision.
- **Net-new capability**: identify upstream product grounding, affected
  downstream contracts, measurable acceptance criteria, and delivery-plan
  placement.
- **Mechanical or tooling work**: identify the focused verification and explain
  why no product, UX, API, data-model, or cross-cutting application decision
  changes.

If multiple classifications are defensible and they imply different decision
work, ask the user to choose.

## 3. Propose And Gate

Present:

- classification and evidence;
- owning decision files and downstream propagation;
- exact proposed decision text, or the cited existing clause or no-decision-edit
  rationale;
- implementation boundary and exclusions;
- measurable acceptance criteria and verification;
- release impact.

Obtain explicit approval before recording a new material decision or changing
implementation. A current, approved Implementation Ready record satisfies this
gate for the decisions and scope it covers; do not re-request approval for
them. Explicit-spec drift and mechanical/tooling changes need no decision-text
approval, but implementation approval still applies when required by the
calling workflow.

## 4. Record Approved Decisions

Write approved decisions into their owning documents before code. Propagate only
approved upstream changes. Keep feature contracts, backend or API contracts,
acceptance criteria, and resolved open questions aligned according to the
project profile.

## 5. Prepare The Branch And Implement

If no calling workflow has already prepared a work branch, prepare one before
editing implementation: reconcile worktree state, preserve unrelated work, and
create or reuse a branch named per the project profile from a clean default
branch. Never implement or commit on the default branch.

Implement the smallest conforming change using repository conventions and
architecture invariants. Start from the controlling code path.

Stop and return to refinement if implementation reveals a material scope,
acceptance, dependency, or decision change.

## 6. Verify And Complete

- Run focused acceptance checks first, then broaden according to risk and blast
  radius.
- Apply release bookkeeping in the same change when the project release trigger
  is met, including every manifest and corresponding lockfile.
- Report passed, failed, and skipped checks faithfully.
- Produce completion evidence using the repository's lifecycle-evidence
  template: implemented scope, classification, decisions or rationale,
  acceptance evidence, verification, release impact, limitations, blockers, and
  next action.

Stop after the verified repository change. Pull-request submission is an
independent workflow and requires an explicit request or coordinator handoff.
