#!/bin/sh
set -eu

DOTFILES_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
upgrade=0

usage() {
  printf 'Usage: %s [--upgrade]\n' "$0"
}

case "${1:-}" in
  "")
    ;;
  --upgrade)
    upgrade=1
    shift
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if [ "$#" -ne 0 ]; then
  usage >&2
  exit 2
fi

warn() {
  printf 'Warning: %s\n' "$*" >&2
}

configure_homebrew_path() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_homebrew() {
  configure_homebrew_path
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  if ! command -v curl >/dev/null 2>&1; then
    warn "curl is unavailable; cannot install Homebrew"
    return 1
  fi

  installer="$(mktemp)" || return 1
  if ! curl -fsSL \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
    -o "$installer"; then
    rm -f "$installer"
    warn "Failed to download the Homebrew installer"
    return 1
  fi

  if ! /bin/bash "$installer"; then
    rm -f "$installer"
    warn "Failed to install Homebrew"
    return 1
  fi

  rm -f "$installer"
  configure_homebrew_path

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew was installed but is unavailable on PATH"
    return 1
  fi
}

ensure_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    return 0
  fi

  case "$(uname -s)" in
    Darwin)
      ensure_homebrew || return 1
      brew install chezmoi
      ;;
    Linux)
      if ! command -v curl >/dev/null 2>&1; then
        warn "curl is unavailable; cannot install chezmoi"
        return 1
      fi

      installer="$(mktemp)" || return 1
      if ! curl -fsLS https://get.chezmoi.io -o "$installer"; then
        rm -f "$installer"
        warn "Failed to download the chezmoi installer"
        return 1
      fi

      if ! sh "$installer" -b "$HOME/.local/bin"; then
        rm -f "$installer"
        warn "Failed to install chezmoi"
        return 1
      fi

      rm -f "$installer"
      PATH="$HOME/.local/bin:$PATH"
      export PATH
      ;;
    *)
      warn "chezmoi is missing on an unsupported platform"
      return 1
      ;;
  esac
}

if [ "$(uname -s)" = "Darwin" ]; then
  ensure_homebrew
fi

ensure_chezmoi
chezmoi init --apply --source "$DOTFILES_DIR"

if [ "$upgrade" -eq 1 ]; then
  if [ "$(uname -s)" != "Darwin" ]; then
    warn "--upgrade is only supported on macOS"
    exit 2
  fi

  brew bundle upgrade --file "$HOME/.Brewfile"
fi
