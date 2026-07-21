# Archived: Tech Grid Transitions

**Status:** Rejected (2026-07-21)  
**Context:** Smooth transitions for tech grid cards during window resize (column reflow)

---

## Problem

When resizing the browser window, `.tech-item` cards reflow between rows/columns as the grid layout changes (≥960px: 3 columns, 640-959px: 2 columns, <640px: 1 column). This creates a visual jump that feels jarring.

---

## Timeline

| Commit | Session | What | Why it failed |
|--------|---------|------|---------------|
| `cdac741` | 102 | Initial FLIP: `storedRects` + `flipAnimate()` + `data-flip` on items | Performance issues with 31 items, vertigo effect |
| `5025473` | 105-106 | FLIP refactored to animate categories only → then full removal | **"Vertigo effect"** — 31 items animating simultaneously |
| `696a9b2` | 110 | "flip-lite": `captureTechCardPositions()` + `matchMedia` breakpoints | Abandoned — same complexity, same fundamental problems |
| `3c7e94c` | 111 | Opacity fade → scale pulse → archive | "Ghost effect" / "artificial" |

---

## Approaches tried

### 1. FLIP animation — Session 102 (commit `cdac741`)

**What:** Position-based animation using `getBoundingClientRect()` to smoothly transition items from old positions to new positions. Initial implementation with `data-flip` attributes on all `.tech-item` elements.

**Code (removed from `src/scripts/client.js`):**
```js
const storedRects = new Map()

function flipAnimate(container) {
  if (!motionOK) return
  const targets = container.querySelectorAll('[data-flip]')
  if (!targets.length) return

  if (storedRects.size === 0) {
    targets.forEach(el => storedRects.set(el, el.getBoundingClientRect()))
    return
  }

  const newRects = new Map()
  targets.forEach(el => newRects.set(el, el.getBoundingClientRect()))

  targets.forEach(el => {
    const oldRect = storedRects.get(el)
    const newRect = newRects.get(el)
    if (!oldRect || !newRect) return
    const dx = oldRect.left - newRect.left
    const dy = oldRect.top - newRect.top
    if (dx === 0 && dy === 0) return

    el.style.transform = `translate(${dx}px, ${dy}px)`
    el.style.transition = 'none'
  })

  container.getBoundingClientRect()

  targets.forEach(el => {
    if (el.style.transform) {
      el.style.transition = 'transform 0.3s ease'
      el.style.transform = ''
    }
  })

  targets.forEach(el => storedRects.set(el, newRects.get(el)))
}

const techShowcase = document.querySelector('.tech-showcase')
let techFlipTimer = null
if (techShowcase) {
  const techObserver = new ResizeObserver(() => {
    clearTimeout(techFlipTimer)
    techFlipTimer = setTimeout(() => flipAnimate(techShowcase), 60)
  })
  techObserver.observe(techShowcase)
}
```

**Why rejected:**
1. **Vertigo effect** (Session 106): 31 items animating positions simultaneously created visual chaos
2. **Race conditions**: Rapid resize caused FLIP animations to stack and overlap
3. **Performance**: 31× `getBoundingClientRect()` + 31× `style.transform` per resize event
4. **Required `data-flip` attributes**: Added HTML complexity for a marginal visual effect

---

### 2. FLIP refactored to categories only — Session 105 (commit `5025473`)

**What:** Removed `data-flip` from individual items, attempted to FLIP only the `.tech-category` containers (3 elements instead of 31).

**Why rejected:** Even category-level FLIP caused vertigo. The categories contain inner grids that reflow independently — animating the category container doesn't capture the internal card movement. Session 106 removed ALL FLIP code.

**Session 106 changes:**
- Removed `data-flip` from `.tech-category` in `About.astro`
- Removed `reveal` from `.tech-showcase` (caused vertigo effect)
- Removed entire FLIP block: `storedRects`, `flipAnimate()`, `techFlipTimer`, `techObserver` (~50 lines)
- Removed `storedRects.clear()` from `navigateTo()`
- Removed `document.querySelectorAll('[data-flip]').forEach(...)` from `initScrollReveal()`

---

### 3. FLIP-lite — Session 110 (commit `696a9b2`)

**What:** Simplified FLIP using `matchMedia` breakpoint detection + `captureTechCardPositions()` + 1000ms debounce. Attempted to capture positions at resize start (before reflow) using `window.addEventListener('resize', ...)`.

**Code (removed from `src/scripts/client.js`):**
```js
// --- FLIP animation for tech cards on resize ---
let techCardPositions = new Map()

function captureTechCardPositions() {
  techCardPositions.clear()
  document.querySelectorAll('.tech-item').forEach(el => {
    techCardPositions.set(el, el.getBoundingClientRect())
  })
}

function flipTechCards() {
  if (!motionOK || !techCardPositions.size) {
    techCardPositions.clear()
    return
  }
  document.querySelectorAll('.tech-item').forEach(el => {
    const oldRect = techCardPositions.get(el)
    if (!oldRect) return
    const newRect = el.getBoundingClientRect()
    const dx = oldRect.left - newRect.left
    const dy = oldRect.top - newRect.top
    if (dx === 0 && dy === 0) return

    el.setAttribute('data-flip', '')
    el.style.transform = `translate(${dx}px, ${dy}px)`
    el.style.transition = 'none'
    el.addEventListener('transitionend', function handler() {
      el.removeEventListener('transitionend', handler)
      el.removeAttribute('data-flip')
      el.style.transition = ''
      el.style.transform = ''
    }, { once: true })
  })

  // Force reflow
  document.body.offsetHeight

  // Animate to final positions
  document.querySelectorAll('.tech-item[data-flip]').forEach(el => {
    el.style.transition = 'transform 0.3s ease-out'
    el.style.transform = ''
  })

  techCardPositions.clear()
}

// Trigger FLIP at known breakpoints
window.matchMedia('(min-width: 960px)').addEventListener('change', () => {
  captureTechCardPositions()
  setTimeout(flipTechCards, 1000)
})
window.matchMedia('(min-width: 640px)').addEventListener('change', () => {
  captureTechCardPositions()
  setTimeout(flipTechCards, 1000)
})
```

