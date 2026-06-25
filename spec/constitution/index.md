# Metaspec SDD — Alonso Suárez Reza Portfolio

Este directorio contiene la especificación formal del proyecto siguiendo los principios de **Specification-Driven Development (SDD)**.

## Estructura

```
spec/
├── constitution/      — Metadocumentación: visión general, plan, histórico
├── features/          — Especificaciones detalladas de cada feature (01 a 13)
├── template/          — Plantillas reutilizables para escribir nuevas specs
└── glossary.md        — Definiciones del dominio del proyecto
```

## Convenciones

- Cada feature en `features/` se numera (`01-nombre.md`) para establecer orden de lectura.
- Las specs se escriben en markdown plano, sin herramientas externas.
- El contenido raíz (`AGENTS.md`, `README.md`) mantiene una versión operativa mínima; las specs contienen la documentación canónica y expandida.

## Cómo leer este spec

1. **Glosario** (`spec/glossary.md`) si encuentras un término desconocido.
2. **Project overview** (`spec/constitution/project-overview.md`) para visión general.
3. **Agent instructions** (`spec/constitution/agent-instructions.md`) si eres un agente de IA.
4. **Features** (`spec/features/`) en orden numérico para profundizar en áreas específicas.
