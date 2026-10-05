---
name: github-cli
description: Use authenticated GitHub tooling for issues, pull requests, reviews, Actions, Codespaces, releases, and code search. Use whenever a task touches a GitHub repository, issue, or pull request.
---

# GitHub

Prefer `gh` or another authenticated GitHub integration for repository data and operations. Use the repository supplied by the task or detected from the current checkout, and report missing access or authentication as a blocked result.

## Publishing

Treat remote changes such as issues, pull requests, comments, reviews, releases, merges, and bookmarks as publication actions that require the user's request.

Before writing a pull request:

- Use the repository's pull request template when one exists, preserving its required structure.
- Lead with why the change exists before describing the implementation.
- Include only verification evidence produced by checks that actually ran.

Read the [GitHub reference](./references/command-reference.md) when template discovery requires remote inspection or when requesting a Copilot review.

## Development handoff

For local code changes, apply the `jujutsu-development` skill. Preserve the current revision stack, base, and publication state unless the task requires changing them.

## Copilot reviews

Request Copilot through GitHub's requested-reviewer flow. An `@copilot` comment does not create that review request.

## Code search

Read the [code search reference](./workflows/code-search.md) when searching beyond the current checkout or providing repository code citations.
