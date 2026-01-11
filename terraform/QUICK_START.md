# Terraform Quick Start - Recipe Cookbook

Super quick guide to get your infrastructure up and running.

## ⚡ 5-Minute Setup

```bash
# 1. Login to Azure
az login

# 2. Go to terraform directory
cd terraform

# 3. Initialize Terraform
terraform init

# 4. Create everything
terraform apply -auto-approve

# 5. Get the VM IP
terraform output vm_public_ip

# 6. Set GitHub secrets
gh secret set SSH_USER --body "azureuser"
gh secret set SSH_HOST --body "$(terraform output -raw vm_public_ip)"
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa
```

Done! Your infrastructure is ready.

---

## 🗑️ Quick Teardown

```bash
# Delete everything
terraform destroy -auto-approve
```

---

## 📋 Essential Commands

```bash
# Preview changes
terraform plan

# Create infrastructure
terraform apply

# Show current state
terraform show

# Get outputs
terraform output

# Get specific output
terraform output vm_public_ip

# Destroy infrastructure
terraform destroy
```

---

## 🔧 Quick Customization

Edit `terraform.tfvars`:

```hcl
# Change region
location = "northeurope"

# Use bigger VM
vm_size = "Standard_B2s"

# Change resource group name
resource_group_name = "my-demo-rg"
```

---

## 🆘 Quick Troubleshooting

**Can't SSH?**
```bash
# Wait 2-3 minutes for cloud-init, then:
ssh azureuser@$(terraform output -raw vm_public_ip)
```

**Docker permission denied?**
```bash
# Logout and login again
exit
ssh azureuser@$(terraform output -raw vm_public_ip)
docker ps
```

**Need to start over?**
```bash
terraform destroy -auto-approve
terraform apply -auto-approve
```

---

## 🎯 Complete Demo Flow

```bash
# Setup
terraform init
terraform apply -auto-approve

# Configure
VM_IP=$(terraform output -raw vm_public_ip)
gh secret set SSH_USER --body "azureuser"
gh secret set SSH_HOST --body "$VM_IP"
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

# Deploy
git push origin cicd-start-demo

# Access
open "http://$VM_IP"

# Cleanup
terraform destroy -auto-approve
```

That's it! 🚀
