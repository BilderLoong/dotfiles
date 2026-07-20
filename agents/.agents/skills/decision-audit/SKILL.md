

## What the existing skill does better

### 1. Better activation conditions

Its description covers several important triggers:

* uncertainty;
* missing requirements or authority;
* case-specific fixes;
* completion, review, commit, and merge boundaries.

That is more operational than merely saying “use for bug fixes and architecture changes.”

There is one grammar error:

```yaml
Use when you has made
```

Change it to:

```yaml
Use when you have made
```

Or better:

```yaml
description: Use after making a material implementation decision, when uncertain about a choice, when requirements or authority are missing, when a fix may be case-specific, or before declaring work complete, requesting review, committing, merging, or archiving a change.
```

### 2. It defines materiality well

This section prevents the report from filling up with nonsense such as:

* renamed a variable;
* formatted a file;
* imported a dependency;
* followed an already-approved plan.

That filter was missing from the longer version.

### 3. The output is predictable

A strict output format is valuable for a skill. Humans and other agents can scan it quickly, and automated workflows can potentially parse it.

The longer version had a more complete analysis framework, but it risked turning every completion into a lengthy engineering review document.

## What it is currently missing

The concise version loses three important ideas from the longer one.

### It does not explicitly distinguish root cause from mitigation

The MatMul mistake could still slip through:

```text
Decision I made:
Increased the buffer to 128 because 64 was insufficient.

What I am not sure about:
Whether larger workloads need more.
```

That exposes uncertainty, but it does not force the agent to say:

> This is a workload-specific mitigation, not a root-cause correction.

That classification is extremely useful.

### It does not require a counterexample

An agent can list uncertainties without actively trying to disprove its own solution.

The best part of the longer skill was essentially:

> Find an input where the current test passes but the underlying problem remains.

That deserves one concise rule.

### It relies entirely on retrospective memory

“Before declaring a task complete, tell the user what decisions were made” means the agent reconstructs its choices afterward.

It may omit choices it no longer recognizes as choices. A lightweight instruction to maintain notes while working would improve coverage without creating a huge decision ledger.

## Two wording problems

### “The Assumptions You Made”

This sounds like the agent is accusing the user of making assumptions. It should be:

```md
### Assumptions I Made
```

### The readiness rule is too absolute

This rule:

```text
Do not claim ready for review while an unresolved material uncertainty or assumption remains.
```

may prevent review precisely when review is needed.

A change can reasonably be ready for review while containing a clearly disclosed, low-risk assumption. “Ready for review” does not mean “ready to merge.”

Better:

```text
Do not claim ready for review when an unresolved issue could materially
invalidate the implementation. Otherwise disclose the accepted risk.
```

Or add a status:

```text
ready with accepted risk
```

## Recommended final version

I would keep the existing structure and add only the missing safeguards:

````markdown
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
````

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
