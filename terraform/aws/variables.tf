variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "poc-n8n"
}

variable "task_cpu" {
  description = "CPU units for ECS task"
  type        = string
  default     = "512"
}

variable "task_memory" {
  description = "Memory for ECS task"
  type        = string
  default     = "1024"
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
