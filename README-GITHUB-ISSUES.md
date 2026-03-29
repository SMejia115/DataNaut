# DataNaut - GitHub Issues Setup Guide

## 📋 Resumen

Se han creado **31 issues de GitHub** organizados por fases y prioridades para el desarrollo de DataNaut, un analizador automático de datasets.

## 📦 Archivos Generados

1. **datanaut-plan.md** - Plan de desarrollo completo en formato markdown
2. **datanaut-issues.json** - Todos los issues en formato JSON
3. **create-issues-from-json.py** - Script para crear los issues automáticamente
4. **create-issues.sh** - Script alternativo (obsoleto, no usar)
5. **create-issues.py** - Script alternativo (obsoleto, no usar)

## 🚀 Próximos Pasos

### Paso 1: Instalar y Autenticar GitHub CLI

```bash
# Instalar gh CLI
brew install gh

# Autenticarte (sigue las instrucciones)
gh auth login
```

### Paso 2: Crear los Issues

```bash
# Asegúrate de estar en el directorio del repo
cd /Users/smejia/Documents/repos/DataNaut

# Ejecutar el script
python3 create-issues-from-json.py
```

Esto creará todos los 31 issues en GitHub.

### Paso 3: Responder Decisiones Críticas

Los primeros 2 issues son **DECISIONES** que necesitas responder:

1. **[DECISION] Arquitectura** - Next.js solo vs Next.js + FastAPI
2. **[DECISION] Límites de seguridad** - PII detection, rate limiting, etc.

**⚠️ IMPORTANTE:** Responde estas decisiones primero antes de empezar el desarrollo.

## 📊 Estructura de Issues

### Decisiones Críticas (2 issues)
- `priority-critical` - Responder antes de empezar cualquier desarrollo

### Fase 1: Auto-Analysis Engine (14 issues)
- Issues #P101 a #P114 (ver datanaut-plan.md para detalles)
- Prioridad: HIGH
- Timeline: 2-3 semanas

### Fase 2: Dashboard Simplificado (4 issues)
- Issues #P201 a #P204
- Prioridad: MEDIUM-HIGH
- Timeline: 1 semana

### Fase 3: Backend Python (5 issues)
- Issues #P301 a #P305
- Prioridad: CONDITIONAL (solo si se necesita)

### Fase 4: Export & Share (2 issues)
- Issues #P401 a #P402
- Prioridad: MEDIUM

### Fase 5: Seguridad & Future-Proofing (4 issues)
- Issues #P501 a #P504
- Prioridad: MEDIUM-HIGH

## 🎯 Decisiones que Debes Tomar AHORA

Antes de empezar el desarrollo, responde:

1. **Tamaño máximo de datasets:** ¿10MB? ¿20MB? ¿100MB?
2. **Presupuesto:** ¿$0/mes? ¿$20/mes? ¿Más?
3. **Timeline:** ¿3 semanas (MVP rápido)? ¿5 semanas (completo)?
4. **ML Features:** ¿Necesitadas en MVP? (Sí/No)
5. **Seguridad:** ¿Manejará data sensible? (Sí/No)

## 📘 Documentación Complementaria

- **datanaut-plan.md** - Plan detallado con todas las fases, decisiones técnicas, métricas de éxito y próximos pasos
- **README.md** - Documentación original del proyecto

## 🛠️ Si no tienes gh CLI disponible

Si no puedes instalar gh CLI, puedes crear los issues manualmente:

1. Abre cada issue en GitHub manualmente
2. Copia/pega el título y contenido desde `datanaut-issues.json`
3. Asigna las labels correspondientes

**Nota:** Esto tomará tiempo. Recomiendo fuertemente instalar gh CLI.

## 🔄 Actualizaciones Futuras

Si necesitas regenerar los issues:

1. Modifica `datanaut-issues.json` si es necesario
2. Ejecuta de nuevo `python3 create-issues-from-json.py`
3. El script detectará duplicados y fallará si los issues ya existen

## 🤝 Soporte

Si encuentras problemas:
1. Verifica que `gh auth login` está configurado correctamente con `gh auth status`
2. Asegúrate de tener permisos en el repositorio
3. Ejecuta `gh issue list` para ver issues existentes

## 📊 Resumen de Estado

✅ **Completado:**
- [x] Análisis del código existente
- [x] Plan de desarrollo completo (31 issues)
- [x] Archivo datanaut-plan.md creado
- [x] Script de automatización creado
- [x] Decisiones documentadas

⏳ **Pendiente (tus acciones):**
- [ ] Instalar y autenticar gh CLI
- [ ] Ejecutar script para crear issues
- [ ] Responder decisiones críticas
- [ ] Comenzar desarrollo (Fase 1)

---

**Última actualización:** 2024-01-15  
**Total de issues:** 31  
**Complexidad:** Alto  
**Estado:** ✅ Listo para ejecución
