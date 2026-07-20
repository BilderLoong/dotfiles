---
name: decision-audit
description: Use after making a material implementation decision, when uncertain about a choice, when requirements or authority are missing, when a fix may be case-specific, or before declaring work complete, requesting review, committing, merging, or archiving a change.
---

# Decision Audit

Before declaring a task complete, report the material decisions made and
what remains uncertain. Audit choices, not the full diff.

## Rule

Do not hide assumptions about missing requirements, business policies,
user intent, risk tolerance, success criteria, or test evidence.

Record material decisions as they arise so they are not reconstructed only
at the end.

For a corrective change:

- state whether it fixes the root cause or only mitigates the observed case;
- challenge any new default, threshold, capacity, or heuristic;
- consider at least one counterexample where the current test passes but
  the underlying problem remains.

## Material Decisions

Report choices that affect behavior, correctness, security, data,
architecture, performance strategy, operational cost, or the supported
input or workload range.

Do not report mechanical work such as formatting, renaming, or routine
plan-prescribed wiring.

## Required Output

Use this structure exactly:

```md
## Decision Audit

### Decisions I Made
- <decision, short reason, and whether it is a root-cause fix or mitigation>

### What I Am Not Sure About
- <uncertainty, why it matters, and what could prove it wrong>

### Assumptions I Made
- <assumption and why it was necessary>
- <confirmation or evidence needed>

### Counterexample Considered
- <case that could expose a locally correct but non-general solution>

### Status
<ready for review | ready with accepted risk | needs validation | needs user decision>

State `None` in any section with no entries.

Do not claim `ready for review` when an unresolved issue could materially
invalidate the implementation. Do not claim readiness solely because the
current test, reproduction, or benchmark passes.

## Common Mistakes

* Treating a passing reproduction or benchmark as proof that a fix is general.
* Presenting a mitigation as a root-cause correction.
* Choosing a default, threshold, capacity, or record-selection policy without authority.
* Reporting uncertainty without naming the missing fact, evidence, or decision.
* Omitting a choice because it seemed obvious during implementation.

```

## Verdict

Use the **existing concise skill as the foundation**.

The longer version is more intellectually complete, but too elaborate for the primary file. The revised concise version above preserves the existing skill’s discipline while adding the three highest-value protections:

1. root cause versus mitigation;
2. counterexample testing;
3. recording decisions as they arise.

That is the best balance.
```
