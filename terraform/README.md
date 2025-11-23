# Terraform - POC n8n

Configurações Terraform para deploy do n8n na AWS e Azure.

## 📁 Estrutura

```
terraform/
├── aws/                    # Configuração AWS
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
└── azure/                  # Configuração Azure
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform.tfvars.example
```

## 🚀 Deploy na AWS

### Recursos Criados

- VPC com subnets públicas
- ECS Fargate Cluster
- Application Load Balancer
- EFS (Elastic File System) para dados persistentes
- CloudWatch Logs
- IAM Roles

### Deploy

```bash
cd terraform/aws

# Copiar e editar variáveis
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars (especialmente n8n_basic_auth_password)

# Inicializar e aplicar
terraform init
terraform plan
terraform apply
```

### Acessar n8n

```bash
# Obter URL
terraform output application_url

# Credenciais padrão:
# Usuário: admin
# Senha: (definida em terraform.tfvars)
```

## 🔷 Deploy no Azure

### Recursos Criados

- Resource Group
- Storage Account com Azure Files
- App Service Plan
- App Service (Web App for Containers)
- Application Insights

### Deploy

```bash
cd terraform/azure

# Login no Azure
az login

# Copiar e editar variáveis
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars (storage_account_name deve ser único)

# Inicializar e aplicar
terraform init
terraform plan
terraform apply
```

### Acessar n8n

```bash
# Obter URL
terraform output app_service_url

# Credenciais padrão:
# Usuário: admin
# Senha: (definida em terraform.tfvars)
```

## 🔧 Configuração

### Variáveis Importantes

**AWS:**
- `n8n_basic_auth_user`: Usuário de autenticação
- `n8n_basic_auth_password`: Senha (altere!)
- `timezone`: Fuso horário (padrão: America/Sao_Paulo)

**Azure:**
- `storage_account_name`: Nome único para Storage Account
- `app_service_name`: Nome único para App Service
- `n8n_basic_auth_password`: Senha (altere!)

## 📊 Dados Persistentes

**AWS:** Usa EFS montado em `/home/node/.n8n`
**Azure:** Usa Azure Files montado em `/home/node/.n8n`

Os workflows e credenciais são persistidos automaticamente.

## 🗑️ Destruir Recursos

```bash
# AWS
cd terraform/aws
terraform destroy

# Azure
cd terraform/azure
terraform destroy
```

## 💰 Custos Estimados

**AWS:**
- ECS Fargate: ~$15-30/mês
- ALB: ~$20/mês
- EFS: ~$3/mês
- Total: ~$38-53/mês

**Azure:**
- App Service B1: ~$13/mês
- Storage Account: ~$2/mês
- Total: ~$15/mês

## 🔒 Segurança

- Altere a senha padrão em produção
- Configure HTTPS (adicione certificado SSL)
- Restrinja acesso por IP se necessário
- Use Azure Key Vault ou AWS Secrets Manager para senhas
