# 14 · Bug tracking

**Status:** implemented ✅

## What it does

Defines the portfolio's bug documentation and tracking system. All bugs are recorded in `spec/constitution/bugs.md` BEFORE being fixed, ensuring no finding is lost between sessions.

### Bug file format
```
## 🔴 Not fixed
### [Title] — SEVERITY
- **File:** `path/file:line`
- **Source:** [detection script]
- **Detected:** Session N
- **Description:** [explanation + impact]
- **Proposed fix:** [how to fix]
- **Status:** ⏳ Pending

## 🟡 Partially fixed
... (same format + note on what's missing)

## ✅ Fixed
### [Title] — SEVERITY
- **File:** `path/file:line`
- **Detected:** Session N
- **Fixed:** Session N (commit abc1234)
- **Description:** [explanation]
- **Fix applied:** [what was changed]
```

### Lifecycle
```
DETECT → DOCUMENT (before fixing) → DECIDE (fix now or later)
→ FIX (if approved) → UPDATE bugs.md → REGRESSION (next run-all.ps1)
```

## Why

AI sessions are stateless. If a bug is found but not fixed immediately, it would be lost between sessions. The `bugs.md` file acts as persistent memory. The "document before fixing" rule ensures no fix happens without an audit trail.

## Acceptance criteria

- [ ] Every finding from `run-all.ps1` is saved to `bugs.md` before any fix.
- [ ] Each bug entry has: file/line, source, session, description, proposed fix, status.
- [ ] Fixed bugs include the session and commit hash where they were fixed.
- [ ] The most recent scan date is updated in the `Last scan` line.
- [ ] `run-all.ps1` re-verifies fixed bugs for regression.

## Out of scope

- Bug priority automation — severity is set manually (HIGH / MEDIUM / LOW).
- Integration with external issue trackers — `bugs.md` is the single source of truth.
