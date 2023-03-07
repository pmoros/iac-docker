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

# Storage Account
variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "The tier of the storage account."
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "The replication type of the storage account."
}
