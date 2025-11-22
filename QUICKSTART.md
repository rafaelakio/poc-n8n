# Guia de Início Rápido - n8n HTTP Validator

## 3 Passos para Começar

### 1. Inicie o n8n (1 minuto)

```bash
cd poc-n8n
docker-compose up -d
```

Aguarde alguns segundos e acesse: http://localhost:5678

### 2. Faça Login (30 segundos)

- Usuário: `admin`
- Senha: `admin123`

### 3. Importe os Workflows (1 minuto)

1. Clique em "Workflows" no menu lateral
2. Clique em "Import from File"
3. Selecione `workflows/webhook-http-validator.json`
4. Repita para `workflows/http-status-validator.json`

## Teste Rápido

### Ative o Webhook Workflow

1. Abra o workflow "Webhook HTTP Validator"
2. Clique em "Active" no canto superior direito
3. Copie a URL do webhook (aparece no nó Webhook)

### Faça um Teste

```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}'
```

Você deve receber uma resposta JSON com o status da validação!

## Próximos Passos

- Leia o [README.md](README.md) completo
- Execute os testes em `examples/test-requests.sh` (Linux/Mac) ou `test-requests.bat` (Windows)
- Customize os workflows na interface do n8n
- Explore a [documentação oficial do n8n](https://docs.n8n.io/)

## Comandos Úteis

```bash
# Ver logs
docker-compose logs -f

# Parar n8n
docker-compose down

# Reiniciar
docker-compose restart
```
