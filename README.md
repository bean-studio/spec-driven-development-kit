# Spec-Driven Development Kit

A lightweight collection of agent skills that support Spec-Driven Development (SDD) — the practice of recording all design decisions, trade-offs, and scope changes in spec files **before** any code is written.

## Skills

### spec-first-change

Enforces a spec-first development workflow. Before any feature, behavior change, or architectural decision is implemented in code, this skill verifies that the relevant spec files are reviewed, accurate, and updated to capture the decision.

**When to use:**
- New feature requests
- Behavior or data model changes
- API contract modifications
- UX flow updates
- Architecture or tech stack decisions

**How to invoke:**
```
/spec-first-change [task or change description]
```

### submit-pr

Enforces test passage and PR template usage before submitting a Pull Request. Validates that all configured tests have passed and assembles a standardised PR body from the project's template.

**When to use:**
- Creating, submitting, or opening a pull request
- Pushing a branch and creating a PR
- Merging a feature branch via PR

**How to invoke:**
```
/submit-pr [base-branch] [title]
```

### jira-ticket-work

End-to-end JIRA ticket workflow orchestration. Takes a ticket from scope review through spec-driven implementation, acceptance criteria validation, PR submission, and ticket resolution. Composes the `spec-first-change` and `submit-pr` skills.

**When to use:**
- Working on, implementing, or picking up a JIRA ticket
- Continuing work on an in-progress ticket
- Finalising and resolving a ticket after implementation

**How to invoke:**
```
/jira-ticket-work <ticket-key-or-url> [base-branch]
```

## Getting Started

### Option A: Install as Qoder Plugins (Recommended)

Each skill is packaged as a standalone Qoder-native plugin. Install only the ones you need:

```bash
# Install a single plugin
qodercli plugin install --scope local /path/to/spec-driven-development-kit/plugins/spec-first-change
qodercli plugin install --scope local /path/to/spec-driven-development-kit/plugins/submit-pr
qodercli plugin install --scope local /path/to/spec-driven-development-kit/plugins/jira-ticket-work
```

Plugins can be installed independently — pick just `submit-pr` without the full kit.

**Prerequisites for `jira-ticket-work`:** See [CONNECTORS.md](plugins/jira-ticket-work/CONNECTORS.md) for Atlassian MCP server setup and companion plugin requirements.

### Option B: Manual Skill Installation

1. Copy the desired skill from `skills/` into your project's `.qoder/skills/` or `.agents/skills/` directory
2. Invoke a skill using the `/skill-name` command
3. Follow the workflow steps outlined in each skill

### Using the Skills

1. Invoke a skill using the `/skill-name` command
2. Follow the workflow steps outlined in each skill

## Plugin Structure

```
plugins/
├── spec-first-change/     # Standalone plugin: spec-first workflow
│   ├── .qoder-plugin/plugin.json
│   ├── README.md
│   └── skills/spec-first-change/SKILL.md
├── submit-pr/             # Standalone plugin: PR submission workflow
│   ├── .qoder-plugin/plugin.json
│   ├── README.md
│   └── skills/submit-pr/SKILL.md
└── jira-ticket-work/      # Standalone plugin: JIRA ticket orchestration
    ├── .qoder-plugin/plugin.json
    ├── README.md
    ├── CONNECTORS.md
    └── skills/jira-ticket-work/SKILL.md
```

## Philosophy

Spec-Driven Development ensures that:
- All decisions are documented before implementation
- Specs serve as the single source of truth
- Scope creep is caught early through spec verification
- Teams maintain alignment on product direction
