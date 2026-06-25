# 13 — Logging system

## Purpose

Defines the build-driven logging protocol that ensures all work sessions are automatically recorded.

## Protocolo

### Before — Initial snapshot
Before the first change of the session:
```powershell
git diff --stat
git diff
```
The output is saved as a reference of the initial clean state.

### After every build
Immediately after `npm run build`, `npm run update` or any command that compiles:

1. Capture the full build output (success/failure, time, errors, warnings).
2. Run `git diff --stat` and `git diff` to identify all modified files.
3. Check `docs/logs/YYYY-MM-DD.md`:
   - **Is there an active session?** (has `### Prompt` and `### Plan` but is missing `### Changes` or `### Build`)
     - Complete: fill in `### Changes` + `### Build`
   - **Is there NO active session?** (build without a prior session created)
     - Create new session: auto-generate `### Prompt` from recent context, write `### Changes` from git diff, and `### Build`
4. Update `docs/bitacora.md` with a summary entry.
5. Reset initial snapshot with `git diff --stat` (next build only captures new changes).

### Session structure

```markdown
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

### Log files
- `docs/logs/YYYY-MM-DD.md` — detailed sessions by day. One file per date.
- `docs/bitacora.md` — scannable global summary with links to daily logs.

## Rules
- **No exceptions.** The check runs after EVERY build.
- If no changes detected by git diff, state explicitly in `### Changes`.
- Historical context: if the user asks about work from previous sessions, scan `docs/logs/` and `docs/bitacora.md`.

## Relevant code
- `docs/bitacora.md` — global summary
- `docs/logs/2026-06-25.md` — today's logs
- `AGENTS.md` — defined build-driven workflow
