# GitHub reference

## Pull request templates

Look for `pull_request_template.md` in the repository root, `docs/`, and `.github/`, and for multiple templates under `.github/PULL_REQUEST_TEMPLATE/`. Match filenames case-insensitively.

When no checkout is available, list candidate directories with `gh api repos/owner/repo/contents/<path>` and inspect the returned names.

## Copilot review requests

Use the requested-reviewer flow:

```bash
gh api repos/owner/repo/pulls/123/requested_reviewers \
  --jq '{users: [.users[]?.login], teams: [.teams[]?.slug]}'

gh pr edit 123 \
  --repo owner/repo \
  --add-reviewer "copilot-pull-request-reviewer[bot]"
```

An `@copilot` PR or issue comment does not create a requested review.
