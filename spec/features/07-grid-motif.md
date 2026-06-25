# 07 — Cuadrícula computacional

## Propósito

Firma visual del portfolio: una cuadrícula sutil que evoca papel milimetrado, coordenadas, física computacional y análisis de datos.

## Técnica

La cuadrícula se implementa como `background-image` con dos gradientes lineales sobre la sección `#inicio`:

```css
#inicio {
    background-image:
        linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 28px 28px;
}
```

- **Spacing:** 28px (intencionalmente no redondo, evita parecer una cuadrícula de diseño genérica).
- **Opacidad:** 2% blanco — apenas perceptible, no compite con el contenido.
- **Responsive:** En móvil, `background-size: 20px`.

## Degradado de desvanecimiento

```css
#inicio::after {
    background: linear-gradient(180deg, transparent 60%, var(--color-bg) 100%);
}
```

Esto evita que la cuadrícula se corte abruptamente al final del hero.

## Reglas
- La cuadrícula solo aparece en `#inicio`. No replicar en otras secciones.
- No aumentar la opacidad — el diseño debe ser sutil.

## Código relevante
- `src/styles/global.css:154-178` — implementación completa
