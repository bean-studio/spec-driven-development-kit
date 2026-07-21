---
name: jira-ticket-work
description: >
  End-to-end JIRA ticket workflow orchestration. Takes a ticket from scope
  review through spec-driven implementation, acceptance criteria validation,
  PR submission, and ticket resolution. Orchestrates the spec-first-change
  and submit-pr skills. Activate this skill whenever the user wants to work
  on, implement, or resolve a JIRA ticket.
version: 0.0.1
user-invocable: true
argument-hint: "<ticket-key-or-url> [base-branch]"
---

# JIRA Ticket Workflow

This skill orchestrates the complete lifecycle of working on a JIRA ticket —
from scope review to ticket resolution. It composes two other skills in the
spec-driven development kit:

- **`spec-first-change`** — for spec-driven implementation (Step 3)
- **`submit-pr`** — for PR submission (Step 5)

```
┌─────────────────────────────────────────────────────────┐
│                  JIRA Ticket Workflow                    │
│                                                         │
│  1. Fetch & Review Ticket                               │
│  2. Clarify Scope (interactive)                         │
│  3. Spec-Driven Implementation  → /spec-first-change    │
│  4. Validate Acceptance Criteria                        │
│  5. Submit PR                   → /submit-pr            │
│  6. Wait for Merge                                      │
│  7. Resolve Ticket                                      │
└─────────────────────────────────────────────────────────┘
```

## When This Skill Applies

Activate this workflow whenever the user:

- Provides a JIRA ticket key or URL and wants to work on it
- Asks to implement, start, or pick up a ticket
- Wants to continue work on an in-progress ticket
- Wants to finalise and resolve a ticket after implementation

## Prerequisites

The following must be available:

1. **Atlassian MCP server** — for reading and updating JIRA tickets.
   The skill uses `getJiraIssue`, `getTransitionsForJiraIssue`,
   `transitionJiraIssue`, and `addCommentToJiraIssue`.
2. **Git repository** — the working directory must be a git repo.
3. **Companion skills** — `spec-first-change` and `submit-pr` must be
   installed in the same skill directory.

## Interactive Prompts via Widgets

This skill uses the IDE's **show_widget** capability (via the `genui` MCP
server) to raise interactive questions and status updates when waiting for
user input. Widgets are used for:

- **Scope clarification questions** — when the ticket is ambiguous
- **Confirmation gates** — before PR submission or ticket resolution
- **Progress dashboards** — showing workflow status at a glance

When rendering a widget, always call `load_guidelines` first (once per
session), then use `show_widget` with `i_have_seen_guidelines: true`.

### Scope Clarification Widget

When the ticket has open questions or ambiguous acceptance criteria, render
a form widget to collect clarification:

```
show_widget({
  title: "ticket_scope_clarification",
  i_have_seen_guidelines: true,
  widget_code: <form with questions derived from ticket description>,
  artifact: { enabled: true, title: "Scope Review", icon: "🔍" }
})
```

### Progress Dashboard Widget

After each major step, update the user with a progress widget:

```
show_widget({
  title: "ticket_workflow_progress",
  i_have_seen_guidelines: true,
  widget_code: <status dashboard showing completed/pending steps>,
  artifact: { enabled: true, title: "Workflow Progress", icon: "📋" }
})
```

## Workflow Steps

### Step 1: Fetch & Review Ticket

1. **Parse the ticket identifier** from the user's input:
   - Full URL: `https://site.atlassian.net/browse/PROJ-123` → key `PROJ-123`,
     cloudId `site.atlassian.net`
   - Bare key: `PROJ-123` → use the configured cloudId or prompt the user
2. **Fetch the ticket** using `getJiraIssue`:
   - Request fields: `summary`, `description`, `status`, `issuetype`,
     `priority`, `assignee`, `reporter`, `labels`, `components`,
     `fixVersions`
   - Request `comment` field to see prior discussion
3. **Review the ticket content**:
   - Read the summary and full description
   - Identify acceptance criteria (explicit or implied)
   - Note any linked issues, epics, or parent tickets
   - Check the current status and transition history
4. **Transition to In Progress** if not already:
   - Use `getTransitionsForJiraIssue` to find the "In Progress" transition
   - Apply it via `transitionJiraIssue`

### Step 2: Clarify Scope

Review the ticket for gaps, ambiguities, or open questions:

1. **Identify unclear areas**:
   - Vague acceptance criteria
   - Missing edge cases or error handling requirements
   - Undefined data shapes or API contracts
   - Conflicting requirements with other specs
2. **If clarification is needed**, render a scope clarification widget:
   - List each open question as a numbered item
   - Provide suggested answers where possible
   - Allow the user to confirm, modify, or dismiss each question
3. **If no clarification is needed**, present a brief scope summary to the
   user for confirmation:
   - "I understand this ticket as: [summary]. Key deliverables: [list].
     Ready to proceed?"
4. **Record the finalised scope** as the working context for subsequent
   steps.

### Step 3: Spec-Driven Implementation

Invoke the **`spec-first-change`** skill workflow:

1. Pass the ticket's description and acceptance criteria as the task context.
2. Follow the full spec-first-change workflow:
   - Identify affected spec files
   - Verify spec accuracy
   - Propose and apply spec updates (with user approval)
   - Implement against verified specs
3. **Implementation notes to capture** (for Step 7):
   - Which spec files were updated and why
   - Key design decisions made during implementation
   - Any deviations from the original ticket scope (with justification)

