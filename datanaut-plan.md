# DataNaut - Plan de Desarrollo Completo

## Resumen de Conversación

### Hallazgos Clave del Estado Actual
- **Stack Actual:** React 19 + TypeScript + Vite + Recharts ✅
- **Documentación desactualizada:** Menciona Angular pero no se utiliza
- **Funciona:** Carga CSV/Excel, estadísticas básicas, histogramas y pie charts
- **Problema principal:** Demasiado manual - enfocado en análisis automático

### Mejoras Prioritarias Aplicadas
1. **Enfoque en Auto-Análisis:** Priorizar insights automáticos sobre configuración manual
2. **Migración a Next.js 15:** Mejor seguridad, SSR, API Routes integradas
3. **Strategia Híbrida Backend:** Next.js API Routes + pyodide (Fase 1), FastAPI opcional (Fase 3)
4. **Enhanced Visualizations:** Plotly.js en lugar de Recharts (box plots, scatter matrix)
5. **Auto-Insights Engine:** Generación inteligente de insights con prioridades
6. **Simplificación de Dashboard:** Grid auto-generado, no drag-drop complejo
7. **Export Inmediato:** CSV limpio, PDF report, compartir por URL
8. **Seguridad Preparada:** Detección PII, rate limiting, arquitectura extensible
9. **Future-Proof:** Diseñado para conexión a BD (PostgreSQL, MySQL, BigQuery)

---

## Decisiones Arquitectónicas Críticas

### Decision #1: Stack Tecnológico
**Frontend:** Next.js 15 + TypeScript + App Router + Tailwind CSS  
**Visualización:** Plotly.js (más interactivo, box plots nativos)  
**Backend Fase 1:** Next.js API Routes + Pyodide (WebAssembly)  
**Backend Fase 3:** FastAPI microservice (opcional, solo si se necesita ML o datasets >20MB)  

### Decision #2: Enfoque de Producto
**MVP Auto-Analítico:** El usuario sube un archivo → obtiene reporte completo automáticamente  
**No manual configuration:** Grid y visualizaciones generadas basadas en reglas  
**Insights priorizados:** HIGH/MEDIUM/INFO con acciones integradas  

### Decision #3: Límites y Seguridad
- Max file size de entrada: 10MB (configurable)
- Detección automática de PII con alertas
- Rate limiting: 10 uploads/hora por IP
- URLs compartibles expiran en 7 días
- Future: conexión a bases de datos con row-level security

---

## Fase 1: Auto-Analysis Engine (Semanas 1-3)

### Objetivo
Análisis completamente automático del dataset con insights inteligentes y visualizaciones generadas sin configuración manual.

### Issues de Fase 1
1. **Setup/Infrastructure:**
   - Migrar de React 19 + Vite a Next.js 15 App Router
   - Crear API Route `/api/analyze` para procesamiento de archivos
   - Establecer estructura de directorios final

2. **Enhanced Statistics Engine:**
   - Implementar Enhanced Statistics Engine (mean, median, std dev, skewness, kurtosis)
   - Implementar Correlation Matrix & Scatter Plot Analysis
   - Implementar Outlier Detection Engine (IQR + Z-score)
   - Implementar detección avanzada de tipos (email, fecha, ID, URL)
   - Implementar detección de time series automática
   - Implementar data quality score (0-100)

3. **Auto-Insights Engine:**
   - Generador de insights inteligentes (HIGH/MEDIUM/INFO)
   - Componente UI AutoInsightsPanel
   - 10+ tipos de insights: missing data, outliers, constant columns, correlation fuerte, time series detectada

4. **Visualizaciones:**
   - Migrar Recharts → Plotly.js
   - Crear AutoVisualizationGrid (generado automáticamente)
   - Box plots, scatter plot matrix, correlation heatmap
   - Histogramas, pie charts, line charts para time series

5. **Export:**
   - Export dataset limpio (CSV con outliers marcados/removidos)
   - Export summary report (TXT/Markdown)

---

## Fase 2: Interactive Dashboard Simplificado (Semana 4)

### Objetivo
Dashboard funcional con layout auto-generado, persistencia y controles básicos.

### Issues de Fase 2
- Crear DashboardLayout con grid auto-generado
- Implementar toggle para mostrar/ocultar visualizaciones
- Implementar reordenamiento simple (react-beautiful-dnd)
- Persistir dashboard layout en localStorage

