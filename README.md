# Spec-Driven Development Kit

A portable spec-driven development (SDD) toolkit for teams that want product
decisions, implementation, verification, releases, and pull requests to move
together — designed for repositories worked on by coding agents (Claude Code,
Codex, GitHub Copilot). It is intentionally independent of any product domain.

## What Is Included

- `POLICY.md` defines the reusable engineering policy.
- `project-profile.template.md` captures repository-specific authorities and
  conventions without changing the shared policy.
- `agent-source/instructions.md` is the canonical agent routing manual.
- `agent-source/skills/` contains six focused workflow skills.
- `templates/` contains the authority-document skeletons (product spec,
  architecture record, roadmap, feature brief) and the records passed between
  workflow stages.
- `guardrails/` contains optional GitHub Actions backstops.
- `scripts/sdd.sh` scaffolds the kit into a repository and renders the
  Claude Code, Codex, and GitHub Copilot discovery files from the canonical
  sources.
- `VERSION` identifies the kit release vendored into adopting repositories.

## Operating Model

```text
bootstrap-specs ------------> authority documents + completed project profile
                              (one-time foundation; rerun when an authority
                               is missing)

manage-ticket
    |
    +-- refine-ticket ------> approved Implementation Ready record
    |
    +-- implement-ticket ---> spec-first-change -> verified change
    |
    +-- submit-pr ----------> reviewed and submitted pull request
    |
    +-- post-merge closure -> merged, tagged per release policy, closed
```

`spec-first-change` is the development engine and also works stand-alone for
ad-hoc changes without a work item (it prepares its own branch in that case).
The ticket skills adapt issue-lifecycle stages to that engine. `submit-pr` owns
delivery, and `manage-ticket` coordinates stages without duplicating their
work. The issue tracker (e.g. Jira) is configuration in the project profile,
not part of the skills.

## Adopt In A Repository

From a checkout of this kit, run:

```sh
/path/to/spec-driven-development-kit/scripts/sdd.sh init /path/to/your-repo
```

This vendors the kit into `your-repo/.sdd/` (policy, canonical agent sources,
templates, guardrails, the script itself, and a `KIT_VERSION` stamp), creates
`.sdd/project-profile.md` from the template, `.sdd/agents.conf` listing the
agents to render, and an empty `.sdd/project-skills/` home for
repository-owned skills, then renders the agent discovery files:

| Agent | `agents.conf` name | Instructions | Skills |
|---|---|---|---|
| Claude Code | `claude` | `CLAUDE.md` | `.claude/skills/` |
| Codex | `codex` | `AGENTS.md` | `.codex/skills/` |
| GitHub Copilot | `copilot` | `.github/copilot-instructions.md` | `.github/skills/` |

Then:

1. Complete `.sdd/project-profile.md` — or run the `bootstrap-specs` skill,
   which establishes missing authority documents from the templates and fills
   the profile with you.
2. Trim `.sdd/agents.conf` to the agents you actually use, then run
   `./.sdd/scripts/sdd.sh sync`.
3. Optionally copy `.sdd/guardrails/*.yml` to `.github/workflows/` and adapt
   their path configuration.
4. Commit `.sdd/` together with the rendered agent files.
5. Test the workflow with one small mechanical change and one behavior change.

If the repository already has independently owned agent instruction files
(`CLAUDE.md`, `AGENTS.md`, skills), reconcile them first — repository-specific
rules move into `.sdd/project-profile.md` and repository-specific skills into
`.sdd/project-skills/` — then remove the old files; the script refuses to
overwrite files that do not carry its generated-file marker.

## Choosing Agents

`.sdd/agents.conf` lists the agents `sync` renders for, one name per line;
`#` starts a comment. It is repository-owned — `sdd.sh update` never rewrites
it, and a repository adopted before the file existed behaves as if all agents
were listed.

Dropping an agent from the list is the supported way to stop maintaining its
files: the next `sync` removes the instructions, skills, and supporting files
it generated for that agent, and `check` reports any that come back as drift.
Only files carrying the generated-file marker are removed, so a hand-owned
`AGENTS.md` at the same path is left alone.

## Project-Local Skills

Skills that belong to one repository (a domain-specific generator, a
project-only workflow) live under `.sdd/project-skills/<skill-name>/SKILL.md`,
in the same format as kit skills including the `{{GENERATED_NOTICE}}`
placeholder. `sdd.sh sync` renders them to every configured agent alongside
the kit skills; `sdd.sh update` never modifies them. A project skill may not
reuse a kit skill's name — `sync` fails on a collision.

A skill may also carry supporting files — references, scripts, or
agent-specific metadata such as a Codex `agents/openai.yaml`. Anything inside
a skill directory besides `SKILL.md` is copied verbatim (binary-safe, no
placeholder rendering) to every agent's skills tree; agents ignore metadata
files that are not theirs. Because arbitrary formats cannot carry the
generated-file marker, these copies are tracked in
`.sdd/rendered-support.list` — a generated manifest that `sync` maintains and
`check` verifies; commit it with the rendered files. A hand-placed copy that
is identical to its source is adopted into the manifest; a differing
unmanaged file is refused, same as for rendered instruction files.

## Stay Current

- Kit-owned sources under `.sdd/agent-source/` are refreshed by `sdd.sh
  update`; durable project customization belongs in `.sdd/project-profile.md`
  and `.sdd/project-skills/`. After editing any canonical source, run
  `./.sdd/scripts/sdd.sh sync`. CI verifies with `./.sdd/scripts/sdd.sh check`
  (see `guardrails/agent-sync-check.yml`).
- To pull a new kit release into an adopted repository, run
  `/path/to/spec-driven-development-kit/scripts/sdd.sh update /path/to/your-repo`
  from a checkout of the desired kit tag. Kit-owned files are refreshed;
  `.sdd/project-profile.md`, `.sdd/agents.conf`, and `.sdd/project-skills/`
  are preserved. Review
  the diff — local edits to kit-owned files under `.sdd/` are overwritten by
  design.

## Adaptation Boundary

Share the lifecycle, classifications, approval gates, evidence contracts, and
guardrails. Configure these per project (in `.sdd/project-profile.md`):

- specification and architecture authority;
- implementation and decision paths;
- issue provider, project, and supported work-item types;
- default branch and branch naming;
- release triggers, version policy, manifests, and lockfiles;
- project-specific architecture invariants;
- required tests, builds, and manual checks.

Do not copy another project's product rules into the shared policy.

## Non-Goals (v1)

Deliberately out of scope; adopt project-local solutions if needed:

- epic- or initiative-level decomposition (the skills operate on stories,
  bugs, and tasks);
- periodic spec-drift audits across a whole codebase (drift is handled
  change-by-change through classification);
- automated issue-provider integrations beyond what the coding agent's
  configured tools provide.

## Enforcement Levels

| Level | Mechanism | Purpose |
|---|---|---|
| Policy | `POLICY.md` and agent instructions | Defines judgment and boundaries |
| Workflow | Skills and record templates | Makes execution repeatable |
| Guardrail | Pull-request checks | Enforces minimum evidence |

Guardrails are deliberately blunt. They can prove that expected files and
evidence are present; they cannot prove that a product decision is correct.
