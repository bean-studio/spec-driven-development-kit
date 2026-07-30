# Architecture Record

This document is the authority for cross-cutting technical decisions. Record
only decisions that span features; feature-local detail belongs in feature
contracts. Number sections so other documents can cite them.

## 1. Runtime And Deployment

Record the runtime model, process topology, and deployment constraints that
implementation must respect.

## 2. Data Model And Identity

Record entity identity, ID schemes, lineage or traceability rules, and scoping
rules that apply across features.

## 3. External Boundaries

Record each external system boundary, the single approved integration path for
it, and the failure policy at that boundary.

## 4. Storage And Persistence

Record storage engines, ownership of schemas and migrations, and durability
rules.

## 5. API Conventions

Record wire-format conventions: casing, error shape, pagination, versioning.

## 6. Invariants

List hard rules implementation must never break, one per bullet, each stated so
a violation is checkable. These are the rules the project profile's
architecture-invariants section links to.

## 7. Testing Strategy

Record what must be tested first (hard rules, state transitions, contract
shapes), what may be tested after implementation, and where the required
commands are listed in the project profile.

## Open Questions

- [ ] Question
  - **Owner:** decision maker or authoritative source
  - **Decision:** complete only after approval; cite the decision source
