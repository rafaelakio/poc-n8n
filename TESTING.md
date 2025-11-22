# Guia de Testes - POC n8n

Este documento descreve como testar os workflows localmente e garantir que tudo funciona corretamente.

## 📋 Índice

- [Configuração do Ambiente de Teste](#configuração-do-ambiente-de-teste)
- [Testes Manuais](#testes-manuais)
- [Testes Automatizados](#testes-automatizados)
- [Testes de Integração](#testes-de-integração)
- [Validação de Workflows](#validação-de-workflows)
- [Troubleshooting](#troubleshooting)

## 🔧 Configuração do Ambiente de Teste

### Pré-requisitos

- Docker e Docker Compose instalados
- curl instalado
- jq instalado (opcional, para formatar JSON)
- Postman ou similar (opcional)

### Iniciar Ambiente de Teste

```bash
# 1. Navegue até o diretório
cd poc-n8n

# 2. Inicie o n8n
docker-compose up -d

# 3. Aguarde o n8n iniciar (10-15 segundos)
sleep 15

# 4. Verifique se está rodando
docker-compose ps

# 5. Verifique logs
docker-compose logs -f n8n
```

### Verificar Saúde do Sistema

```bash
# Verificar se n8n está respondendo
curl http://localhost:5678

# Deve retornar HTML da página de login
```

## 🧪 Testes Manuais

### 1. Teste via Interface n8n

#### Passo a Passo

1. **Acesse a interface**:
   ```
   http://localhost:5678
   ```

2. **Faça login**:
   - Usuário: `admin`
   - Senha: `admin123`

3. **Importe o workflow**:
   - Workflows → Import from File
   - Selecione `workflows/http-status-validator.json`

4. **Execute o workflow**:
   - Abra o workflow importado
   - Clique em "Execute Workflow"
   - No node "Start", adicione:
   ```json
   {
     "url": "https://httpbin.org/status/200"
   }
   ```

5. **Verifique resultados**:
   - Cada node deve mostrar dados processados
   - Node "Merge Results" deve ter output final

#### Casos de Teste

**Teste 1: Status 200 (Sucesso)**
```json
Input: {"url": "https://httpbin.org/status/200"}
Esperado: status = "success"
```

**Teste 2: Status 404 (Not Found)**
```json
Input: {"url": "https://httpbin.org/status/404"}
Esperado: status = "client_error", error_type = "Not Found"
```

**Teste 3: Status 401 (Unauthorized)**
```json
Input: {"url": "https://httpbin.org/status/401"}
Esperado: status = "client_error", error_type = "Unauthorized"
```

**Teste 4: Status 500 (Server Error)**
```json
Input: {"url": "https://httpbin.org/status/500"}
Esperado: status = "other_error"
```

### 2. Teste via Webhook

#### Ativar Webhook

1. Importe `workflows/webhook-http-validator.json`
2. Abra o workflow
3. Clique em "Active" no canto superior direito
4. Copie a URL do webhook (aparece no node Webhook)

#### Executar Testes

**Teste 1: Status 200**
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}'
```

**Resposta Esperada:**
```json
{
  "success": true,
  "status": 200,
  "message": "Request successful",
  "url": "https://httpbin.org/status/200",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**Teste 2: Status 404**
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/404"}'
```

**Resposta Esperada:**
```json
{
  "success": false,
  "status": 404,
  "message": "Client error detected",
  "error_type": "Not Found",
  "url": "https://httpbin.org/status/404",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

## 🤖 Testes Automatizados

### Script de Teste Completo (Linux/Mac)

```bash
#!/bin/bash
# test-all.sh

WEBHOOK_URL="http://localhost:5678/webhook/validate-url"
PASSED=0
FAILED=0

echo "=========================================="
echo "  Executando Testes Automatizados"
echo "=========================================="
echo ""

# Função para testar
test_status() {
    local status=$1
    local expected_success=$2
    local description=$3
    
    echo "Testando: $description"
    
    response=$(curl -s -X POST $WEBHOOK_URL \
        -H "Content-Type: application/json" \
        -d "{\"url\": \"https://httpbin.org/status/$status\"}")
    
    success=$(echo $response | jq -r '.success')
    
    if [ "$success" == "$expected_success" ]; then
        echo "✓ PASSOU"
        ((PASSED++))
    else
        echo "✗ FALHOU"
        echo "  Resposta: $response"
        ((FAILED++))
    fi
    echo ""
}

# Executar testes
test_status 200 "true" "Status 200 (Sucesso)"
test_status 404 "false" "Status 404 (Not Found)"
test_status 401 "false" "Status 401 (Unauthorized)"
test_status 403 "false" "Status 403 (Forbidden)"
test_status 500 "false" "Status 500 (Server Error)"

# Resumo
echo "=========================================="
echo "  Resumo dos Testes"
echo "=========================================="
echo "Passou: $PASSED"
echo "Falhou: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✓ Todos os testes passaram!"
    exit 0
else
    echo "✗ Alguns testes falharam"
    exit 1
fi
```

### Script de Teste Completo (Windows)

```batch
@echo off
REM test-all.bat

set WEBHOOK_URL=http://localhost:5678/webhook/validate-url
set PASSED=0
set FAILED=0

echo ==========================================
echo   Executando Testes Automatizados
echo ==========================================
echo.

REM Teste 1: Status 200
echo Testando: Status 200 (Sucesso)
curl -s -X POST %WEBHOOK_URL% -H "Content-Type: application/json" -d "{\"url\": \"https://httpbin.org/status/200\"}" > response.json
findstr /C:"\"success\": true" response.json > nul
if %errorlevel% equ 0 (
    echo [PASS] PASSOU
    set /a PASSED+=1
) else (
    echo [FAIL] FALHOU
    set /a FAILED+=1
)
echo.

REM Teste 2: Status 404
echo Testando: Status 404 (Not Found)
curl -s -X POST %WEBHOOK_URL% -H "Content-Type: application/json" -d "{\"url\": \"https://httpbin.org/status/404\"}" > response.json
findstr /C:"\"success\": false" response.json > nul
if %errorlevel% equ 0 (
    echo [PASS] PASSOU
    set /a PASSED+=1
) else (
    echo [FAIL] FALHOU
    set /a FAILED+=1
)
echo.

REM Resumo
echo ==========================================
echo   Resumo dos Testes
echo ==========================================
echo Passou: %PASSED%
echo Falhou: %FAILED%
echo.

del response.json

if %FAILED% equ 0 (
    echo [OK] Todos os testes passaram!
    exit /b 0
) else (
    echo [ERROR] Alguns testes falharam
    exit /b 1
)
```

## 🔗 Testes de Integração

### Teste de Timeout

```bash
# Teste com URL que demora a responder
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/delay/5"}'
```

### Teste de URL Inválida

```bash
# Teste com URL malformada
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "not-a-valid-url"}'
```

### Teste de Redirect

```bash
# Teste com redirect
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/redirect/1"}'
```

### Teste de SSL

```bash
# Teste com certificado SSL inválido
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://self-signed.badssl.com/"}'
```

## ✅ Validação de Workflows

### Checklist de Validação

- [ ] Workflow importa sem erros
- [ ] Todos os nodes estão conectados corretamente
- [ ] Workflow executa sem erros
- [ ] Output está no formato esperado
- [ ] Tratamento de erros funciona
- [ ] Timeout está configurado apropriadamente
- [ ] Webhook responde corretamente (se aplicável)

### Validar JSON do Workflow

```bash
# Validar sintaxe JSON
cat workflows/webhook-http-validator.json | jq .

# Se retornar erro, o JSON está inválido
```

### Validar Estrutura do Workflow

```bash
# Verificar campos obrigatórios
cat workflows/webhook-http-validator.json | jq '.name, .nodes, .connections'

# Verificar se todos os nodes têm ID único
cat workflows/webhook-http-validator.json | jq '.nodes[].id'
```

## 🐛 Troubleshooting

### Problema: Webhook não responde

**Diagnóstico:**
```bash
# 1. Verificar se workflow está ativo
# Na interface: Workflow deve mostrar "Active"

# 2. Verificar logs
docker-compose logs -f n8n

# 3. Testar conectividade
curl http://localhost:5678
```

**Solução:**
- Ative o workflow na interface
- Verifique se a URL do webhook está correta
- Reinicie o n8n: `docker-compose restart`

### Problema: HTTP Request falha

**Diagnóstico:**
```bash
# Testar URL diretamente
curl -v https://httpbin.org/status/200

# Verificar timeout
# Na interface: HTTP Request node → Options → Timeout
```

**Solução:**
- Aumente o timeout (padrão: 10000ms)
- Verifique conectividade de rede
- Teste URL em navegador

### Problema: IF node não funciona

**Diagnóstico:**
```bash
# Verificar expressão no IF node
# Na interface: IF node → Conditions

# Testar expressão manualmente
# Use console.log no Code node
```

**Solução:**
- Verifique sintaxe da expressão
- Use operadores corretos (===, >=, etc)
- Teste com valores conhecidos

### Problema: JSON inválido

**Diagnóstico:**
```bash
# Validar JSON
cat workflows/webhook-http-validator.json | jq .
```

**Solução:**
- Use editor com validação JSON
- Exporte workflow novamente do n8n
- Verifique vírgulas e chaves

## 📊 Métricas de Teste

### Cobertura de Testes

- ✅ Status 200 (Sucesso)
- ✅ Status 4xx (Client Errors)
  - ✅ 400 Bad Request
  - ✅ 401 Unauthorized
  - ✅ 403 Forbidden
  - ✅ 404 Not Found
- ✅ Status 5xx (Server Errors)
- ✅ Timeout
- ✅ URL inválida
- ⚠️ Redirect (parcial)
- ⚠️ SSL inválido (parcial)

### Performance

```bash
# Teste de performance simples
time curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}'

# Deve responder em < 2 segundos
```

### Teste de Carga

```bash
# Teste com múltiplas requisições simultâneas
for i in {1..10}; do
  curl -X POST http://localhost:5678/webhook/validate-url \
    -H "Content-Type: application/json" \
    -d '{"url": "https://httpbin.org/status/200"}' &
done
wait
```

## 📝 Relatório de Testes

### Template de Relatório

```markdown
# Relatório de Testes - [Data]

## Ambiente
- n8n version: 1.0.0
- Docker version: 20.10.0
- OS: Ubuntu 20.04

## Testes Executados
- Total: 10
- Passou: 9
- Falhou: 1

## Detalhes

### Passou
- ✓ Status 200
- ✓ Status 404
- ✓ Status 401
- ✓ Status 403
- ✓ Status 500
- ✓ Timeout
- ✓ URL inválida
- ✓ Webhook response
- ✓ JSON format

### Falhou
- ✗ SSL inválido
  - Erro: Connection refused
  - Ação: Investigar configuração SSL

## Conclusão
Sistema está 90% funcional. Necessário corrigir tratamento de SSL.
```

## 🔄 CI/CD (Futuro)

### GitHub Actions (Exemplo)

```yaml
name: Test Workflows

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Start n8n
        run: docker-compose up -d
      
      - name: Wait for n8n
        run: sleep 15
      
      - name: Run tests
        run: |
          cd examples
          chmod +x test-all.sh
          ./test-all.sh
      
      - name: Stop n8n
        run: docker-compose down
```

## 📚 Recursos Adicionais

- [n8n Testing Guide](https://docs.n8n.io/workflows/testing/)
- [curl Documentation](https://curl.se/docs/)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [Postman Learning Center](https://learning.postman.com/)

---

**Nota**: Sempre teste em ambiente local antes de fazer deploy em produção!
