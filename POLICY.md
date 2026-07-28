# Spec-Driven Development Policy

## 1. Authority

- A work item is intake, not product authority.
- Product specifications own intended behavior.
- Architecture records own cross-cutting technical decisions.
- Feature contracts connect product intent to implementation and acceptance.
- Delivery plans own ordering and completion state.
- Code is downstream. Restore code to an explicit authoritative decision rather
  than weakening that decision to match drifted implementation.
- Each repository must identify its concrete authorities in a project profile.

## 2. Change Classification

Classify every change before editing implementation:

1. **Explicit-spec drift**: implementation contradicts an authoritative clause.
   Cite the clause and restore conformance. Do not edit the decision merely to
   make the implementation change pass a process check.
2. **Existing-behavior gap or change**: behavior is unspecified, ambiguous, or
   intentionally changing. Obtain approval and record the decision in its owning
   document before or with implementation.
3. **Net-new capability**: establish upstream product grounding, downstream
   feature contracts, measurable acceptance criteria, and delivery-plan
   placement before implementation.
4. **Mechanical or tooling work**: no product, UX, API, data-model, or
   cross-cutting application decision changes. Record why no decision-file edit
   is required.

If more than one classification is plausible and the choice changes the required
decision work, obtain a decision instead of choosing the easiest route.

## 3. Decisions Before Code

- Record a new or changed material decision in the document that owns it.
- Propagate an approved upstream change to affected downstream contracts only
  with approval.
- Keep contract declarations and acceptance criteria aligned.
- Resolve open questions in place and preserve the source of the decision.
- Stop and return to refinement when implementation reveals a material scope or
  decision change.

## 4. Workflow Boundaries

- Refinement owns approved scope and the implementation handoff. It does not
  implement.
- Implementation owns the verified repository change. It does not submit a pull
  request or close the work item.
- Pull-request submission owns final review, release bookkeeping, verification,
  and submission. It does not invent scope or product decisions.
- Lifecycle coordination reconciles state and routes to focused workflows. It
  does not create a second implementation path.

Cross a boundary only after the current stage's completion contract is satisfied
and the next required approval is present.

## 5. Approval Gates

Require explicit approval for:

- finalized implementation scope and material decisions;
- beginning implementation from an approved handoff;
- unsafe branch preparation or handling ambiguous worktree state;
- material scope changes discovered during implementation;
- pull-request submission when it was not already explicitly requested.

Approval must identify what was approved. A broad request does not silently
waive later material-decision gates.

## 6. Git Safety

- Never implement or commit on the default branch.
- Preserve unrelated worktree changes and existing user work.
- Reuse a valid work-item branch and open pull request instead of duplicating
  them.
- Do not discard, overwrite, hide, or rewrite unrelated changes.
- Reconcile local, remote, work-item, and pull-request state before mutating any
  of them.

## 7. Verification And Evidence

- Derive verification from measurable acceptance criteria and project
  invariants.
- Test hard rules, state transitions, and contract shapes before lower-risk CRUD
  or presentation details when risk warrants that order.
- Use the cheapest focused check that can falsify the implementation hypothesis,
  then broaden verification according to blast radius.
- Report passed, failed, and skipped checks faithfully.
- Completion evidence identifies implemented scope, decision basis, acceptance
  evidence, tests, release impact, limitations, blockers, and next action.

## 8. Releases And Changelog

- Assess release impact for every completed implementation.
- User-facing behavior and completed delivery milestones require the repository's
  release bookkeeping in the same change unless its profile explicitly defines a
  different release boundary.
- Keep every version-bearing manifest and corresponding lockfile aligned.
- Write changelog entries for users and operators, not as a raw commit list.
- Pure documentation, specification-only, refactor, and tooling work normally do
  not require a product release unless the project profile says otherwise.
- Post-merge tag or publish steps required by the project's release policy are
  performed or confirmed during lifecycle closure and recorded in its evidence.

## 9. Pull-Request Guardrails

- Decisions move with code: a pull request identifies the authoritative basis
  for every material behavior or contract change.
- A pull request with no decision-file edit must state one valid rationale:
  implementation restored conformance to a cited existing decision, or the work
  was mechanical/tooling with no behavior or contract impact.
- Pull requests use the repository template and complete its decision, release,
  and verification sections.
- Automated path checks are backstops, not proof that the recorded decision is
  correct.

## 10. Customization Ownership

- Maintain one canonical source for shared agent instructions and skills.
- Generate vendor-specific discovery files when multiple agent products are
  supported.
- Mark generated files and reject stale generated outputs in CI.
- Put project-specific rules in the project profile rather than forking shared
  skills without need.
