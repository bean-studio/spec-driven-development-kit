## Problem

What is wrong or missing, and the evidence for it: observed versus expected,
and where it is observable. No solution, no design.

## Scope

Numbered, separately verifiable pieces of work. State each boundary inline as
"Not in scope: ...".

## Open questions

One per line, each marked blocking or non-blocking. Refinement removes a
question once its answer is recorded in the Implementation Ready record. Remove
the section when empty.

## Acceptance criteria

One checkable statement per line: what must be observably true for this item to
be done.

---

The sections above are the same for every implementable type. What the change is
decides the additions below, not the tracker's type field: a task can change
user-visible behavior and a story can be entirely internal, so read each
condition against the change itself.

- A defect's Problem carries reproduction steps and the affected version or
  environment as part of its evidence.
- A net-new capability states the absent capability and the expected behavior as
  its evidence; there is no observed side to contrast.
- A mechanical or tooling item may state the obligation that makes the work
  necessary in place of a defect, and still needs measurable acceptance
  criteria.
- A change to user-visible behavior names the UX or feature contract it conforms
  to or changes, so acceptance criteria can be checked against that contract.
- A child item states only the slice of scope it owns and does not restate its
  parent's boundary; the parent link carries the rest.

Dependencies and blockers use the tracker's native links and the Implementation
Ready record, not a section here.
