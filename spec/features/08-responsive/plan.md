# 08 · Responsive — Plan

## Approach

Desktop-first base layout with two `@media (max-width: ...)` breakpoints. The desktop layout is the full experience; mobile versions remove or simplify elements that don't fit.

## Implementation

1. **global.css** defines the full desktop layout as the default (no `@media` wrapper).
2. **@media (max-width: 650px)** — profile column, 1-column skills, compressed nav, adjusted hero spacing.
3. **@media (max-width: 480px)** — stacked social buttons, further compressed nav.
4. **LangSwitcher** uses `position: fixed` so it's always accessible on any screen.

## Decisions

- **Desktop-first over mobile-first** — The portfolio is a showcase site, most viewers use desktop. Mobile is the adapted version.
- **650px breakpoint** — Captures iPad portrait (768px) with a margin. Most phones are <=430px, so 650px catches small tablets and large phones.
- **480px breakpoint** — Targets phones <=430px (iPhone, most Androids). At this width, two social buttons side-by-side would be too cramped.
- **`padding-right: 80px` on nav at 650px** — The fixed lang switcher overlaps nav links on small screens. This padding prevents overlap.

## Risks

- **Known bug: lang switcher overflow on very small screens** — On phones < 360px width, the language button may extend outside the viewport. Needs CSS fix (smaller padding/font at 360px breakpoint).
- **Known bug: social buttons width on mobile** — The LinkedIn and GitHub buttons may exceed section width on small screens. Mitigated by `max-width: 280px` at 480px.
