# 14 — Bug tracking system

## Purpose

Defines the portfolio's bug documentation and tracking system. Bugs are recorded in `spec/constitution/bugs.md` BEFORE being fixed, ensuring that no finding is lost between sessions.

## Bug file

**Location:** `spec/constitution/bugs.md`

**Structure:**
```markdown
# Known bugs — Alonso Suárez Reza Portfolio
Last scan: YYYY-MM-DD (Session N)
Total: X FAIL(s), Y WARN(s)

## 🔴 Not fixed
### [Bug title] — SEVERITY
- **File:** `path/file:line`
- **Source:** [script that detected it]
- **Detected:** Session N
- **Description:** [bug explanation, why it occurs, impact]
- **Proposed fix:** [how to fix it]
- **Status:** ⏳ Pending / 🔄 In progress

## 🟡 Partially fixed
### [Title] — SEVERITY
- [same fields + note on what's missing]

## ✅ Fixed
### [Title] — SEVERITY
- **File:** `path/file:line`
- **Detected:** Session N
- **Fixed:** Session N (commit abc1234)
- **Description:** [explanation]
- **Fix applied:** [what was changed]
```

## Bug lifecycle

```
1. DETECT
   - Automated tests (run-all.ps1) identify mechanical bugs
   - [MANUAL] review identifies deep logic bugs
        │
2. DOCUMENT (BEFORE fixing)
   - run-all.ps1 saves FAILs and WARNs to bugs.md under 🔴 Not fixed
   - Manual bugs are added by the agent in the same format
        │
3. DECIDE
   - The user decides whether to fix now or leave it for another session
   - If fixed → go to step 4
   - If not → the bug remains documented for future sessions
        │
4. FIX
   - Agent proposes plan, user approves
   - Fix is applied
   - Build + run-all.ps1 to verify
        │
5. UPDATE bugs.md
   - Move entry from 🔴 Not fixed → ✅ Fixed
   - Add session and commit hash
   - If the fix is partial → move to 🟡 Partially fixed
        │
6. REGRESSION
   - On the next run-all.ps1, bugs marked as ✅ are re-verified
   - If they reappear, move back to 🔴 Not fixed
```

## Rules

- **Document before fixing.** No fix is applied without the bug being registered in `bugs.md`.
- **Every bug has a status.** It cannot go from detected to fixed without going through documented.
- **Automatic regression.** The `run-all.ps1` tests cover all known bugs. If a fixed bug reappears, the test will detect it.
- **Bugs don't expire.** Even if not fixed for months, they remain documented. The most recent scan updates their status in `Last scan`.

## Dependencies

- [Feature 11](11-testing-mcp.md) — MCP Tests (run-all.ps1 is the entry point)
- [Feature 12](12-testing-design.md) — Design tests
- [Feature 13](13-logging-system.md) — Session logging (each fix is recorded in the session log)
