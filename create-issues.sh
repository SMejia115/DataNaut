#!/bin/bash

# Script para crear todos los issues de DataNaut en GitHub
# Uso: bash create-issues.sh
# Requiere: gh CLI autenticado con permisos en el repo

set -e  # Stop on error

echo "🌌 Creando issues de DataNaut en GitHub..."
echo ""

# Función para crear un issue usando gh CLI
create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"
  
  echo "📋 Creando issue: $(echo "$title" | cut -c1-60)..."
  
  # Crear archivo temporal para el body (para manejar bodies grandes)
  printf "%s" "$body" > /tmp/issue_body.md
  
  # Crear el issue
  gh issue create \
    --title "$title" \
    --body-file /tmp/issue_body.md \
    --label "$labels"
  
  # Limpiar
  rm -f /tmp/issue_body.md
}

# Issue #1: Decisiones de arquitectura
create_issue "[DECISION] Arquitectura: Next.js solo vs Next.js + FastAPI híbrido" "## Contexto
Necesitamos decidir la arquitectura backend para DataNaut basado en:
- Tamaño máximo de datasets esperado: [PENDIENTE: definir]
- Timeline: MVP rápido (3 semanas) vs robusto (5 semanas)
- Presupuesto infraestructura: [PENDIENTE: definir]
- Complejidad de análisis: Estadísticas vs ML

## Opciones

### Opción A: Next.js 15 API Routes (Monolítico)
**Pros:**
- Deploy simple en Vercel (gratis/muy económico)
- Sin infraestructura adicional
- Menor latencia (no llamadas de red entre servicios)
- Usar pyodide (WebAssembly) para pandas en browser

**Cons:**
- Límite de 4.5MB (Vercel Hobby) o 100MB (Pro) en body requests
- Procesamiento en browser puede bloquear UI para datasets >10MB
- No se puede usar scikit-learn, ydata-profiling nativo
- CPU limitado en Vercel

**Mejor para:** MVP rápido, datasets <20MB, sin ML complejo

### Opción B: Next.js + FastAPI Microservice (Híbrido)
**Pros:**
- Pandas, NumPy, scikit-learn al 100%
- ydata-profiling para análisis automático completo
- Maneja datasets grandes (hasta 2GB con streaming)
- Async processing con Celery si es necesario

**Cons:**
- Deploy más complejo (Docker, Railway/Render)
- Comunicación entre servicios (CORS, retries)
- Costo mínimo $10-20/mes
- Overhead de mantener dos servicios

**Mejor para:** Datasets >20MB, ML clustering/predicción, producción seria

### Opción C: Next.js API Routes + Python Worker (Eventual)
**Pros:**
- Start simple, escala cuando sea necesario
- API Routes para Fase 1, migrar patrones costosos a Python
- Balanceado

**Cons:**
- Refactoring necesario en Fase 3

## Preguntas para responder:
1. ¿Cuál es el tamaño máximo de dataset esperado en los primeros 3 meses?
2. ¿Necesitas ML (clustering, predicción) en el MVP o puede esperar?
3. ¿Presupuesto infraestructura: $0, $10-20/mes, o más?
4. ¿Deploy timeline: 1 semana o 3 semanas?

## Recomendación Técnica:
- Para datasets <20MB: Opción A (Next.js solo) con pyodide
- Para datasets >20MB o ML inmediato: Opción B (FastAPI desde Fase 1)

## Acceptance Criteria:
- [ ] Decisión documentada en /docs/architecture-decision-record.md
- [ ] Team consensus alcanzado
- [ ] Presupuesto aprobado si se necesita infraestructura" "architecture,decision-needed,priority-critical"

# Issue #2: Decisiones de seguridad
create_issue "[DECISION] Límites de seguridad y privacidad de datos" "## Contexto
DataNaut eventualmente conectará a bases de datos con información confidencial. Necesitamos definir límites de seguridad desde el MVP.

## Decisiones por tomar:

