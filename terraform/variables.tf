# Variables for Recipe Cookbook Infrastructure

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "recipe-cookbook-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "norwayeast"

  validation {
    condition = contains([
      "norwayeast",
      "northeurope",
      "eastus",
      "westus",
      "uksouth",
      "centralus"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "recipe-cookbook"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
  default     = "recipe-cookbook-vm"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B1s"

  validation {
    condition = contains([
      "Standard_B1s",
      "Standard_B1ms",
      "Standard_B2s",
      "Standard_B2ms"
    ], var.vm_size)
    error_message = "VM size must be a valid B-series size."
  }
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
