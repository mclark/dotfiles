---
name: jujutsu-development
description: Shape, inspect, revise, and publish development work with Jujutsu. Use when planning revisions, editing an existing revision stack, resolving conflicts, or preparing Jujutsu changes for review.
---

# Jujutsu Development

Use this workflow to place changes in an intentional revision stack without disturbing unrelated work.

## Place work

1. Run `jj status` and inspect the relevant stack with `jj log`.
2. Select the revision that logically owns the change, or create one when the change is a distinct concern.
3. Describe each non-empty revision with a concise, outcome-focused subject. When the subject is not self-documenting, add a body explaining why the revision exists, its significant contents, and any important constraints or verification.

Preserve working-copy changes and revisions outside the task's intended scope.

## Choose current mechanics

For nontrivial stack rewrites, conflict resolution, or remote operations, inspect `jj --version` and the relevant `jj help` before acting. Prefer purpose-built commands available in that version over memorized command sequences; treat examples in this skill as fallbacks rather than an exhaustive workflow.

## Shape the stack

- Inspect revision boundaries with `jj diff -r <revision>` and `jj show <revision>`.
- Identify the intended destination revisions before moving changes.
- Put each conflict resolution in the revision where it logically belongs.
- After rewriting history or resolving conflicts, inspect affected revisions and descendants for misplaced changes or new conflicts.

## Work with remotes

Inspect `jj help git` and the relevant subcommand before fetching, tracking, moving, or publishing bookmarks. Publish when requested or when the established workflow includes publication; otherwise leave bookmarks local.

## Finish

1. Run the relevant checks.
2. Inspect `jj status`, `jj diff`, and the final `jj log`.
3. Confirm that revisions have intentional boundaries and no unresolved conflicts.
4. Confirm that every description matches its revision's final contents after all stack rewrites.
