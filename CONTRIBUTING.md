# Guia de Contribuição - POC n8n

Obrigado por considerar contribuir com este projeto! Este documento fornece diretrizes para colaboração.

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Desenvolvimento Local](#desenvolvimento-local)
- [Criando Workflows](#criando-workflows)
- [Testando Workflows](#testando-workflows)
- [Processo de Pull Request](#processo-de-pull-request)
- [Padrões e Convenções](#padrões-e-convenções)

## 🤝 Código de Conduta

Este projeto adere a um código de conduta. Ao participar, você concorda em manter um ambiente respeitoso e colaborativo.

## 🚀 Como Contribuir

### 1. Fork e Clone

```bash
# Fork o repositório no GitHub
# Clone seu fork
git clone https://github.com/seu-usuario/poc-n8n.git
cd poc-n8n
```

### 2. Configure o Ambiente

```bash
# Inicie o n8n
docker-compose up -d

# Verifique se está rodando
docker-compose ps

# Acesse http://localhost:5678
```

### 3. Crie uma Branch

```bash
git checkout -b feature/minha-contribuicao
```

### 4. Faça suas Alterações

- Crie ou modifique workflows
- Atualize documentação
- Adicione testes

### 5. Teste suas Alterações

```bash
# Execute os testes
cd examples
chmod +x test-requests.sh
./test-requests.sh

# Ou no Windows
test-requests.bat
```

### 6. Commit e Push

```bash
git add .
git commit -m "feat: adiciona novo workflow de validação"
git push origin feature/minha-contribuicao
```

### 7. Abra um Pull Request

- Vá para o repositório original no GitHub
- Clique em "New Pull Request"
- Selecione sua branch
- Descreva suas alterações detalhadamente

## 📁 Estrutura do Projeto

```
poc-n8n/
├── docker-compose.yml          # Configuração do container n8n
├── .gitignore                  # Arquivos ignorados pelo Git
├── README.md                   # Documentação principal
├── QUICKSTART.md              # Guia de início rápido
├── WORKFLOWS.md               # Documentação dos workflows
├── CONTRIBUTING.md            # Este arquivo
├── TESTING.md                 # Guia de testes
├── workflows/                 # Workflows do n8n (JSON)
│   ├── webhook-http-validator.json
│   └── http-status-validator.json
├── credentials/               # Credenciais (não versionadas)
│   └── .gitkeep
└── examples/                  # Scripts de exemplo e teste
    ├── test-requests.sh
    └── test-requests.bat
```

## 💻 Desenvolvimento Local

### Requisitos

- Docker e Docker Compose
- Git
- Editor de texto ou IDE
- curl (para testes)

### Configuração Inicial

1. **Inicie o n8n**:
```bash
docker-compose up -d
```

2. **Acesse a interface**:
```
http://localhost:5678
```

3. **Faça login**:
- Usuário: `admin`
- Senha: `admin123`

4. **Importe workflows existentes**:
- Workflows → Import from File
- Selecione arquivos da pasta `workflows/`

### Desenvolvimento de Workflows

#### Criar Novo Workflow

1. Na interface do n8n, clique em "New Workflow"
2. Adicione e configure nodes
3. Teste o workflow
4. Exporte o workflow (JSON)
5. Salve na pasta `workflows/`

#### Modificar Workflow Existente

1. Abra o workflow na interface
2. Faça as modificações
3. Teste as mudanças
4. Exporte o workflow atualizado
5. Substitua o arquivo JSON em `workflows/`

### Estrutura de um Workflow JSON

```json
{
  "name": "Nome do Workflow",
  "nodes": [
    {
      "parameters": {
        // Configurações do node
      },
      "id": "identificador-unico",
      "name": "Nome do Node",
      "type": "n8n-nodes-base.tipo",
      "typeVersion": 1,
      "position": [x, y]
    }
  ],
  "connections": {
    "Node1": {
      "main": [
        [
          {
            "node": "Node2",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "settings": {},
  "staticData": null,
  "tags": []
}
```

## 🧪 Testando Workflows

### Testes Manuais

1. **Via Interface n8n**:
   - Abra o workflow
   - Clique em "Execute Workflow"
   - Forneça dados de teste
   - Verifique resultados

2. **Via Webhook (para workflows com webhook)**:
```bash
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://httpbin.org/status/200"}'
```

### Testes Automatizados

Execute os scripts de teste:

**Linux/Mac**:
```bash
cd examples
chmod +x test-requests.sh
./test-requests.sh
```

**Windows**:
```bash
cd examples
test-requests.bat
```

### Criar Novos Testes

Adicione novos casos de teste em `examples/`:

```bash
# Exemplo de novo teste
curl -X POST http://localhost:5678/webhook/validate-url \
  -H "Content-Type: application/json" \
  -d '{"url": "https://api.example.com/endpoint"}'
```

## 🔄 Processo de Pull Request

### Workflow de Branches

- Branches de feature devem usar os prefixos:
  - `feature/<descricao-curta>` para novas funcionalidades
  - `fix/<descricao-curta>` para correção de bugs
  - `chore/<descricao-curta>` para manutenção, CI, build, etc.
- Todo trabalho deve ser feito em um feature branch derivado de `main`.
- Abra um Pull Request contra `main`.
- Aguarde **pelo menos 1 aprovação** antes de fazer merge.
- O merge em `main` só ocorre após review e CI verde.

### Processo de Code Review

- Todo PR precisa de **ao menos 1 aprovação** de um code owner antes do merge.
- Reviewers devem verificar:
  - Aderência ao style guide e padrões do projeto
  - Cobertura de testes (quando aplicável)
  - Documentação atualizada
  - Ausência de credenciais ou segredos no código
- O autor do PR deve responder comentários e empurrar novos commits (nunca force-push em PRs em review).

### Como criar um PR

1. Use um título descritivo seguindo Conventional Commits (`feat: ...`, `fix: ...`, etc.).
2. Preencha **todo** o template de PR (`.github/pull_request_template.md`).
3. Vincule issues relacionadas com `Closes #123` ou `Refs #123`.
4. Verifique que `make test` e `pre-commit run --all-files` passam localmente.
5. Anexe screenshots quando houver mudanças visuais.

### Branch Protection (como configurar no GitHub)

Em `Settings → Branches → Add rule` para `main`, habilite:

- **Require a pull request before merging** → Require approvals: `1`
- **Require status checks to pass before merging** → selecione o job `validate` do workflow `CI`
- **Require branches to be up to date before merging**
- **Include administrators**
- (Recomendado) **Do not allow bypassing the above settings**

### Checklist

Antes de submeter um PR, verifique:

- [ ] Workflow foi testado manualmente
- [ ] Testes automatizados passam
- [ ] Documentação foi atualizada
- [ ] Arquivo JSON está formatado corretamente
- [ ] Commit messages são descritivas
- [ ] Não há credenciais no código
- [ ] .gitignore está atualizado

### Formato de Commit Messages

Use o padrão Conventional Commits:

```
tipo(escopo): descrição curta

Descrição mais detalhada se necessário.

Fixes #123
```

**Tipos (Conventional Commits):**
- `feat`: Nova funcionalidade (novo workflow, node)
- `fix`: Correção de bug
- `docs`: Alterações na documentação
- `refactor`: Refatoração de workflow
- `test`: Adição ou correção de testes
- `chore`: Tarefas de manutenção
- `ci`: Mudanças em pipelines de CI/CD
- `build`: Mudanças em build, dependências, Docker, Terraform

**Exemplos:**

```
feat(workflow): adiciona validação de status 3xx

Implementa novo workflow para detectar e tratar redirects HTTP.
Inclui testes e documentação.

Closes #45
```

```
fix(webhook): corrige timeout em requisições longas

Aumenta timeout de 10s para 30s para APIs lentas.

Fixes #67
```

## 📝 Padrões e Convenções

### Nomenclatura de Workflows

- Use kebab-case: `webhook-http-validator`
- Seja descritivo: `email-notification-on-error`
- Evite abreviações: `http-status-validator` (não `http-stat-val`)

### Nomenclatura de Nodes

- Use PascalCase ou Title Case
- Seja claro: `HTTP Request`, `Status 200?`
- Indique ação: `Send Email`, `Save to Database`

### Organização de Nodes

- Fluxo da esquerda para direita
- Espaçamento consistente (200px horizontal)
- Agrupe nodes relacionados
- Use cores para categorizar (se disponível)

### Documentação de Workflows

Cada workflow deve ter:

1. **Descrição clara** no campo "description"
2. **Tags apropriadas** para categorização
3. **Comentários** em nodes complexos
4. **Documentação** em WORKFLOWS.md

### Exemplo de Documentação

```markdown
## Nome do Workflow

### Descrição
Breve descrição do que o workflow faz.

### Trigger
- Tipo: Webhook/Manual/Schedule
- Configuração específica

### Input
```json
{
  "campo": "valor"
}
```

### Output
```json
{
  "resultado": "valor"
}
```

### Casos de Uso
- Caso 1
- Caso 2
```

## 🎯 Áreas para Contribuição

### Novos Workflows

- [ ] Validação de status 3xx (redirects)
- [ ] Validação de status 5xx (server errors)
- [ ] Monitoramento contínuo de URLs
- [ ] Integração com banco de dados
- [ ] Notificações por email/Slack
- [ ] Dashboard de métricas
- [ ] Batch validation de múltiplas URLs

### Melhorias nos Workflows Existentes

- [ ] Adicionar retry logic
- [ ] Implementar rate limiting
- [ ] Adicionar logging detalhado
- [ ] Melhorar tratamento de erros
- [ ] Adicionar validação de input
- [ ] Implementar cache de resultados

### Documentação

- [ ] Tutoriais passo a passo
- [ ] Vídeos explicativos
- [ ] Diagramas de fluxo
- [ ] Exemplos de integração
- [ ] FAQ expandido
- [ ] Tradução para outros idiomas

### Testes

- [ ] Testes de integração
- [ ] Testes de performance
- [ ] Testes de carga
- [ ] Validação de edge cases
- [ ] Testes de segurança

## 🔧 Ferramentas Úteis

### Desenvolvimento

- **n8n Desktop**: Aplicação desktop do n8n
- **Postman**: Para testar webhooks
- **curl**: Para testes via linha de comando
- **jq**: Para formatar JSON no terminal

### Debugging

```bash
# Ver logs do n8n
docker-compose logs -f

# Ver logs específicos
docker-compose logs -f n8n

# Entrar no container
docker-compose exec n8n sh
```

### Validação de JSON

```bash
# Validar JSON com jq
cat workflows/webhook-http-validator.json | jq .

# Formatar JSON
cat workflows/webhook-http-validator.json | jq . > formatted.json
```

## 🐛 Reportando Bugs

### Template de Bug Report

```markdown
**Descrição do Bug**
Descrição clara e concisa do problema.

**Workflow Afetado**
Nome do workflow onde o bug ocorre.

**Como Reproduzir**
1. Execute o workflow
2. Forneça input '...'
3. Observe erro '...'

**Comportamento Esperado**
O que deveria acontecer.

**Comportamento Atual**
O que está acontecendo.

**Logs**
```
Cole logs relevantes aqui
```

**Ambiente:**
- n8n version: [ex: 1.0.0]
- Docker version: [ex: 20.10.0]
- OS: [Windows 10, Ubuntu 20.04, etc]

**Contexto Adicional**
Qualquer outra informação relevante.
```

## 💡 Sugerindo Melhorias

### Template de Feature Request

```markdown
**Problema a Resolver**
Descrição clara do problema ou necessidade.

**Solução Proposta**
Como você imagina que isso deveria funcionar.

**Workflow Exemplo**
Descrição ou diagrama do workflow proposto.

**Alternativas Consideradas**
Outras abordagens que você considerou.

**Contexto Adicional**
Screenshots, exemplos, referências, etc.
```

## 📚 Recursos Úteis

- [Documentação n8n](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [n8n GitHub](https://github.com/n8n-io/n8n)
- [n8n Workflow Templates](https://n8n.io/workflows)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ Dúvidas

Se tiver dúvidas sobre como contribuir:

1. Abra uma issue com a tag `question`
2. Descreva sua dúvida claramente
3. Aguarde resposta da comunidade

## 🙏 Agradecimentos

Obrigado por contribuir! Sua ajuda torna este projeto melhor para todos.

---

**Nota**: Este é um projeto educacional. Sinta-se livre para experimentar e aprender!
