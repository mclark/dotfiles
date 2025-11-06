#!/bin/sh

# Run by github/github codespaces after starting

# install mise-en-place
curl https://mise.run | sh

DOTFILES_DIR="$(realpath .)"
TARGET_HOME="$HOME"

ln -sf "${DOTFILES_DIR}/.gitconfig" "${TARGET_HOME}/.gitconfig"

# Ensure .config/mise directory exists
mkdir -p "${TARGET_HOME}/.config/mise"

MISE_SOURCE="${DOTFILES_DIR}/mise.toml"
MISE_TARGET="${TARGET_HOME}/.config/mise/mise.toml"

ln -sf "$MISE_SOURCE" "$MISE_TARGET"

echo "eval \"\$(/home/codespace/.local/bin/mise activate zsh)\"" >> ~/.zshrc

