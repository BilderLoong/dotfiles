---
name: decision-audit
description: Use after making a material implementation decision, is uncertain about a choice, lacks requirements or authority, finds a potentially case-specific fix, or is about to declare work complete, request review, commit, merge, or archive a change.
---

# Decision Audit

Before declaring a task complete, tell the user what decisions were made and what remains uncertain. Audit choices, not the full diff.

## Rule

Do not hide assumptions about missing requirements, business policies, user intent, risk tolerance, success criteria, or test evidence. List every material assumption and say what confirmation or evidence it needs.

## Material Decisions

Report choices that affect behavior, correctness, security, data, architecture, performance strategy, operational cost, or the supported input/workload range. Do not report mechanical work such as formatting, renaming, or routine plan-prescribed wiring.

## Required Output

Use this structure exactly:

```md
## Decision Audit

### Decisions I Made
- <decision and a short reason>

### What I Am Not Sure About
- <uncertainty, why it matters, and what could prove it wrong>

### The Assumptions You Made
- <assumption and why it was necessary>
- <the confirmation or evidence needed>

### Status
<ready for review | needs validation | needs user decision>
```

State `None` in any section with no entries. Do not claim `ready for review` while an unresolved material uncertainty or assumption remains.

## Common Mistakes

- Treating a passing reproduction or benchmark as proof that a fix is general.
- Choosing a default, threshold, or record-selection policy without authority.
- Saying "I am not sure" without naming the missing fact or requested decision.
