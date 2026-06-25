# 13 — Sistema de logging

## Propósito

Define el protocolo de logging build-driven que garantiza que todas las sesiones de trabajo queden registradas automáticamente.

## Protocolo

### Before — Snapshot inicial
Antes del primer cambio de la sesión:
```powershell
git diff --stat
git diff
```
El output se guarda como referencia del estado limpio inicial.

### After every build
Inmediatamente después de `npm run build`, `npm run update` o cualquier comando que compile:

1. Capturar el output completo del build (éxito/fallo, tiempo, errors, warnings).
2. Ejecutar `git diff --stat` y `git diff` para identificar todos los archivos modificados.
3. Consultar `docs/logs/YYYY-MM-DD.md`:
   - **¿Hay sesión activa?** (tiene `### Prompt` y `### Plan` pero le falta `### Cambios` o `### Build`)
     - Completar: rellenar `### Cambios` + `### Build`
   - **¿NO hay sesión activa?** (build sin sesión creada previamente)
     - Crear nueva sesión: auto-generar `### Prompt` del contexto reciente, escribir `### Cambios` del git diff, y `### Build`
4. Actualizar `docs/bitacora.md` con entrada resumida.
5. Resetear snapshot inicial con `git diff --stat` (próximo build solo captura cambios nuevos).

### Estructura de sesión

```markdown
## Sesión N — Título descriptivo

### Prompt
Resumen de lo que pidió el usuario.

### Plan
Pasos acordados (si aplica).

### Cambios
Lista de archivos modificados con rutas, líneas y descripción breve.

### Build
Comando ejecutado, resultado, tiempo, warnings/errors relevantes.
```

### Archivos de bitácora
- `docs/logs/YYYY-MM-DD.md` — sesiones detalladas por día. Un archivo por fecha.
- `docs/bitacora.md` — resumen global escaneable con links a los logs diarios.

## Reglas
- **No hay excepciones.** El check se ejecuta después de CADA build.
- Si no hay cambios detectados por git diff, indicar explícitamente en `### Cambios`.
- Contexto histórico: si el usuario pregunta por trabajo de sesiones anteriores, escanear `docs/logs/` y `docs/bitacora.md`.

## Código relevante
- `docs/bitacora.md` — resumen global
- `docs/logs/2026-06-25.md` — logs del día
- `AGENTS.md` — workflow build-driven definido
