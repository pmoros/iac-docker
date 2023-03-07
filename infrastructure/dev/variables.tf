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