---
name: github-writing
description: Write or revise pull request descriptions, issue descriptions, and GitHub Discussions with artifact-specific audience, detail, and structure. Use whenever drafting, editing, or reviewing the communication quality of a pull request, issue, or discussion.
---

# GitHub Writing

Respect the reader's time and focus. Communicate the important information with as little friction and in as little time as the subject allows.

Lead with what the reader needs to understand, decide, or do. Use plain, direct language with a casual, professional voice. Prefer concrete actors and actions, state uncertainty honestly, and support factual claims with links or other evidence when possible.

Do not repeat detailed context that is already explained well in an issue, discussion, document, or other durable source. Summarize the relevant point and link to that source. If no adequate source exists and the context is necessary, explain it inline rather than making the reader reconstruct it.

Checklists can help track work, but they are not a substitute for explaining the work to another person.

Follow the target repository's templates and conventions.

## Choose the operation

Default to creation. Use revision only when the user explicitly asks to change, rewrite, shorten, or clarify an existing artifact. Reading existing issues, pull requests, or documents for context does not by itself make the task a revision.

### Creation

Start from the intended message rather than inheriting the structure of source material. Synthesize the available context into the smallest draft that gives the intended audience what it needs. Establish scope, choose a useful structure, and leave unsupported details out.

### Revision

Treat requests to rewrite, improve, shorten, or clarify existing text as editing tasks, not permission to re-author the artifact.

- Preserve the existing meaning, scope, useful links, and settled decisions, not the existing headings, formatting, or level of formality.
- Remove repetition and friction before adding anything.
- Do not introduce new requirements, sections, design questions, or implementation detail unless the user requests them or a cited source makes them necessary.
- Treat existing checklists and acceptance criteria as source material. Keep them as checklists only when checking items off provides real tracking value; otherwise fold their substance into concise prose or linked sub-issues.
- Restructure only where it materially improves comprehension.

## Editing pass

Before returning a draft:

1. Identify the main point and what the reader needs to understand, decide, or do.
2. Remove any paragraph, section, bullet, or question whose absence would not change that.
3. Replace repeated background with a short summary and a link to the durable source.
4. Merge headings when the draft reads like a report or template rather than a message to another person.
5. Move independently understandable work or design questions into linked issues instead of keeping every detail inline.

## Pull requests

Write for the narrow audience reviewing the change. Assume they will read the description thoroughly.

- Explain the context, why the change is needed, and why the implementation took this shape.
- Call out important tradeoffs, alternatives, scope boundaries, and details that deserve reviewer attention.
- Describe the risk level and the rollout, observability, mitigation, and rollback plan that fit the actual risk.
- Explain how the change was tested or otherwise verified.
- Follow the repository template, but do not add ceremonial sections that convey no useful information.

## Issues

Write for the team first, while remaining understandable across the organization. Keep the voice informal, succinct, clear, and accurate.

- Keep each issue focused on one logical piece of work.
- Start with a short narrative describing the current situation, the desired change, and why it matters.
- Link evidence and prior context near the claims they support.
- Use headings, bullets, and checkboxes only when they make the issue easier to read or track.
- Do not manufacture acceptance criteria or exhaustive validation sections when the outcome is already clear.
- Preserve real uncertainty as an open question instead of disguising it as a requirement.
- Include only unresolved questions that block understanding or progress. Do not turn every implementation choice or edge case into a review point.
- Split independently understandable work into sub-issues rather than expanding the parent into a long checklist. Keep the parent readable and use up to three levels of hierarchy when that clarifies the work.

### Hierarchy

When using an Epic, Batch, and Task hierarchy:

- An **Epic** describes the overall outcome, major constraints, and child workstreams. It contains Batches without repeating their gap lists or implementation details.
- A **Batch** owns one coherent workstream. It explains the related gaps or outcomes and decomposes them into Tasks.
- A **Task** is a concrete leaf unit of work that should usually map closely to one pull request or deliverable.
- An analysis or investigation issue is a leaf Task. Its parent owns any implementation work that follows from the findings.
- Each parent summarizes why a child exists; the child owns the detail.

Represent this structure with GitHub's native metadata:

- Set the issue type field instead of adding type prefixes such as `[Epic]`, `[Batch]`, or `[Task]` to titles.
- Use parent and sub-issue relationships for hierarchy instead of simulating it with task lists or plain links.
- Do not add labels that merely duplicate the issue type. Reserve labels for independent attributes that remain useful across types.

## Discussions

Write for the broadest engineering audience. Treat a discussion like a short public blog post.

- Lead with the point, proposal, or question.
- Keep it brief and punchy; link to deeper material instead of reproducing it.
- Assume readers lack the team's local context.
- Prefer diagrams, graphs, screenshots, and other visuals when they communicate faster than prose.
