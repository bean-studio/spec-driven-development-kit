#!/bin/sh
# spec-driven-development-kit: scaffold the kit into a repository and keep rendered
# agent discovery files (Claude Code, Codex, GitHub Copilot) in sync.
set -eu

usage() {
  cat >&2 <<'EOF'
Usage: sdd.sh <command> [target-repo]

Commands run from a kit checkout:
  init [target]    Vendor the kit into <target>/.sdd, create
                   the project profile from its template, and render agent
                   files. Refuses if <target>/.sdd exists.
  update [target]  Refresh kit-owned files under <target>/.sdd (preserving
                   the project profile, local skills, and .sdd/agents.conf),
                   then re-render agent files.

Commands run from a kit checkout with [target], or from <repo>/.sdd/scripts:
  sync [target]    Render agent instruction and skill files from
                   .sdd/agent-source/.
  check [target]   Verify rendered agent files are current; exit 1 on drift.

Which agents are rendered is listed in <repo>/.sdd/agents.conf; sync removes
the generated files of an agent dropped from that list.
EOF
  exit 2
}

[ "$#" -ge 1 ] || usage
command=$1
shift
target=${1:-}
[ "$#" -le 1 ] || { shift; usage; }

script_dir=$(cd "$(dirname "$0")" && pwd)
kit_root=$(cd "$script_dir/.." && pwd)

temp_root=
init_cleanup_dir=
kit_stage_dir=
update_backup_dir=
update_applied=0
kit_owned_paths='POLICY.md agent-source templates guardrails scripts/sdd.sh KIT_VERSION'

remove_kit_owned_paths() {
  for relative_path in $kit_owned_paths; do
    rm -rf "$sdd_dir/$relative_path"
  done
}

rollback_update() {
  remove_kit_owned_paths
  for relative_path in $kit_owned_paths; do
    if [ -e "$update_backup_dir/$relative_path" ]; then
      mkdir -p "$(dirname "$sdd_dir/$relative_path")"
      mv "$update_backup_dir/$relative_path" "$sdd_dir/$relative_path"
    fi
  done
  echo "sdd: update failed; restored previous kit-owned files" >&2
}

on_exit() {
  rc=$?
  if [ -n "$temp_root" ]; then
    rm -rf "$temp_root"
  fi
  if [ -n "$kit_stage_dir" ]; then
    rm -rf "$kit_stage_dir"
  fi
  if [ "$rc" -ne 0 ] && [ "$update_applied" -eq 1 ] && [ -n "$update_backup_dir" ]; then
    rollback_update
  fi
  if [ -n "$update_backup_dir" ]; then
    rm -rf "$update_backup_dir"
  fi
  if [ "$rc" -ne 0 ] && [ -n "$init_cleanup_dir" ]; then
    rm -rf "$init_cleanup_dir"
    echo "sdd: init failed; removed partial $init_cleanup_dir" >&2
  fi
}
trap on_exit EXIT
trap 'exit 130' HUP INT TERM
notice='<!-- GENERATED FILE. Edit the canonical source under .sdd/ (agent-source/ or project-skills/) and run ./.sdd/scripts/sdd.sh sync. -->'
# Notice written by kit 0.1.0; still recognized as managed so update works.
legacy_notice='<!-- GENERATED FILE. Edit .sdd/agent-source/ and run ./.sdd/scripts/sdd.sh sync. -->'

is_managed() {
  grep -Fqx "$notice" "$1" || grep -Fqx "$legacy_notice" "$1"
}
placeholder='{{GENERATED_NOTICE}}'

known_agents='claude codex copilot'

agent_manual() {
  case $1 in
    claude) echo "CLAUDE.md" ;;
    codex) echo "AGENTS.md" ;;
    copilot) echo ".github/copilot-instructions.md" ;;
  esac
}

agent_skills_root() {
  case $1 in
    claude) echo ".claude/skills" ;;
    codex) echo ".codex/skills" ;;
    copilot) echo ".github/skills" ;;
  esac
}

