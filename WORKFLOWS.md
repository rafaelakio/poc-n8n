# Documentação dos Workflows

## 1. Webhook HTTP Validator

### Descrição
Workflow acionado por webhook que valida o status HTTP de URLs fornecidas via POST request.

### Trigger
- **Tipo**: Webhook
- **Método**: POST
- **Path**: `/validate-url`
- **URL Completa**: `http://localhost:5678/webhook/validate-url`

### Input Esperado
```json
{
  "url": "https://example.com"
}
```

### Fluxo de Execução

1. **Webhook Node**
   - Recebe requisição POST
   - Extrai URL do body

2. **HTTP Request Node**
   - Faz requisição para a URL fornecida
   - Timeout: 10 segundos
   - Continue on fail: true (não para em erro)

3. **Status 200? (IF Node)**
   - Verifica se statusCode === 200
   - **True**: Vai para Response 200
   - **False**: Vai para próxima verificação

4. **Status 4xx? (IF Node)**
   - Verifica se statusCode >= 400 e < 500
   - **True**: Vai para Response 4xx
   - **False**: Vai para Response Other

5. **Response Nodes**
   - Retorna JSON estruturado com resultado

### Outputs

#### Sucesso (200)
```json
{
  "success": true,
  "status": 200,
  "message": "Request successful",
  "url": "https://example.com",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

#### Erro 4xx
```json
{
  "success": false,
  "status": 404,
  "message": "Client error detected",
  "error_type": "Not Found",
  "url": "https://example.com",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

#### Outros Erros
```json
{
  "success": false,
  "status": 500,
  "message": "Other error or status",
  "url": "https://example.com",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### Casos de Uso

- Monitoramento de APIs
- Validação de URLs em formulários
- Health checks automatizados
- Integração com sistemas externos

---

## 2. HTTP Status Validator

### Descrição
Workflow manual para validação de status HTTP com processamento detalhado.

### Trigger
- **Tipo**: Manual
- **Execução**: Via interface do n8n

### Input Esperado
```json
{
  "url": "https://example.com"
}
```

### Fluxo de Execução

1. **Start Node**
   - Trigger manual
   - Fornece URL via input

2. **HTTP Request Node**
   - Faz requisição HTTP
   - Timeout: 10 segundos
   - Allow unauthorized certs: true
   - Continue on fail: true

3. **Status 200? (IF Node)**
   - Verifica se statusCode === 200
   - **True**: Success Handler
   - **False**: Próxima verificação

4. **Status 4xx? (IF Node)**
   - Verifica se statusCode >= 400 e < 500
   - **True**: 4xx Error Handler
   - **False**: Other Error Handler

5. **Handler Nodes (SET)**
   - Estruturam dados de resposta
   - Adicionam informações contextuais

6. **Merge Results**
   - Combina todos os resultados
   - Output unificado

### Outputs

#### Success Handler
```json
{
  "status": "success",
  "message": "Request successful - Status 200",
  "url": "https://example.com",
  "statusCode": "200"
}
```

#### 4xx Error Handler
```json
{
  "status": "client_error",
  "message": "Client error - Status 4xx",
  "url": "https://example.com",
  "statusCode": "404",
  "error_type": "Not Found"
}
```

#### Other Error Handler
```json
{
  "status": "other_error",
  "message": "Other HTTP status or error",
  "url": "https://example.com",
  "statusCode": "500"
}
```

### Casos de Uso

- Testes manuais de URLs
- Debugging de integrações
- Validação de endpoints
- Análise de respostas HTTP

---

## Comparação dos Workflows

| Característica | Webhook Validator | Status Validator |
|----------------|-------------------|------------------|
| Trigger | Webhook (automático) | Manual |
| Input | POST body | Interface n8n |
| Output | Webhook response | Dados processados |
| Uso | Produção/Integração | Desenvolvimento/Teste |
| Merge | Não | Sim |

## Customizações Possíveis

### Adicionar Mais Status Codes

Adicione novos IF nodes para verificar:
- 3xx (Redirects)
- 5xx (Server Errors)
- Timeouts específicos

### Adicionar Notificações

Conecte nodes de:
- Email
- Slack
- Discord
- Telegram

### Adicionar Logging

Conecte nodes de:
- Google Sheets
- Database
- File System

### Adicionar Retry Logic

Use o node "Split In Batches" com loop para:
- Tentar múltiplas vezes
- Backoff exponencial
- Alertas após X falhas

## Melhores Práticas

1. **Timeouts**: Configure timeouts apropriados (10-30s)
2. **Error Handling**: Sempre use "Continue on Fail"
3. **Logging**: Adicione nodes de log para debugging
4. **Validação**: Valide input antes de fazer requests
5. **Rate Limiting**: Adicione delays entre requests em batch
6. **Segurança**: Não exponha webhooks sem autenticação em produção

## Troubleshooting

### Webhook não responde
- Verifique se o workflow está ativo
- Confirme a URL do webhook
- Teste com curl primeiro

### HTTP Request falha
- Verifique conectividade
- Teste a URL manualmente
- Aumente o timeout
- Verifique certificados SSL

### IF nodes não funcionam
- Verifique expressões
- Use console.log para debug
- Teste valores manualmente
