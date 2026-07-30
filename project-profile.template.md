# SDD Project Profile

Complete this profile before enabling the workflow. Replace instructional
examples with authoritative project values. Use `N/A` with a reason when an
optional authority, integration, or command does not apply.

## Authorities

| Topic | Authoritative document or location |
|---|---|
| Product behavior | Path to the product specification |
| UX and interaction | Path to the UX specification, feature contracts, or N/A rationale |
| Cross-cutting architecture | Path to the architecture record |
| Feature contracts | Feature-contract path convention |
| Delivery order and status | Path to the roadmap or delivery plan |

Describe the upstream-to-downstream specification chain and which affected
documents must change when an approved decision changes.

## Repository Paths

- Implementation paths:
- Decision paths:
- Durable documentation paths:

## Issue Tracking

- Provider and instance, or N/A:
- Project identifier:
- Supported work-item types:
- Ready, active, review, blocked, and done semantics:
- Stable lifecycle record location:
- Required links and dependency behavior:

Agents discover actual transition identifiers and required fields from provider
metadata instead of assuming display names are stable.

## Git And Pull Requests

- Default branch:
- Branch naming convention:
- Pull-request provider and template:
- Required checks:
- No-decision-edit label:

## Release Policy

- Release policy document:
- Changelog:
- Version scheme and release triggers:
- Version-bearing manifests and corresponding lockfiles:
- Release verification:
- Tag or publish convention:

## Architecture Invariants

List only hard, cross-cutting constraints implementation must preserve. Link
each invariant to its authoritative architecture section.

## Verification

- Fast focused checks:
- Backend checks:
- Frontend checks:
- Manual or visual checks:
- Release-wide checks:
- When existing verification evidence may be reused:

## External Systems

For each required external system, identify the approved integration, access
constraints, fallback policy, and safe defaults. Never place credentials in
this profile.
