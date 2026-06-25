# 14 — Sistema de Bug Tracking

## Propósito

Define el sistema de documentación y seguimiento de bugs del portfolio. Los bugs se registran en `spec/constitution/bugs.md` ANTES de ser corregidos, garantizando que ningún hallazgo se pierda entre sesiones.

## Archivo de bugs

**Ubicación:** `spec/constitution/bugs.md`

**Estructura:**
```markdown
# Bugs conocidos — Alonso Suárez Reza Portfolio
Último escaneo: YYYY-MM-DD (Sesión N)
Total: X FAIL(s), Y WARN(s)

## 🔴 Sin arreglar
### [Título del bug] — SEVERIDAD
- **Archivo:** `ruta/archivo:línea`
- **Origen:** [script que lo detectó]
- **Detectado:** Sesión N
- **Descripción:** [explicación del bug, por qué ocurre, impacto]
- **Fix propuesto:** [cómo arreglarlo]
- **Estado:** ⏳ Pendiente / 🔄 En progreso

## 🟡 Parcialmente arreglado
### [Título] — SEVERIDAD
- [mismos campos + nota de qué falta]

## ✅ Arreglado
### [Título] — SEVERIDAD
- **Archivo:** `ruta/archivo:línea`
- **Detectado:** Sesión N
- **Arreglado:** Sesión N (commit abc1234)
- **Descripción:** [explicación]
- **Fix aplicado:** [qué se cambió]
```

## Ciclo de vida de un bug

```
1. DETECTAR
   - Tests automáticos (run-all.ps1) identifican bugs mecánicos
   - Revisión [MANUAL] identifica bugs de lógica profunda
        │
2. DOCUMENTAR (ANTES de arreglar)
   - run-all.ps1 guarda FAILs y WARNs en bugs.md bajo 🔴 Sin arreglar
   - Bugs manuales se añaden por el agente con el mismo formato
        │
3. DECIDIR
   - El usuario decide si arreglar ahora o dejarlo para otra sesión
   - Si se arregla → seguir a paso 4
   - Si no → el bug queda documentado para futuras sesiones
        │
4. ARREGLAR
   - Agente propone plan, usuario aprueba
   - Se aplica el fix
   - Build + run-all.ps1 para verificar
        │
5. ACTUALIZAR bugs.md
   - Mover entrada de 🔴 Sin arreglar → ✅ Arreglado
   - Añadir sesión y hash del commit
   - Si el fix es parcial → mover a 🟡 Parcialmente arreglado
        │
6. REGRESIÓN
   - En el próximo run-all.ps1, los bugs marcados como ✅ se re-verifican
   - Si reaparecen, volver a 🔴 Sin arreglar
```

## Reglas

- **Documentar antes de arreglar.** No se aplica ningún fix sin que el bug esté registrado en `bugs.md`.
- **Cada bug tiene un estado.** No puede pasar de detectado a arreglado sin pasar por documentado.
- **Regresión automática.** Los tests de `run-all.ps1` cubren todos los bugs conocidos. Si un bug arreglado reaparece, el test lo detectará.
- **Los bugs no expiran.** Aunque no se arreglen en meses, quedan documentados. El escaneo más reciente actualiza su estado en `Último escaneo`.

## Dependencias

- [Feature 11](11-testing-mcp.md) — Tests MCP (run-all.ps1 es el entry point)
- [Feature 12](12-testing-design.md) — Tests de diseño
- [Feature 13](13-logging-system.md) — Logging de sesiones (cada fix se registra en el log de sesión)
