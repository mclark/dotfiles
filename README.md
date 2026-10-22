# dotfiles

Public, portable development and agent configuration managed with chezmoi.

## Install

### New machine

On a new machine, bootstrap your dotfiles with a one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/mclark/dotfiles/main/install.sh | sh
```

This downloads and runs the bootstrap script, which:
- Installs Homebrew on macOS (when needed)
- Installs chezmoi
- Clones this repo to `~/.local/share/chezmoi`
- Applies all dotfiles to your home directory

On Linux, chezmoi is installed as a standalone binary in `~/.local/bin`.

### Existing installation

To re-run the bootstrap locally (idempotent):

```bash
~/.local/share/chezmoi/install.sh
```

This can be run multiple times safely; it will skip chezmoi and Homebrew
installation if already present.

Pass `--upgrade` to explicitly upgrade the packages declared in the Brewfile
after applying the dotfiles:

```bash
./install.sh --upgrade
```

The source state lives in `home/`, selected by `.chezmoiroot`. Files use
chezmoi's standard source-state names such as `dot_gitconfig`, `dot_zshrc`, and
`symlink_...`.

## macOS tooling

`~/.Brewfile` declares the baseline macOS tools:

- chezmoi
- Jujutsu
- Herdr
- Pi
- Ghostty

Chezmoi runs `brew bundle install --no-upgrade` whenever the Brewfile changes.
It installs missing dependencies without cleaning up unrelated packages or
forcing upgrades of installed tools. Upgrades occur only when requested with
`./install.sh --upgrade`.

## Shell

Oh My Zsh is managed as a chezmoi archive external and refreshed weekly.
Generated cache files are left outside chezmoi's ownership. Custom configuration
lives at `~/.config/oh-my-zsh/custom`, where chezmoi installs the
Jujutsu-aware prompt.

The managed `.zshrc` enables the Git and Jujutsu plugins, initializes Homebrew
on Apple silicon, adds `~/.local/bin` to `PATH`, and sources an optional
unmanaged `~/.zshrc.local` for machine-specific settings.

The prompt shows the current Jujutsu change ID, local bookmarks, and conflicts.
A yellow `git-only` marker identifies Git checkouts that have not been
initialized for Jujutsu. Repository metadata is cached and refreshed on
directory changes or after `jj` and `git` commands. Prompt reads use
`--ignore-working-copy`, so rendering never snapshots or mutates the working
copy.

## Jujutsu

After applying files, chezmoi initializes this checkout as a colocated Jujutsu
repository when needed. Missing Jujutsu user name or email values are copied
from the managed Git configuration; existing Jujutsu identity values are
preserved.

## Agent configuration

```text
.agents/
  AGENTS.md
  skills/
    github-cli/
    jujutsu-development/
    managing-agent-configuration/
```

Chezmoi creates per-skill links in `~/.agents/skills` and links the shared
instructions to `~/.copilot/copilot-instructions.md`. Harness-specific behavior
belongs in that harness's configuration package, and private work behavior
belongs in a private overlay.

Credentials, sessions, caches, binaries, generated state, and private
configuration remain untracked.
