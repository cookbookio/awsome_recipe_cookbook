# Terraform Infrastructure for Recipe Cookbook

This directory contains Terraform Infrastructure as Code (IaC) to provision an Azure VM for the Recipe Cookbook CI/CD demo.

## 📋 What Gets Created

When you run this Terraform configuration, it creates:

- ✅ **Resource Group** - Container for all resources
- ✅ **Virtual Network** - Network for the VM
- ✅ **Subnet** - Subnet within the VNet
- ✅ **Public IP** - Static public IP address
- ✅ **Network Security Group** - Firewall rules (ports 22, 80, 443)
- ✅ **Network Interface** - NIC for the VM
- ✅ **Linux VM** - Ubuntu 22.04 LTS
- ✅ **Docker & Docker Compose** - Installed via cloud-init

---

## 🚀 Quick Start

### Prerequisites

1. **Install Terraform** ([Download](https://www.terraform.io/downloads))
   ```bash
   # macOS
   brew install terraform

   # Ubuntu/Debian
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform

   # Windows
   # Download from https://www.terraform.io/downloads
   ```

2. **Install Azure CLI** ([Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
   ```bash
   # macOS
   brew install azure-cli

   # Ubuntu/Debian
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

3. **Login to Azure**
   ```bash
   az login
   ```

4. **Ensure SSH key exists**
   ```bash
   # Check if SSH key exists
   ls ~/.ssh/id_rsa.pub

   # If not, create one
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
   ```

---

## 📝 Usage

### 1. Initialize Terraform

```bash
cd terraform
terraform init
```

This downloads the Azure provider and prepares Terraform.

### 2. (Optional) Customize Variables

Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to customize:
```hcl
resource_group_name = "recipe-cookbook-rg"
location           = "westeurope"
vm_size            = "Standard_B1s"
admin_username     = "azureuser"
```

### 3. Preview Changes

```bash
terraform plan
```

This shows what Terraform will create without actually creating it.

### 4. Create Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. This takes 3-5 minutes.

### 5. Get Outputs

After successful creation:
```bash
terraform output
```

You'll see:
- VM public IP
- SSH command
- GitHub secrets commands
- App URL

### 6. Set GitHub Secrets

Use the output commands:
```bash
# Get the commands from Terraform
terraform output github_secrets_commands

# Run them
gh secret set SSH_USER --body "azureuser"
gh secret set SSH_HOST --body "YOUR_VM_IP"
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa
```

### 7. Destroy Infrastructure

When you're done:
```bash
terraform destroy
```

Type `yes` to confirm. This deletes everything.

---

## 📂 File Structure

```
terraform/
├── main.tf                    # Main infrastructure configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output values
├── cloud-init.yaml           # VM initialization script
├── terraform.tfvars.example  # Example variables (copy to terraform.tfvars)
├── .gitignore               # Git ignore for Terraform files
└── README.md                # This file
```

---

## 🎯 File Descriptions

### `main.tf`
Main Terraform configuration defining all Azure resources:
- Resource group
- Virtual network and subnet
- Public IP and NSG
- Virtual machine with cloud-init

### `variables.tf`
Input variables with defaults and validation:
- `resource_group_name` - Resource group name
- `location` - Azure region
- `vm_size` - VM size (B1s, B2s, etc.)
- `admin_username` - SSH username
- `ssh_public_key_path` - Path to SSH public key

### `outputs.tf`
Output values displayed after `terraform apply`:
- VM public IP
- SSH command
- GitHub secrets setup commands
- App URL

### `cloud-init.yaml`
Cloud-init configuration that runs on first boot:
- Updates packages
- Installs Docker and Docker Compose
- Configures firewall
- Creates app directory
- Adds user to docker group

---

## 🔧 Customization

### Change Azure Region

Edit `terraform.tfvars`:
```hcl
location = "eastus"  # or northeurope, uksouth, etc.
```

### Use Bigger VM

Edit `terraform.tfvars`:
```hcl
vm_size = "Standard_B2s"  # 2 vCPU, 4 GB RAM
```

### Change Resource Group Name

Edit `terraform.tfvars`:
```hcl
resource_group_name = "my-custom-rg"
prefix             = "my-app"
```

### Use Different SSH Key

Edit `terraform.tfvars`:
```hcl
ssh_public_key_path = "~/.ssh/azure_key.pub"
```

---

## 📊 Terraform Commands Reference

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Preview changes
terraform plan

# Apply changes
terraform apply

# Apply without prompting
terraform apply -auto-approve

# Show current state
terraform show

# List resources
terraform state list

# Get outputs
terraform output

# Get specific output
terraform output vm_public_ip

# Destroy infrastructure
terraform destroy

# Destroy without prompting
terraform destroy -auto-approve
```

---

## 🎓 Teaching with Terraform

### Benefits Over Scripts

1. **Declarative** - Describe what you want, not how to create it
2. **Idempotent** - Run multiple times safely
3. **State Management** - Terraform tracks what exists
4. **Plan Before Apply** - Preview changes before making them
5. **Resource Graph** - Terraform handles dependencies automatically
6. **Industry Standard** - Widely used in DevOps

### Demo Flow for Students

```bash
# 1. Show the configuration
cat main.tf

# 2. Initialize
terraform init

# 3. Preview what will be created
terraform plan

# 4. Create infrastructure
terraform apply

# 5. Show outputs
terraform output

# 6. SSH to VM
ssh $(terraform output -raw admin_username)@$(terraform output -raw vm_public_ip)

# 7. Destroy when done
terraform destroy
```

### Key Concepts to Teach

- **Resources** - Things to create (VM, network, etc.)
- **Providers** - Plugins for different clouds (Azure, AWS, etc.)
- **Variables** - Parameterize configurations
- **Outputs** - Extract information after creation
- **State** - How Terraform tracks infrastructure
- **Cloud-init** - Automate VM configuration

---

## 💰 Cost Comparison

### Bash Scripts vs Terraform

Both create the same infrastructure, so costs are identical:

| VM Size | Monthly Cost (24/7) | Per Hour |
|---------|-------------------|----------|
| Standard_B1s | ~$7-10 | ~$0.01 |
| Standard_B2s | ~$30-40 | ~$0.04 |

### Cost Saving Tips

1. **Destroy after demos**
   ```bash
   terraform destroy
   ```

2. **Stop VM when not in use**
   ```bash
   az vm deallocate \
     --resource-group $(terraform output -raw resource_group_name) \
     --name $(terraform output -raw vm_name)
   ```

3. **Use smaller VM for demos**
   ```hcl
   vm_size = "Standard_B1s"
   ```

---

## 🔍 Troubleshooting

### Issue: "terraform: command not found"

**Solution:** Install Terraform (see Prerequisites above)

### Issue: "Error: Error building account"

**Solution:** Login to Azure
```bash
az login
```

### Issue: "Error: SSH Public Key file does not exist"

**Solution:** Create SSH key
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

### Issue: Can't SSH to VM after creation

**Cause:** VM still initializing (cloud-init running)

**Solution:** Wait 2-3 minutes, then try again
```bash
ssh $(terraform output -raw admin_username)@$(terraform output -raw vm_public_ip)
```

### Issue: Docker permission denied on VM

**Cause:** Need to logout/login after docker group change

**Solution:**
```bash
# Logout
exit

# Login again
ssh $(terraform output -raw admin_username)@$(terraform output -raw vm_public_ip)

# Verify
docker ps
```

### Issue: "Error: A resource with the ID already exists"

**Cause:** Resources already exist from previous run

**Solution 1:** Import existing resources
```bash
terraform import azurerm_resource_group.main /subscriptions/YOUR_SUB_ID/resourceGroups/recipe-cookbook-rg
```

**Solution 2:** Destroy and recreate
```bash
terraform destroy
terraform apply
```

### Issue: "Error acquiring the state lock"

**Cause:** Previous Terraform run didn't complete properly

**Solution:** Force unlock (use ID from error message)
```bash
terraform force-unlock LOCK_ID
```

---

## 🆚 Terraform vs Bash Scripts

| Feature | Terraform | Bash Scripts |
|---------|-----------|--------------|
| **Idempotent** | ✅ Yes | ❌ No |
| **State Tracking** | ✅ Yes | ❌ No |
| **Preview Changes** | ✅ Yes | ❌ No |
| **Dependency Management** | ✅ Automatic | ⚠️ Manual |
| **Learning Curve** | ⚠️ Steeper | ✅ Easier |
| **Portability** | ✅ Multi-cloud | ❌ Azure only |
| **Industry Use** | ✅ Very common | ⚠️ Less common |

**Recommendation:**
- Use **Bash scripts** for quick demos and beginners
- Use **Terraform** for teaching IaC concepts and production

---

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Cloud-init Documentation](https://cloudinit.readthedocs.io/)
- [Learn Terraform (HashiCorp)](https://learn.hashicorp.com/terraform)

---

## 🎯 Next Steps

After infrastructure is created:

1. ✅ SSH to VM and verify Docker is installed
2. ✅ Login to GHCR: `docker login ghcr.io`
3. ✅ Set GitHub secrets (use commands from `terraform output`)
4. ✅ Push code to trigger CI/CD pipeline
5. ✅ Access app at `http://VM_IP`
6. ✅ Run `terraform destroy` when done

---

## 📝 Example Workflow

```bash
# Clone repo
git clone https://github.com/YOUR_USERNAME/awsome_recipe_cookbook.git
cd awsome_recipe_cookbook/terraform

# Initialize Terraform
terraform init

# Create infrastructure
terraform apply -auto-approve

# Get VM IP
VM_IP=$(terraform output -raw vm_public_ip)
echo "VM IP: $VM_IP"

# Set GitHub secrets
gh secret set SSH_USER --body "azureuser"
gh secret set SSH_HOST --body "$VM_IP"
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

# Wait for cloud-init to complete (2-3 minutes)
sleep 180

# SSH and login to GHCR
ssh azureuser@$VM_IP
# On VM: docker login ghcr.io -u YOUR_GITHUB_USERNAME
exit

# Push code to trigger deployment
git push origin cicd-start-demo

# Access app
open "http://$VM_IP"

# Clean up when done
terraform destroy -auto-approve
```
