#!/bin/sh

agent_config_warn() {
  printf 'Warning: %s\n' "$*" >&2
}

agent_config_link() {
  source_path="$1"
  target_path="$2"

  if [ -L "$target_path" ]; then
    current_target="$(readlink "$target_path")"
    if [ "$current_target" = "$source_path" ]; then
      return 0
    fi

    agent_config_warn "Refusing to replace $target_path -> $current_target"
    return 1
  fi

  if [ -e "$target_path" ]; then
    agent_config_warn "Refusing to replace unmanaged path $target_path"
    return 1
  fi

  if ! mkdir -p "$(dirname "$target_path")"; then
    agent_config_warn "Failed to create parent directory for $target_path"
    return 1
  fi

  if ln -s "$source_path" "$target_path"; then
    printf 'Linked %s -> %s\n' "$target_path" "$source_path"
    return 0
  fi

  agent_config_warn "Failed to link $target_path"
  return 1
}

agent_config_install_skills() {
  skills_source="$1"
  skills_target="${2:-$HOME/.agents/skills}"
  failures=0

  [ -d "$skills_source" ] || return 0

  if ! mkdir -p "$skills_target"; then
    agent_config_warn "Failed to create $skills_target"
    return 1
  fi

  for skill_dir in "$skills_source"/*; do
    [ -d "$skill_dir" ] || continue

    skill_name="$(basename "$skill_dir")"
    if [ ! -f "$skill_dir/SKILL.md" ]; then
      agent_config_warn "Skipping $skill_dir because it has no SKILL.md"
      failures=$((failures + 1))
      continue
    fi

    if ! agent_config_link "$skill_dir" "$skills_target/$skill_name"; then
      failures=$((failures + 1))
    fi
  done

  return "$failures"
}
