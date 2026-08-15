# Spec-Driven Development Policy

## 1. Authority

- A work item is intake, not product authority.
- Product specifications own intended behavior.
- Architecture records own cross-cutting technical decisions.
- Feature contracts connect product intent to implementation and acceptance.
- Delivery plans own ordering and completion state.
- Code is downstream. Restore code to an explicit authoritative decision rather
  than weakening that decision to match drifted implementation.
- Each repository must identify its concrete authorities and their precedence
  in a project profile.

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
- Read the governing upstream documents before editing a downstream one. Search
  for the governing clause first and read only the matched sections; full-read a
  document only when it owns the decision at hand.
- Propagate an approved upstream change to affected downstream contracts only
  with approval.
- Keep contract declarations and acceptance criteria aligned.
- Resolve open questions in place and preserve the source of the decision.
- Stop and return to refinement when implementation reveals a material scope or
  decision change.

## 4. Workflow Boundaries

- Refinement owns approved scope and the implementation handoff. It does not
  implement.
- Implementation owns the verified repository change, including required
  decision propagation, release bookkeeping, and delivery-status updates. It
  does not submit a pull request or close the work item.
- Pull-request submission owns final diff and evidence validation, pull-request
  template completion, and submission. It does not invent scope, make product
  decisions, or become a second path for repository changes.
- Review follow-up that changes code returns to implementation when it remains
  inside approved scope, or to refinement when it changes material scope,
  acceptance criteria, dependencies, or decisions.

Cross a boundary only after the current stage's completion contract is satisfied
and the next required approval is present.

## 5. Approval Gates

Require explicit approval for:

- new or changed material decisions and materially expanded scope;
- unsafe branch preparation or handling ambiguous worktree state;
- material scope changes discovered during implementation;
- pull-request submission when it was not already explicitly requested.

An explicit request to implement a clear boundary authorizes implementation.
Do not re-request a still-current approval, but do not treat a broad request as
approval for a newly discovered material decision.

## 6. Git Safety

- Never implement or commit on the default branch.
- Preserve unrelated worktree changes and existing user work.
- Reuse a valid work-item branch and open pull request instead of duplicating
  them.
- Do not discard, overwrite, hide, or rewrite unrelated changes.
- Reconcile local, remote, work-item, and pull-request state before mutating any
  of them.
- Refresh work-item, branch, transition, and pull-request state immediately
  before mutating the corresponding system.

## 7. Verification And Evidence

- Derive verification from measurable acceptance criteria and project
  invariants.
- Order tests by risk: hard rules, state transitions, and contract shapes before
  CRUD and presentation details.
- Use the cheapest focused check that can falsify the implementation hypothesis,
  then broaden verification according to blast radius.
- Report passed, failed, and skipped checks faithfully.
- Reuse verification evidence when the tested change has not moved and project
  policy does not require a fresh run.
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
- Pull-request submission validates release bookkeeping against the final diff.
  Missing or contradictory bookkeeping makes implementation incomplete and
  returns to that stage.

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
- Put project-specific facts and rules in the project profile rather than
  forking shared skills without need.
- Route a new rule to its owning file. A concrete value, path, command, state,
  or identifier belongs in the project profile. A principle that holds for any
  repository belongs in this policy. Agent behavior and navigation belong in
  the shared agent instructions. A multi-step procedure with a completion
  contract belongs in a skill.
- Precedence on conflict: the project profile is authoritative for project
  facts, and this policy is authoritative for approval, traceability,
  verification, and Git-safety guarantees. A profile may adapt facts but may
  not silently weaken a guarantee.
- Shared agent instructions win neither contest. They may compress a policy
  clause that must be available without a second read; any other disagreement
  with this policy or the profile is drift to repair at the canonical source.
