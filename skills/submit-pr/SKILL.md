---
name: submit-pr
description: >
  Enforce test passage and PR template usage before submitting a Pull Request.
  Validates that all configured tests have passed, assembles a standardised PR
  body from the project's template, and blocks PR creation until all gates are
  satisfied. Activate this skill whenever the user wants to create, submit, or
  open a pull request.
version: 0.0.1
user-invocable: true
argument-hint: "[base-branch] [title]"
---

# Submit PR Workflow

This skill enforces two gates before any Pull Request is created:

1. **All configured tests must pass** — no exceptions.
2. **A standardised PR template body must be used** — ensuring every PR has
   consistent, reviewable context.

## When This Skill Applies

Activate this workflow whenever the user requests to:

- Create, submit, or open a pull request
- Push a branch and create a PR
- Merge a feature branch (if PR is the merge mechanism)

## Configuration

### Test Configuration

The skill discovers required tests from the following locations, checked in
priority order:

1. **`submit-pr.json`** at the repo root — explicit test configuration:
   ```json
   {
     "requiredTests": [
       { "name": "unit", "command": "npm run test:unit" },
       { "name": "integration", "command": "npm run test:integration" },
       { "name": "lint", "command": "npm run lint" },
       { "name": "typecheck", "command": "npm run typecheck" }
     ]
   }
   ```
2. **CI configuration files** (`.github/workflows/*.yml`, `.gitlab-ci.yml`,
   `Jenkinsfile`, `bitbucket-pipelines.yml`) — test steps are inferred from
   the pipeline definition.
3. **Package manager scripts** (`package.json` scripts, `Makefile` targets,
   `pyproject.toml` test config) — common test commands are inferred.
4. **Conventional defaults** — if nothing is configured, the skill attempts
   common test runners (`npm test`, `pytest`, `cargo test`, `go test`,
   `mvn test`, `dotnet test`) based on detected language/framework.

If no tests can be discovered, the skill warns the user and asks whether to
proceed without test validation or configure tests first.

### PR Template Configuration

The skill discovers PR templates from the following locations:

1. **`.github/PULL_REQUEST_TEMPLATE.md`** (or `.github/pull_request_template.md`)
2. **`.gitlab/merge_request_templates/`**
3. **`docs/pr-template.md`** or **`PR_TEMPLATE.md`** at the repo root
4. **`submit-pr.json`** — inline template:
   ```json
   {
     "prTemplate": {
       "sections": ["summary", "changes", "testing", "screenshots", "tickets"]
     }
   }
   ```
5. **Default template** — if no template is found, the skill uses a built-in
   default (see below).

## Default PR Template

When no project template exists, this template is used:

```markdown
## Summary

<!-- One-sentence description of what this PR does and why -->

## Changes

<!-- Bullet list of specific changes made -->
-

## Testing

<!-- How were these changes tested? -->
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing performed

## Screenshots (if applicable)

<!-- Add screenshots or recordings for UI changes -->

## Linked Tickets

<!-- Link any related tickets (e.g. Closes #123, Relates to JIRA-456) -->
```

## Workflow Steps

### Step 1: Detect Changed Files and Scope

Before running any checks, determine what has changed:

1. Identify the base branch (default: `main` or `master`; configurable).
2. Run `git diff --stat <base>...HEAD` to see changed files.
3. Run `git log <base>...HEAD --oneline` to see commits in the branch.
4. Summarise the scope of changes for the PR body.

### Step 2: Run Required Tests

Execute each configured test in sequence:

1. Run the test command.
2. Capture the exit code and relevant output.
3. Record pass/fail status for each test.

**Display progress as each test runs:**
```
Running tests...
  ✓ unit        (2.3s)
  ✓ integration (8.1s)
  ✗ lint        (0.4s) — FAILED
  ✓ typecheck   (1.2s)
```

**If any test fails:**
- Show the failure output (truncated to the most relevant lines).
- **Block PR creation.** Do not proceed to Step 3.
- Offer to help fix the failing test.
- After the user fixes the issue, re-run only the failed tests (unless the
  fix touches other areas, then re-run all).

**If all tests pass:**
- Show the summary and proceed to Step 3.

### Step 3: Assemble PR Body

Build the PR body from the template:

1. Load the discovered PR template.
2. Pre-fill sections using gathered context:
   - **Summary**: Generate from commit messages and diff summary.
   - **Changes**: List changed files grouped by directory/module.
   - **Testing**: Mark all tests that passed.
   - **Linked Tickets**: Extract ticket references from commit messages
     (e.g., `KAN-11`, `#123`, `[JIRA-456]`).
3. Present the assembled PR body to the user for review and edits.

### Step 4: Confirm PR Details

Before creating the PR, confirm with the user:

1. **Title**: Suggest from the branch name or first commit message. Allow
   the user to edit.
2. **Base branch**: Confirm the target branch.
3. **PR body**: Show the final assembled body. Allow the user to edit.
4. **Draft vs. ready**: Ask if this should be a draft PR.

### Step 5: Create the PR

Create the pull request using the appropriate CLI:

**GitHub:**
```bash
gh pr create --base <base> --title "<title>" --body "<body>" [--draft]
```

**GitLab:**
```bash
glab mr create --target-branch <base> --title "<title>" --description "<body>" [--draft]
```

**Bitbucket:**
```bash
# Use the Bitbucket API or web UI
```

**If no CLI is available**, provide the user with:
- The branch name to push
- The URL to create the PR manually
- The assembled PR body to paste

### Step 6: Post-Creation

After the PR is created:

1. Print the PR URL.
2. Offer to open it in the browser.
3. If the project uses auto-assign or review request, confirm those are set.

## Handling Test Failures

When a test fails, the skill provides:

1. **Clear identification** of which test failed and why.
2. **Relevant output** — the last N lines of failure output, not the entire
   log.
3. **Suggested fix direction** — based on the error type:
   - Compilation errors → point to the file and line
   - Assertion failures → show expected vs. actual
   - Lint errors → show the rule violation and file location
   - Type errors → show the type mismatch
4. **Block message**: "PR creation blocked until all tests pass. Fix the
   issue above and run `/submit-pr` again, or ask me to help fix it."

## Skipping Test Validation

Tests may only be skipped when:

- The user explicitly requests it with `--skip-tests` and acknowledges the
  risk.
- The change is documentation-only (markdown files, comments) and the skill
  detects no code changes.
- The project has no tests configured and the user declines to add any.

In all other cases, tests must pass before PR creation.

## Customisation Reference

### submit-pr.json Schema

```json
{
  "requiredTests": [
    {
      "name": "string (display name)",
      "command": "string (shell command to run)",
      "timeout": "number (seconds, optional)",
      "workingDir": "string (optional, relative to repo root)"
    }
  ],
  "prTemplate": {
    "path": "string (path to template file, optional)",
    "sections": ["array of section names (optional)"]
  },
  "defaults": {
    "baseBranch": "string (default: main)",
    "draftByDefault": "boolean (default: false)"
  }
}
```

### Environment Variables

- `SUBMIT_PR_SKIP_TESTS` — set to `1` to skip test validation (not
  recommended for regular use).
- `SUBMIT_PR_BASE` — override the default base branch.
- `SUBMIT_PR_DRAFT` — set to `1` to create draft PRs by default.

## Quick Reference Checklist

```
Before creating PR:
  □ Identified base branch
  □ Reviewed changed files and commit history
  □ All required tests passed
  □ PR body assembled from template
  □ Title confirmed with user
  □ PR body reviewed and approved by user
  □ Draft vs. ready confirmed
  □ PR created successfully
```
