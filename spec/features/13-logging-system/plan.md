# 13 · Logging system — Plan

## Approach

Build-driven: every `npm run build` (or `npm run update`) triggers a mandatory log review. The agent captures the build output, diffs changes, and records the session.

## Implementation

1. **Before first change:** Run `git diff --stat` → write output to variable. This is the "initial snapshot".
2. **After every build:** Capture full build output (stdout, stderr, exit code, timestamp).
3. **Diff detection:** Run `git diff --stat` and `git diff` → identify all changed files.
4. **Session check:** Open `docs/logs/YYYY-MM-DD.md`. If a session with `### Prompt` and `### Plan` exists but lacks `### Changes` or `### Build`, complete it. Otherwise, create a new session entry.
5. **Bitacora update:** Append a one-line summary to `docs/bitacora.md`.
6. **Snapshot reset:** Run `git diff --stat` again (the new baseline for the next build).

## Decisions

- **Build-driven over time-driven** — Compilation is a natural checkpoint. "After every build" is unambiguous and tied to meaningful work.
- **git diff over manual tracking** — Automatic diff detection prevents missed files. Manual tracking would be error-prone.
- **Daily files over a single file** — `docs/logs/2026-06-25.md` keeps files small and scannable. The bitacora provides the cross-day view.

## Risks

- **Build fails** — Even a failed build should trigger logging (the failure itself is notable).
- **No changes detected** — The log should state "No changes" explicitly so it's clear the build was a no-op.
