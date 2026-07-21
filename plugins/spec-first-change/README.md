# Spec-First Change

A Qoder plugin that enforces a spec-first development workflow before any code change.

## What It Does

Before any feature, behavior change, or architectural decision is implemented in code, this plugin verifies that the relevant spec files are reviewed, accurate, and updated to capture the decision.

## Installation

```bash
qodercli plugin install --scope local /path/to/spec-first-change
```

Or copy the `plugins/spec-first-change/` directory into your project's `.qoder/plugins/` directory.

## Usage

```
/spec-first-change [task or change description]
```

## Included Skills

| Skill | Description |
|---|---|
| `spec-first-change` | 5-step workflow: Identify affected specs → Verify accuracy → Propose updates → Apply changes → Implement |

## When to Use

- New feature requests
- Behavior or data model changes
- API contract modifications
- UX flow updates
- Architecture or tech stack decisions

## Source

Part of the [spec-driven-development-kit](https://github.com/HeyLuka/spec-driven-development-kit).
