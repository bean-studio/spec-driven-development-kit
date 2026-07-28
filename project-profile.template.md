# SDD Project Profile

Complete this profile before enabling the workflow. Replace every instructional
example with an authoritative project value.

## Authorities

| Topic | Authoritative document or location |
|---|---|
| Product behavior | Path to the product specification |
| UX and interaction | Path to the UX specification |
| Cross-cutting architecture | Path to the architecture record |
| Feature contracts | Feature-contract path convention |
| Delivery order and status | Path to the roadmap or delivery plan |

Describe the project's upstream-to-downstream specification chain and the rule
for propagating approved changes.

## Implementation And Decision Paths

- Implementation paths: list directories treated as product implementation.
- Decision paths: list files or directories that record product and architecture
  decisions.
- Documentation paths: list durable user and operator documentation.

## Issue Tracking

- Provider and instance:
- Project or organization identifier:
- Supported work-item types:
- Ready, active, review, blocked, and done state semantics:
- Stable lifecycle record location:
- Required link and dependency behavior:

Agents must discover actual transition identifiers and required fields from the
provider instead of assuming display names are stable.

## Git And Pull Requests

- Default branch:
- Branch naming convention:
- Pull-request provider:
- Pull-request template:
- Required checks:
- Label used when no decision-file edit is required:

## Release Policy

- Release policy document:
- Changelog:
- Version scheme:
- Release triggers:
- Version-bearing manifests:
- Corresponding lockfiles:
- Release verification:
- Tag convention:

## Architecture Invariants

List only hard, cross-cutting constraints that implementation must preserve.
Link each invariant to its authoritative architecture section.

## Verification

- Fast focused test commands:
- Backend test and validation commands:
- Frontend test, typecheck, and build commands:
- Manual or visual verification requirements:
- Release-wide verification commands:

## External Systems

For each required external system, identify the approved integration, access
constraints, fallback policy, and safe defaults. Never place credentials in this
profile.
