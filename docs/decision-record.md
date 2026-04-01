# DataNaut - Decisiones Arquitectónicas Tomadas

> Fecha: 2024-06-15
> Version: 1.0
> Estado: Decisiones resueltas

## Resumen General

- Proyecto: DataNaut - Analizador automático de datasets
- Stack: Next.js 15 + TypeScript + FastAPI (Opcion B)
- Enfoque: Demo profesional con escalabilidad
- Presupuesto: Gratis inicialmente

## Decisiones Criticas Resueltas

### Decisión #1: Arquitectura Backend (Issue #2)
**Estado: COMPLETADA**

Opcion Seleccionada: B (Next.js + FastAPI Hibrido)
Razon: Demo profesional requiere escalabilidad

Stack Tecnico:
- Frontend: Next.js 15 App Router
- Backend: FastAPI (Python)
- Deploy Frontend: Vercel (gratis)
- Deploy Backend: Railway/Render
- Visualizaciones: Plotly.js
- Database: localStorage para MVP, PostgreSQL futuro

### Decisión #2: Seguridad (Issue #3)
**Estado: COMPLETADA**

Decision: Preparar para privacidad futura, NO procesar PII en MVP

Configuraciones:
- Tamaño maximo archivo: 10MB
- Rate limiting: 10 uploads/hora/IP
- Timeout: 60s
- PII Detection: SI (deshabilitado con flags)

## Decisiones Pendientes

Para ver todas las decisiones pendientes, visita:
https://github.com/SMejia115/DataNaut/issues?q=is%3Aopen+is%3Aissue+label%3Adecision-needed

Issues abiertos: #35, #36, #37, #38, #39, #40

## Presupuesto Estimado

Fase 0-1 (Mes 1-2): $0 (free tiers)
Fase 2-3 (Mes 3-4): $45/mes
Fase 4-5 (Mes 5+): $65/mes

## Proximos Pasos

1. Responde decisiones pendientes (issues #35-#40)
2. Asigna responsables
3. Comienza Fase 0: Setup
