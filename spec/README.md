# SDD Metaspec — Alonso Suárez Reza Portfolio

This directory contains the formal specification of the project following **Specification-Driven Development (SDD)** principles.

## Structure

```
spec/
├── README.md                ← This file — metaspec entry point
├── constitution/            ← Stable project rules (change infrequently)
│   ├── mission.md           ← What we build, for whom, principles
│   ├── tech-stack.md        ← Technologies, conventions, design, limits
│   ├── roadmap.md           ← Feature status: done / next / backlog
│   ├── changelog.md         ← Historical record of sessions
│   └── bugs.md              ← Known bugs and lifecycle tracking
├── features/                ← One folder per feature (NNN-name/)
│   └── NNN-name/
│       ├── spec.md          ← What it does + acceptance criteria
│       ├── plan.md          ← How it's implemented (decisions, risks)
│       └── tasks.md         ← Actionable checklist
├── glossary.md              ← Domain definitions
└── template/                ← Reusable templates for new specs
    ├── AGENTS_TEMPLATE.md
    └── spec_template/       ← Canonical SDD template
```

## Conventions

- **Only write code after the spec.** Each feature goes through spec → plan → tasks → code.
- **The constitution governs all features.** If a feature conflicts with `mission.md` or `tech-stack.md`, the feature is re-evaluated, not the constitution.
- **Root content** (`AGENTS.md`, `README.md`) keeps a minimal operational version; specs contain canonical and expanded documentation.

## How to read this spec

1. **Glossary** (`spec/glossary.md`) if you find an unknown term.
2. **Mission** (`spec/constitution/mission.md`) for the project's purpose.
3. **Tech stack** (`spec/constitution/tech-stack.md`) for technologies and conventions.
4. **Features** (`spec/features/`) in numerical order for specific area details.
