#!/bin/sh
set -eu

ARCH_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"

if [ "$(id -u)" -eq 0 ]; then
  printf 'Run this script as your regular user, not root.\n' >&2
  exit 1
fi

# Always upgrade with repository installs: Arch does not support partial upgrades.
sudo pacman -Syu --needed - < "$ARCH_DIR/packages.txt"

# Keep AUR builds unprivileged and require review; no AUR helper is needed.
while IFS= read -r package; do
  [ -n "$package" ] || continue
  if pacman -Q "$package" >/dev/null 2>&1; then
    continue
  fi
  build_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/aur/$package"
  if [ -e "$build_dir" ]; then
    printf 'Existing build directory: %s\nReview or remove it before retrying.\n' "$build_dir" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$build_dir")"
  git clone "https://aur.archlinux.org/$package.git" "$build_dir"
  printf '\nReview PKGBUILD and supporting files in:\n  %s\n' "$build_dir"
  printf 'AUR packages are community-maintained and run code as your user.\n'
  printf 'After reviewing in another terminal, type yes to build %s: ' "$package"
  read -r answer < /dev/tty
  if [ "$answer" != yes ]; then
    printf 'Skipped %s; rerun after reviewing/removing its build directory.\n' "$package" >&2
    exit 1
  fi
  (cd "$build_dir" && makepkg --syncdeps --install)
done < "$ARCH_DIR/aur.txt"

# Use a user-owned prefix rather than sudo npm. Already installed packages
# (including pi's standalone installation) are left alone.
export PATH="$HOME/.local/bin:$PATH"
while IFS= read -r package; do
  [ -n "$package" ] || continue
  if [ "$package" = '@mariozechner/pi-coding-agent' ] && command -v pi >/dev/null 2>&1; then
    continue
  fi
  if ! npm list --global --prefix "$HOME/.local" --depth=0 "$package" >/dev/null 2>&1; then
    npm install --global --prefix "$HOME/.local" "$package"
  fi
done < "$ARCH_DIR/npm.txt"

printf '\nArch packages ready. Ensure ~/.local/bin is on your shell PATH.\n'
