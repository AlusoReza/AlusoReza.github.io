# Frontend decisions — Alonso Suarez Reza Portfolio

Visual and design decisions in `global.css`, `*.astro` components, and related client-side rendering. Each entry documents what was decided, why, what visual problem it solves, and what happens if reverted. Cross-references to `code-decisions.md` when a visual decision has a technical counterpart.

**Rule:** One entry per major page section/component. Each entry is updated in-place as decisions evolve. New alternatives and rationale are added to the existing entry, not as new entries.

## 1. Design system & tokens
- **Location:** visual: `global.css` `@theme` (L13-25) + `:root` (L27-51) / component: `BaseLayout.astro` (Google Fonts)
- **Technical:** Tailwind CSS v4 `@theme` block + CSS custom properties, `--font-display`, `--font-body`, `--color-accent`, `--sidebar-fade`
- **Related code decision:** #12 — `data-data` attribute (all data flows through this)
- **Session:** 2, 3, 6, 20, 37
- **Current appearance:** Deep navy bg (`#0a1527`), teal accent (`#64ffda`), Space Grotesk display + Inter body, semantic color system with accent-muted for hover states.
- **Key decisions:**
  - Palette shifted from GitHub dark (`#0d1117`, blue `#7fc1fe`) to deeper navy + teal (Session 37) — reads more distinctive, less "template"
  - JetBrains Mono rejected — tiring in paragraphs
  - system-ui rejected — too generic
  - Emojis removed from headings — unprofessional noise
  - All hardcoded `#ffffff` migrated to `var(--color-text-bright)` — theme consistency
  - Dual definition: `@theme` (Tailwind CSS v4) + `:root` (CSS fallback) — ensures compatibility
- **Rejected alternatives:** `#58a6ff` (generic GitHub), JetBrains Mono (tiring), system-ui (generic), keeping emojis
- **Revert consequence:** Loses entire color/typography identity. Page reverts to generic GitHub dark look.

## 2. Sidebar & responsive layout
- **Location:** visual: `global.css` L461-501 (sidebar rules) / component: `BaseLayout.astro` sidebar markup
- **Technical:** `--sidebar-fade` clamp, `sidebar-midpoint-mode`, `@keyframes sidebar-entrance`, CSS variable padding system
- **Related code decisions:** #1 (sidebar flash), #2 (1235px alignment), #7 (midpoint mode), #11 (clamp→JS handoff), #17 (keyframes)
- **Session:** 20-31, 36, 40, 46-50, 85-87, 98-100, 104, 124
- **Current appearance:** Fluid sidebar `clamp(240px, 23vw, 320px)` that fades to 0 over 100px before 1235px breakpoint. Inner wrapper 60px wider with gradient mask. Content area with CSS variable padding system.
- **Key decisions:**
  - CSS `clamp()` over JS ResizeObserver — simpler, no JS overhead
  - 1235px breakpoint derived from CV button natural width — not arbitrary
  - Sidebar width fades with opacity simultaneously via `calc(var(--sidebar-width) * var(--sidebar-fade))` — no content jump
  - Gradient mask (`mask-image: linear-gradient`) over content compression — content doesn't shrink
  - `@keyframes sidebar-entrance` over CSS transitions — `is-resizing` blocks CSS transitions, animations bypass this
  - Midpoint mode (~140 lines duplication) — handles 1236-1285px dead zone where sidebar nearly invisible
  - Content padding via CSS custom properties (`--content-pad-*`) — user controls layout from `:root`
- **Rejected alternatives:** JS compact mode (overcomplicated), fixed breakpoints (too narrow/wide), abrupt layout switch (visual jump), content compression approach
- **Revert consequence:** Sidebar loses fluid behavior. Breakpoint dead zone returns. Layout jumps on resize.

