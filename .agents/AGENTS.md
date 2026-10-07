# Global Instructions

## Engineering Principles

- Prefer deleting code to reshaping it, and reshaping code to adding it. Choose the first approach that fully solves the problem; new code must justify its ongoing cost.

## Revision Design

- Design revision history as deliberately as code: each revision should be a coherent, intentional step, described by its final contents, in a clear progression from foundations to outcomes.
- Put each change in the revision where it logically belongs. Fold refinements into existing revisions; create a new revision only for a distinct concern.

## Version Control

- Use Jujutsu (`jj`) for version control in every repository. Use Git only when explicitly requested or when the required operation has no Jujutsu equivalent.

## Commit Attribution

- Do not add a Copilot `Co-authored-by` trailer to commits or Jujutsu revision descriptions.
