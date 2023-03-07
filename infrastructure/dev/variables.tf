variable "owner" {
  type        = string
  default     = "owner"
  description = "The name of the owner of this example."
}

variable "project" {
  type        = string
  default     = "sample"
  description = "Project name"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Region"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags"
}

# Key Vault
variable "object_ids" {
  type        = list(string)
  default     = []
  description = "Object IDs"
}

variable "keyvault_sku" {
  type        = string
  default     = "standard"
  description = "Key Vault SKU"
}

# Database
variable "administrator_login" {
  type        = string
  description = "The administrator username of the SQL Server."
}


variable "database_sku" {
  type        = string
  default     = "GP_Standard_D2ds_v4"
  description = "Database SKU"
}

variable "database_zone" {
  type        = string
  default     = "3"
  description = "Database Zone"
}

# services
variable "web_app_sku_name" {
  type        = string
  default     = "B1"
  description = "SKU name"
}