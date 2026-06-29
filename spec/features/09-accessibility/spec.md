# 09 · Accessibility

**Status:** implemented ✅

## What it does

Ensures the portfolio is usable by people with motion sensitivities. Implements `prefers-reduced-motion` in both CSS and JavaScript.

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
The universal `!important` override is intentional and WCAG-recommended — it's the only reliable way to override all transitions and animations.

### JavaScript
```javascript
const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
if (motionOK) {
  window.addEventListener('scroll', reveal);
} else {
  document.querySelectorAll('.reveal').forEach(el => el.classList.add('active'));
}
```
When reduced motion is enabled: no scroll event listener is registered (zero animations), and all `.reveal` elements are immediately visible.

## Why

Motion animations (scroll-reveal) can cause discomfort for people with vestibular disorders. The portfolio respects system-level accessibility settings.

## Acceptance criteria

- [ ] With `prefers-reduced-motion: reduce` enabled, no CSS transitions or animations run.
- [ ] With `prefers-reduced-motion: reduce` enabled, all `.reveal` elements are immediately visible (no scroll-triggered animation).
- [ ] The only `!important` declarations in the CSS are inside the `prefers-reduced-motion` block.
- [ ] JavaScript respects the same media query as CSS (they are not contradictory).

## Out of scope

- Screen reader-specific ARIA labels — semantic HTML is used where appropriate.
- Keyboard navigation beyond browser defaults.
- Color contrast — the GitHub dark palette provides sufficient contrast ratios by design.
