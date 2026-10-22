# Repository instructions

## Multi-Harness Agent Configuration

This repository manages configuration for multiple agent harnesses (Pi, Copilot, and others). Agent instructions are symlinked from `~/.pi/agent/AGENTS.md` and `~/.copilot/copilot-instructions.md` to the shared source at `.agents/AGENTS.md`.

When modifying `.agents/AGENTS.md` or agent configuration in this repo, remember that changes affect all harnesses. Keep shared guidance harness-neutral. Harness-specific instruction overrides belong in private overlays or that harness's own configuration package.

## Safety

This repository is public. Keep committed content safe to publish: use generic examples and placeholders, and keep secrets, credentials, customer data, internal systems, and private documentation outside the repository.

Before finalizing a change, inspect it for private or company-specific content.
