# Release Policy

## Version Scheme

Define the project's version scheme and the meaning of major, minor, and patch
changes. Define any pre-1.0 policy explicitly.

## Release Triggers

State which events require release bookkeeping. At minimum, decide how the
project treats:

- new user-facing capability;
- user-facing fixes and polish;
- completed delivery milestones;
- documentation and specification-only changes;
- refactors and tooling changes;
- emergency releases.

## Sources Of Truth

- Product version manifests:
- Corresponding lockfiles:
- Human-readable changelog:
- Delivery status:
- Release tags:

Every version-bearing manifest and corresponding lockfile must remain aligned.
Durable documentation should link to version and delivery sources rather than
copying values that will become stale.

## Release Checklist

1. Confirm acceptance criteria and delivery milestone status.
2. Run release-appropriate automated and manual verification.
3. Select the version according to this policy.
4. Update every version-bearing manifest.
5. Regenerate and update every corresponding lockfile.
6. Add a newest-first changelog entry focused on users and operators.
7. Verify the aligned version metadata.
8. Commit and tag according to repository policy.
