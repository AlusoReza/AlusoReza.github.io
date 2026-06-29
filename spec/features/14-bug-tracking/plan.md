# 14 · Bug tracking — Plan

## Approach

A single markdown file (`bugs.md`) under constitution serves as the persistent bug database. Automated tests write to it; the agent manages entries with manual review.

## Implementation

1. **Automated detection:** `run-all.ps1` appends findings to `bugs.md` under `🔴 Not fixed`. Each finding includes source, description, severity.
2. **Manual detection:** The agent adds `[MANUAL]` bugs in the same format for deep logic issues that tests can't catch.
3. **Fix flow:** User approves → fix applied → build + tests verify → agent moves entry to `✅ Fixed` with session and commit hash.
4. **Partial fixes:** Moved to `🟡 Partially fixed` with a note on remaining work.
5. **Regression:** Next `run-all.ps1` run checks all bugs. If a "fixed" bug reappears, it moves back to `🔴 Not fixed`.

## Decisions

- **Markdown over JSON/YAML** — Readable and editable by humans without special tools. Tests append to it programmatically.
- **Single file over per-bug files** — All bugs in one file is simpler for scanning. The `Last scan` header and section organization keep it navigable.
- **Three-state system (🔴🟡✅)** — Covers the full lifecycle: unfixed, partially fixed, fixed. No "won't fix" state (bugs don't expire).

## Risks

- **File bloat** — If hundreds of bugs accumulate, the file becomes unwieldy. Mitigated by the `Last scan` filter: only meaningful bugs (not every test run) are kept.
- **Merge conflicts** — If two sessions add bugs simultaneously, manual merge may be needed. Low risk (single developer).