### Restricciones de MVP
- No multiple dashboard tabs (requiere auth)
- No drag-drop complejo (solo reordenar, no resize)
- No configuración manual de charts (solo toggle/mostrar-ocultar)

---

## Fase 3: Backend Python para Análisis Avanzado (Semanas 5-6)

### Objetivo
Implementar FastAPI backend para casos que Next.js no cubre: datasets grandes, ML, análisis profundo.

### Issues de Fase 3
- **[DECISION]** Implementar FastAPI backend vs mantener Next.js solo
- Crear setup FastAPI con Poetry/Docker
- Implementar endpoint `/api/v1/analyze` con ydata-profiling
- Implementar endpoint `/api/v1/cluster` (K-means + elbow method)
- Implementar endpoint `/api/v1/anomalies` (Isolation Forest)
- Dockerizar FastAPI backend

### Criterio de Implementación
Implementar **solo si**:
- Datasets >20MB frecuentes
- ML features (clustering, anomaly detection) requeridas en MVP
- Next.js API Routes no son suficientes

Alternativa: Postergar a Fase 6 o usar solo si clientes lo demandan.

---

## Fase 4: Export & Share (Semana 7)

### Objetivo
Export reportes profesionales y compartir dashboards sin auth.

### Issues de Fase 4
- Implementar export PDF report (html2canvas + jsPDF)
- Implementar share URL con query params (opcional con cifrado)

### Características
- PDF multipage (cover, insights, visualizaciones, appendix)
- URL compartible con dataset encoded (expira en 7 días)
- Opcional: password protect para URLs

---

## Fase 5: Seguridad & Future-Proofing (Semanas 8-9)

### Objetivo
Preparar para datos sensibles y futura integración con bases de datos.

### Issues de Fase 5
- Implementar detección y sanitización de PII
- Implementar rate limiting y security headers
- Diseñar arquitectura extensible para conexión a bases de datos

### Seguridad Implementada
- Detección de emails, tarjetas, SSN
- Hasheo opcional (SHA-256 con salt)
- Rate limiting: 10 uploads/hora/IP
- Security headers (CSP, HSTS, X-Frame-Options)
- Audit logs

### Future-Proofing
- Interfaz DataSource abstracta
- Preparado para PostgreSQL, MySQL, BigQuery
- Row-level security design
- Connection pooling y query sanitization

---

## Fase 6: Escalado & Usuarios (Futuro, Opcional)

### Objetivo
Multi-user, auth persistente, conexión a bases de datos.

### Características (No en MVP)
- User authentication (NextAuth.js)
- PostgreSQL para usuarios y dashboards
- Row-level security
- Conexión a bases de datos (Postgres, MySQL, BigQuery)
- Team workspaces
- RBAC (Viewer, Analyst, Admin)
- On-premise deployment

---

## Decisiones Técnicas Finales

### 1. Backend Strategy
**Primero:** Next.js 15 API Routes + Pyodide  
**Condicional:** FastAPI si datasets >20MB o ML requerido  
**Razón:** Deploy más simple, costo cero inicial, MVP más rápido

### 2. Chart Library
**Plotly.js** sobre Recharts  
**Razón:** Box plots nativos, scatter matrix, interacción superior  
**Trade-off:** +50KB bundle size

### 3. State Management
**React Context + Server Components**  
**Razón:** Suficiente para MVP, no necesita Zustand/Redux  
**Migración:** Usar Zustand solo si dashboard se vuelve complejo

### 4. Deployment
**Frontend:** Vercel (optimizado para Next.js)  
**Backend (si aplica):** Railway ($7-20/mes)  
**Database (futuro):** Railway PostgreSQL o Neon

### 5. Performance Targets
- Análisis de 10,000 filas x 50 columnas: <5s
- Render de 10 visualizaciones: <3s
- Generación de PDF: <30s
- Upload file: <10s para 10MB

---

## Preguntas Abiertas para Seguir Iterando

### 1. Tamaño de Datasets
- ¿Cuál es el tamaño máximo esperado en producción?
- ¿Necesitas procesar datasets >20MB en Fase 1?

### 2. Timeline
- ¿Tienes deadline específico para MVP?
- ¿3 semanas (Next.js solo) o 5 semanas (con FastAPI)?

### 3. Presupuesto
- ¿Cuánto presupuesto para infraestructura mensual?
- ¿$0 (Vercel Hobby), $20/mes (Vercel Pro), o más?