### 1. Detección de PII (Personally Identifiable Information)
**Opciones:**
- A: Solo detectar y alertar al usuario (no bloquear)
- B: Detectar y requerir confirmación para procesar
- C: Auto-anonimizar (hashing de columnas detectadas)

**Columnas a detectar:**
- Emails (regex)
- Credit cards (Luhn algorithm)
- SSN/National IDs (patterns)
- Phone numbers
- Names (diccionario)

### 2. Límites de archivos
- ¿Tamaño máximo por archivo? (10MB, 50MB, 100MB?)
- ¿Límites por IP/usuario? (Rate limiting)
- ¿Timeout de análisis? (30s, 60s, 120s?)

### 3. Retención de datos
- ¿Cuánto tiempo guardamos datasets en servidor? (no guardar, 24h, 7 días?)
- ¿Encriptar datasets en reposo? (S3 con SSE, local encryption?)
- ¿Auditar accesos? (logs de quién sube qué)

### 4. Conexión a BD (futuro)
- ¿Método de autenticación? (connection strings, IAM roles, SSH tunnels?)
- ¿Cifrado en tránsito? (TLS 1.2+ obligatorio)
- ¿Query sanitization? (prevenir SQL injection)
- ¿Row-level security? (usuarios solo ven sus datos)

## Acceptance Criteria:
- [ ] Política de seguridad documentada en /docs/security-policy.md
- [ ] Implementar validator de PII en Fase 1.2
- [ ] Configurar límites de archivo
- [ ] Decisiones documentadas en ADR" "business-logic,security,decision-needed,priority-high"

# Fase 1: Auto-Analysis Engine
echo ""
echo "🔬 Creando issues de Fase 1: Auto-Analysis Engine..."
echo ""

# Issue #3
create_issue "[FASE-1] Migrar de React 19 + Vite a Next.js 15 App Router" "## Objetivo
Migrar el codebase actual de React 19 + Vite a Next.js 15 con App Router para habilitar SSR, API Routes y mejor seguridad.

