#!/bin/sh
set -u

DOTFILES_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
TARGET_HOME="$HOME"
failures=0

. "$DOTFILES_DIR/lib/agent-config.sh"

install_mise() {
  if command -v mise >/dev/null 2>&1 || [ -x "$TARGET_HOME/.local/bin/mise" ]; then
    return 0
  fi

  if ! command -v curl >/dev/null 2>&1; then
    agent_config_warn "curl is unavailable; cannot install mise"
    return 1
  fi

  curl -fsSL https://mise.run | sh
}

ensure_zsh_activation() {
  zshrc="$TARGET_HOME/.zshrc"
  activation='eval "$($HOME/.local/bin/mise activate zsh)"'

  touch "$zshrc"
  if ! grep -Fqx "$activation" "$zshrc"; then
    printf '%s\n' "$activation" >> "$zshrc"
  fi
}

if ! install_mise; then
  failures=$((failures + 1))
fi

if [ -e "$TARGET_HOME/.gitconfig" ] && [ ! -L "$TARGET_HOME/.gitconfig" ]; then
  agent_config_warn "Leaving unmanaged file $TARGET_HOME/.gitconfig in place"
elif ! agent_config_link "$DOTFILES_DIR/.gitconfig" "$TARGET_HOME/.gitconfig"; then
  failures=$((failures + 1))
fi

if ! agent_config_link "$DOTFILES_DIR/mise.toml" "$TARGET_HOME/.config/mise/mise.toml"; then
  failures=$((failures + 1))
fi

if ! agent_config_link \
  "$DOTFILES_DIR/.agents/AGENTS.md" \
  "$TARGET_HOME/.copilot/copilot-instructions.md"; then
  failures=$((failures + 1))
fi

if ! agent_config_install_skills "$DOTFILES_DIR/.agents/skills"; then
  failures=$((failures + 1))
fi

if ! ensure_zsh_activation; then
  failures=$((failures + 1))
fi

if [ "$failures" -gt 0 ]; then
  agent_config_warn "Dotfiles installation completed with $failures issue(s)"
  exit 1
fi

printf 'Dotfiles installed successfully.\n'
