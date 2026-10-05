---
name: managing-agent-configuration
description: Design, place, migrate, and validate agent instructions and skills. Use when creating or changing SKILL.md, AGENTS.md, harness configuration, private overlays, or third-party agent guidance.
---

# Managing Agent Configuration

## Decide what persists

Persist guidance when it resolves repeated friction, prevents meaningful risk, or provides a capability that would otherwise be rediscovered. Prefer removing, reshaping, or reusing existing guidance over adding another rule.

## Give behavior one owner

Read the [placement reference](./references/placement.md), choose the narrowest scope that fully owns the behavior, and keep the complete policy or workflow there. Other locations need only the obligation or pointer required to make that owner visible.

Use:

- Always-on instructions for durable policy that applies whenever they load.
- Skills for conditional expertise and procedures.
- References for detail needed by only some skill runs.

## Write executable guidance

- Give each statement one decision.
- State policy as outcomes or decision order.
- State procedures as ordered actions with observable completion and blocked results.
- Keep demonstrated safety gates visible where the risky action occurs.

Read the [skill mechanics reference](./references/skill-mechanics.md) when creating or renaming a skill.

## Migrate deliberately

Read the [provenance reference](./references/provenance.md) before adapting external material. Read the [validation checklist](./references/validation.md) before replacing an existing owner.

Keep configuration changes local until publication is requested or belongs to the established workflow. Keep private context in the private overlay and runtime state untracked.