# The agent list is repository-owned configuration. A missing file means every
# known agent, so repositories adopted before agents.conf existed keep working.
read_enabled_agents() {
  agents_conf="$sdd_dir/agents.conf"
  if [ ! -f "$agents_conf" ]; then
    enabled_agents=$known_agents
    return
  fi
  enabled_agents=
  while IFS= read -r line || [ -n "$line" ]; do
    line=${line%%#*}
    line=$(printf '%s' "$line" | tr -d '[:space:]')
    [ -n "$line" ] || continue
    case " $known_agents " in
      *" $line "*) ;;
      *)
        echo "sdd: unknown agent '$line' in .sdd/agents.conf; known agents: $known_agents" >&2
        exit 1
        ;;
    esac
    case " $enabled_agents " in
      *" $line "*) continue ;;
    esac
    enabled_agents="$enabled_agents $line"
  done < "$agents_conf"
  if [ -z "$enabled_agents" ]; then
    echo "sdd: warning: .sdd/agents.conf enables no agents; no discovery files will be rendered" >&2
  fi
}

agent_enabled() {
  case " $enabled_agents " in
    *" $1 "*) return 0 ;;
    *) return 1 ;;
  esac
}

write_default_agents_conf() {
  [ -f "$sdd_dir/agents.conf" ] && return 0
  cat > "$sdd_dir/agents.conf" <<'EOF'
# Agents that sdd.sh renders discovery files for. Comment out or delete a line
# to stop rendering for that agent; the next sync removes the files it
# generated. This file is repository-owned — sdd.sh update never changes it.
#
#   claude   -> CLAUDE.md, .claude/skills/
#   codex    -> AGENTS.md, .codex/skills/
#   copilot  -> .github/copilot-instructions.md, .github/skills/

claude
codex
copilot
EOF
}

is_kit_checkout() {
  [ -f "$kit_root/project-profile.template.md" ] && [ -d "$kit_root/agent-source" ]
}

is_vendored() {
  [ ! -f "$kit_root/project-profile.template.md" ] && [ -d "$kit_root/agent-source" ]
}

require_kit_checkout() {
  if ! is_kit_checkout; then
    echo "sdd: '$command' must run from a kit checkout, not a vendored .sdd copy" >&2
    exit 1
  fi
}

