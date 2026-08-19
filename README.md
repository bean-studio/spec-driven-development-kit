# spec-driven-development-kit

A lightweight, portable set of spec-driven development practices for
repositories worked on by people and coding agents. It keeps product decisions,
implementation, verification, releases, and pull requests aligned without
assuming a particular product domain or issue tracker.

## What Is Included

- `POLICY.md`: the shared engineering principles.
- `agent-source/instructions.md`: the canonical agent manual — conversation
  style, code quality, command and dependency safety, workflow routing, and
  the user-override boundary. It points to the project profile for concrete
  values rather than restating them.
- `agent-source/skills/`: five focused workflows, each bundling the resources
  it uses as supporting files under its `assets/` directory:
  - `bootstrap-specs` carries the specification, architecture, roadmap,
    release, feature-brief, changelog, and pull-request skeletons;
  - `refine-ticket` carries the work-item description and Implementation Ready
    record templates;
  - `implement-change` carries the lifecycle-evidence template;
  - `submit-pr` uses the repository's established pull-request template;
  - `setup-sdd` carries the project-profile template and the optional GitHub
    Actions guardrail backstops, and owns kit setup, updates, and sync repair.
- `scripts/sdd.sh`: installs the kit and keeps Claude Code, Codex, and GitHub
  Copilot discovery files synchronized.

## Three Files, Three Roles

`POLICY.md`, `agent-source/instructions.md`, and `.sdd/project-profile.md` are
three different kinds of statement, not three documents about the same thing.
Content in the wrong one is the most common way an adoption goes wrong.

| | `POLICY.md` | `instructions.md` | `project-profile.md` |
|---|---|---|---|
| Answers | What must be true of any change | How to behave, and where to look | What the values actually are here |
| Scope | Any repository | Any repository | One repository |
| Owner | Kit | Kit | The adopting team |
| Survives `sdd.sh update` | No, replaced | No, replaced | Yes, preserved |
| Rendered into agent files | No | Yes | No |
| Read when | A clause is cited | Every turn, always loaded | A value is needed |
| Names a repo path or command | Never | Never | Always |
| Form | Numbered citable clauses | Prose rules and pointers | Tables of values |

`POLICY.md` is the constitution: numbered principles that hold regardless of
language, tracker, or domain, phrased so a review comment can cite them.

`instructions.md` is the manual an agent has open at all times, rendered into
every supported agent product. Because it is always in context, it states
behavior and navigation and points at the profile for concrete values instead
of restating them.

`project-profile.md` is the only file that knows which repository it is in:
authorities, paths, commands, issue states, invariants, and integrations.

When a new rule needs a home, ask in this order:

1. Is it a name, path, command, identifier, or number? Project profile.
2. Would it hold in an unrelated repository, and would you cite it in a
   review? Policy.
3. Is it about how the agent behaves or where it looks? Agent instructions.
4. Is it a multi-step procedure with a completion contract? A skill — kit-wide
   under `agent-source/skills/`, repository-only under `.sdd/project-skills/`.

`POLICY.md` §10 states the same routing rule and the precedence between these
files. See [What To Configure](#what-to-configure) for the profile checklist.

## Operating Model

```text
bootstrap-specs  -> establish missing authorities and complete the profile

refine-ticket    -> optional approved handoff for an unclear tracked item
        |
        v
implement-change -> classify, decide, implement, release bookkeeping, verify
        |
        v
submit-pr        -> validate the final diff and evidence, then open the PR
```

A fifth skill, `setup-sdd`, sits outside the product flow: it completes kit
adoption, installs the optional guardrail workflows, pulls kit updates, and
repairs rendered-file drift.

`implement-change` is the only implementation workflow. It works for both
tracked and ad-hoc changes. When an approved Implementation Ready record exists,
it reuses it; otherwise it establishes only the boundary needed for the current
change. Review corrections inside approved scope use the same skill.

Ticket status updates are small stage responsibilities rather than a separate
coordination workflow. The shared instructions cover review follow-up and
post-merge closure.

## Adopt In A Repository

From a checkout of this kit:

```sh
/path/to/spec-driven-development-kit/scripts/sdd.sh init /path/to/your-repo
```

This vendors the kit into `your-repo/.sdd/`, creates
`.sdd/project-profile.md`, and renders:

| Agent | Instructions | Skills |
|---|---|---|
| Claude Code | `CLAUDE.md` | `.claude/skills/` |
| Codex | `AGENTS.md` | `.codex/skills/` |
| GitHub Copilot | `.github/copilot-instructions.md` | `.github/skills/` |

Then:

1. Complete `.sdd/project-profile.md`, or use `bootstrap-specs`.
2. Optionally install the guardrail workflows with the `setup-sdd` skill, or
   copy them from `.sdd/agent-source/skills/setup-sdd/assets/guardrails/` to
   `.github/workflows/` and adapt their clearly marked path settings.
3. Commit `.sdd/` together with the rendered agent files.
4. Try one mechanical change and one behavior change.

If agent instruction files already exist, audit their scope before
initialization. Move reusable repository facts into the project profile and
repository-only workflows into project-local skills. Preserve directory-scoped
or vendor-specific rules rather than flattening them. The script refuses to
overwrite unmanaged files.

## Project-Local Skills

Repository-specific skills live under
`.sdd/project-skills/<skill-name>/SKILL.md`. Use the same format as kit skills,
including the `{{GENERATED_NOTICE}}` placeholder. A project skill may not reuse
a kit skill name.

Supporting files inside a skill directory are copied to each agent's skill tree
and tracked in `.sdd/rendered-support.list`. Commit that manifest with the
rendered files.

## Stay Current

- Edit canonical sources under `.sdd/agent-source/` or
  `.sdd/project-skills/`, then run `./.sdd/scripts/sdd.sh sync`.
- CI can verify generated files with `./.sdd/scripts/sdd.sh check`.
- Pull a newer kit version with:

  ```sh
  /path/to/new-kit/scripts/sdd.sh update /path/to/your-repo
  ```

  Update preserves `.sdd/project-profile.md` and `.sdd/project-skills/`.
  Kit-owned files are staged and backed up so a failed render restores the
  previous kit state.

## What To Configure

Keep the shared policy generic. Put these project facts in
`.sdd/project-profile.md`:

- specification and architecture authorities;
- implementation, decision, and documentation paths;
- optional issue provider and lifecycle semantics;
- default branch and pull-request conventions;
- release triggers, manifests, lockfiles, and tags;
- architecture invariants;
- focused, broad, and manual verification.

## Non-Goals

- replacing product judgment with automated path checks;
- requiring a work item for every change;
- epic or initiative decomposition;
- whole-codebase specification-drift audits;
- built-in integrations for every issue or pull-request provider.

## Enforcement Levels

| Level | Mechanism | Purpose |
|---|---|---|
| Policy | Policy and agent instructions | Defines judgment and boundaries |
| Workflow | Five skills with bundled templates | Makes common work repeatable |
| Guardrail | Optional pull-request checks | Enforces minimum evidence |
