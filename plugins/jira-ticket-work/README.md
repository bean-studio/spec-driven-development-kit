# JIRA Ticket Work

A Qoder plugin for end-to-end JIRA ticket workflow orchestration.

## What It Does

Takes a JIRA ticket from scope review through spec-driven implementation, acceptance criteria validation, PR submission, and ticket resolution. Orchestrates the `spec-first-change` and `submit-pr` companion skills.

## Installation

```bash
qodercli plugin install --scope local /path/to/jira-ticket-work
```

Or copy the `plugins/jira-ticket-work/` directory into your project's `.qoder/plugins/` directory.

## Prerequisites

See [CONNECTORS.md](./CONNECTORS.md) for required setup, including the Atlassian MCP server.

### Companion Plugins

This plugin composes two other plugins from the spec-driven development kit:

- **`spec-first-change`** — install from `plugins/spec-first-change/`
- **`submit-pr`** — install from `plugins/submit-pr/`

## Usage

```
/jira-ticket-work <ticket-key-or-url> [base-branch]
```

## Included Skills

| Skill | Description |
|---|---|
| `jira-ticket-work` | 7-step workflow: Fetch ticket → Clarify scope → Spec-driven implementation → Validate AC → Submit PR → Wait for merge → Resolve ticket |

## Workflow Steps

1. **Fetch & Review Ticket** — parse ticket, fetch details, transition to In Progress
2. **Clarify Scope** — resolve ambiguities via interactive widgets
3. **Spec-Driven Implementation** — delegates to `spec-first-change` skill
4. **Validate Acceptance Criteria** — systematic verification of each criterion
5. **Submit PR** — delegates to `submit-pr` skill
6. **Wait for Merge** — monitor PR status
7. **Resolve Ticket** — add implementation comment, transition to Done

## Source

Part of the [spec-driven-development-kit](https://github.com/HeyLuka/spec-driven-development-kit).
