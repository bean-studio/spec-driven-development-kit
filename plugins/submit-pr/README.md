# Submit PR

A Qoder plugin that enforces test passage and PR template usage before submitting a Pull Request.

## What It Does

Validates that all configured tests have passed, assembles a standardised PR body from the project's template, and blocks PR creation until all gates are satisfied.

## Installation

```bash
qodercli plugin install --scope local /path/to/submit-pr
```

Or copy the `plugins/submit-pr/` directory into your project's `.qoder/plugins/` directory.

## Usage

```
/submit-pr [base-branch] [title]
```

## Included Skills

| Skill | Description |
|---|---|
| `submit-pr` | Test validation gate → PR template enforcement → PR body assembly → PR creation via GitHub/GitLab CLI |

## Features

- **Test validation gate**: discovers and runs configured tests; blocks PR creation on failure
- **PR template enforcement**: uses project-specific templates or built-in defaults
- **Multi-platform support**: GitHub CLI, GitLab CLI, and manual fallback
- **Flexible configuration**: `submit-pr.json`, CI config inference, and package manager scripts

## Source

Part of the [spec-driven-development-kit](https://github.com/HeyLuka/spec-driven-development-kit).