**Do not proceed to Step 4 until implementation is complete and the user
confirms they are satisfied with the result.**

### Step 4: Validate Acceptance Criteria

Systematically verify each acceptance criterion from the ticket:

1. **List all acceptance criteria** extracted from the ticket description.
2. **For each criterion**, verify:
   - [ ] The implementation satisfies the criterion
   - [ ] The spec files reflect the implemented behavior
   - [ ] There are no regressions in existing functionality
3. **Render a validation widget** showing the status of each criterion:
   - Green check for satisfied criteria
   - Red X for unmet criteria (with explanation)
   - Yellow warning for partially met criteria
4. **If any criterion is not met**:
   - Return to Step 3 to address the gap
   - Re-validate after fixes
5. **Only proceed to Step 5 when all criteria are satisfied.**

### Step 5: Submit PR

Invoke the **`submit-pr`** skill workflow:

1. Pass the ticket key for the PR body's linked tickets section.
2. Follow the full submit-pr workflow:
   - Run all configured tests
   - Assemble the PR body from the template
   - Pre-fill the PR body with:
     - **Summary**: Generated from the ticket summary and implementation
       notes
     - **Changes**: From the git diff
     - **Testing**: From the test results
     - **Linked Tickets**: The JIRA ticket key (e.g., `Relates to KAN-12`)
   - Confirm PR details with the user
   - Create the PR
3. **Record the PR URL** for Step 7.

**If tests fail**, the submit-pr skill blocks PR creation. Help the user
fix the issues, then re-run Step 5.

### Step 6: Wait for Merge

After the PR is created:

1. **Inform the user** that the PR is ready for review.
2. **Render a status widget** showing:
   - PR URL and status (open/merged)
   - Ticket key and summary
   - Workflow progress (Step 6 of 7 — waiting for merge)
3. **If the user asks to check PR status**, use the git CLI or hosting
   platform CLI to check:
   ```bash
   gh pr status    # GitHub
   glab mr status  # GitLab
   ```
4. **When the PR is merged**, proceed to Step 7.
   - The user can explicitly tell you "the PR was merged" to trigger this.
   - Or you can check periodically if asked.

### Step 7: Resolve Ticket

After the PR is merged:

1. **Add an implementation comment** to the JIRA ticket using
   `addCommentToJiraIssue`:
   ```markdown
   **Implementation completed.**

   _PR_: <PR URL>
   _Branch_: <branch name>

   _Summary of changes:_
   - <bullet list of key changes>

   _Spec updates:_
   - <list of spec files updated, if any>

   _Acceptance criteria validation:_
   - [x] Criterion 1 — satisfied
   - [x] Criterion 2 — satisfied
   ```
2. **Transition the ticket** to the appropriate resolved status:
   - Use `getTransitionsForJiraIssue` to find the "Done" or "Resolved"
     transition
   - Apply it via `transitionJiraIssue`
3. **Render a completion widget** confirming:
   - Ticket is resolved
   - PR is merged
   - All acceptance criteria were met
   - Link to the PR and ticket

## Handling Edge Cases

### Ticket Has No Acceptance Criteria

If the ticket description lacks explicit acceptance criteria:

1. Infer criteria from the ticket summary and description.
2. Present the inferred criteria to the user for confirmation.
3. Use a scope clarification widget to collect any missing criteria.

### Ticket Is Already In Progress

If the ticket is already in an "In Progress" state:

1. Check for existing implementation comments or linked PRs.
2. Ask the user if they want to:
   - Continue from where previous work left off
   - Start fresh (noting what was already done)
3. Adjust the workflow accordingly.

### PR Is Rejected or Changes Requested

If the PR review results in requested changes:

1. Note the review feedback.
2. Return to Step 3 to implement the requested changes.
3. Re-run Steps 4–5 (validate criteria, update PR or create a new one).

### Ticket Scope Changes Mid-Implementation

If the user or ticket reporter changes the scope:

1. Pause implementation.
2. Re-run Step 2 (Clarify Scope) with the updated ticket.
3. Re-run the spec-first-change workflow if specs need updating.
4. Continue from where implementation left off.

## Configuration

### jira-ticket-work.json Schema

Optional configuration at the repo root:

```json
{
  "cloudId": "string (default Atlassian cloud ID)",
  "defaultBaseBranch": "string (default: main)",
  "autoTransition": {
    "onStart": "boolean (auto-transition to In Progress, default: true)",
    "onComplete": "boolean (auto-transition to Done after merge, default: true)"
  },
  "commentOnComplete": "boolean (add implementation comment, default: true)"
}
```

## Integration with Companion Skills

| Workflow Step | Skill Used | Purpose |
|---|---|---|
| Step 3: Implementation | `spec-first-change` | Spec-driven code changes |
| Step 5: PR Submission | `submit-pr` | Test validation + PR creation |

Both skills are invoked as part of this workflow. They can also be used
independently for ad-hoc tasks outside the JIRA workflow.

## Quick Reference Checklist

```
Full ticket workflow:
  □ Fetched and reviewed ticket
  □ Clarified scope (resolved ambiguities)
  □ Transitioned ticket to In Progress
  □ Ran spec-first-change workflow (specs updated, code implemented)
  □ Validated all acceptance criteria
  □ Ran submit-pr workflow (tests passed, PR created)
  □ PR merged
  □ Added implementation comment to ticket
  □ Transitioned ticket to Done/Resolved
```
