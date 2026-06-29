# 09 · Accessibility — Tasks

- [x] Add `@media (prefers-reduced-motion: reduce)` block with universal `!important` override
- [x] Add `.reveal` reset inside the media query
- [x] Add JavaScript `matchMedia` detection
- [x] Conditional scroll listener registration based on `motionOK`
- [ ] Verify no `!important` declarations outside the reduced-motion block (run `check-frontend-design.ps1`)
- [ ] Test with OS-level reduced motion enabled

## Maintenance

- [ ] When adding a new animation or transition, verify its override exists in `prefers-reduced-motion` block
- [ ] Do NOT add `!important` outside the reduced-motion block
