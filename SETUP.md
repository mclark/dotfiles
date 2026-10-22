# Setup Guide

## 1Password SSH Agent

After installing 1Password from Brewfile, configure it as your SSH agent for Git authentication.

### Prerequisites

Before setting up the SSH agent, ensure:

1. **SSH key in 1Password vault** - Your GitHub SSH private key is stored in 1Password (not just on disk)
2. **SSH Agent enabled** - In 1Password Settings → Developer, toggle "SSH Agent" to ON
3. **Key configured for SSH** - Your SSH key item in 1Password is marked as usable for SSH (usually automatic)

### Configuration

Create or edit `~/.ssh/config`:

```
Host github.com
   IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

This configures GitHub to use 1Password's SSH agent socket for authentication.

### Verification

After setup, Git operations (clone, pull, push) should prompt for fingerprint authentication via 1Password rather than passphrase.

### Official Documentation

- [1Password SSH Agent Overview](https://developer.1password.com/docs/ssh/)
- [1Password SSH Agent for Git](https://developer.1password.com/docs/ssh/git-commit-signing)
- [macOS Setup Guide](https://developer.1password.com/docs/ssh/agent/setup#macos)

### Notes

- Prerequisites must be completed in 1Password before `~/.ssh/config` setup will work
- This configuration is kept private in `~/.ssh/config` and not version-controlled
- 1Password must be running for Git operations to succeed
- The 1Password app is installed via `brew bundle` from the Brewfile
- On new machines: install 1Password, restore SSH keys from 1Password backup, enable SSH Agent, then set up `~/.ssh/config`
