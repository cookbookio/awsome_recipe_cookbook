# Outputs for Recipe Cookbook Infrastructure

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_name" {
  description = "Name of the VM"
  value       = azurerm_linux_virtual_machine.main.name
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = var.admin_username
}

output "github_secrets_commands" {
  description = "Commands to set GitHub secrets"
  value = <<-EOT
    Set these GitHub secrets:

    gh secret set SSH_USER --body "${var.admin_username}"
    gh secret set SSH_HOST --body "${azurerm_public_ip.main.ip_address}"
    gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

    Or manually:
    SSH_USER: ${var.admin_username}
    SSH_HOST: ${azurerm_public_ip.main.ip_address}
    SSH_PRIVATE_KEY: Contents of ~/.ssh/id_rsa
  EOT
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://${azurerm_public_ip.main.ip_address}"
}

output "password_authentication_enabled" {
  description = "Whether password authentication is enabled"
  value       = var.enable_password_authentication
}

output "login_instructions" {
  description = "How to login to the VM"
  value = var.enable_password_authentication ? join("\n", [
    "You can login with either:",
    "",
    "1. SSH Key (recommended):",
    "   ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}",
    "",
    "2. Password:",
    "   ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}",
    "   Password: (the one you set in terraform.tfvars)"
  ]) : "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}
