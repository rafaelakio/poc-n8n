#!/bin/bash
# Script de teste para o webhook HTTP validator

echo "=========================================="
echo "  n8n HTTP Validator - Testes"
echo "=========================================="
echo ""

WEBHOOK_URL="http://localhost:5678/webhook/validate-url"

echo "1. Testando Status 200 (Sucesso)"
echo "------------------------------------------"
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}' \
  | python -m json.tool
echo ""
echo ""

echo "2. Testando Status 404 (Not Found)"
echo "------------------------------------------"
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/404"}' \
  | python -m json.tool
echo ""
echo ""

echo "3. Testando Status 401 (Unauthorized)"
echo "------------------------------------------"
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/401"}' \
  | python -m json.tool
echo ""
echo ""

echo "4. Testando Status 403 (Forbidden)"
echo "------------------------------------------"
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/403"}' \
  | python -m json.tool
echo ""
echo ""

echo "5. Testando Status 500 (Server Error)"
echo "------------------------------------------"
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/500"}' \
  | python -m json.tool
echo ""
echo ""

echo "=========================================="
echo "  Testes Concluídos!"
echo "=========================================="
