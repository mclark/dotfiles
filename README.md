# dotfiles

Public, portable development and agent configuration managed with chezmoi.

## Install

### New machine

On a new machine, bootstrap your dotfiles with a one-liner:

```bash
git clone https://github.com/mclark/dotfiles.git ~/.local/share/chezmoi
sh ~/.local/share/chezmoi/install.sh
```

This clones the repository and runs the bootstrap script, which:
- Installs Homebrew on macOS (when needed)
- Installs chezmoi
- On Arch Linux, installs the packages listed in `arch/`
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

## Arch Linux tooling

Arch has its own app lists, independent of the macOS Brewfile:

- `arch/packages.txt`: official repository packages (build tools, Git, Node.js, npm)
- `arch/aur.txt`: AUR packages (currently 1Password)
- `arch/npm.txt`: user-local npm tools (currently pi)

From this checkout, run:

```bash
sh ./install.sh
```

Or install only the Arch apps without applying dotfiles:

```bash
sh ./arch/install.sh
```

The installer runs `sudo pacman -Syu --needed`, including a **full system
upgrade**, to avoid unsupported partial upgrades. Review pacman's transaction
before confirming. It never removes unrelated packages. Keep package lists to
one package per line, without comments.

Missing AUR packages are cloned into `~/.cache/dotfiles/aur/` (or
`$XDG_CACHE_HOME/dotfiles/aur/`). Review the PKGBUILD and supporting files in
another terminal before typing `yes` to build. Builds run as your regular user;
`makepkg` requests sudo for dependencies and installation. Existing AUR packages
are skipped, not upgraded. Maintain their updates separately. A failed or
cancelled build directory is preserved for inspection; remove it before retrying.

npm tools are installed under `~/.local` without sudo. Existing pi installations
are preserved, including standalone installs. Ensure `~/.local/bin` is on your
PATH (the managed Zsh config already does this). For Bash, add this to
`~/.bashrc` if needed:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

The Arch installer requires an interactive terminal and sudo access. It does not
change your login shell or configure/unlock 1Password. See [SETUP.md](SETUP.md)
for SSH agent setup. Other Linux distributions only get the existing chezmoi
bootstrap; these package lists are Arch-specific.

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
