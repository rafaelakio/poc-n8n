#!/usr/bin/env bash
# Valida se todos os arquivos *.json do repo sao JSON validos (usa jq).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v jq >/dev/null 2>&1; then
    echo "[test_workflows_json] jq nao instalado; pulando validacao."
    exit 0
fi

mapfile -t files < <(find . -type f -name '*.json' -not -path './.git/*' -not -path './.terraform/*')

if [ "${#files[@]}" -eq 0 ]; then
    echo "[test_workflows_json] nenhum arquivo JSON encontrado; ok."
    exit 0
fi

failed=0
for f in "${files[@]}"; do
    echo "[test_workflows_json] validando $f"
    if ! jq . "$f" >/dev/null; then
        echo "[test_workflows_json] FALHA em $f" >&2
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo "[test_workflows_json] ok."
