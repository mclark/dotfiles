---
name: github-epic-organization
description: Design, create, revise, and audit readable GitHub Epic hierarchies using native issue types and sub-issues. Use when splitting a large initiative into Epics, Batches, and Tasks; organizing or reordering sub-issues; or removing duplicated workstream detail from parent issues.
---

# GitHub Epic Organization

Build an issue hierarchy that communicates the plan without repeating it. This skill owns the readability and composition of Epic, Batch, and Task hierarchies: what belongs at each level, how children are ordered, and how to keep parent descriptions concise.

Apply the repository's conventions and the available GitHub writing and GitHub tooling guidance.

When available, use `issue-breakdown` for platform-limit checks and bulk decomposition mechanics, and `issue-relationships` for exact hierarchy, dependency, and reprioritization operations. Keep this skill as the owner of the resulting hierarchy's information design.

## Model the hierarchy

Use no more than three levels unless the repository has a stronger convention:

- **Epic:** the overall outcome, major constraints, completion signal, and scope boundaries.
- **Batch:** one coherent, independently ownable workstream with a meaningful outcome.
- **Task:** a concrete leaf investigation or deliverable that should usually map closely to one pull request or artifact.

Split work by independently understandable outcomes, not merely by chronological phases. Prefer one Batch when several steps contribute to one outcome. An investigation is a Task; its parent owns implementation work created from its findings.

## Design before publishing

1. State the Epic's desired outcome and architectural or operational constraints.
2. Inventory the distinct deliverables, gaps, environments, rollout work, and retirement work.
3. Group related deliverables into Batches with clear ownership boundaries.
4. Decompose each Batch only as far as concrete Tasks.
5. Identify dependencies and parallel work before ordering any children.
6. Reuse related issues when their existing scope fits; do not create duplicates to make the hierarchy look complete.

## Write each level

### Epic

Keep the body focused on:

- `## Goal`
- `## Constraints`, when constraints materially shape the work
- `## Complete when`
- optional `## Related work` and `## Out of scope`

Do not add a Workstreams section that restates the native Batch titles displayed on the Epic.

### Batch

Keep the body focused on:

- `## What`
- `## Complete when`
- optional `## Out of scope`

Explain why the Batch exists, but do not add an Outcomes or task-list section that restates its native Task titles.

### Task

Keep the body focused on:

- `## What`
- `## Done when`
- optional `## Out of scope`

Put detailed contracts, gaps, implementation requirements, and validation in the Task that owns them rather than copying them into its parents.

Titles must be specific enough to communicate the hierarchy when GitHub displays sub-issues inline.

## Use native GitHub structure

- Set the native Epic, Batch, or Task issue type.
- Use native parent and sub-issue relationships.
- Do not add type prefixes to titles or labels that merely repeat the issue type.
- Use task lists only for work that is not represented by native child issues.
- Keep detailed context in the narrowest issue that owns it; parents summarize why the child exists.

## Order children by dependency

Order issues by the work's logical progression, not issue number or creation time:

1. discovery, inventory, and contract decisions
2. foundational service or infrastructure capabilities
3. client and integration work
4. compatibility evidence and operational controls
5. controlled rollout
6. broader operation or target coverage
7. cleanup, retirement, and access revocation

Put blockers before dependents. For example, put an inventory before work whose requirements depend on it, a server capability before its client integration, routing before rollout, and access revocation last. Keep independent work adjacent and describe genuine parallelism instead of inventing dependencies.

Order every level recursively. A well-ordered Epic with a poorly ordered Batch is still difficult to execute.

## Publish and verify

When publication is authorized:

1. Create or revise the issue bodies without duplicating child titles.
2. Set native issue types.
3. Attach every child to its parent.
4. Arrange children in dependency order.
5. Verify the hierarchy recursively from the Epic.

The final audit must confirm:

- every issue has the intended type and parent;
- every child appears once and at the correct level;
- child ordering matches dependencies;
- parent descriptions do not repeat the native child list;
- completion criteria describe parent-level success rather than child implementation;
- titles remain understandable in GitHub's inline sub-issue display;
- links, scope boundaries, and settled decisions remain intact.

When revising an existing hierarchy, remove redundancy surgically. Preserve useful narrative, constraints, completion criteria, historical links, and scope boundaries.