### 4. ML Features
- ¿Necesitas clustering/anomaly detection en MVP?
- ¿O puede esperar a Fase 3+?

### 5. Seguridad
- ¿Manejarás datasets con información sensible?
- ¿PII detection es prioridad #1 o puede esperar?

### 6. Charting Library
- ¿Plotly.js está aprobado o prefieres mantener Recharts?
- ¿Box plots son must-have para tu caso de uso?

### 7. Usuarios
- ¿Necesitas multi-user con login desde el día 1?
- ¿O single-user para demo/interno es suficiente?

---

## Siguientes Pasos Recomendados

### Inmediato (Ahora)
1. **Verificar y aprobar** las decisiones arquitectónicas
2. **Responder las 7 preguntas abiertas** para afinar el plan
3. **Priorizar Fase 1:** Identificar cuáles issues son must-have vs nice-to-have

### Semana 1
1. Migrar a Next.js 15 (Issue #3)
2. Crear API Route /api/analyze (Issue #4)
3. Implementar Enhanced Statistics Engine (Issue #5-9)

### Semana 2
1. Migrar a Plotly.js (Issue #9)
2. Implementar Auto-Insights Engine (Issue #8, #11)
3. Crear AutoVisualizationGrid (Issue #10)

### Semana 3
1. Implementar export features (Issue #12-13)
2. Polishing y testing
3. Deploy a Vercel

### Post-MVP
4. Evaluar si se necesita FastAPI (Fase 3)
5. Implementar PDF export (Fase 4)
6. Mejoras de seguridad (Fase 5)

---

## Recursos y Documentación

### Documentación a Crear
- `/docs/architecture-decision-record.md` - Decisiones técnicas
- `/docs/security-policy.md` - Políticas de seguridad y PII
- `/docs/api.md` - Especificación de endpoints
- `/docs/deployment.md` - Instrucciones de deploy

### Datasets de Prueba
Crear carpeta `/sample-data` con:
- `iris.csv` - Para testing de correlaciones
- `sales-temporal.csv` - Para testing de time series
- `customers-mixed.csv` - Mix numérico/categórico
- `emails.csv` - Para testing de PII detection
- `large-50k-rows.csv` - Para testing de performance

### Herramientas de Testing
- **Performance:** Chrome DevTools + Lighthouse
- **Security:** OWASP ZAP, npm audit
- **E2E:** Playwright
- **API:** Postman/Newman

---

## Métricas de Éxito

### MVP Success Metrics
- [ ] Tiempo de análisis: <5s para 10k filas
- [ ] Insights generados: >80% útiles
- [ ] Usabilidad: 0 configuración manual necesaria
- [ ] Deploy: Vercel con build exitoso
- [ ] Test coverage: >70% en lógica core

### Post-MVP Metrics
- [ ] DAU/MAU si multi-user
- [ ] NPS de usuarios
- [ ] Performance con datasets de 100k+ filas
- [ ] Uptime >99%

---

## Notas Adicionales

### Dependencias Clave
**Frontend:**
- `next@15`, `react@19`, `react-dom@19`
- `plotly.js-dist`, `typescript@5`
- `tailwindcss@3`, `lucide-react` (icons)

**Backend (Fase 3):**
- `fastapi`, `uvicorn`, `pandas`, `numpy`, `scikit-learn`
- `ydata-profiling`, `pyodide` (para Next.js)

**DevOps:**
- `docker`, `docker-compose`
- `vercel CLI`, `railway CLI` (si aplica)

### Agradecimientos
Este plan fue co-creado con feedback iterativo enfocado en:
- Priorizar valor inmediato (auto-insights)
- Mantener simplicidad (no over-engineering)
- Preparar escalabilidad (arquitectura limpia)
- Seguridad desde el día 1 (PII, rate limiting)

---

## Historial de Versiones
- **v1.0** (2024-01-15): Plan inicial completo
- **Next:** Actualizar según respuestas a preguntas abiertas

---

## Contacto y Soporte
- **Repo:** https://github.com/[tu-usuario]/DataNaut
- **Issues:** Ver GitHub Issues para tareas detalladas
- **Discussions:** Usar GitHub Discussions para preguntas

---

> "El objetivo no es construir la herramienta perfecta, sino la herramienta que genere insights inmediatos sin fricción." - DataNaut Philosophy
