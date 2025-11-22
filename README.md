# POC n8n - HTTP Status Validator

Projeto de prova de conceito (POC) usando n8n para validar status HTTP 200 e 4xx de URLs.

## 📋 Visão Geral

Este projeto demonstra como usar n8n para criar workflows automatizados que:
- Fazem requisições HTTP para URLs
- Validam status code 200 (sucesso)
- Detectam e tratam erros 4xx (client errors)
- Respondem com informações estruturadas

## 🎯 Workflows Incluídos

### 1. Webhook HTTP Validator
Workflow acionado por webhook que valida URLs via POST request.

**Características:**
- Trigger: Webhook POST
- Valida status 200
- Detecta erros 4xx (400-499)
- Retorna resposta JSON estruturada

### 2. HTTP Status Validator
Workflow manual para validação de status HTTP.

**Características:**
- Trigger: Manual
- Valida status 200
- Detecta erros 4xx
- Merge de resultados

## 🚀 Início Rápido

### Pré-requisitos

- Docker e Docker Compose instalados
- Porta 5678 disponível

### Instalação

1. Clone ou navegue até o diretório:
```bash
cd poc-n8n
```

2. Inicie o n8n com Docker Compose:
```bash
docker-compose up -d
```

3. Acesse a interface:
```
http://localhost:5678
```

4. Faça login:
- Usuário: `admin`
- Senha: `admin123`

### Importar Workflows

1. Na interface do n8n, clique em "Workflows" → "Import from File"
2. Importe os arquivos da pasta `workflows/`:
   - `webhook-http-validator.json`
   - `http-status-validator.json`

## 📖 Como Usar

### Webhook HTTP Validator

1. Ative o workflow na interface do n8n
2. Copie a URL do webhook gerada
3. Faça uma requisição POST:

```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}'
```

**Resposta para Status 200:**
```json
{
  "success": true,
  "status": 200,
  "message": "Request successful",
  "url": "https://httpbin.org/status/200",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**Resposta para Status 4xx:**
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

### HTTP Status Validator

1. Abra o workflow na interface
2. Clique em "Execute Workflow"
3. Forneça uma URL no input
4. Veja os resultados processados

## 🔧 Estrutura do Projeto

```
poc-n8n/
├── docker-compose.yml          # Configuração Docker
├── .gitignore                  # Arquivos ignorados
├── README.md                   # Esta documentação
├── workflows/                  # Workflows do n8n
│   ├── webhook-http-validator.json
│   └── http-status-validator.json
├── credentials/                # Credenciais (vazio por padrão)
│   └── .gitkeep
└── examples/                   # Exemplos de uso
    └── test-requests.sh
```

## 📊 Fluxo dos Workflows

### Webhook HTTP Validator

```
Webhook (POST)
    ↓
HTTP Request
    ↓
Status 200? ─── Sim ──→ Response 200
    ↓
   Não
    ↓
Status 4xx? ─── Sim ──→ Response 4xx
    ↓
   Não
    ↓
Response Other
```

### HTTP Status Validator

```
Start (Manual)
    ↓
HTTP Request
    ↓
Status 200? ─── Sim ──→ Success Handler ──┐
    ↓                                      │
   Não                                     │
    ↓                                      ↓
Status 4xx? ─── Sim ──→ 4xx Handler ────→ Merge
    ↓                                      ↑
   Não                                     │
    ↓                                      │
Other Handler ─────────────────────────────┘
```

## 🧪 Exemplos de Teste

### Testar Status 200
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}'
```

### Testar Status 404
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/404"}'
```

### Testar Status 401
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/401"}'
```

### Testar Status 403
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/403"}'
```

### Testar Status 500
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/500"}'
```

## ⚙️ Configuração

### Variáveis de Ambiente

Edite `docker-compose.yml` para customizar:

```yaml
environment:
  - N8N_BASIC_AUTH_USER=seu_usuario
  - N8N_BASIC_AUTH_PASSWORD=sua_senha
  - N8N_PORT=5678
  - GENERIC_TIMEZONE=America/Sao_Paulo
```

### Portas

Para mudar a porta padrão (5678):

```yaml
ports:
  - "8080:5678"  # Acesse via localhost:8080
```

## 🛠️ Comandos Úteis

### Iniciar n8n
```bash
docker-compose up -d
```

### Parar n8n
```bash
docker-compose down
```

### Ver logs
```bash
docker-compose logs -f
```

### Reiniciar n8n
```bash
docker-compose restart
```

### Remover tudo (incluindo dados)
```bash
docker-compose down -v
```

## 📝 Notas

- Os workflows são salvos automaticamente no volume Docker
- Credenciais devem ser configuradas na interface do n8n
- O webhook URL muda se você recriar o container

## 🔒 Segurança

- Altere as credenciais padrão em produção
- Use HTTPS em ambientes de produção
- Configure firewall apropriadamente
- Não exponha a porta 5678 publicamente sem proteção

## 🐛 Troubleshooting

### n8n não inicia
```bash
# Verifique se a porta está em uso
netstat -ano | findstr :5678

# Verifique logs
docker-compose logs
```

### Webhook não responde
- Verifique se o workflow está ativo
- Confirme a URL do webhook
- Verifique logs do container

### Erro de permissão
```bash
# Linux/Mac: ajuste permissões
sudo chown -R 1000:1000 ./workflows
```

## 📚 Recursos Adicionais

- [Documentação n8n](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [n8n GitHub](https://github.com/n8n-io/n8n)

## 📄 Licença

Este projeto é fornecido como exemplo educacional.