## Tareas
1. Inicializar proyecto Next.js 15:
   \`\`\`bash
   npx create-next-app@15 datanaut-next --typescript --tailwind --app
   \`\`\`

2. Migrar estructura de carpetas:
   - /app/src/components → /app/components (Client Components)
   - /app/src/pages → /app/pages (App Router)
   - Migrar App.tsx a /app/layout.tsx y /app/page.tsx

3. Actualizar dependencias:
   - @types/react y @types/react-dom compatibles con Next.js 15
   - Asegurar que Tailwind funcione con new config
   - Reemplazar react-router-dom por next/navigation

4. Configurar Client Components:
   - Añadir 'use client' a todos los componentes interactivos
   - Dejar API Routes como Server Components

5. Migrar routing:
   - / → /app/page.tsx
   - /upload → /app/upload/page.tsx
   - /dashboard → /app/dashboard/page.tsx

## Acceptance Criteria:
- [ ] App corre en localhost:3000 sin errores
- [ ] TypeScript sin errores (npm run type-check)
- [ ] ESLint sin warnings (npm run lint)
- [ ] Tests existentes pasan (si hay)
- [ ] Todos los componentes interactivos tienen 'use client'
- [ ] Build exitoso (npm run build)" "phase-1,migration,infrastructure,priority-high"

# Issue #4
create_issue "[FASE-1] Crear API Route /api/analyze para procesamiento de archivos" "## Objetivo
Crear endpoint server-side que reciba archivos CSV/Excel, los valide y extraiga datos sin procesamiento pesado.

## Especificación
**Endpoint:** POST /api/analyze

**Request:**
\`\`\`typescript
FormData:
- file: File (CSV, XLSX, XLS)
- options?: {
    sampleSize?: number, // para datasets grandes
    encoding?: string
  }
\`\`\`

**Response (200 OK):**
\`\`\`typescript
{
  metadata: {
    filename: string,
    size: number,
    rows: number,
    columns: string[],
    detectedTypes: { [column: string]: 'numeric' | 'categorical' | 'date' | 'email' | 'id' },
    processingTime: number
  },
  preview: any[], // primeras 10 filas
  quality: {
    duplicateRows: number,
    emptyColumns: string[],
    highCardinality: { column: string, uniqueCount: number }[]
  }
}
\`\`\`

**Validaciones:**
- [ ] File type validation (CSV, XLSX, XLS)
- [ ] File size < 10MB (configurable via env var)
- [ ] Encoding detection (UTF-8, ISO-8859-1)
- [ ] Reject empty files
- [ ] Reject files con <2 filas o <1 columna
- [ ] Timeout de 30 segundos

**Librerías:**
- PapaParse (CSV parsing en Node.js)
- xlsx (Excel parsing en Node.js)
- pyodide (si usamos Python en WASM) o mantener JS parsing inicialmente

## Acceptance Criteria:
- [ ] API Route funciona en desarrollo
- [ ] API Route funciona en build de producción
- [ ] Handle archivos CSV válidos correctamente
- [ ] Handle archivos Excel válidos correctamente
- [ ] Retorna errores claros para archivos inválidos
- [ ] Límite de tamaño implementado y testeado
- [ ] Timeout implementado
- [ ] Documentación en /docs/api.md" "phase-1,backend,api,priority-high"

# Issue #5
create_issue "[FASE-1] Implementar Enhanced Statistics Engine (backend)" "## Objetivo
Implementar cálculo exhaustivo de estadísticas para cada columna, detectando tipos avanzados y problemas de calidad.

## Cálculos por Columna

### Para columnas numéricas:
- [ ] Mean, median, mode
- [ ] Std deviation, variance
- [ ] Min, max, range
- [ ] Q1, Q3, IQR
- [ ] Skewness (asymmetry)
- [ ] Kurtosis (tail heaviness)
- [ ] Outliers (IQR method: <Q1-1.5*IQR o >Q3+1.5*IQR)
- [ ] Outliers extremos (3-sigma rule)
- [ ] Z-score para cada valor

### Para columnas categóricas:
- [ ] Unique count
- [ ] Cardinality ratio (unique/total)
- [ ] Top 10 most frequent values
- [ ] Most frequent value & frequency
- [ ] Distribution entropy (measure of randomness)
- [ ] Is constant column check (unique === 1)
- [ ] Is unique column check (unique === total)

### Para todas las columnas:
- [ ] Missing value count & percentage
- [ ] Data type inference mejorado:
  - Email detection (regex: /^\S+@\S+\.\S+$/)
  - Date detection (intentar parsear con multiple formats)
  - ID detection (unique === total AND string pattern)
  - URL detection (regex)
  - Boolean detection ('true'/'false', 'yes'/'no', 0/1)
  - Numeric detection (80% threshold + type coercion)
- [ ] Data quality score (0-100):
  - 100: No missing, no outliers, no duplicates
  - Deduction: -10% missing >5%, -20% outliers, -15% duplicates

### Dataset-level:
- [ ] Total rows
- [ ] Total columns
- [ ] Duplicate rows count
- [ ] Columns with high cardinality (>100 unique)
- [ ] Columns with >50% missing
- [ ] Columns constantes
- [ ] Overall quality score (promedio de columnas)

## Acceptance Criteria:
- [ ] Endpoint /api/analyze retorna objeto statistics completo
- [ ] Todos los cálculos implementados y testeados
- [ ] Type inference >95% accuracy en datasets de prueba
- [ ] Performance: <5s para datasets de 10,000 filas x 50 columnas
- [ ] Tests unitarios para cada función estadística
- [ ] Documentación de fórmulas usadas" "phase-1,backend,analytics,priority-high"

# Issue #6
create_issue "[FASE-1] Implementar Correlation Matrix & Scatter Plot Analysis" "## Objetivo
Detectar correlaciones entre columnas numéricas y generar datos para scatter plot matrix.

## Cálculos
1. **Correlation Matrix** (solo columnas numéricas):
   - [ ] Pearson correlation coefficient (-1 to 1)
   - [ ] P-value para significancia
   - [ ] Solo calcular si al menos 2 columnas numéricas
   - [ ] Retornar matriz triangular superior (optimización)

2. **Significant Correlations** (filtradas):
   - [ ] |r| > 0.7 AND p-value < 0.05
   - [ ] Retornar lista: [{col1, col2, correlation, pValue, interpretation}]
   - Interpretación: "strong positive", "moderate negative", etc.

3. **Scatter Plot Matrix Data** (solo pares significativos):
   Para cada par con |r| > 0.5:
   - [ ] Samplear max 1000 puntos (performance)
   - [ ] Retornar array: [{x: value, y: value, rowIndex}]

## API Response
\`\`\`typescript
{
  correlations: {
    matrix: number[][], // 2D array con coeficientes
    significant: {
      count: number,
      pairs: Array<{
        column1: string,
        column2: string,
        correlation: number,
        pValue: number,
        strength: 'weak' | 'moderate' | 'strong',
        direction: 'positive' | 'negative'
      }>
    }
  },
  scatterPlotData: {
    [pairKey: string]: Array<{x: number, y: number, rowIndex: number}>
  }
}
\`\`\`

## Acceptance Criteria:
- [ ] Correlation matrix calculada correctamente
- [ ] P-values calculados (usar scipy.stats si Python, o implementación JS)
- [ ] Solo pares significativos incluidos en scatter plot data
- [ ] Performance: <3s para 10 columnas numéricas x 10,000 filas
- [ ] Tests con datasets conocidos (ej: iris dataset con correlaciones esperadas)" "phase-1,backend,analytics,visualization,priority-high"

# Issue #7
create_issue "[FASE-1] Implementar Outlier Detection Engine" "## Objetivo
Detectar outliers en columnas numéricas usando múltiples métodos y generar datos para box plots.

## Métodos de Detección
1. **IQR Method** (default):
   - Q1 = 25th percentile
   - Q3 = 75th percentile
   - IQR = Q3 - Q1
   - Outliers: valores < Q1 - 1.5*IQR o > Q3 + 1.5*IQR
   - Extreme outliers: valores < Q1 - 3*IQR o > Q3 + 3*IQR

2. **Z-Score Method** (opcional):
   - z = (x - mean) / std
   - Outliers: |z| > 3

3. **Isolation Forest** (si usamos Python backend):
   - Usar scikit-learn
   - Detectar anomalías multivariadas

## Datos para Visualización
Para cada columna numérica:
- [ ] Min, Q1, median, Q3, max (box plot whiskers)
- [ ] Outliers array: [{value, rowIndex, type: 'outlier' | 'extreme'}]
- [ ] Outlier count por tipo
- [ ] Impacto en media: mean_with_outliers vs mean_without_outliers

## Insights Generados
Auto-generar mensajes:
- "Column 'revenue' has 3 extreme outliers affecting the mean by 23.4%"
- "Consider removing outliers or using median instead of mean"

## API Response
\`\`\`typescript
{
  outliers: {
    [column: string]: {
      q1: number,
      q3: number,
      median: number,
      min: number,
      max: number,
      outliers: Array<{value: number, rowIndex: number, type: string}>,
      outlierCount: number,
      extremeCount: number,
      meanImpact: number // percentage difference
    }
  }
}
\`\`\`

## Acceptance Criteria:
- [ ] Box plot stats calculados correctamente
- [ ] Outliers detectados por método IQR
- [ ] Outliers extremos identificados
- [ ] Impacto en media calculado
- [ ] Performance: <2s por columna con 10,000 filas
- [ ] Tests con datasets sintéticos con outliers conocidos" "phase-1,backend,analytics,priority-high"

# Issue #8
create_issue "[FASE-1] Auto-Insights Engine - Generador de Insights Inteligentes" "## Objetivo
Generar tarjetas de insights automáticas que prioricen los problemas más críticos y accionables del dataset.

## Lógica de Generación de Insights

### Prioridad Alta (mostrar primero)
1. **Missing Data Severo** (>50% missing):
   \`\`\`typescript
   {
     id: "missing_critical",
     severity: "high",
     title: "Columna '{col}' tiene {pct}% valores faltantes",
     description: "Considera eliminar esta columna, no aporta información",
     recommendation: "Remove column",
     action: "removeColumn",
     data: { column: string, missingCount: number, missingPct: number }
   }
   \`\`\`

2. **Constant Column** (único valor):
   \`\`\`typescript
   {
     id: "constant_column",
     severity: "high",
     title: "Columna '{col}' es constante",
     description: "Todos los valores son '{value}'. Elimina para reducir dimensionalidad",
     recommendation: "Remove column",
     action: "removeColumn"
   }
   \`\`\`

3. **Outliers Extremos** (>3σ):
   \`\`\`typescript
   {
     id: "extreme_outliers",
     severity: "high",
     title: "Outliers extremos en '{col}'",
     description: "{count} outliers afectan la media en {pct}%. Usa median para estadísticas robustas",
     recommendation: "Show box plot",
     action: "showVisualization",
     chartType: "boxplot"
   }
   \`\`\`

### Prioridad Media
4. **High Cardinality** (>100 unique en categórica):
   ```
   "Columna '{col}' tiene {count} categorías únicas. Considera agrupar o usar representación alternativa"
   ```

5. **Missing Data Moderado** (20-50% missing):
   ```
   "Considera imputation o investiga patrón de datos faltantes"
   ```

6. **Strong Correlations** (|r| > 0.85):
   ```
   "Fuerte correlación entre '{col1}' y '{col2}' (r={r}). ¿Multicolinearidad?"
   ```

### Prioridad Info
7. **Time Series Detected**:
   "Columna '{col}' parece fecha con {count} puntos temporales. ¿Quieres ver tendencias?"
   action: "showLineChart"

8. **Normal Distribution**:
   "Columna '{col}' sigue distribución normal (skewness≈0, kurtosis≈3). Buena para modelos paramétricos"

9. **Data Quality Score**:
   "Dataset quality score: {score}/100. {summary}"

## Reglas de Priorización
- [ ] Ordenar por: severity (high → medium → info), luego por impacto
- [ ] Máximo 10 insights mostrados (evitar overwhelm)
- [ ] Collapsar insights similares
- [ ] No mostrar insights obvios (ej: 0% missing)

## UI Componente
- Crear componente AutoInsightsPanel que:
  - Muestra tarjetas coloreadas por severidad (rojo, amarillo, azul)
  - Botón de dismiss por insight
  - Botón de action cuando aplique
  - Historial de insights ignorados (guardar en localStorage)

## Acceptance Criteria:
- [ ] Engine genera al menos 10 tipos diferentes de insights
- [ ] Priorización implementada y testeada
- [ ] Componente UI creado en Fase 1.8
- [ ] Acciones funcionales (ej: removeColumn actualiza estado)
- [ ] >80% de insights generados son útiles en datasets de prueba" "phase-1,backend,feature,priority-high"

# Issue #9
create_issue "[FASE-1] Migrar Recharts a Plotly.js para visualizaciones avanzadas" "## Objetivo
Reemplazar Recharts por Plotly.js para soportar box plots, scatter plot matrix e interacciones avanzadas.

## Motivación
- Box plots nativos (critical para outliers)
- Scatter plot matrix más eficiente
- Zoom, pan, lasso select integrado
- Mejor performance para datasets grandes

## Tareas

1. **Instalación y configuración:**
   \`\`\`bash
   npm uninstall recharts
   npm install plotly.js-dist plotly.js-types
   \`\`\`

2. **Crear wrapper components:**
   - PlotlyBoxPlot.tsx - Para distribuciones y outliers
   - PlotlyScatterMatrix.tsx - Para correlation analysis
   - PlotlyHistogram.tsx - Para distribuciones numéricas
   - PlotlyHeatmap.tsx - Para correlation matrix
   - PlotlyLineChart.tsx - Para time series
   - PlotlyPieChart.tsx - Para categóricas

3. **Migrar visualizaciones existentes:**
   - Cambiar bar charts en dataVisualization.tsx
   - Cambiar pie charts
   - Mantener responsive containers

4. **Implementar box plots:**
   \`\`\`typescript
   // Datos para Plotly
   const boxPlotData = [{
     y: numericValues,
     type: 'box',
     name: columnName,
     boxpoints: 'outliers', // mostrar outliers como puntos
     marker: { color: '#3b82f6' }
   }]
   \`\`\`

5. **Implementar scatter plot matrix:**
   - Solo para correlations >0.5
   - Samplear max 1000 puntos si dataset es grande
   - Mostrar trendline opcional

6. **Implementar correlation heatmap:**
   - Colorear por intensidad de correlación
   - Show correlation value on hover
   - Axis labels con nombres de columnas

7. **Responsive design:**
   - Usar useEffect y window.resize para replot
   - Configurar responsive: true en Plotly

8. **Performance:**
   - Usar Plotly.react() en lugar de newPlot() para updates
   - Limpiar plots en unmount: Plotly.purge(divId)

## Acceptance Criteria:
- [ ] Todos los charts migrados a Plotly.js
- [ ] Box plots funcionando con outliers marcados
- [ ] Scatter plot matrix implementado
- [ ] Correlation heatmap implementado
- [ ] Responsive en desktop y mobile
- [ ] Performance acceptable (<2s para renderizar 10 charts)
- [ ] No memory leaks (verificar con Chrome DevTools)" "phase-1,frontend,migration,priority-high"

# Issue #10
create_issue "[FASE-1] Crear componente AutoVisualizationGrid (generado automáticamente)" "## Objetivo
Generar un grid de visualizaciones automáticamente basado en el análisis, sin configuración manual del usuario.

## Lógica de Generación Automática

```typescript
// Reglas para cada tipo de columna/dataset
const visualizationRules = [
  {
    condition: (col, stats) => stats[col].type === 'numeric',
    visualizations: ['histogram', 'boxplot'],
    priority: 1
  },
  {
    condition: (col, stats) => stats[col].type === 'categorical' && stats[col].unique <= 10,
    visualizations: ['piechart', 'topvalues_table'],
    priority: 1
  },
  {
    condition: (col, stats) => stats[col].type === 'categorical' && stats[col].unique > 10,
    visualizations: ['topvalues_table'],
    priority: 2
  },
  {
    condition: (dataset) => dataset.significantCorrelations.length > 0,
    visualizations: ['correlation_heatmap', 'scatter_matrix'],
    priority: 1
  },
  {
    condition: (dataset) => dataset.timeSeriesDetected,
    visualizations: ['linechart'],
    priority: 1
  },
  {
    condition: (dataset) => dataset.qualityScore !== null,
    visualizations: ['quality_gauge'],
    priority: 1
  }
]
```

## Componente `<AutoVisualizationGrid>`

**Props:**
```typescript
interface AutoVisualizationGridProps {
  data: any[]
  statistics: Statistics
  correlations: CorrelationData
  outliers: OutlierData
  onVisualizationClick?: (chartId: string) => void
}
```

**Lógica:**
1. Evaluar cada regla en orden de prioridad
2. Generar lista de visualizaciones a mostrar
3. Evitar duplicados (si una columna califica para múltiples, elegir la más informativa)
4. Renderizar grid (2-3 columnas basado en viewport width)

**Layout:**
- CSS Grid con responsive breakpoints:
  - Mobile: 1 columna
  - Tablet: 2 columnas
  - Desktop: 3 columnas
- Espaciado consistente (gap-6)
- Cards con sombra y hover effect

**Interacciones:**
- Click en gráfico → expandir modal fullscreen
- Hover → tooltip con descripción
- Botón \"?\" para explicar qué muestra el gráfico

## Optimizaciones:
1. **Virtualización:** Si >20 visualizaciones, usar react-window o react-virtualized
2. **Lazy Loading:** Cargar gráficos cuando entran al viewport usando IntersectionObserver
3. **Debouncing:** No renderizar todos de golpe, usar setTimeout con 100ms delay entre cada

## Acceptance Criteria:
- [ ] Grid genera visualizaciones automáticamente basado en reglas
- [ ] Sin configuración manual necesaria
- [ ] Responsive layout funciona en todos los breakpoints
- [ ] Performance: render inicial <3s para 10 visualizaciones
- [ ] Modals de expansión funcionales
- [ ] Tests con datasets variados (solo numérico, mixto, categórico solo)" "phase-1,frontend,feature,priority-high"

# Issue #11
create_issue "[FASE-1] Crear componente AutoInsightsPanel UI" "## Objetivo
Componente visual que muestra insights generados automáticamente con acciones integradas.

## Diseño

```
┌─────────────────────────────────────────┐
│  📊 Auto-Insights (12)                 [⚙️]│
├─────────────────────────────────────────┤
│ 🔴 HIGH PRIORITY (3)                    │
│ ┌─────────────────────────────────────┐ │
│ │ Outliers extremos en 'revenue'      │ │
│ │ 3 outliers afectan la media en 23%  │ │
│ │ [View Box Plot] [Dismiss]           │ │
│ └─────────────────────────────────────┘ │
│ ┌─────────────────────────────────────┐ │
│ │ 45% faltantes en 'customer_id'      │ │
│ │ Considera eliminar columna          │ │
│ │ [Remove Column] [Dismiss]           │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ 🟡 MEDIUM PRIORITY (4)                  │
│ (collapsible por default)               │
│                                         │
│ 🔵 INFO (5)                             │
│ (fully collapsed)                       │
└─────────────────────────────────────────┘
```

### Props
```typescript
interface AutoInsightsPanelProps {
  insights: Insight[]
  onAction: (action: string, data: any) => void
  onDismiss: (insightId: string) => void
  className?: string
}
```

### Insight Card Component
- **Icono:** Según severity (🔴🟡🔵)
- **Título:** Font weight semibold
- **Descripción:** Text-sm, gray-600
- **Actions:** Botones small con:
  - primary action (ej: "View Chart")
  - secondary action (ej: "Dismiss")
  - Opcional: tertiary (ej: "Learn More")

### Interacciones
1. **View Action:** Scroll y highlight el gráfico relacionado
2. **Remove Column:** 
   - Confirm dialog: "Are you sure?"
   - Actualizar estado: filter out column
   - Re-run análisis automáticamente
3. **Dismiss:**
   - Guardar en localStorage.dismissedInsights
   - No mostrar de nuevo para este dataset
   - Opcional: "Don't show this type again"

### Estados
- **Empty:** "No issues found! Your data looks great. 🎉"
- **Loading:** Skeleton loader
- **Error:** "Unable to generate insights. Try refreshing."

### Responsive
- Mobile: Full width, cards stack vertical
- Desktop: Max width 3xl, centered

### Accessibility
- Aria-labels para screen readers
- Keyboard navigation (Tab, Enter)
- Color + icons (no solo color)

## Acceptance Criteria:
- [ ] Componente funcional con múltiples insights
- [ ] Acciones ejecutan funcionalidad correctamente
- [ ] Dismiss persiste en localStorage
- [ ] Responsive en mobile y desktop
- [ ] ARIA compliant
- [ ] Tests: renderizado, acciones, dismiss" "phase-1,frontend,ui/ux,priority-high"

echo "✅ Fase 1 issues creados exitosamente!"
