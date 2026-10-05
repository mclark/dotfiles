# dotfiles

Public, portable development and agent configuration.

The installer leaves an existing Jujutsu installation alone. When `jj` is missing, it installs it with Homebrew on macOS or downloads the latest official, checksum-verified Linux release in a Codespace or devcontainer.

Missing Jujutsu user name or email values are copied from global Git configuration. Existing Jujutsu identity values are preserved, and the public `.gitconfig` provides a fallback for fresh environments.

## Agent configuration

```text
.agents/
  AGENTS.md
  skills/
    github-cli/
    jujutsu-development/
    managing-agent-configuration/
```

- `.agents/AGENTS.md` contains behavior shared across harnesses.
- `.agents/skills` contains portable Agent Skills.
- Harness-specific behavior belongs in that harness's configuration package.
- Private work behavior belongs in a private overlay.
- Repository-specific guidance stays with the repository that owns it.
- Credentials, sessions, caches, binaries, and generated state remain untracked.

The installer links portable skills into `~/.agents/skills` and shared instructions into Copilot's personal instruction path. It preserves unmanaged paths and rejects skill-name collisions.

## Install

```bash
./install.sh
```

The installer is idempotent. Existing unmanaged dotfiles are left in place with a warning. The former mise-based Jujutsu configuration is removed only when it points back to this repository.
