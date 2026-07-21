---
name: spec-first-change
description: >
  Enforce a spec-first development workflow. Before any feature, behavior change,
  or architectural decision is implemented in code, verify that the relevant spec
  files are reviewed, accurate, and updated to capture the decision. Activate this
  skill whenever the user requests a new feature, a behavior change, a data model
  update, an API change, a UX flow change, or any modification that touches product
  scope, architecture, or data contracts.
version: 0.0.1
user-invocable: true
argument-hint: "[task or change description]"
---

# Spec-First Change Workflow

This skill enforces a strict spec-first principle: **no implementation code is
landed until the relevant specs have been verified and, if necessary, updated to
capture the decision being made.**

## When This Skill Applies

Activate this workflow whenever a requested change touches any of the following:

- Product scope, acceptance criteria, or launch decisions
- Implementation order, phase deliverables, or build priorities
- Route model, backend shape, deployment, or deferred scope
- Frontend data shapes, seed data, enumerations, or future relational model
- REST API endpoints, request/response schemas, or error contracts
- UX flows, happy paths, edge cases, or form states
- Tech stack or infrastructure choices
- Core product decisions documented in agent/project instruction files

If the change is purely cosmetic (CSS tweaks, typo fixes, formatting) and does
not alter any product behavior, data shape, or architectural decision, this
workflow may be skipped — but when in doubt, check the specs anyway.

## Spec Discovery

Before starting any task, identify the project's spec structure. Common patterns:

- `specs/` directory with markdown files (e.g., `prd.md`, `architecture.md`, `api-contract.md`)
- `docs/` directory with design documents
- `AGENT.md` or similar project instruction files at the root
- README files that define product decisions

If no specs exist, note this to the user and suggest creating a spec structure
before proceeding with the change.

## Workflow Steps

### Step 1: Identify Affected Specs

Before writing any implementation code, determine which spec files are relevant
to the requested change. Consider:

- Does this change add, remove, or modify a **product feature or acceptance
  criterion**? → Product requirements doc (e.g., `prd.md`, `requirements.md`)
- Does this change affect **build order, phase deliverables, or launch
  decisions**? → Roadmap doc (e.g., `ROADMAP.md`, `roadmap.md`)
- Does this change affect **routes, backend modules, deployment, data flow, or
  deferred scope**? → Architecture doc (e.g., `ARCHITECTURE.md`, `architecture.md`)
- Does this change modify **data types, enumerations, seed data, or database
  schema**? → Data model doc (e.g., `data-model.md`, `schema.md`)
- Does this change add or modify **API endpoints, payloads, or error
  responses**? → API contract doc (e.g., `api-contract.md`, `api.md`)
- Does this change affect **user interaction flows, form states, or edge
  cases**? → User flows doc (e.g., `user-flows.md`, `ux.md`)
- Does this change introduce or swap a **technology, library, or infrastructure
  component**? → Tech stack doc (e.g., `tech-stacks.md`, `tech-stack.md`)

Read each identified spec file in full before proceeding.

### Step 2: Verify Spec Accuracy

For each relevant spec file, verify:

- [ ] The spec accurately describes the **current** intended behavior (not a
      stale or superseded version).
- [ ] The requested change is **consistent** with the spec, or the spec needs
      to be updated to accommodate the change.
- [ ] No **contradictions** exist between the affected specs and other spec
      files.
- [ ] The spec's decision log or equivalent section already captures this
      decision, or a new entry is needed.

If specs disagree, follow the project's source priority order (typically: PRD >
Roadmap > Architecture > Data Model > API Contract > User Flows > Tech Stack).

### Step 3: Propose Spec Updates (if needed)

If the change introduces a new decision, modifies existing behavior, or
contradicts a current spec:

1. **Draft the spec update first.** Write the exact additions, modifications, or
   removals needed in each affected spec file.
2. **Present the spec diff to the user for review.** Clearly show:
   - Which spec files will be modified.
   - What is being added, changed, or removed.
   - Why the update is necessary.
3. **Wait for user approval** before applying the spec changes.

### Step 4: Apply Spec Changes

Once the user approves, apply the spec updates. Ensure:

- New decisions are recorded in the appropriate decision log section.
- Acceptance criteria are updated if scope changes.
- Data shapes, enumerations, or API contracts reflect the new state.
- Project instruction files (e.g., `AGENT.md`) are updated if core product
  decisions change.
- The roadmap is updated if phase deliverables or build order changes.

### Step 5: Proceed to Implementation

Only after specs have been verified (and updated if necessary) should
implementation code be written. During implementation:

- Reference the spec sections that justify the implementation decisions.
- If an implementation detail reveals a spec gap (something the spec doesn't
  address), pause and go back to Step 3 to capture it before continuing.

## Handling Ambiguity

If a spec is ambiguous about the requested change:

- Choose the **conservative option** that preserves the current version's scope.
- Note the assumption in the touched spec file.
- Flag the ambiguity to the user so they can resolve it explicitly.

## Handling New Spec Files

If a change requires documentation that doesn't fit any existing spec file:

1. Propose a new spec file with a clear, descriptive name.
2. Explain its scope and relationship to existing specs.
3. Get user approval before creating it.
4. Add it to the project's spec structure and priority order.

## Change Log Discipline

When updating a spec, keep changes surgical:

- Add new entries rather than rewriting existing sections when possible.
- Preserve the document's existing structure and tone.
- Do not remove resolved decisions unless the user explicitly asks to reverse
  them.
- Add a brief context note if the motivation for a change isn't obvious from the
  content alone.

## Quick Reference Checklist

Use this checklist as a gate before any implementation work:

```
Before writing code:
  □ Identified all affected spec files
  □ Read each affected spec in full
  □ Verified specs are accurate and current
  □ Checked for contradictions across specs
  □ Drafted necessary spec updates
  □ Presented spec diffs to user
  □ Received user approval on spec changes
  □ Applied approved spec changes
  □ Ready to implement against verified specs
```

## Integration with Existing Workflows

This skill integrates with common development workflows:

- **Feature requests**: Run this workflow before starting feature implementation
- **Bug fixes**: Check if the bug reveals a spec gap or contradiction
- **Refactoring**: Verify the spec reflects the desired end state before refactoring
- **Code review**: Use specs as the source of truth for expected behavior

## When to Skip This Workflow

Skip the spec-first workflow only when:

- The change is purely cosmetic (formatting, typo fixes, CSS tweaks)
- The change is explicitly marked as experimental or throwaway
- The user explicitly requests to skip spec updates (and acknowledges the risk)
- The project has no spec structure and the user declines to create one

In all other cases, follow the spec-first workflow to maintain decision clarity
and prevent scope drift.
