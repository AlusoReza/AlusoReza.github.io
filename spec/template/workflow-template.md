# Action Plan Template — AI Workflow Protocol

> This document defines the complete working methodology for AI agents on SDD projects.
> Follow this protocol step by step for every session.
> Any AI should be able to replicate this workflow after reading this document once.

## Table of Contents

1. [Session Lifecycle](#1-session-lifecycle)
2. [Plan-First Protocol](#2-plan-first-protocol)
3. [Build-Driven Logging Protocol](#3-build-driven-logging-protocol)
4. [Bug Tracking Protocol](#4-bug-tracking-protocol)
5. [Testing Protocol](#5-testing-protocol)
6. [Commit Protocol](#6-commit-protocol)
7. [Language Policy](#7-language-policy)
8. [Context Recovery](#8-context-recovery)
9. [Quality Gates](#9-quality-gates)

---

## 1. Session Lifecycle

Every session follows this exact sequence:

1. **Context reconstruction** — Read `docs/bitacora.md` and scan `docs/logs/` to understand the current project state. Do not assume knowledge of prior sessions.
2. **Initial git snapshot** — Run `git diff --stat` and `git diff` to capture the clean state before any changes.
3. **Task understanding** — Clarify the user's request. If not at least 80% sure, ask. Do not guess or invent.
4. **Plan proposal** — For any non-trivial task, propose a written plan following the Plan-First Protocol. Wait for explicit user approval.
5. **Implementation** — Execute the approved plan one task at a time. State what was changed when each task finishes.
6. **Build** — Run the project's build command (e.g. `npm run build`). Capture full output.
7. **Tests** — Run the project's test suite (e.g. `.agents/tests/run-all.ps1`). Capture full output.
8. **Session log** — Immediately write `### Changes` and `### Build` in `docs/logs/YYYY-MM-DD.md`. See Logging Protocol for format.
9. **Bitácora update** — Add a 2-3 line summary entry to `docs/bitacora.md` with a link to the detailed log.
10. **Reset snapshot** — Run `git diff --stat` again so the next build captures only new changes.
11. **Commit** — Only when explicitly asked by the user. See Commit Protocol.

---

## 2. Plan-First Protocol

Before writing any code for a non-trivial task, the agent must:

1. **State the goal** — Summarise what the user asked for in one sentence.
2. **Propose a plan** — A numbered list of changes, grouped by file. Each entry describes what will change and why.
3. **Wait for approval** — Do not start implementation until the user explicitly approves the plan.
4. **Stick to the plan** — If during implementation you discover something unexpected, stop and re-propose.

The plan should answer:
- Which files will change?
- What is the change in each file?
- Why is this the right approach?
- How will you verify it works (build + tests)?

> If the task is trivial (typo fix, single-line change, adding one JSON entry), you may skip the formal plan but still say what you are about to do.

---

## 3. Build-Driven Logging Protocol

### 3.1 File Hierarchy

Two files work together:

```
docs/
├── bitacora.md              ← Global index, one line per session, grouped by date
└── logs/
    ├── YYYY-MM-DD.md        ← Detailed log, one ## Session section per session
    └── ...                  ← One file per active day
```

**`docs/bitacora.md`** — The executive summary and entry point. Each entry is 2-3 lines: session number, prompt, plan. Links to the detailed log. Updated after every build.

**`docs/logs/YYYY-MM-DD.md`** — The complete record and source of truth. Contains the full Prompt, Plan, Changes, Build output, and any bugs found. One `## Session N` section per session. Multiple sessions can exist in the same day file.

### 3.2 Relationship

```
bitacora.md                        logs/YYYY-MM-DD.md
┌──────────────────────┐           ┌──────────────────────────────┐
│ 2026-06-29           │           │ # 2026-06-29                 │
│ Session 17: ...      │──link──▶  │                              │
│ Prompt: ...          │           │ ## Session 17                │
│ Plan: ...            │           │ Prompt: ...                  │
│                      │           │ Plan: ...                    │
│ 2026-06-29           │           │ Changes:                     │
│ Session 16: ...      │──link──▶  │ - src/file.js: what changed  │
└──────────────────────┘           │ Build: npm run build → OK    │
                                    │   (543ms, no errors)         │
                                    │                              │
                                    │ ## Session 16                │
                                    │ Prompt: ...                  │
                                    │ ...                          │
                                    └──────────────────────────────┘
```

The bitácora is the map. The logs are the territory. Read the bitácora first to find the relevant session, then open the detailed log for full context.

### 3.3 Session Log Lifecycle

**BEFORE the first change of a session:**
1. Run `git diff --stat` and `git diff` to capture the clean state.
2. Create `docs/logs/YYYY-MM-DD.md` if it does not exist.
3. Add a new `## Session N — Descriptive title` section.
4. Write `### Prompt` (1-2 sentences summarising the user's request).
5. Write `### Plan` (numbered list of what will be done, copied from the approved plan).

**AFTER EVERY BUILD** (immediately after `npm run build`, `npm run update`, or any compile command):
1. Capture the full build output: success/failure, time, errors, warnings.
2. Run `git diff --stat` and `git diff` to identify all files modified since the initial snapshot.
3. Check if there is an active session (a section with `### Prompt` + `### Plan` but missing `### Changes` or `### Build`):
   - **Active session found** → Fill in `### Changes` (every modified file with path, what changed and why) and `### Build` (command, result, time, any warnings/errors).
   - **No active session** → Create one from scratch: auto-generate `### Prompt` from recent conversation context, write `### Changes` from `git diff`, write `### Build` with the command output.
4. Update `docs/bitacora.md` with a summary entry (date, session name, prompt in 1 line, plan in 1 line).
5. Reset the initial snapshot with `git diff --stat` so the next build captures only new changes.

**Rules:**
- No exceptions: this check runs after EVERY build, whether or not a prior session exists.
- If `git diff` shows no changes, state this explicitly in `### Changes`.
- Never leave a session section incomplete. Every session must close with `### Changes` and `### Build`.

### 3.4 Bitácora Format

```
### Session N: Short title
**Prompt:** One line summarising what the user asked.
**Plan:** One line summarising the approach taken.
```

The bitácora entry is written AFTER the session log is complete. Its purpose is to make the full history scannable in 30 seconds.

---

## 4. Bug Tracking Protocol

All bugs live in `spec/constitution/bugs.md`. The protocol is:

### 4.1 Detection

Bugs are detected in two ways:
- **Automatic:** Running the test suite (`run-all.ps1`) auto-saves findings to bugs.md.
- **Manual:** The agent reviews the `[MANUAL]` section in the test output for deep logic bugs (stale fallback text, undetected layout issues, etc.).

### 4.2 Documentation

Every bug entry must include:
- Severity (HIGH / MEDIUM / LOW)
- File: path and line number
- Detection source (which test or manual review)
- Description of the bug
- Proposed fix
- Status (`🔴 Sin arreglar` → `✅ Arreglado` or `🟡 Parcialmente arreglado`)

### 4.3 Fix Cycle

1. Detect and document the bug in bugs.md.
2. Propose a fix plan to the user.
3. Wait for approval.
4. Apply the fix.
5. Build + run tests to verify.
6. Update bugs.md: move the entry to `✅ Arreglado`, add the date, session number, and commit hash.

### 4.4 Never Lose a Bug

- If a bug is detected but not fixed in the same session, it remains documented in bugs.md.
- The next `run-all.ps1` run will re-verify it as a regression (if covered by a test).
- The `[MANUAL]` section of the test output reminds the agent to check known bugs.

---

## 5. Testing Protocol

- **"Run the tests"** — Execute `.agents/tests/run-all.ps1` (or equivalent master runner).
- The test suite runs sequentially through all test modules.
- Each check prints PASS / FAIL / WARN.
- At the end, the runner prints:
  - A summary table (total PASS / FAIL / WARN per module)
  - An action plan for each FAIL and WARN
  - A `[MANUAL]` section with items the agent must review by hand
  - Auto-saves all findings to `spec/constitution/bugs.md`
- The agent must:
  1. Read the full output.
  2. Address every FAIL immediately (they are mechanical bugs).
  3. Review every WARN to decide if it is a real bug or intentional/non-bug.
  4. Execute the `[MANUAL]` review items (verifying data flow, static fallback freshness, regression checks, etc.).
  5. Document any findings in bugs.md.
  6. Propose fixes only after documenting. Never apply automatic fixes without approval.

### Expected Test States

| State | Meaning | Action |
|-------|---------|--------|
| PASS | Check passed | None |
| FAIL | Mechanical bug detected | Fix immediately after documenting |
| WARN | Potential concern | Review manually; decide if real bug or intentional |

---

## 6. Commit Protocol

- **Do not commit unless explicitly asked by the user.**
- When asked to commit:
  1. Run `git status` and `git diff --stat` to see all changes.
  2. Stage only intended files (`git add -A` is safe if all changes are intended).
  3. Write a descriptive commit message with sections:
     ```
     type: short summary (max 72 chars)
     
     Detailed description organised by section:
     
     Section one (e.g. "Nav refactor"):
       - file1.js: specific change 1
       - file2.css: specific change 2
     
     Section two:
       - file3.js: specific change
     
     Fixes: #bug-ref if applicable
     ```
  4. Push (`git push`).
  5. Confirm to the user that the commit was pushed successfully (commit hash + branch).

---

## 7. Language Policy

| Scope | Language |
|-------|----------|
| AI documentation (`AGENTS.md`, `spec/`, `.agents/tests/`, `docs/bitacora.md`) | English |
| Session logs (`docs/logs/`) | Original conversation language (preserve the chat language) |
| Source code (comments, variables, UI strings) | Per project conventions |
| New files created in `spec/`, `.agents/tests/`, `docs/bitacora.md` | English |

The session log preserves the original chat language so the user can re-read it naturally. All AI-facing documentation is in English so any AI agent (regardless of its training language) can interpret it.

---

## 8. Context Recovery

When the user asks about or references work from previous sessions:

1. **Scan `docs/bitacora.md`** — Read the full file to find the relevant date and session title.
2. **Open the detailed log** — Navigate to `docs/logs/YYYY-MM-DD.md` and read the session section.
3. **Cross-reference bugs** — Check `spec/constitution/bugs.md` to see if the issue was fixed or is still open.
4. **Only then respond** — Do not invent details from memory if the information is not in the current context window.

This is mandatory even if you think you remember the session. Always verify from the written record.

---

## 9. Quality Gates

A task is not complete until ALL of the following are true:

- [ ] **Build clean** — `npm run build` (or equivalent) succeeds with no errors. Any warnings are documented.
- [ ] **Tests pass** — `run-all.ps1` shows 0 FAIL. Any WARNs are reviewed and either documented as non-bugs or filed in bugs.md.
- [ ] **Session logged** — `docs/logs/YYYY-MM-DD.md` has a complete entry with Prompt, Plan, Changes, and Build.
- [ ] **Bitácora updated** — `docs/bitacora.md` has a summary entry for the session.
- [ ] **Initial snapshot reset** — `git diff --stat` has been re-run to prepare for the next session.
- [ ] **Bugs documented** — Any bugs found are in bugs.md, either as fixed (✅) or open (🔴).

Do not start a new task while the current task is in an unclosed state (missing log, uncommitted build, unfiled bug).
