# 09 · Accessibility — Plan

## Approach

Detect `prefers-reduced-motion` in both CSS and JS. CSS handles all transition/animation suppression. JS conditionally registers the scroll reveal listener — no listener = no animations.

## Implementation

1. **CSS** — Universal `!important` override inside `@media (prefers-reduced-motion: reduce)`. `.reveal` reset (opacity 1, transform none, transition none).
2. **JavaScript** — `window.matchMedia('(prefers-reduced-motion: reduce)')` check. Store result in `motionOK` constant (evaluated once at load).
3. **Conditional scroll** — If `motionOK` is false, reveal all elements immediately and never register the scroll listener.

## Decisions

- **Universal `!important` override** — WCAG recommends this pattern. Individual selectors would be unreliable because a new animation could be added without the corresponding override. The `!important` ensures all motion is suppressed.
- **JS mirrors CSS** — Both layers check the same media query. CSS handles CSS transitions/animations, JS handles scroll-listeners. No gap between what CSS and JS suppress.
- **`motionOK` as constant** — Evaluated once at load, not re-evaluated on every scroll or language switch. The user's preference doesn't change during a session.

## Risks

- **`!important` outside reduced-motion block** — Currently enforced by tests (`check-frontend-design.ps1` check #3). Any new `!important` outside the block would violate the rule.
- **.reveal elements added dynamically** — After language switch, new `.reveal` elements may be added. The `requestAnimationFrame(() => reveal())` at the end of `changeLanguage()` handles re-triggering.
