---
name: setup-sdd
description: >-
  Complete or maintain the SDD kit installation in this repository: finish
  adoption after `sdd.sh init`, install the optional guardrail workflows,
  pull a newer kit version, and repair rendered agent-file drift reported by
  `sdd.sh check`. Use when the user asks to set up, configure, update, or fix
  the SDD kit itself. Does not create authority documents or implement
  product changes.
---
{{GENERATED_NOTICE}}

# Set Up SDD

Own the kit installation in this repository: the vendored `.sdd/` copy, the
optional guardrail workflows, and the rendered agent files. Do not write
authority documents (that is `bootstrap-specs`) and do not implement product
changes.

## Complete Adoption

After `sdd.sh init` has vendored the kit into `.sdd/`:

1. Confirm `.sdd/project-profile.md` is completed. If sections are missing,
   route to `bootstrap-specs`; a copy of the blank profile ships with this
   skill as `assets/project-profile.template.md` for reference.
2. Offer the optional guardrail workflows bundled with this skill under
   `assets/guardrails/`:
   - `agent-sync-check.yml` fails CI when rendered agent files are stale.
   - `spec-decision-check.yml` requires decision evidence on pull requests.
   Copy the accepted ones to `.github/workflows/` and adapt their clearly
   marked settings (implementation and decision paths, label name) to the
   project profile. Obtain approval before adding CI checks.
3. Commit `.sdd/` together with the rendered agent files and
   `.sdd/rendered-support.list`.

## Keep Rendered Files Current

- Canonical sources live under `.sdd/agent-source/` and
  `.sdd/project-skills/`; every file under `.claude/skills/`,
  `.codex/skills/`, `.github/skills/`, `CLAUDE.md`, `AGENTS.md`, and
  `.github/copilot-instructions.md` is generated.
- After editing a canonical source, run `./.sdd/scripts/sdd.sh sync`.
- When `./.sdd/scripts/sdd.sh check` reports drift, edit the canonical source
  (never the rendered copy) and re-run sync. If check reports an unmanaged
  conflict, reconcile that file into a canonical source or remove it —
  do not delete user content without approval.

## Update The Kit

To pull a newer kit version, run from a checkout of the new kit:

```sh
/path/to/new-kit/scripts/sdd.sh update /path/to/this-repo
```

Update refreshes kit-owned files under `.sdd/`, preserves
`.sdd/project-profile.md` and `.sdd/project-skills/`, re-renders agent files,
and rolls itself back if rendering fails. After updating, re-run
`./.sdd/scripts/sdd.sh check`, review the kit changelog for migration notes,
and re-compare any guardrail workflows previously copied to
`.github/workflows/` against the versions bundled with this skill.

Finish by reporting what was installed or updated, the sync/check result, and
any follow-up the user still owns (profile sections, guardrail approval,
commits).
