variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-poc-n8n"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "poc-n8n"
}

variable "storage_account_name" {
  description = "Storage account name (must be globally unique, lowercase alphanumeric)"
  type        = string
  default     = "stpocn8n"
}

variable "app_service_name" {
  description = "App Service name (must be globally unique)"
  type        = string
  default     = "app-poc-n8n"
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "B1"
}

variable "app_service_always_on" {
  description = "Keep app always on"
  type        = bool
  default     = false
}

variable "n8n_basic_auth_user" {
  description = "n8n basic auth username"
  type        = string
  default     = "admin"
}

variable "n8n_basic_auth_password" {
  description = "n8n basic auth password"
  type        = string
  sensitive   = true
}

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "America/Sao_Paulo"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "poc-n8n"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
