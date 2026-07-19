---
name: decision-audit
description: Use when an AI has made a material implementation decision, found a fix that may be case-specific, changed an unplanned behavior, or is about to declare work complete, request review, commit, merge, or archive a change.
---

# Decision Audit

## Overview

Audit the choices made during implementation, not the entire diff. Surface decisions whose correctness, scope, or trade-offs need a human or independent reviewer to evaluate.

## Trigger

Run this audit immediately after a material decision and again before declaring the task complete. A decision is material when it affects behavior, correctness, architecture, data, security, concurrency, public APIs, performance strategy, operational cost, or the supported input/workload range.

Do not audit mechanical work such as formatting, renaming, routine wiring, or a plan-prescribed implementation with no meaningful alternatives.

## Procedure

1. Read the approved plan, requirements, and relevant test or benchmark evidence.
2. List each material choice made beyond those decisions. Check defaults, thresholds, selection rules, error behavior, algorithms, performance workarounds, compatibility, and security boundaries.
3. State the intended invariant and the range in which the choice is expected to hold. Do not infer a general root cause from one passing reproduction or benchmark.
4. For every decision, name the strongest practical falsification case: an input, workload, state, or sequence that would expose the choice as wrong or too narrow.
5. Mark the disposition. Ask for direction instead of claiming unconditional success when a material decision remains unresolved.

## Required Output

Use this structure exactly:

```md
## Decision Audit

### Reviewed Context
- Approved decisions: <plan, specification, or user direction reviewed>
- Evidence reviewed: <tests, measurements, reproduction, or inspection>

### Material Decisions

#### D1 — <short decision>
- **Choice and trigger:** <what was chosen and why the decision arose>
- **Alternatives:** <credible alternatives considered or not evaluated>
- **Invariant and scope:** <what must remain true; supported range>
- **Evidence:** <what supports this choice>
- **Falsification case:** <what would prove it wrong or too narrow>
- **Confidence:** high | medium | low — <why>
- **Disposition:** accepted | needs validation | needs user decision

### No-Omission Check
<Either list additional decisions or state: No material decisions beyond the approved plan.>

### Completion Status
<ready for review | blocked on validation | needs user decision>
```

## Completion Rule

Only report `ready for review` when every material decision is accepted or validated. A passing original test, reported incident, or single benchmark is evidence for that case only; it is not proof of a general fix.

## Common Mistakes

- Treating an implementation detail as insignificant because it was easy to code.
- Reporting uncertainty without naming an alternative, invariant, or falsification case.
- Calling a workaround a root-cause fix because it passes the original reproduction.
- Omitting decisions that were made implicitly through a changed default, threshold, or selection rule.
