# Changelog

All notable releases for the spec-driven development kit are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] — 2026-07-21

### Added

- **`spec-first-change`** (v0.0.1) — Enforces a spec-first development workflow,
  verifying that relevant spec files are reviewed, accurate, and updated before any
  implementation code is written.
- **`submit-pr`** (v0.0.1) — Enforces test passage and PR template usage before
  submitting a Pull Request. Validates that all configured tests have passed and
  assembles a standardised PR body from the project's template.
- **`jira-ticket-work`** (v0.0.1) — End-to-end JIRA ticket workflow orchestration.
  Takes a ticket from scope review through spec-driven implementation, acceptance
  criteria validation, PR submission, and ticket resolution. Composes the
  `spec-first-change` and `submit-pr` skills.
- `README.md` with kit overview, skill descriptions, and getting started guide.
- `LICENSE` (MIT) to clarify usage terms.
