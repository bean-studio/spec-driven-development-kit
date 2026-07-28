---
name: manage-ticket
description: >-
  Coordinate the lifecycle of a work item (story, bug, or task in the
  configured issue tracker, e.g. Jira) by reconciling work-item, branch, and
  pull-request state and routing to refinement, implementation, submission,
  review follow-up, or post-merge closure. Use for broad requests to work,
  manage, continue, resume, or close a ticket when the lifecycle stage is not
  already explicit.
---
{{GENERATED_NOTICE}}

# Manage Ticket

Own lifecycle routing, cross-stage reconciliation, pull-request follow-up, and
post-merge closure. Delegate focused work to `refine-ticket`,
`implement-ticket`, and `submit-pr`.

Apply the shared workflow rules in the agent instructions. The issue provider,
Git conventions, and pull-request provider come from the project profile.

## Reconcile And Route

Load the work item, relevant parent and links, stable lifecycle record,
transitions, Git state, work-item branch, and discoverable pull-request state.
Route from evidence, not status alone:

- missing, ambiguous, contradictory, stale, or unapproved scope ->
  `refine-ticket`;
- current **Implementation ready: Yes** record with no completed change ->
  `implement-ticket`;
- verified implementation plus explicit submission approval -> `submit-pr`;
- open pull request -> report checks and perform only requested follow-up;
- material review scope change -> `refine-ticket`;
- closed, unmerged pull request -> record the blocker and obtain a reopen-or-
  replace decision;
- provider-confirmed merged pull request -> post-merge closure.

Honor explicit refine, implement, or submit requests when their prerequisites
are satisfied. For broad requests, start at the earliest incomplete phase and
cross each boundary only after the focused skill's completion contract and
next approval gate are satisfied.

## Pull-Request And Closure Ownership

After submission, add the pull-request link once, update lifecycle evidence,
and transition to an available review state. Reuse an open pull request or
obtain a decision before replacing a closed, unmerged one.

Mark the work item done only when the hosting provider reports a merged state
and merge timestamp. Then:

- perform or confirm any post-merge tag or publish step the project release
  policy requires for the merged change, and record the result;
- update final evidence and set a resolution when exposed;
- use an available done-category transition.

If tools, permissions, transition fields, Git state, or scope block progress,
preserve evidence and ask one focused question.
