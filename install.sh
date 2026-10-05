#!/bin/sh
set -u

DOTFILES_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
TARGET_HOME="$HOME"
failures=0

. "$DOTFILES_DIR/lib/agent-config.sh"

verify_sha256() {
  archive="$1"
  checksum="$2"

  if command -v sha256sum >/dev/null 2>&1; then
    printf '%s  %s\n' "$checksum" "$archive" | sha256sum -c -
    return
  fi

  if command -v shasum >/dev/null 2>&1; then
    printf '%s  %s\n' "$checksum" "$archive" | shasum -a 256 -c -
    return
  fi

  agent_config_warn "No SHA-256 verification command is available"
  return 1
}

is_devcontainer() {
  [ "${CODESPACES:-}" = "true" ] \
    || [ -n "${CODESPACE_NAME:-}" ] \
    || [ "${REMOTE_CONTAINERS:-}" = "true" ] \
    || [ "${DEVCONTAINER:-}" = "true" ]
}

install_latest_jj() {
  architecture="$(uname -m)"

  case "$architecture" in
    arm64|aarch64) architecture="aarch64" ;;
    x86_64|amd64) architecture="x86_64" ;;
    *)
      agent_config_warn "Unsupported Jujutsu architecture: $architecture"
      return 1
      ;;
  esac

  if ! command -v curl >/dev/null 2>&1; then
    agent_config_warn "curl is unavailable; cannot install Jujutsu"
    return 1
  fi

  release_json="$(curl -fsSL \
    -H 'Accept: application/vnd.github+json' \
    -H 'X-GitHub-Api-Version: 2022-11-28' \
    https://api.github.com/repos/jj-vcs/jj/releases/latest)" || return 1

  version="$(printf '%s\n' "$release_json" \
    | awk -F '"' '/"tag_name":/ { print $4; exit }')"
  if [ -z "$version" ]; then
    agent_config_warn "Could not determine the latest Jujutsu release"
    return 1
  fi

  asset_name="jj-$version-$architecture-unknown-linux-musl.tar.gz"
  checksum="$(printf '%s\n' "$release_json" \
    | awk -F '"' -v asset="$asset_name" '
        index($0, "\"name\": \"" asset "\"") { found = 1 }
        found && /"digest": "sha256:/ {
          sub(/^sha256:/, "", $4)
          print $4
          exit
        }
      ')"
  if [ -z "$checksum" ]; then
    agent_config_warn "Could not find the SHA-256 digest for $asset_name"
    return 1
  fi

  temporary="$(mktemp -d)" || return 1
  archive="$temporary/jj.tar.gz"
  url="https://github.com/jj-vcs/jj/releases/download/$version/$asset_name"
  jj_target="$TARGET_HOME/.local/bin/jj"

  if ! curl -fsSL "$url" -o "$archive" \
    || ! verify_sha256 "$archive" "$checksum" \
    || ! tar -xzf "$archive" -C "$temporary" \
    || ! mkdir -p "$TARGET_HOME/.local/bin" \
    || ! install -m 0755 "$temporary/jj" "$jj_target"; then
    rm -rf "$temporary"
    agent_config_warn "Failed to install Jujutsu $version"
    return 1
  fi

  rm -rf "$temporary"
}

ensure_jj() {
  if command -v jj >/dev/null 2>&1; then
    return 0
  fi

  case "$(uname -s)" in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        agent_config_warn "Homebrew is unavailable; cannot install Jujutsu"
        return 1
      fi
      brew install jj
      ;;
    Linux)
      if ! is_devcontainer; then
        agent_config_warn "Jujutsu is missing outside a supported devcontainer"
        return 1
      fi
      install_latest_jj
      ;;
    *)
      agent_config_warn "Jujutsu is missing on an unsupported platform"
      return 1
      ;;
  esac
}

git_config_value() {
  key="$1"

  if command -v git >/dev/null 2>&1; then
    value="$(git config --global --get "$key" 2>/dev/null || true)"
    if [ -n "$value" ]; then
      printf '%s\n' "$value"
      return 0
    fi

    value="$(git config --file "$DOTFILES_DIR/.gitconfig" --get "$key" 2>/dev/null || true)"
    if [ -n "$value" ]; then
      printf '%s\n' "$value"
      return 0
    fi
  fi

  return 1
}

ensure_jj_identity_value() {
  identity_key="$1"

  if [ -n "$(jj config list --user "$identity_key" 2>/dev/null)" ]; then
    return 0
  fi

  identity_value="$(git_config_value "$identity_key")" || {
    agent_config_warn "Cannot configure Jujutsu $identity_key because no Git value is available"
    return 1
  }

  jj config set --user "$identity_key" "$identity_value"
}

ensure_jj_identity() {
  identity_failures=0

  if ! ensure_jj_identity_value user.name; then
    identity_failures=$((identity_failures + 1))
  fi

  if ! ensure_jj_identity_value user.email; then
    identity_failures=$((identity_failures + 1))
  fi

  return "$identity_failures"
}

remove_mise_configuration() {
  mise_target="$TARGET_HOME/.config/mise/mise.toml"
  if [ -L "$mise_target" ] && [ "$(readlink "$mise_target")" = "$DOTFILES_DIR/mise.toml" ]; then
    rm "$mise_target"
    rmdir "$(dirname "$mise_target")" 2>/dev/null || true
  fi

  zshrc="$TARGET_HOME/.zshrc"
  [ -f "$zshrc" ] || return 0

  temporary="$(mktemp "$zshrc.tmp.XXXXXX")" || return 1
  if ! while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      'eval "$($HOME/.local/bin/mise activate zsh)"'|\
      'eval "$(/home/codespace/.local/bin/mise activate zsh)"')
        continue
        ;;
    esac
    printf '%s\n' "$line"
  done < "$zshrc" > "$temporary"; then
    rm -f "$temporary"
    return 1
  fi

  if mode="$(stat -f '%Lp' "$zshrc" 2>/dev/null)" \
    || mode="$(stat -c '%a' "$zshrc" 2>/dev/null)"; then
    chmod "$mode" "$temporary"
  fi

  mv "$temporary" "$zshrc"
}

if ! ensure_jj; then
  failures=$((failures + 1))
elif ! ensure_jj_identity; then
  failures=$((failures + 1))
fi

if ! remove_mise_configuration; then
  failures=$((failures + 1))
fi

if [ -e "$TARGET_HOME/.gitconfig" ] && [ ! -L "$TARGET_HOME/.gitconfig" ]; then
  agent_config_warn "Leaving unmanaged file $TARGET_HOME/.gitconfig in place"
elif ! agent_config_link "$DOTFILES_DIR/.gitconfig" "$TARGET_HOME/.gitconfig"; then
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

if [ "$failures" -gt 0 ]; then
  agent_config_warn "Dotfiles installation completed with $failures issue(s)"
  exit 1
fi

printf 'Dotfiles installed successfully.\n'
