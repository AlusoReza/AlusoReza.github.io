# 09 — Accesibilidad

## Propósito

Garantizar que el portfolio sea utilizable por personas con sensibilidades al movimiento.

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

Patrón WCAG recomendado: el `!important` universal es intencional y necesario para overridear todas las transiciones.

### JavaScript
```javascript
const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;

if (motionOK) {
  window.addEventListener('scroll', reveal);
} else {
  document.querySelectorAll('.reveal').forEach(el => el.classList.add('active'));
}
```

Si el usuario tiene activado `prefers-reduced-motion`:
- No se registra el event listener de scroll → cero animaciones.
- Todos los elementos `.reveal` se muestran inmediatamente visibles.

## Reglas
- **No eliminar el `!important`** en el bloque `prefers-reduced-motion` — es necesario por especificidad.
- **No añadir `!important` fuera** de ese bloque.
- El JS debe respetar la misma media query que el CSS.

## Código relevante
- `src/styles/global.css:782-792` — bloque CSS prefers-reduced-motion
- `src/scripts/client.js:114-120` — detección JS + scroll condicional
