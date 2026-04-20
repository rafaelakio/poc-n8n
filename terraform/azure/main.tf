# Terraform para POC n8n - Azure
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.69"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Storage Account for persistent data
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_share" "n8n_data" {
  name                 = "n8n-data"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 5
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku

  tags = var.tags
}

# App Service (Web App for Containers)
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  site_config {
    always_on = var.app_service_always_on

    application_stack {
      docker_image     = "n8nio/n8n"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    "N8N_BASIC_AUTH_USER"                 = var.n8n_basic_auth_user
    "N8N_BASIC_AUTH_PASSWORD"             = var.n8n_basic_auth_password
    "N8N_PORT"                            = "5678"
    "GENERIC_TIMEZONE"                    = var.timezone
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITES_PORT"                       = "5678"
  }

  storage_account {
    name         = "n8ndata"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.main.name
    access_key   = azurerm_storage_account.main.primary_access_key
    share_name   = azurerm_storage_share.n8n_data.name
    mount_path   = "/home/node/.n8n"
  }

  tags = var.tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "${var.project_name}-insights"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  application_type    = "web"

  tags = var.tags
}
