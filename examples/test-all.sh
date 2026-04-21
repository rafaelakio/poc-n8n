#!/bin/bash
# test-all.sh

WEBHOOK_URL="http://localhost:5678/webhook/validate-url"
PASSED=0
FAILED=0

echo "=========================================="
echo "  Executando Testes Automatizados"
echo "=========================================="

test_status() {
    local status=$1
    local expected_success=$2
    local description=$3
    
    echo "Testando: $description"
    
    response=$(curl -s -X POST $WEBHOOK_URL \
        -H "Content-Type: application/json" \
        -d "{\"url\": \"https://httpbin.org/status/$status\"}")
    
    success=$(echo $response | jq -r '.success' 2>/dev/null)
    
    if [ "$success" == "$expected_success" ]; then
        echo "✓ PASSOU"
        ((PASSED++))
    else
        echo "✗ FALHOU"
        ((FAILED++))
    fi
}

test_status 200 "true" "Status 200 (Sucesso)"
test_status 404 "false" "Status 404 (Not Found)"
test_status 500 "false" "Status 500 (Server Error)"

echo "=========================================="
echo "Passou: $PASSED | Falhou: $FAILED"

if [ $FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi