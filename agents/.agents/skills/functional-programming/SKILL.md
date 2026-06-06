---
name: functional-programming
description: Enforce strict functional programming style when writing code. Use this skill whenever the user asks you to write or modify functions, modules, data transformations, algorithms, error handling, or any non-trivial code. Auto-detect when code is being written and apply FP constraints proactively — even if the user doesn't say "functional programming." Stay quiet for config files, HTML/templates, SQL, CSS, and framework-mandated class boilerplate (e.g., React class components pre-hooks, Angular services, NestJS decorators).
---

# Functional Programming — Strict Enforcement

When writing or modifying code, apply these rules. They are ordered by importance: [REQUIRED] constraints are non-negotiable; [DEFAULT] rules apply unless the language/framework strictly forces otherwise.

## Core Principles

### 0. Readability First & When NOT to Use FP

Every FP rule below serves one goal: **code that is easier to understand, debug, and modify.** When strict adherence to an FP pattern reduces readability, step back and choose the clearer alternative. A well-named `if/else` beats a clever ternary chain. A simple early return beats a forced `pipe`. FP is a tool for clarity, not a dogma.

Before reaching for an FP pattern, ask whether the language already gives you a simpler, clearer way.

**Simple nulls — use optional chaining:**

The language ships with `?.` and `??`. Use them for straightforward property access — don't build a pipeline for a single traversal.

```typescript
// YES — built-in, every JS/TS dev understands this
const city = user?.address?.city ?? "Unknown";

// NO — overkill for a single property chain
const city = pipe(
  O.fromNullable(user),
  O.flatMap(u => O.fromNullable(u.address)),
  O.flatMap(a => O.fromNullable(a.city)),
  O.getOrElse(() => "Unknown")
);
```

**Early exit — use a for loop:**

When you need to `break`, `continue`, or `return` mid-iteration, a `for` loop is the clearest tool. Pushing that logic into `map`/`filter`/`reduce` makes it harder, not easier.

```typescript
// YES — early return is the whole point
const findFirstMatch = (items: Item[], pred: (i: Item) => boolean): Item | null => {
  for (const item of items) {
    if (pred(item)) return item;
  }
  return null;
};

// NO — can't express early exit without .find(), and not every case fits .find()
```

**Hot paths — imperative is fine:**

When profiling shows the allocation cost of `map`/`filter`/`reduce` matters, write the imperative loop. Correctness and readability still apply, but intermediate allocations are a genuine tradeoff in hot code.

```typescript
// YES — single pass, no allocations
let sum = 0;
for (let i = 0; i < numbers.length; i++) {
  sum += numbers[i];
}

// OK for 99% of cases, but not when every allocation counts
const sum = numbers.reduce((acc, n) => acc + n, 0);
```

### 1. Pure Functions & Side Effects [REQUIRED]

Core logic must have zero side effects. A side effect is anything that interacts with the outside world: I/O (files, network, console), DOM manipulation, `Date.now()`, `Math.random()`, mutating external state, or throwing exceptions for control flow.

**Push unavoidable side effects to the absolute edges of the system.** The "edges" are the entry point (main, request handler, CLI command) and the exit point (the final return/render). Everything between must be pure.

**Before writing any function, ask:**
- Does this function depend ONLY on its arguments?
- Does it return a value (not `void`/`undefined` except at system edges)?
- Can I call it 1000 times and get the same result?

A function returning `void` is a red flag — it almost certainly has side effects. If it's not at the system edge, redesign it.

### 2. Immutability [REQUIRED]

Never mutate existing data structures. Operations that alter data must return a newly constructed instance.

This means:
- No `array.push()`, `array.pop()`, `array.sort()` (mutates in place)
- No `obj.field = value` on existing objects
- No `Map.set()`, `Set.add()` on existing collections
- No reassigning function parameters

**Use these instead:**
- Spread operators: `{ ...obj, field: value }`, `[...arr, newItem]`
- Non-mutating array methods: `.map()`, `.filter()`, `.concat()`, `.slice()`, `.toSorted()`, `.toReversed()`
- Library utilities: Immutable.js, Immer (only for complex nested updates)

**Language notes:**
- JavaScript/TypeScript: `const` by default; objects/arrays still need spread
- Python: `tuple` over `list` where possible; `dataclasses.replace()` for field updates; `frozenset` over `set`
- Go: return new structs; never use pointer receivers that mutate
- Rust: owned values, not `&mut`; `clone()` is explicit and acceptable for purity

### 3. Data Over Objects (No OOP) [DEFAULT]

Do not use classes, inheritance, encapsulation, or the `this` keyword. Exception: when the framework lifecycle strictly mandates it (React class components, Angular decorators, NestJS providers).

**Instead:**
- Keep data structures plain — interfaces, types, records, dataclasses, structs
- Keep functions separate from data — think in pipelines, not methods on objects
- Use modules/files for grouping related functions, not classes for grouping methods