resolve_repo_root() {
  if [ -n "$target" ]; then
    repo_root=$(cd "$target" && pwd)
  elif [ "$command" = "init" ] || [ "$command" = "update" ]; then
    repo_root=$(pwd)
  elif is_vendored; then
    repo_root=$(cd "$kit_root/.." && pwd)
  else
    echo "sdd: '$command' needs a target repository when run from a kit checkout" >&2
    exit 1
  fi
  case "$repo_root/" in
    "$kit_root"/*)
      echo "sdd: target $repo_root is inside the kit checkout; pass an explicit target repository" >&2
      exit 1
      ;;
  esac
  sdd_dir="$repo_root/.sdd"
}

copy_kit_owned_files() {
  for required_path in POLICY.md agent-source templates guardrails scripts/sdd.sh VERSION; do
    if [ ! -e "$kit_root/$required_path" ]; then
      echo "sdd: kit checkout is missing $required_path" >&2
      exit 1
    fi
  done

  kit_stage_dir=$(mktemp -d "$sdd_dir/.kit-stage.XXXXXX")
  mkdir -p "$kit_stage_dir/scripts"
  cp "$kit_root/POLICY.md" "$kit_stage_dir/POLICY.md"
  cp -R "$kit_root/agent-source" "$kit_stage_dir/agent-source"
  cp -R "$kit_root/templates" "$kit_stage_dir/templates"
  cp -R "$kit_root/guardrails" "$kit_stage_dir/guardrails"
  cp "$kit_root/scripts/sdd.sh" "$kit_stage_dir/scripts/sdd.sh"
  chmod +x "$kit_stage_dir/scripts/sdd.sh"
  cp "$kit_root/VERSION" "$kit_stage_dir/KIT_VERSION"

  if [ "$command" = "update" ]; then
    update_backup_dir=$(mktemp -d "$sdd_dir/.kit-backup.XXXXXX")
    for relative_path in $kit_owned_paths; do
      if [ -e "$sdd_dir/$relative_path" ]; then
        mkdir -p "$(dirname "$update_backup_dir/$relative_path")"
        mv "$sdd_dir/$relative_path" "$update_backup_dir/$relative_path"
      fi
    done
    update_applied=1
  fi

  for relative_path in $kit_owned_paths; do
    mkdir -p "$(dirname "$sdd_dir/$relative_path")"
    mv "$kit_stage_dir/$relative_path" "$sdd_dir/$relative_path"
  done
  rm -rf "$kit_stage_dir"
  kit_stage_dir=
}

commit_update_transaction() {
  if [ -n "$update_backup_dir" ]; then
    rm -rf "$update_backup_dir"
    update_backup_dir=
  fi
  update_applied=0
}

render() {
  source_file=$1
  output_file=$2
  placeholder_count=$(grep -F -c "$placeholder" "$source_file" || true)
  if [ "$placeholder_count" -ne 1 ]; then
    echo "sdd: canonical source must contain exactly one $placeholder placeholder: $source_file" >&2
    exit 1
  fi
  sed -e "s#$placeholder#$notice#g" "$source_file" > "$output_file"
}

preflight_file() {
  expected=$1
  destination=$2
  relative_destination=${destination#"$repo_root"/}

  if [ -f "$destination" ] && ! cmp -s "$expected" "$destination" && ! is_managed "$destination"; then
    echo "sdd: refusing to overwrite unmanaged file $relative_destination; reconcile it into .sdd/agent-source/ or remove it first" >&2
    exit 1
  fi
}

preflight_support_file() {
  expected=$1
  destination=$2
  relative_destination=${destination#"$repo_root"/}

  if [ -f "$destination" ] && ! cmp -s "$expected" "$destination" &&
     ! grep -Fqx "$relative_destination" "$old_support_manifest"; then
    echo "sdd: refusing to overwrite unmanaged supporting file $relative_destination; reconcile it into its skill's source directory or remove it first" >&2
    exit 1
  fi
}

sync_file() {
  expected=$1
  destination=$2
  relative_destination=${destination#"$repo_root"/}

  if [ -f "$destination" ] && cmp -s "$expected" "$destination"; then
    return
  fi

  if [ -f "$destination" ] && ! is_managed "$destination"; then
    if [ "$mode" = "check" ]; then
      echo "sdd: unmanaged file conflicts with generated output $relative_destination" >&2
      drift=1
      return
    fi
    echo "sdd: refusing to overwrite unmanaged file $relative_destination; reconcile it into .sdd/agent-source/ or remove it first" >&2
    exit 1
  fi

  if [ "$mode" = "check" ]; then
    echo "sdd: stale or missing $relative_destination" >&2
    drift=1
    return
  fi

  mkdir -p "$(dirname "$destination")"
  cp "$expected" "$destination"
  echo "synced: $relative_destination"
}

# Render kit skills and project-local skills (.sdd/project-skills/) into one
# expected set. A project skill may not reuse a kit skill's path. Supporting
# files (anything inside a skill directory besides SKILL.md) are copied
# verbatim and tracked in the rendered-support manifest, since arbitrary or
# binary formats cannot carry the generated-file notice.
collect_expected_skills() {
  expected_skills_root="$temp_root/expected-skills"
  expected_skills_list="$temp_root/expected-skills.list"
  expected_support_list="$temp_root/expected-support.list"
  expected_names_list="$temp_root/expected-skill-names.list"
  mkdir -p "$expected_skills_root"
  : > "$expected_skills_list"
  : > "$expected_support_list"
  : > "$expected_names_list"

  for skills_source in "$source_skills" "$sdd_dir/project-skills"; do
    if [ ! -d "$skills_source" ]; then
      continue
    fi
    source_list="$temp_root/source-skills.list"
    find "$skills_source" -name SKILL.md -type f | sort > "$source_list"
    while IFS= read -r source_skill; do
      relative_skill=${source_skill#"$skills_source"/}
      skill_directory=$(basename "$(dirname "$relative_skill")")
      declared_name=$(sed -n 's/^name:[[:space:]]*//p' "$source_skill" | sed -n '1p')
      if [ -z "$declared_name" ] || [ "$declared_name" != "$skill_directory" ]; then
        echo "sdd: skill name '$declared_name' must match directory '$skill_directory': $source_skill" >&2
        exit 1
      fi
      if grep -Fqx "$declared_name" "$expected_names_list"; then
        echo "sdd: duplicate skill name '$declared_name' across canonical sources" >&2
        exit 1
      fi
      printf '%s\n' "$declared_name" >> "$expected_names_list"
      if [ -f "$expected_skills_root/$relative_skill" ]; then
        echo "sdd: skill '$relative_skill' exists in both .sdd/agent-source/skills/ and .sdd/project-skills/; rename the project skill" >&2
        exit 1
      fi
      mkdir -p "$(dirname "$expected_skills_root/$relative_skill")"
      render "$source_skill" "$expected_skills_root/$relative_skill"
      printf '%s\n' "$relative_skill" >> "$expected_skills_list"
    done < "$source_list"

    support_list="$temp_root/source-support.list"
    find "$skills_source" -mindepth 2 -type f ! -name SKILL.md | sort > "$support_list"
    while IFS= read -r source_support; do
      relative_support=${source_support#"$skills_source"/}
      if [ -f "$expected_skills_root/$relative_support" ]; then
        echo "sdd: supporting file '$relative_support' exists in both .sdd/agent-source/skills/ and .sdd/project-skills/; rename the project skill" >&2
        exit 1
      fi
      mkdir -p "$(dirname "$expected_skills_root/$relative_support")"
      cp "$source_support" "$expected_skills_root/$relative_support"
      printf '%s\n' "$relative_support" >> "$expected_support_list"
    done < "$support_list"
  done
  sort -o "$expected_skills_list" "$expected_skills_list"
  sort -o "$expected_support_list" "$expected_support_list"
}

preflight_agent() {
  manual_path=$1
  skills_root=$2

  expected_manual="$temp_root/$manual_path"
  mkdir -p "$(dirname "$expected_manual")"
  render "$source_manual" "$expected_manual"
  preflight_file "$expected_manual" "$repo_root/$manual_path"

  while IFS= read -r relative_skill; do
    preflight_file "$expected_skills_root/$relative_skill" "$repo_root/$skills_root/$relative_skill"
  done < "$expected_skills_list"

  while IFS= read -r relative_support; do
    preflight_support_file "$expected_skills_root/$relative_support" "$repo_root/$skills_root/$relative_support"
  done < "$expected_support_list"
}

# Supporting files carry no notice, so managed-ness comes from the manifest:
# a destination is safe to overwrite or remove only if the manifest (or an
# identical content match, which adopts a hand-placed copy) says we wrote it.
sync_support_file() {
  expected=$1
  destination=$2
  relative_destination=${destination#"$repo_root"/}

  printf '%s\n' "$relative_destination" >> "$new_support_manifest"

  if [ -f "$destination" ] && cmp -s "$expected" "$destination"; then
    return
  fi

  if [ -f "$destination" ] && ! grep -Fqx "$relative_destination" "$old_support_manifest"; then
    if [ "$mode" = "check" ]; then
      echo "sdd: unmanaged file conflicts with generated supporting file $relative_destination" >&2
      drift=1
      return
    fi
    echo "sdd: refusing to overwrite unmanaged supporting file $relative_destination; reconcile it into its skill's source directory or remove it first" >&2
    exit 1
  fi

  if [ "$mode" = "check" ]; then
    echo "sdd: stale or missing $relative_destination" >&2
    drift=1
    return
  fi

  mkdir -p "$(dirname "$destination")"
  cp "$expected" "$destination"
  echo "synced: $relative_destination"
}

# An agent absent from .sdd/agents.conf keeps none of its generated files.
# Only files carrying the generated marker are touched, so a hand-owned file at
# the same path survives.
remove_agent() {
  manual_path=$1
  skills_root=$2

  destination_manual="$repo_root/$manual_path"
  if [ -f "$destination_manual" ] && is_managed "$destination_manual"; then
    if [ "$mode" = "check" ]; then
      echo "sdd: unexpected generated file $manual_path (agent not enabled in .sdd/agents.conf)" >&2
      drift=1
    else
      rm "$destination_manual"
      echo "removed: $manual_path"
    fi
  fi

  destination_root="$repo_root/$skills_root"
  [ -d "$destination_root" ] || return 0
  disabled_list="$temp_root/disabled-skills.list"
  find "$destination_root" -name SKILL.md -type f | sort > "$disabled_list"
  while IFS= read -r destination_skill; do
    is_managed "$destination_skill" || continue
    relative_skill=${destination_skill#"$repo_root"/}
    if [ "$mode" = "check" ]; then
      echo "sdd: unexpected generated skill $relative_skill (agent not enabled in .sdd/agents.conf)" >&2
      drift=1
    else
      rm "$destination_skill"
      (cd "$repo_root" && rmdir -p "$(dirname "$relative_skill")" 2>/dev/null) || true
      echo "removed: $relative_skill"
    fi
  done < "$disabled_list"
}

sync_agent() {
  manual_path=$1
  skills_root=$2

  expected_manual="$temp_root/$manual_path"
  mkdir -p "$(dirname "$expected_manual")"
  render "$source_manual" "$expected_manual"
  sync_file "$expected_manual" "$repo_root/$manual_path"

  while IFS= read -r relative_skill; do
    sync_file "$expected_skills_root/$relative_skill" "$repo_root/$skills_root/$relative_skill"
  done < "$expected_skills_list"

  while IFS= read -r relative_support; do
    sync_support_file "$expected_skills_root/$relative_support" "$repo_root/$skills_root/$relative_support"
  done < "$expected_support_list"

  destination_root="$repo_root/$skills_root"
  if [ -d "$destination_root" ]; then
    destination_list="$temp_root/destination-skills.list"
    find "$destination_root" -name SKILL.md -type f | sort > "$destination_list"
    while IFS= read -r destination_skill; do
      relative_skill=${destination_skill#"$destination_root"/}
      if [ -f "$expected_skills_root/$relative_skill" ]; then
        continue
      fi
      if ! is_managed "$destination_skill"; then
        continue
      fi

      if [ "$mode" = "check" ]; then
        echo "sdd: unexpected generated skill $skills_root/$relative_skill" >&2
        drift=1
      else
        rm "$destination_skill"
        (cd "$repo_root" && rmdir -p "$(dirname "$skills_root/$relative_skill")" 2>/dev/null) || true
        echo "removed: $skills_root/$relative_skill"
      fi
    done < "$destination_list"
  fi
}

run_sync() {
  source_manual="$sdd_dir/agent-source/instructions.md"
  source_skills="$sdd_dir/agent-source/skills"

  if [ ! -f "$source_manual" ] || [ ! -d "$source_skills" ]; then
    echo "sdd: missing canonical sources under $sdd_dir/agent-source; run init first" >&2
    exit 1
  fi
  if [ ! -f "$sdd_dir/project-profile.md" ]; then
    echo "sdd: warning: $sdd_dir/project-profile.md is missing; complete it before relying on the workflow" >&2
  fi
  temp_root=$(mktemp -d "${TMPDIR:-/tmp}/sdd-sync.XXXXXX")
  drift=0

  support_manifest="$sdd_dir/rendered-support.list"
  old_support_manifest="$temp_root/old-support-manifest.list"
  new_support_manifest="$temp_root/new-support-manifest.list"
  if [ -f "$support_manifest" ]; then
    cp "$support_manifest" "$old_support_manifest"
  else
    : > "$old_support_manifest"
  fi
  : > "$new_support_manifest"

  read_enabled_agents
  collect_expected_skills
  for agent in $known_agents; do
    if agent_enabled "$agent"; then
      preflight_agent "$(agent_manual "$agent")" "$(agent_skills_root "$agent")"
    fi
  done
  for agent in $known_agents; do
    if agent_enabled "$agent"; then
      sync_agent "$(agent_manual "$agent")" "$(agent_skills_root "$agent")"
    else
      remove_agent "$(agent_manual "$agent")" "$(agent_skills_root "$agent")"
    fi
  done

  sort -u -o "$new_support_manifest" "$new_support_manifest"
  reconcile_support_manifest

  if [ "$mode" = "check" ]; then
    if [ "$drift" -ne 0 ]; then
      echo "sdd: generated files are out of date; run ./.sdd/scripts/sdd.sh sync" >&2
      exit 1
    fi
    echo "sdd: generated files are up to date"
  fi
}

# Remove previously rendered supporting files that are no longer expected,
# then bring .sdd/rendered-support.list in line with what was rendered.
reconcile_support_manifest() {
  while IFS= read -r stale_path; do
    [ -n "$stale_path" ] || continue
    if grep -Fqx "$stale_path" "$new_support_manifest"; then
      continue
    fi
    if [ ! -f "$repo_root/$stale_path" ]; then
      continue
    fi
    if [ "$mode" = "check" ]; then
      echo "sdd: unexpected generated supporting file $stale_path" >&2
      drift=1
    else
      rm "$repo_root/$stale_path"
      (cd "$repo_root" && rmdir -p "$(dirname "$stale_path")" 2>/dev/null) || true
      echo "removed: $stale_path"
    fi
  done < "$old_support_manifest"

  manifest_relative=${support_manifest#"$repo_root"/}
  if [ -s "$new_support_manifest" ]; then
    if ! cmp -s "$new_support_manifest" "$old_support_manifest"; then
      if [ "$mode" = "check" ]; then
        echo "sdd: stale or missing $manifest_relative" >&2
        drift=1
      else
        cp "$new_support_manifest" "$support_manifest"
        echo "synced: $manifest_relative"
      fi
    fi
  elif [ -f "$support_manifest" ]; then
    if [ "$mode" = "check" ]; then
      echo "sdd: unexpected $manifest_relative (no supporting files are expected)" >&2
      drift=1
    else
      rm "$support_manifest"
      echo "removed: $manifest_relative"
    fi
  fi
}

case "$command" in
  init)
    require_kit_checkout
    resolve_repo_root
    if [ -d "$sdd_dir" ]; then
      echo "sdd: $sdd_dir already exists; use 'update' to refresh kit-owned files" >&2
      exit 1
    fi
    mkdir -p "$sdd_dir"
    init_cleanup_dir="$sdd_dir"
    copy_kit_owned_files
    cp "$kit_root/project-profile.template.md" "$sdd_dir/project-profile.md"
    write_default_agents_conf
    mkdir -p "$sdd_dir/project-skills"
    cat > "$sdd_dir/project-skills/README.md" <<'EOF'
Project-local skills. This directory is owned by the repository; `sdd.sh
update` never modifies it.

Each skill lives at `<skill-name>/SKILL.md` with YAML frontmatter followed by
a `{{GENERATED_NOTICE}}` placeholder line, exactly like the kit skills under
`../agent-source/skills/`. `sdd.sh sync` renders these skills to every
configured agent alongside the kit skills. A project skill may not reuse a
kit skill's name.

Any other file inside a skill directory (references, scripts, agent-specific
metadata such as `agents/openai.yaml`) is copied verbatim to every agent's
skills tree and tracked in `.sdd/rendered-support.list`; agents ignore
metadata files that are not theirs. Commit that manifest with the rendered
files.
EOF
    mode=write
    run_sync
    init_cleanup_dir=
    cat <<EOF
sdd: initialized $sdd_dir (kit version $(cat "$kit_root/VERSION"))

Next steps:
  1. Complete .sdd/project-profile.md (or run the bootstrap-specs skill to
     establish missing foundation documents and fill the profile).
  2. Optionally copy .sdd/guardrails/*.yml to .github/workflows/ and adapt
     their path configuration.
  3. Commit .sdd/ together with the rendered agent files.
EOF
    ;;
  update)
    require_kit_checkout
    resolve_repo_root
    if [ ! -d "$sdd_dir" ]; then
      echo "sdd: $sdd_dir does not exist; use 'init' first" >&2
      exit 1
    fi
    copy_kit_owned_files
    write_default_agents_conf
    mode=write
    run_sync
    commit_update_transaction
    echo "sdd: updated kit-owned files in $sdd_dir to version $(cat "$kit_root/VERSION"); project profile, local skills, and .sdd/agents.conf were preserved"
    ;;
  sync)
    resolve_repo_root
    mode=write
    run_sync
    ;;
  check)
    resolve_repo_root
    mode=check
    run_sync
    ;;
  *)
    usage
    ;;
esac
