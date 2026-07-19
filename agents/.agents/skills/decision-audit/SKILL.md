---
name: decision-audit
description: Use when an AI has made a material implementation decision, is uncertain about a choice, lacks requirements or authority, finds a potentially case-specific fix, or is about to declare work complete, request review, commit, merge, or archive a change.
---

# Decision Audit

Before declaring a task complete, tell the user what decisions were made and what remains uncertain. Audit choices, not the full diff.

## Rule

Do not assume missing requirements, business policies, user intent, risk tolerance, success criteria, or test evidence. Label missing context as unknown and ask for a decision when it materially affects the work.

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

### Unknown — No Assumptions Made
- <missing fact, policy, authority, or success criterion>
- <the user decision or evidence needed>

### Status
<ready for review | needs validation | needs user decision>
```

State `None` in any section with no entries. Do not claim `ready for review` while an unresolved material uncertainty or unknown remains.

## Common Mistakes

- Treating a passing reproduction or benchmark as proof that a fix is general.
- Choosing a default, threshold, or record-selection policy without authority.
- Saying "I am not sure" without naming the missing fact or requested decision.
