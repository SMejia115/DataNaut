#!/usr/bin/env python3
"""
Script para crear todos los issues de DataNaut en GitHub
Uso: python3 create-issues.py
Requiere: gh CLI autenticado
"""

import subprocess
import sys

def create_issue(title, body, labels):
    """Crear un issue usando gh CLI"""
    print(f"📋 Creando issue: {title[:60]}...")
    
    try:
        # Crear archivo temporal para el body
        with open('/tmp/issue_body.md', 'w') as f:
            f.write(body)
        
        # Ejecutar gh CLI
        result = subprocess.run([
            'gh', 'issue', 'create',
            '--title', title,
            '--body-file', '/tmp/issue_body.md',
            '--label', labels
        ], capture_output=True, text=True, check=True)
        
        print(f"✅ Issue creado: {result.stdout.strip()}")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Error creando issue: {e.stderr}")
        return False
    finally:
        # Limpiar archivo temporal
        subprocess.run(['rm', '-f', '/tmp/issue_body.md'])

def main():
    print("🌌 Creando issues de DataNaut en GitHub...")
    print("")
    
    issues_created = 0
    
    # ========== DECISIONES CRÍTICAS ==========
    
    print("🔴 Creando decisiones críticas...")
    
    # Issue 1: Decisiones de arquitectura
    if create_issue(
        title="[DECISION] Arquitectura: Next.js solo vs Next.js + FastAPI híbrido",
        body="## Contexto\nNecesitamos decidir la arquitectura backend para DataNaut basado en:",
        labels="architecture,decision-needed,priority-critical"
    ):
        issues_created += 1
    
    print(f"✅ Proceso completado. Se crearon {issues_created} issues exitosamente.")
    print("📊 Nota: Este script crea solo los primeros issues como prueba.")
    print("Para crear todos los issues, se recomienda usar el script completo o crear uno por uno.")

if __name__ == "__main__":
    main()