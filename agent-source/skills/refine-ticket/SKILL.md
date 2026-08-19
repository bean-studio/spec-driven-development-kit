---
name: refine-ticket
description: >-
  Refine and finalize a work item (story, bug, task, or epic in the configured
  issue tracker, e.g. Jira) for implementation. Use when the user asks to
  clarify, scope, refine, finalize, prepare, or make a ticket
  implementation-ready, or to decompose an epic. Resolves ambiguity, obtains
  approval, and records one idempotent Implementation Ready or Decomposition
  Ready record. Does not implement the change.
---
{{GENERATED_NOTICE}}

# Refine Ticket

Own approved scope, the implementation handoff, and epic decomposition. Do not
create a branch, edit repository files, move the work item to active work, or
implement — that is `implement-change` — and do not submit a pull request (that
is `submit-pr`).

Apply the shared workflow rules in the agent instructions. The issue provider,
supported work-item types, state semantics, and lifecycle-record location come
from the project profile.

## Workflow

Load the work item, relevant parent and links, lifecycle record, dependencies,
and available transitions. Decide from the profile's supported work-item types
whether the item is implementable on its own or is a container whose children
carry the work, and follow the matching path. When the type is ambiguous, treat
an item that already has or needs children as a container.

Both paths share a spine: classify the change, find the gaps, propose exact
decision text for every material decision against the repository document that
owns it, obtain explicit approval before writing anything, then shape the
description — preserving unrelated content, updating exposed native fields, and
removing each open question the approved answers resolve — and record readiness
once. Each path below carries only what differs.

### Implementable Item

1. Classify and diagnose the change using the four classifications in the
   shared policy and change protocol: trace the implicated behavior to its
   controlling decision, code path, and cheapest discriminating check.
2. Identify gaps or contradictions in the problem statement, scope boundaries,
   acceptance criteria, open questions, dependencies, verification, release
   impact, and implementation boundary. When the change is user-visible, check
   it against the UX or feature contract the profile makes authoritative.
3. Present the complete proposed handoff for approval.
4. Shape the description to `assets/work-item-description.md` bundled with this
   skill, and amend scope or acceptance criteria that an approved decision
   changed.
5. Create or update one stable Implementation Ready record using
   `assets/implementation-ready.md` bundled with this skill.

Set **Implementation ready: Yes** only when:

- the problem and scope are approved and no open question remains;
- acceptance criteria are measurable;
- every material decision is approved and names its owning repository document,
  or has a valid N/A rationale;
- verification and release impact are identified;
- no unresolved blocker prevents implementation.

### Container Item

1. Classify the epic's dominant change using the same four classifications, and
   name where the classification differs for a child.
2. Identify gaps or contradictions in the problem statement, boundary,
   decomposition coverage, epic-level open questions, dependencies,
   verification strategy, and release impact.
3. Scope decisions to the epic: leave one that only a single child's
   implementation settles to that child.
4. Present the proposed boundary, decomposition, and decisions for approval.
5. Shape the description to `assets/epic-description.md` bundled with this
   skill.
6. Create or update child items so each covers one boundary slice, is separately
   deliverable, and is linked to this epic. Express order and dependencies as
   tracker links.
7. Create or update one stable Decomposition Ready record using
   `assets/decomposition-ready.md` bundled with this skill.

Set **Decomposition ready: Yes** only when:

- the problem and boundary are approved and no blocking epic-level question
  remains;
- every child item exists, is linked, and is separately deliverable;
- the children together cover the boundary and nothing outside it;
- exit criteria are measurable at the epic level;
- every material epic-level decision is approved and names its owning
  repository document, or has a valid N/A rationale;
- release impact is identified and no unresolved blocker prevents starting the
  first child.

Never record implementation readiness or a proposed branch on a container item.
Refine a child to implementation readiness through the implementable path, one
child at a time and only when asked.

### Both Paths

The description carries the problem, the approved boundary, remaining open
questions, and the criteria for done. The readiness record carries the readiness
gate and the resolved decisions. Neither restates the other.

Write an approval, an answered question, or a decision owner as the fact and its
date, with the owning repository document as the owner — including when the user
names someone while approving.

Move to an available ready or backlog state only when that state is accurate.

Finish with the work-item update, readiness value, approved decisions,
blockers, and expected repository decision files. For a container, also finish
with the child items created or changed. Stop without repository changes.
