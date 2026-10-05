# Portable skill mechanics

A portable skill is a directory containing `SKILL.md`.

```text
skill-name/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

`SKILL.md` begins with YAML frontmatter containing a `name` that matches the directory and a `description` that identifies both the capability and its triggers.

Keep instructions needed on every run in `SKILL.md`. Put conditional detail in focused references and state when each reference should be read. Reference files remain ordinary Markdown, and links to bundled content use paths relative to the containing file.

Add scripts and assets only when the workflow consumes them. Check the current portable specification and target harness documentation before relying on optional fields or harness extensions.

Validate that frontmatter parses, links resolve, installation has no name collision, and each intended harness discovers the skill.
