# Connectors

This plugin requires the following external services to function.

## Atlassian MCP Server (Required)

The `jira-ticket-work` skill depends on the **Atlassian MCP server** for reading and updating JIRA tickets. The following MCP tools are used:

| Tool | Purpose |
|---|---|
| `getJiraIssue` | Fetch ticket details (summary, description, status, acceptance criteria) |
| `getTransitionsForJiraIssue` | Discover available status transitions |
| `transitionJiraIssue` | Move ticket between statuses (Backlog → In Progress → Done) |
| `addCommentToJiraIssue` | Add implementation completion comments |

### Setup

1. Install and configure the Atlassian MCP server in your Qoder environment.
2. Ensure the MCP server is connected to your Atlassian Cloud instance.
3. The `cloudId` for your JIRA site will be derived from the MCP server configuration or ticket URLs.

### Configuration

Optionally, create a `jira-ticket-work.json` at your project root:

```json
{
  "cloudId": "your-site.atlassian.net",
  "defaultBaseBranch": "main",
  "autoTransition": {
    "onStart": true,
    "onComplete": true
  },
  "commentOnComplete": true
}
```

## Genui MCP Server (Optional)

The skill uses the `genui` MCP server for interactive widgets (scope clarification forms, progress dashboards). If unavailable, the skill falls back to text-based prompts.

| Tool | Purpose |
|---|---|
| `show_widget` | Render interactive forms and status dashboards |
| `load_guidelines` | Load widget design guidelines |

## Companion Plugins

Install these companion plugins for full workflow support:

- **`spec-first-change`** — used in Step 3 (Spec-Driven Implementation)
- **`submit-pr`** — used in Step 5 (Submit PR)

Both are available as standalone plugins in this kit and can be installed independently.