```typescript
// NO — class with methods
class UserService {
  private users: User[];
  constructor(users: User[]) { this.users = users; }
  getActive(): User[] { return this.users.filter(u => u.active); }
}

// YES — plain data + standalone functions
interface User { id: string; active: boolean; }
const getActive = (users: User[]): User[] => users.filter(u => u.active);
```

### 4. Declarative Style [DEFAULT]

Describe *what* to achieve, not *how* (step-by-step loop mechanics).

Use higher-order functions (`map`, `filter`, `reduce`/`fold`) over explicit `for`/`while` loops. Prefer expression-oriented programming — but **readability always wins**. A clear `if/else` with early returns is better than a nested ternary that requires mental stack management.

**Ternary rule of thumb:** Use ternaries for simple binary choices (one condition, two outcomes). For multi-branch logic, use `if/else` with early returns. Never nest ternaries beyond one level.

```typescript
// NO — imperative loop
const result = [];
for (let i = 0; i < items.length; i++) {
  if (items[i].active) result.push(items[i].name);
}

// YES — declarative pipeline
const result = items.filter(i => i.active).map(i => i.name);
```

```typescript
// NO — nested ternaries (hard to read)
const status = isActive
  ? user.verified ? "active-verified" : "active-unverified"
  : user.verified ? "inactive-verified" : "inactive-unverified";

// YES — if/else with early returns (clear, debuggable)
if (isActive && user.verified) return "active-verified";
if (isActive) return "active-unverified";
if (user.verified) return "inactive-verified";
return "inactive-unverified";
```

### 5. Algebraic Data Types & Error Handling [REQUIRED for domain modeling, DEFAULT for errors]

Model domain states explicitly. Don't rely on `null`/`undefined`/`None` sentinels alone — use tagged unions/discriminated unions/sum types to represent mutually exclusive states.

For error handling, return errors as values (Result/Either pattern) rather than throwing and catching exceptions for expected control flow.

```typescript
// NO — throwing for control flow
function parseConfig(raw: string): Config {
  try {
    return JSON.parse(raw);
  } catch (e) {
    throw new Error(`Invalid config: ${e.message}`);
  }
}

// YES — Result type
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };

function parseConfig(raw: string): Result<Config> {
  try {
    return { ok: true, value: JSON.parse(raw) };
  } catch (e) {
    return { ok: false, error: new Error(`Invalid config: ${e.message}`) };
  }
}
```

**Language adaptations:**
- TypeScript: discriminated unions (`{ kind: "success"; value: T } | { kind: "error"; error: E }`) or libraries like `fp-ts`/`effect-ts`
- Python: `@dataclass` with a `kind` field, or `Result` type from `returns` library
- Go: multi-value returns `(T, error)` — this is idiomatic and acceptable
- Rust: native `Result<T, E>` — use it, never `unwrap()` in core logic

### 6. Code Quality [REQUIRED / DEFAULT]

These rules keep FP from drifting into clever-but-unreadable territory. They're the guardrails.

**Single Responsibility [REQUIRED]**: Each function should do one clear thing. Pure does not mean tiny — a pure function can be 50 lines if it's one cohesive operation. But if you can't name it without "and" or "or", split it.

**Prefer slight duplication over the wrong abstraction [DEFAULT]**: Abstract only after a clear, stable pattern emerges multiple times. A repeated 3-line `{ ...obj, field: value }` spread is better than a premature `withField()` combinator that nobody understands. FP devs over-abstract — resist it.

**YAGNI [REQUIRED]**: Do not build features or abstractions "just in case." A 4-line discriminated union does the job — don't reach for a full `Either` monad or `fp-ts` unless the project already uses it. The simplest thing that works is the right choice.

**Clarity over cleverness [REQUIRED]**: Avoid dense abstractions, excessive indirection, and overly generic utilities. If a junior dev can't read your `pipe` chain in one pass, break it into named intermediate variables. The goal is code a teammate can quickly understand, debug, and safely modify.

**Explicit typing [REQUIRED]**: Explicitly type all function arguments and return values. Avoid overly broad types unless the interface genuinely requires it. Define specific shapes for all data structures — in TypeScript that's `interface` or `type`, in Python that's `TypedDict` or `dataclass`.

**No `any`, no unsafe casts [REQUIRED]**: Never use `any` — it disables the type checker and hides bugs. `unknown` is acceptable only at system boundaries (parsing JSON, reading external input) but must be narrowed to a specific type via type guards before use. Never use `as` casts, non-null assertions (`!`), or `@ts-ignore` to silence the compiler — if the types don't align, fix the types, not the cast.

```typescript
// NO — any defeats the purpose
function process(data: any): any {
  return data.items.map((item: any) => item.name);
}

// NO — unsafe cast hides the problem
const user = data as User;
user.email.toLowerCase(); // hope this works

// YES — unknown at the boundary, narrowed via type guard
const isUser = (value: unknown): value is User =>
  typeof value === "object" && value !== null && "email" in value;

function process(data: unknown): Result<User[]> {
  if (!isUser(data)) return failure(new Error("Invalid user data"));
  return success(data.items); // data is now User, no cast needed
}
```

