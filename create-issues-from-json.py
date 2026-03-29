#!/usr/bin/env python3
"""
Script para crear issues de DataNaut en GitHub desde un archivo JSON
Uso: python3 create-issues-from-json.py
Requiere: gh CLI autenticado (brew install gh && gh auth login)
"""

import json
import subprocess
import sys
from pathlib import Path

def main():
    json_path = Path('/Users/smejia/Documents/repos/DataNaut/datanaut-issues.json')
    
    if not json_path.exists():
        print("❌ Error: No se encontró datanaut-issues.json")
        sys.exit(1)
    
    with open(json_path, 'r') as f:
        data = json.load(f)
    
    issues = data.get('issues', [])
    total = len(issues)
    
    print(f"🌌 Creando {total} issues de DataNaut...")
    print("")
    
    created = 0
    failed = []
    
    for i, issue in enumerate(issues, 1):
        title = issue['title']
        body = issue['body']
        labels = issue['labels']
        
        print(f"[{i}/{total}] {title[:60]}...")
        
        try:
            # Crear archivo temporal para el body
            preview_body = body[:100] + "..." if len(body) > 100 else body
            with open('/tmp/issue_body.md', 'w') as f:
                f.write(body)
            
            # Crear el issue usando gh CLI
            result = subprocess.run([
                'gh', 'issue', 'create',
                '--title', title,
                '--body-file', '/tmp/issue_body.md',
                '--label', labels
            ], capture_output=True, text=True, check=True)
            
            print(f"✅ {result.stdout.strip()}")
            created += 1
            
        except subprocess.CalledProcessError as e:
            print(f"❌ Error: {e.stderr[:100]}")
            failed.append(f"{i}: {title[:50]}")
        except Exception as e:
            print(f"❌ Error inesperado: {str(e)}")
            failed.append(f"{i}: {title[:50]}")
    
    # Limpiar archivo temporal
    subprocess.run(['rm', '-f', '/tmp/issue_body.md'], capture_output=True)
    
    print("")
    print("="*50)
    print(f"✅ Issues creados exitosamente: {created}")
    
    if failed:
        print(f"❌ Issues fallidos: {len(failed)}")
        for f in failed:
            print(f"   - {f}")
    else:
        print("🎉 ¡Todos los issues creados con éxito!")
    
    print("")
    print("📋 Próximos pasos:")
    print("1. Revisa los issues creados en GitHub")
    print("2. Responde las decisiones críticas primero")
    print("3. Asigna prioridades y fechas")

if __name__ == "__main__":
    try:
        result = subprocess.run(['gh', '--version'], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ gh CLI no está instalado o no está autenticado.")
        print("📦 Instálalo con: brew install gh")
        print("🔐 Luego autentícate con: gh auth login")
        sys.exit(1)
    
    main()
