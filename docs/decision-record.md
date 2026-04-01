# DataNaut - Decisiones Arquitectónicas Tomadas

> Fecha: 1 de abril de 2026  
> Versión: 1.0  
> Estado: ✅ Todas las decisiones resueltas

## Resumen General

- **Proyecto:** DataNaut - Analizador automático de datasets  
- **Stack Tecnológico:** Next.js 15 + TypeScript + FastAPI (Opción B)  
- **Enfoque:** Demo profesional con escalabilidad futura  
- **Presupuesto:** Gratis inicialmente (Vercel Hobby + Railway Free)

**Total Decisiones:** 8/8 completadas  
**Issues cerrados:** 8/8

---

## ✅ Decisiones Criticás Resueltas

### Decisión #1: Arquitectura Backend (Issue #2)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Opción Seleccionada:** **B** (Next.js + FastAPI Híbrido)

**Razón:** Demo profesional requiere escalabilidad y features ML

**Stack Técnico:**
- Frontend: Next.js 15 App Router (TypeScript)
- Backend: FastAPI (Python)
- Deploy Frontend: Vercel (gratis/free tier)
- Deploy Backend: Railway.app (ver decisión #35)
- Visualizaciones: Plotly.js
- Database: localStorage para MVP, PostgreSQL futuro (ver decisión #40)

**Costo estimado:**
- Meses 1-3: $0 (free tiers)
- Meses 4-6: $20-30/mes (Vercel Pro + Railway Pro)

---

### Decisión #2: Seguridad y Privacidad (Issue #3)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Decisión:** Preparar para privacidad futura, NO manejar PII en MVP

**Razón:** Demo inicial no requiere datos sensibles, pero sistema debe estar preparado

**Toma de decisiones:**
| Configuración | Valor | Racional |
|--------------|-------|----------|
| Procesar PII en MVP | ❌ NO | Solo datasets públicos/demo |
| PII Detection system | ✅ SÍ (deshabilitado) | Feature flags preparados (ver #38) |
| Tamaño máximo archivo | 10MB | Configurable via env vars |
| Rate limiting | 10 uploads/hora/IP | Previene abuso |
| Timeout análisis | 60s | Configurable |
| Encrypt en reposo | ❌ NO (futuro) | Para Fase 5 (GDPR) |

---

### Decisión #3: Infraestructura Deploy (Issue #35)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Servicio Seleccionado:** **Railway.app** (Opción A)

**Razón:**
- UI intuitiva y dashboard simple (bueno para equipo)
- Deploy automático desde GitHub (rápido para iterar)
- PostgreSQL integrado cuando lo necesitemos
- Free tier: 500 horas/mes (suficiente para demo)
- Mejor costo-beneficio para MVP: $7-20/mes cuando subamos a Pro

**Configuración inicial:**
- Crear proyecto: `datanaut-backend`
- Conectar repo GitHub
- Configurar variables de entorno: `PYTHON_VERSION=3.11`, `PORT=8000`
- Setup auto-deploy en push a `main`

---

### Decisión #4: Estructura de Código (Issue #36)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Patrón Seleccionado:** **Monolítico** (Opción A)

**Razón:**
- MVP/demo requiere velocidad, no perfección arquitectónica
- Menos archivos = más fácil de entender para futuros contribuidores
- Si el demo tiene éxito y necesitamos escalar, refactorizar a services es sencillo
- Menos boilerplate = focus en features que importan

**Estructura Final:**
```
/app
  ├── main.py              # FastAPI app
  ├── api/
  │   └── v1/
  │       ├── __init__.py
  │       ├── analyze.py   # POST /api/v1/analyze
  │       ├── cluster.py   # POST /api/v1/cluster
  │       └── anomalies.py # POST /api/v1/anomalies
```

---

### Decisión #5: CI/CD y Monitoreo (Issue #37)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Decisión 1: CI/CD**
**Servicio:** GitHub Actions (recomendado)

**Razón:**
- Gratis para repos públicos
- Integración nativa con GitHub
- No necesita credenciales externas
- Marketplace con templates ready-to-use
- Automático en push a `main`

**Pipeline:**
1. Test: `pytest` on PR
2. Build: Docker image
3. Deploy: Railway CLI

**WorkFlow File:** `.github/workflows/deploy.yml`

**Decisión 2: Monitoreo**
**Nivel:** Console logs (suficiente para demo)

**Razón:**
- Demo no requiere monitoreo 24/7
- Console.log + Railway logs dashboard es suficiente
- Logtail/Datadog agrega costo ($5-20/mes) sin valor inicial
- Podemos agregar Logtail en Fase 3 si clientes lo requieren

**Para producción futura:** Migrar a Logtail + alerts

---

### Decisión #6: PII Detection Feature Flags (Issue #38)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Nivel de Detección:** Detectar + hashing implementado (disabled by flag)

**Razón:**
- Queremos demostrar que el sistema es "enterprise-ready"
- Pero no queremos bloquear al usuario en demo
- Feature flag permite "toggle on" en settings
- Good para: "Mira, puedes activar PII detection con 1 click"

**Columnas a detectar:**
- Emails (regex)
- Credit cards (Luhn algorithm)  
- Phone numbers (patterns)
- SSN/National IDs
- Nombres (using dictionary)

**Feature Flag Config:**
```typescript
const piiConfig = {
  enabled: true,        // Always detect
  action: 'alert',      // 'alert' | 'confirm' | 'hash'
  autoAnonymize: false, // false = demo mode
  auditLog: true
}
```

---

### Decisión #7: ML Features (Issue #39)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Clustering:** **K-means + elbow method** (auto-detect n_clusters)

**Razón:**
- Auto-detectar es más inteligente = mejor demo
- Elbow method encuentra "punto óptimo" (menor WCSS)
- User no necesita pensar "¿cuántos clusters?"
- Más impresionante: "El sistema determinó que hay 3 clusters naturales"

**Anomaly Detection:** **SÍ, implementar Isolation Forest**

**Razón:**
- Es lo que diferencia DataNaut de herramientas básicas
- Pocas herramientas gratuitas hacen esto bien
- Good para: "Detectamos 243 anomalías automáticamente"
- Implementar endpoint `/api/v1/anomalies` con `contamination=0.1`

---

### Decisión #8: Database Strategy (Issue #40)
**Estado:** ✅ **COMPLETADA** - Cerrada el 1-abr-2026

**Estrategia:** **No usar base de datos en MVP**

**Razón:**
- LocalStorage es suficiente para demo single-user
- Si agregamos auth en futuro, sí necesitaremos PostgreSQL (ver Fase 6)
- Por ahora, evitamos complejidad de ORM, migraciones, backups
- Eliminamos costo de $5-15/mes

**Fase 6 (futuro):** Cuando agreguemos usuarios, migrar a PostgreSQL

**Alternativa escalar:** Supabase (gratis tier, PostgreSQL managed, auth integrado)

---

## 📊 **Resumen de Decisiones**

### Completadas (8/8)
- [x] **Decisión #1:** Arquitectura Backend → **Opción B**
- [x] **Decisión #2:** Seguridad → **Preparar PII, deshabilitado**
- [x] **Decisión #3:** Infraestructura → **Railway.app**
- [x] **Decisión #4:** Estructura Código → **Monolítico**
- [x] **Decisión #5:** CI/CD + Monitoreo → **GitHub Actions + Console logs**
- [x] **Decisión #6:** PII Detection → **Feature flags con hashing (disabled)**
- [x] **Decisión #7:** ML Features → **K-means auto + Isolation Forest**
- [x] **Decisión #8:** Database → **None para MVP**

**Coverage:** 100% de decisiones críticas resueltas

---

## 💰 **Presupuesto Estimado con Opción B**

| Fase | Tiempo | Costo/mes | Servicios |
|------|--------|-----------|-----------|
| **Fase 0-1** | Mes 1-2 | **$0** | Vercel Hobby + Railway Free |
| **Fase 2-3** | Mes 3-4 | **$45** | Vercel Pro + Railway Pro + Logtail |
| **Fase 4-5** | Mes 5+ | **$65** | + PostgreSQL + Monitor avanzado |

**Mensaje para clientes:** "DataNaut escala contigo. Empiezas gratis, pagas según necesidad."

---

## 🎯 **Próximos Pasos Recomendados**

### Hoy (Inmediato)
1. ✅ **Leer este documento completo**
2. ✅ **Revisar issues cerrados** (#2, #3, #35-#40)
3. 👥 **Asignar responsables** para Fase 0

### Esta semana (Fase 0 - Setup)
1. Crear cuenta en **railway.app** (ver issue #35)
2. Setup repositorio FastAPI (ver estructura en #36)
3. Crear **Dockerfile** y `docker-compose.yml`
4. Configurar **GitHub Actions** (ver #37)
5. Crear primer endpoint `/health`

### Semana 1 (Fase 1 - Desarrollo)
1. Implementar `/api/v1/analyze` con pandas y ydata-profiling
2. Migrar frontend a Next.js 15 (issue #6)
3. Conectar frontend → backend (CORS config)
4. Testear end-to-end con dataset de prueba

### Semana 2-3 (Fase 1 - Features)
1. Enhanced Statistics Engine (issue #8)
2. Auto-Insights Engine (issue #11)
3. Plotly.js migration (issue #12)
4. Export features (issues #15-#16)

### Semana 4 (Fase 2 - Dashboard)
1. AutoVisualizationGrid (issue #13)
2. AutoInsightsPanel UI (issue #14)
3. Toggle/ocultar visualizaciones (issue #21)
4. Persistencia en localStorage (issue #23)

### Semana 5-6 (Fase 3 - ML)
1. K-means clustering (issue #26)
2. Isolation Forest anomalies (issue #27)
3. Dockerizar backend (issue #28)

---

## 📞 **Links y Referencias**

**GitHub Issues:** https://github.com/SMejia115/DataNaut/issues

**Issues por estado:**
- ✅ Cerradas: #2, #3, #35-#40 (8 issues)
- 🟡 Abiertas: #4-#34 (30 issues de desarrollo)

**Labels organizados:**
- `priority-critical`, `priority-high`, `priority-medium`, `priority-low`
- `phase-1`, `phase-2`, `phase-3`, `phase-4`, `phase-5`
- `architecture`, `backend`, `frontend`, `api`, `ml`, `security`, `devops`

**Documentación clave:**
- `datanaut-plan.md` - Plan completo de desarrollo (31 issues, 5 fases)
- `RESUMEN-EJECUTIVO.md` - Resumen rápido (< 5 min de lectura)
- `README-GITHUB-ISSUES.md` - Guía de uso de issues y setup
- `create-issues-from-json.py` - Script para recrear issues si es necesario

---

> **Nota:** Este documento es la fuente de verdad arquitectónica del proyecto. Actualiza siempre que haya cambios en decisiones.
