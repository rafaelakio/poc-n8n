#!/usr/bin/env bash
# Valida diretorios terraform (fmt -check + validate sem backend).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v terraform >/dev/null 2>&1; then
    echo "[test_terraform] terraform nao instalado; pulando validacao."
    exit 0
fi

failed=0
for d in terraform/aws terraform/azure; do
    if [ ! -d "$d" ]; then
        continue
    fi
    echo "[test_terraform] validando $d"
    if ! terraform -chdir="$d" fmt -check -recursive; then
        echo "[test_terraform] fmt divergente em $d (apenas aviso)."
    fi
    if ! terraform -chdir="$d" init -backend=false -input=false -no-color >/dev/null; then
        echo "[test_terraform] FALHA no init de $d" >&2
        failed=1
        continue
    fi
    if ! terraform -chdir="$d" validate -no-color; then
        echo "[test_terraform] FALHA no validate de $d" >&2
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo "[test_terraform] ok."
