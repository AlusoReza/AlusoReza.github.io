# SDD Metaspec — Alonso Suárez Reza Portfolio

This directory contains the formal specification of the project following **Specification-Driven Development (SDD)** principles.

## Structure

```
spec/
├── constitution/      — Metadocs: overview, roadmap, changelog, bugs, agent instructions
├── features/          — Detailed specifications for each feature (01 to 14)
├── template/          — Reusable templates for writing new specs
└── glossary.md        — Domain definitions
```

## Conventions

- Each feature in `features/` is numbered (`01-name.md`) to establish reading order.
- Specs are written in plain markdown, no external tools.
- Root content (`AGENTS.md`, `README.md`) keeps a minimal operational version; specs contain canonical and expanded documentation.

## How to read this spec

1. **Glossary** (`spec/glossary.md`) if you find an unknown term.
2. **Project overview** (`spec/constitution/project-overview.md`) for general vision.
3. **Agent instructions** (`spec/constitution/agent-instructions.md`) if you are an AI agent.
4. **Features** (`spec/features/`) in numerical order to dive into specific areas.
