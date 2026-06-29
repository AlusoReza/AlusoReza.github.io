# 13 · Logging system

**Status:** implemented ✅

## What it does

Defines the build-driven logging protocol that ensures all work sessions are automatically recorded in `docs/logs/` with a global summary in `docs/bitacora.md`.

### Protocol
1. **Before — initial snapshot:** Run `git diff --stat` and `git diff` to capture clean state.
2. **After every build:** Capture build output → run `git diff --stat` → check `docs/logs/YYYY-MM-DD.md` → complete or create session → update `docs/bitacora.md` → reset snapshot.

### Session structure
```
## Session N — Descriptive title

### Prompt
Summary of what the user requested.

### Plan
Agreed steps (if applicable).

### Changes
List of modified files with paths, lines and brief description.

### Build
Command executed, result, time, relevant warnings/errors.
```

## Why

Without enforced logging, work done by AI agents disappears between sessions. The build-driven approach ties logging to a natural checkpoint (compilation), ensuring no session goes unrecorded.

## Acceptance criteria

- [ ] Every build triggers a logging review.
- [ ] `docs/logs/YYYY-MM-DD.md` exists for each active day.
- [ ] `docs/bitacora.md` contains summary entries with links to daily logs.
- [ ] If no changes detected by `git diff`, the log explicitly states it.
- [ ] Historical context requests scan `docs/logs/` and `docs/bitacora.md`.

## Out of scope

- Automated changelog generation from git history — sessions are written manually.
- CI/CD integration — logging is agent-driven, not pipeline-driven.