**Why rejected:**
1. **Same fundamental problem**: `window.addEventListener('resize')` fires AFTER reflow — positions are already new
2. **matchMedia only helps with breakpoints**: Doesn't solve the pre-capture problem for continuous resize
3. **1000ms debounce too slow**: Users see the jump, then FLIP plays after a full second
4. **Same 31-item performance issue**: `querySelectorAll('.tech-item').forEach()` × 2 per breakpoint change
5. **Abandoned as WIP**: Never reached a working state

---

### 4. Opacity fade (CSS + JS) — Session 111

**What:** Items fade to 0.2-0.5 opacity during column reflow, fade back to 1 after debounce. Used `getColCount()` / `getSignature()` to only trigger on actual column count changes.

**Code (removed from `src/styles/global.css`):**
```css
.tech-item {
  transition: opacity 0.2s ease-in, border-color 0.25s ease, background-color 0.25s ease;
}

.tech-showcase.is-resizing .tech-item {
  opacity: 0.5;
  transition: opacity 0.12s ease-out;
}

@media (prefers-reduced-motion: reduce) {
  .tech-showcase.is-resizing .tech-item {
    opacity: 1;
    transition: none;
  }
}
```

**Code (removed from `src/scripts/client.js`):**
```js
const techShowcase = document.querySelector('.tech-showcase')
let techFadeTimer = null
let lastSignature = ''
if (techShowcase) {
  const grids = techShowcase.querySelectorAll('.tech-grid')
  function getColCount(grid) {
    const items = grid.children
    if (items.length < 2) return items.length
    const firstTop = items[0].offsetTop
    let count = 1
    for (let i = 1; i < items.length; i++) {
      if (items[i].offsetTop === firstTop) count++
      else break
    }
    return count
  }
  function getSignature() {
    return Array.from(grids).map(g => getColCount(g)).join(',')
  }
  lastSignature = getSignature()
  const techObserver = new ResizeObserver(() => {
    const sig = getSignature()
    if (sig !== lastSignature) {
      lastSignature = sig
      techShowcase.classList.add('is-resizing')
      clearTimeout(techFadeTimer)
      techFadeTimer = setTimeout(() => {
        techShowcase.classList.remove('is-resizing')
      }, 120)
    }
  })
  techObserver.observe(techShowcase)
}
```

**Why rejected:** "Ghost effect" — items become transparent and reappear in new positions without spatial relationship. Felt like decoration, not function. The opacity fade doesn't communicate *why* items are moving, it just hides the movement.

---

### 5. Scale pulse (CSS) — Session 111

**What:** `.tech-showcase` scales to 0.98 during reflow (60ms), creating a subtle "breathing" effect.

**Code (removed from `src/styles/global.css`):**
```css
.tech-showcase {
  transition: transform 0.06s ease-out;
}

.tech-showcase.is-resizing {
  transform: scale(0.98);
}

@media (prefers-reduced-motion: reduce) {
  .tech-showcase.is-resizing {
    transform: none;
    transition: none;
  }
}
```

**Why rejected:** Still felt artificial. No organic connection to the reflow. The scale affects the entire grid container, not individual items, so it doesn't communicate which items are moving.

---

## Technical reference: Column count detection

The `getColCount()` / `getSignature()` approach is reusable for future features:

```js
function getColCount(grid) {
  const items = grid.children
  if (items.length < 2) return items.length
  const firstTop = items[0].offsetTop
  let count = 1
  for (let i = 1; i < items.length; i++) {
    if (items[i].offsetTop === firstTop) count++
    else break
  }
  return count
}

function getSignature() {
  return Array.from(grids).map(g => getColCount(g)).join(',')
}
// Signature format: "4,3,4" (columns per category: L, H, F)
```

---

## Lessons learned

1. **FLIP requires pre-reflow capture** — `ResizeObserver` fires AFTER reflow, making "before" positions unavailable. The only way to capture pre-reflow positions is `requestAnimationFrame` polling, which is wasteful.
2. **31 items is too many for per-item animation** — Batch approaches (category-level, container-level) don't capture the internal card movement.
3. **matchMedia helps with breakpoints but not continuous resize** — It only fires at exact breakpoint crossings, not during the resize gesture.
4. **System behaviors don't need animation** — Layout shift from window resize is expected behavior. Animating it draws attention to mechanics rather than content.
5. **Column count detection is reusable** — The `getColCount()`/`getSignature()` pattern works for detecting reflow without hardcoding viewport widths.

---

## Future ideas

- **Container queries** for per-category responsive behavior (each `.tech-category` could have its own breakpoint logic)
- **Staggered reveal** on initial page load (not resize) — items fade in with micro-delays
- **Intersection Observer** based animations for scroll-triggered reveals (already implemented via `.reveal` class)
- **FLIP with `requestAnimationFrame`** — Only if a future feature genuinely needs smooth position transitions (e.g., drag-and-drop reordering). Not worth it for resize.

---

## Decision rationale

The grid reflow is a **system behavior** (user resized the window), not a **content moment**. Animating system behaviors draws attention to the mechanics rather than the content. For a developer portfolio, the most appropriate response is: the layout changes because you asked it to. No decoration needed.

> "sometimes less is more, and extra animation contributes to the feeling that the design is AI-generated"  
> — Frontend Design Skill