**Self-documenting code [REQUIRED]**: Names must explain *what* is happening. Use inline comments exclusively for *why* a non-obvious decision was made. Standard docstrings for public functions are fine, but the code itself should tell the story.

**Don't swallow errors [REQUIRED]**: If you return a `Result` type, the caller must handle both branches. An unhandled `failure` branch is a silent bug waiting to happen. At the system edge, log the error before converting to a user-facing message.

**Performance [DEFAULT]**: Optimize only when constraints are known, profiling identifies a bottleneck, or the cost is obviously significant. Do not sacrifice readability, correctness, or maintainability for speculative micro-optimizations. A pure `O(n²)` that's correct beats a clever `O(n log n)` that's wrong.

---

### 7. Function Composition [OPTIONAL]

Use currying, partial application, and data-last function signatures where they improve composability of your pipeline. Prefer `pipe`/`compose` over deeply nested calls.

```typescript
// NO — nested calls
const result = sortByDate(filterActive(parseUsers(raw)));

// YES — pipeline
const result = pipe(raw, parseUsers, filterActive, sortByDate);
```

---

### 8. Control Flow Patterns [DEFAULT]

These three patterns work together to keep function bodies flat, readable, and easy to debug. They're the *how* — the concrete structures that implement the principles above.

**Fail early — validate at the top, bail immediately:**

Check preconditions first. If something is wrong, return the error immediately. This keeps the happy path unindented and the error handling visible.

```typescript
const transfer = (from: Account, to: Account, amount: number): Result<Transaction> => {
  // Fail early — all preconditions checked at the top
  if (amount <= 0)            return failure(new Error("Amount must be positive"));
  if (from.balance < amount)  return failure(new Error("Insufficient funds"));
  if (from.id === to.id)      return failure(new Error("Cannot transfer to self"));

  // Happy path — clean, unindented, easy to follow
  return success({ from: deduct(from, amount), to: credit(to, amount) });
};
```

**Early return — flat control flow, no deep nesting:**

Use `if`/`else` with early returns instead of deeply nested blocks. This is the mechanism that keeps ternaries from nesting. A single `if (x) return y` is always clearer than a nested ternary.

```typescript
// NO — nested if/else, hard to trace
if (user) {
  if (user.active) {
    if (user.hasPermission("write")) {
      return update(data);
    } else { return failure("no permission"); }
  } else { return failure("inactive"); }
} else { return failure("not found"); }

// YES — flat early returns, each case visible at a glance
if (!user)                        return failure("not found");
if (!user.active)                 return failure("inactive");
if (!user.hasPermission("write")) return failure("no permission");
return update(data);
```

**EAFP — it's easier to ask forgiveness than permission:**

Instead of defensively pre-validating every possible failure, just try the operation and wrap the error. This pairs with `Result` types — the try/catch is a thin shell that converts exceptions into values.

```typescript
// NO — defensive pre-validation (fragile, duplicates the parser's own checks)
const parseJSON = (raw: string): Result<Config> => {
  if (typeof raw !== "string")  return failure(new Error("Not a string"));
  if (raw.trim() === "")        return failure(new Error("Empty string"));
  if (!raw.startsWith("{"))     return failure(new Error("Doesn't look like JSON"));
  // ... always some edge case you missed
};

// YES — EAFP (concise, complete, trusts JSON.parse to do its job)
const parseJSON = (raw: string): Result<Config> => {
  try { return success(JSON.parse(raw)); }
  catch (e) { return failure(new Error(`Invalid JSON: ${e.message}`)); }
};
```

**EAFP is the right choice when:** the operation has a built-in validation mechanism (like `JSON.parse`'s throw). **Fail early is the right choice when:** you have business rules that the operation doesn't check (like "amount must be positive").

---

## Trigger Logic — When to Enforce

**Enforce strictly when:**
- Writing new functions or modules
- Refactoring existing code
- Implementing data transformations, algorithms, business logic
- Designing error handling
- Modeling domain types

**Stay quiet (don't enforce) when:**
- Writing config files (JSON, YAML, TOML)
- Writing SQL queries, HTML templates, CSS
- Framework boilerplate that requires classes (Angular, NestJS, etc.)
- Shell scripts, Makefiles, CI configs
- The user insists on OOP after you've shown them the FP alternative — don't argue with explicit overrides like "No, I really want a class for this"

## Code Review Checklist

Before finalizing any code, verify:

1. **No mutations**: No `push`, `pop`, `sort`, `splice`, direct property assignment to existing objects, or `&mut` receiver methods
2. **No classes**: No `class`, `this`, `extends`, `new` (unless framework-mandated)
3. **No loops**: No `for`, `while`, `do...while` — use `map`/`filter`/`reduce`/`fold` instead
4. **Pure core**: All non-edge functions are deterministic and side-effect-free
5. **Explicit errors**: Errors are returned as values, not thrown for control flow
6. **Explicit state**: Domain states use discriminated unions/tagged types, not `null` sentinels alone
7. **Pipe, don't nest**: Deeply nested function calls are replaced with `pipe`/`compose` chains
