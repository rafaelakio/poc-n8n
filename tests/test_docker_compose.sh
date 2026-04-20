#!/usr/bin/env bash
# Valida sintaticamente todos os arquivos docker-compose*.y?ml do repo.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "[test_docker_compose] procurando arquivos docker-compose..."
mapfile -t files < <(find . -type f \( -name 'docker-compose*.yml' -o -name 'docker-compose*.yaml' \) -not -path './.git/*')

if [ "${#files[@]}" -eq 0 ]; then
    echo "[test_docker_compose] nenhum arquivo docker-compose encontrado; ok."
    exit 0
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "[test_docker_compose] docker nao instalado; pulando validacao."
    exit 0
fi

failed=0
for f in "${files[@]}"; do
    echo "[test_docker_compose] validando $f"
    if ! docker compose -f "$f" config -q; then
        echo "[test_docker_compose] FALHA em $f" >&2
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo "[test_docker_compose] ok."
