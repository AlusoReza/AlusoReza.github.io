# 09 — Accessibility

## Purpose

Ensure the portfolio is usable by people with motion sensitivities.

## prefers-reduced-motion

### CSS
```css
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        transition-duration: 0.01ms !important;
        animation-duration: 0.01ms !important;
    }
    .reveal {
        opacity: 1;
        transform: none;
        transition: none;
    }
}
```

Recommended WCAG pattern: the universal `!important` is intentional and necessary to override all transitions.

### JavaScript
```javascript
const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;

if (motionOK) {
  window.addEventListener('scroll', reveal);
} else {
  document.querySelectorAll('.reveal').forEach(el => el.classList.add('active'));
}
```

If the user has `prefers-reduced-motion` enabled:
- The scroll event listener is not registered → zero animations.
- All `.reveal` elements are immediately visible.

## Rules
- **Do not remove `!important`** in the `prefers-reduced-motion` block — it's required for specificity.
- **Do not add `!important` outside** that block.
- The JS must respect the same media query as the CSS.

## Relevant code
- `src/styles/global.css:782-792` — prefers-reduced-motion CSS block
- `src/scripts/client.js:114-120` — JS detection + conditional scroll
