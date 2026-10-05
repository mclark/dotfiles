# dotfiles

Public, portable development and agent configuration.

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

The installer is idempotent. Existing unmanaged dotfiles are left in place with a warning.
