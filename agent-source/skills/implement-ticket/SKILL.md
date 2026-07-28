---
name: implement-ticket
description: >-
  Implement and verify an already-refined work item (story, bug, or task in the
  configured issue tracker, e.g. Jira). Use when the user asks to implement,
  develop, build, or fix a ticket with current approved scope. Validates the
  Implementation Ready record, prepares the branch, invokes spec-first
  development, tests the result, and records completion evidence. Does not
  submit a pull request or close the work item.
---
{{GENERATED_NOTICE}}

# Implement Ticket

Own the verified repository change and its implementation evidence. Apply the
shared workflow rules in the agent instructions; project configuration comes
from the project profile.

## Workflow

1. Load the work item, relevant links and dependencies, lifecycle record, and
   transitions.
2. Require a current **Implementation ready: Yes** record containing approved
   scope, exclusions, measurable acceptance criteria, classification, decision
   owners or rationale, implementation boundary, verification, release impact,
   blockers, and proposed branch.
3. Compare the record with the work item and relevant repository authorities.
   If it is missing, stale, contradictory, unapproved, or blocked, route to
   `refine-ticket`; do not refine inside this skill.
4. Present the approved boundary and obtain implementation approval.
5. Reconcile local and remote Git state, the proposed branch, and discoverable
   pull-request state. Create the approved branch from a clean default branch
   or reuse the valid branch. Only then move to an available active state.
6. Invoke `spec-first-change` to land approved decisions, implement the
   smallest conforming change, verify acceptance criteria, and assess release
   impact. The approved Implementation Ready record satisfies its decision and
   implementation approval gates for the scope the record covers; do not
   re-request those approvals. The branch is already prepared; skip its
   branch-preparation step.
7. Route every material scope delta back through refinement before resuming.
8. Update the stable lifecycle record with implemented scope, decision changes
   or rationale, acceptance evidence, tests, release bookkeeping, limitations,
   blockers, next action, and pull-request readiness.

If blocked, preserve completed evidence and use a blocked state only when the
provider exposes an appropriate transition.

Finish after the verified repository change and work-item evidence. Stop
before pull-request submission.
