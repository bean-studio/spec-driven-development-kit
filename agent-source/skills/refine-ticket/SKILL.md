---
name: refine-ticket
description: >-
  Refine and finalize a work item (story, bug, or task in the configured issue
  tracker, e.g. Jira) for implementation. Use when the user asks to clarify,
  scope, refine, finalize, prepare, or make a ticket implementation-ready.
  Resolves ambiguity, obtains approval, and records one idempotent
  Implementation Ready record. Does not implement the change.
---
{{GENERATED_NOTICE}}

# Refine Ticket

Own approved scope and the implementation handoff. Apply the shared workflow
rules in the agent instructions; project configuration comes from the project
profile.

## Workflow

1. Load the work item, relevant parent and links, lifecycle record,
   dependencies, and available transitions.
2. Classify and diagnose the change using the four classifications in the
   shared policy, with the same evidence standard `spec-first-change` applies:
   trace the implicated behavior to its controlling decision, code path, and
   cheapest discriminating check.
3. Identify gaps or contradictions in objective, boundaries, exclusions,
   acceptance criteria, dependencies, decisions, verification, release impact,
   and implementation boundary.
4. For every material decision, identify the owning repository document and
   propose exact decision text.
5. Present the complete proposed handoff and obtain explicit approval.
6. Preserve unrelated work-item content while updating exposed native fields.
7. Create or update one stable Implementation Ready record using the
   repository template.

Set **Implementation ready: Yes** only when:

- objective, scope, and exclusions are approved;
- acceptance criteria are measurable;
- every material decision is approved and has an owner, or has a valid N/A
  rationale;
- verification and release impact are identified;
- no unresolved blocker prevents implementation.

Move to an available ready or backlog state only when that state is accurate.
Never transition to active development from this skill.

Finish with the work-item update, readiness value, approved decisions,
blockers, and expected repository decision files. Stop without repository
changes.