## 3. Mobile profile
- **Location:** visual: `global.css` L259-436 / component: `MobileProfile.astro`
- **Technical:** `animateMobileProfile()`, `grid-template-rows: 0fr/1fr`, `overflow: hidden`, 3 named timers, FLIP for layout switch
- **Related code decisions:** #3, #4, #5, #6, #8, #9, #13, #14, #16
- **Session:** 51, 54-65, 70-83, 109, 118, 132-133
- **Current appearance:** Photo + name + description + social links above content on mobile. Smooth height animation via `scrollHeight`. 2 states: vertical (narrow) and row (wide). Only visible on "Sobre mi" page.
- **Key decisions:**
  - Grid 0fr/1fr over max-height, clip-path, position toggle — `height: auto` can't transition, grid rows can
  - `overflow: hidden` (not `clip`) — `clip` makes `scrollHeight` unreliable
  - JS-driven height animation over CSS-only — `height: auto → 0` isn't transitionable
  - 3 named timers prevent race conditions — profile flickering and height pops
  - Restricted to about page only — showing on all pages was cluttered
  - FLIP animation for row↔vertical — Y-compensation prevents teleporting
- **Rejected alternatives:** max-height (can't animate to auto), clip-path (complex), Web Animations API (fill issues), CSS-only (no transition), `overflow: clip` (unreliable scrollHeight)
- **Revert consequence:** Profile animation breaks. Race conditions return. Profile shows on wrong pages.

## 4. Navigation & lang-switcher
- **Location:** visual: `global.css` nav/lang-switcher rules / component: `BaseLayout.astro` sidebar nav
- **Technical:** `lang-switcher-delayed` class, `sidebar-locked` timing, `--sidebar-fade` sync
- **Related code decisions:** #8, #9, #15, #18
- **Session:** 16, 17, 19, 36, 40, 128-129, 138
- **Current appearance:** Nav links inside sidebar, lang-switcher fades with sidebar, hamburger morphs to X on mobile, conditional nav links (hidden when data empty).
- **Key decisions:**
  - Lang-switcher inside sidebar (not fixed) — avoids escaping on small screens
  - Synced with `--sidebar-fade` — consistent with sidebar behavior
  - `lang-switcher-delayed` class — prevents pop-in when sidebar appears
  - Conditional links — no dead links when experience/certificates empty
  - Hamburger slide + X morph — standard mobile pattern
- **Rejected alternatives:** Fixed-position lang-switcher (escapes nav), always-visible links (dead links), abrupt show/hide
- **Revert consequence:** Lang-switcher pops in. Nav shows dead links. Hamburger loses animation.

## 5. Scroll-reveal & page transitions
- **Location:** visual: `global.css` L170-199 (`.reveal` rules) / technical: `client.js` IntersectionObserver
- **Technical:** `.reveal` + `.stagger-item` classes, double rAF for page entry, loading spinner
- **Related code decision:** #53 (page entry)
- **Session:** 37-39, 53, 101, 103
- **Current appearance:** Content fades in + slides up on scroll (24px Y, 0.1s ease). Pages slide in from right (40px X). 300ms loading spinner. Perfil title fades with sidebar.
- **Key decisions:**
  - IntersectionObserver over scroll event — performant, no jank
  - `prefers-reduced-motion` globally respected — accessibility
  - Double rAF for page entry — single rAF never renders intermediate state
  - Perfil title fades with sidebar (not scroll-reveal) — follows sidebar-fade, not scroll position
- **Rejected alternatives:** Static content (no entrance animation), single rAF (broken transitions), scroll-linked animations (jank)
- **Revert consequence:** Content appears instantly. No entrance animation. Loading spinner removed.

## 6. Tech grid (About page)
- **Location:** visual: `global.css` L899-928 / technical: `client.js` ResizeObserver
- **Technical:** CSS Grid `repeat(auto-fit, 73px)`, `.tech-item` fixed 76px, 3-state responsive categories
- **Session:** 90-92, 108, 115
- **Current appearance:** Centered grid of 76px tech items with DevIcon logos. Categories flow side-by-side at >=960px, stack below. No animation (5 approaches archived).
- **Key decisions:**
  - Fixed 76px items over auto-fit expanding — consistent icon size, predictable layout
  - No animation after 5 failed attempts — FLIP, opacity fade, scale pulse all had fundamental issues
  - Categories reorder per breakpoint — Lenguajes → Herramientas → Frameworks
  - Merged About + Skills into single page — eliminates navigation overhead
- **Rejected alternatives:** CSS Grid auto-fit (items expanded), FLIP animation (3 attempts, all buggy), opacity fade (invisible transition), scale pulse (distracting)
- **Revert consequence:** Tech grid reverts to old skills page layout. Loses centered alignment. Animation history lost.

## 7. Education cards — image layout and content differentiation
- **Location:** visual: `global.css` L1174-1221 (card-image rules) / component: `Education.astro`
- **Technical:** `client.js` L90-112 (`renderEducationItem()`), onerror fallback
- **Related code decision:** #12 — `data-data` attribute
- **Session:** 144
- **Current appearance:** Cards with institution image (120x120px) on left, content on right (desktop). Mobile: image on top, content below. Initials fallback if image fails. List items with accent triangle bullets for achievements.
- **Key decisions:**
  - Image+text layout differentiates education from certificates (text-only) — encodes "institution is significant"
  - Same `card-item` base system as certificates — consistency across card types
  - CSS-only placeholders (initials) — no image files needed until user adds real ones
  - onerror fallback: image → initials automatically — graceful degradation
  - List items with accent triangles — content-driven differentiation from certificate tags
  - 120x120px normalized size — consistent across different institution logos
  - Mobile vertical layout — image above content at <650px
- **Rejected alternatives:**
  - 2-column grid — doesn't scale with more entries, compresses content
  - Emoji prefix — academic titles are formal, emojis feel decorative
  - Different accent color — breaks design system consistency
  - Timeline markers — only 2 entries, not a sequence
- **Revert consequence:** Education cards lose image layout. Reverts to text-only cards identical to certificates.

## 8. Card system — shared CSS and progressive collapse
- **Location:** visual: `global.css` L1031-1227 (card-item, card-header, card-title, card-emoji, card-tags, card-date, card-list, card-image)
- **Technical:** CSS flex-wrap with natural-width title as collapse trigger, emoji extraction via regex in `client.js`
- **Related code decision:** #12 — `data-data` attribute
- **Session:** 137-146
- **Current appearance:** Cards with left border accent (0.3), emoji (inline desktop, block above title on mobile), title (`flex: 0 0 auto`, `max-width: 100%`, `overflow-wrap: break-word`), tags (`flex-shrink: 0`), date (`flex-shrink: 0`). Progressive collapse: tags wrap → date wraps → title text wraps (last resort).
- **Key decisions:**
  - Shared `card-item` base for certificates and education — consistency across card types
  - Title `flex: 0 0 auto` — takes natural width, never compresses. Tags and date wrap first.
  - Title `max-width: 100%` + `overflow-wrap: break-word` — text wraps ONLY when container is narrower than title natural width. Absolute last resort.
  - Tags `flex-shrink: 0` — never shrinks, wraps when space runs out (cleaner collapse)
  - Date `flex-shrink: 0` — never shrinks, only wraps when absolutely necessary
  - `flex-wrap: wrap` on header — natural wrap order: tags first, then date, then title text
  - Emoji extracted into `<span class="card-emoji">` — repositioned above title on mobile via `flex-direction: column`
  - `margin-left: 16px` removed from tags/date — `gap: 10px` handles spacing, no extra indentation on wrap
  - Regex `^[\p{Emoji_Presentation}\p{Extended_Pictographic}]*\s*` extracts leading emoji — handles certificates with emojis, gracefully skips those without
- **Rejected alternatives:**
  - 2-column grid — doesn't scale with more entries
  - Fixed breakpoints for collapse — doesn't adapt to title length
  - JavaScript-based detection — overengineered for CSS-native behavior
  - `flex-shrink: 1` on title — allowed compression before tags/date wrapped, wrong priority
  - `flex: 1` on title — grew to fill space but also compressed, defeating immutability
  - `min-width: 120px` threshold — triggered collapse at arbitrary width, not natural wrap
  - `margin-left` on tags/date — created ~25px left margin when wrapped, misaligned content
- **Revert consequence:** Title compresses instead of wrapping tags/date. Text wraps prematurely. Emoji stays inline on mobile. Wrapped content has left indentation.
