# Azure Setup and Teardown Scripts Guide

This guide explains how to use the automated scripts to quickly set up and tear down your Azure VM infrastructure for the Recipe Cookbook CI/CD demo.

## 📋 Prerequisites

- Azure CLI installed ([Installation guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- Azure account with active subscription
- GitHub CLI installed (optional, for setting secrets)

---

## 🚀 Setup Script: `azure-setup.sh`

This script automates the entire Azure VM setup process.

### What It Does

1. ✅ Checks Azure CLI is installed and you're logged in
2. ✅ Creates SSH key pair (if needed)
3. ✅ Creates Azure Resource Group
4. ✅ Creates Ubuntu 22.04 VM
5. ✅ Configures network security (opens ports 22, 80, 443)
6. ✅ Installs Docker and Docker Compose on the VM (optional)
7. ✅ Sets up firewall rules
8. ✅ Displays VM IP and connection info
9. ✅ Provides GitHub secrets setup commands

### Usage

```bash
# Make executable (first time only)
chmod +x azure-setup.sh

# Run the setup
./azure-setup.sh
```

### Configuration

You can customize settings by editing variables at the top of `azure-setup.sh`:

```bash
RESOURCE_GROUP="recipe-cookbook-rg"  # Resource group name
LOCATION="westeurope"                # Azure region
VM_NAME="recipe-cookbook-vm"         # VM name
VM_SIZE="Standard_B1s"               # VM size (B1s = 1 vCPU, 1GB RAM)
ADMIN_USERNAME="azureuser"           # SSH username
SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub" # SSH public key path
```

### Available Azure Regions

Common regions:
- `westeurope` - West Europe (Amsterdam)
- `northeurope` - North Europe (Dublin)
- `eastus` - East US (Virginia)
- `westus` - West US (California)
- `uksouth` - UK South (London)

See all regions: `az account list-locations --output table`

### VM Sizes

- `Standard_B1s` - 1 vCPU, 1 GB RAM (~$7-10/month) - Good for demo
- `Standard_B2s` - 2 vCPU, 4 GB RAM (~$30-40/month) - Better performance
- `Standard_B1ms` - 1 vCPU, 2 GB RAM (~$15-20/month) - Middle ground

See all sizes: `az vm list-sizes --location westeurope --output table`

### Example Output

```
==========================================
Azure VM Setup for Recipe Cookbook
==========================================

✅ Azure CLI is installed
✅ Already logged in to Azure
Using subscription: Pay-As-You-Go

✅ SSH key found at /Users/you/.ssh/id_rsa.pub

==========================================
Creating Resource Group
==========================================
Name: recipe-cookbook-rg
Location: westeurope
✅ Resource group created

==========================================
Creating Virtual Machine
==========================================
VM Name: recipe-cookbook-vm
Size: Standard_B1s
Admin User: azureuser
This may take 2-5 minutes...

✅ Virtual machine created

==========================================
Getting VM Information
==========================================
✅ VM is ready!

VM Public IP: 20.123.45.67
SSH command: ssh azureuser@20.123.45.67

==========================================
Next Steps:
==========================================

1. SSH to your VM:
   ssh azureuser@20.123.45.67

2. Login to GitHub Container Registry:
   docker login ghcr.io -u YOUR_GITHUB_USERNAME

3. Add GitHub secrets:
   echo "azureuser" | gh secret set SSH_USER
   echo "20.123.45.67" | gh secret set SSH_HOST
   gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa
```

---

## 🗑️ Teardown Script: `azure-teardown.sh`

This script safely deletes all Azure resources.

### What It Does

1. ✅ Checks if resource group exists
2. ✅ Shows all resources that will be deleted
3. ✅ Asks for double confirmation (safety)
4. ✅ Deletes the entire resource group
5. ✅ Optionally waits for deletion to complete

### Usage

```bash
# Make executable (first time only)
chmod +x azure-teardown.sh

# Run the teardown
./azure-teardown.sh
```

### Safety Features

The script requires **two confirmations**:

1. First confirmation: Type "yes" to proceed
2. Second confirmation: Type the exact resource group name

This prevents accidental deletion.

### Example Output

```
==========================================
Azure Resource Teardown
==========================================

✅ Logged in to Azure
Using subscription: Pay-As-You-Go

==========================================
Resources to be deleted:
==========================================

Name                Type
------------------  -------------------------
recipe-cookbook-vm  Microsoft.Compute/virtualMachines
...                 ...

⚠️  WARNING: This will permanently delete all resources in 'recipe-cookbook-rg'

Are you sure you want to continue? (yes/NO): yes

⚠️  FINAL CONFIRMATION
Type the resource group name 'recipe-cookbook-rg' to confirm deletion: recipe-cookbook-rg

==========================================
Deleting Resource Group
==========================================
Resource Group: recipe-cookbook-rg
This may take several minutes...

✅ Deletion initiated

The resource group is being deleted in the background.
```

---

## 🎓 Usage for Teaching

### Quick Demo Setup

```bash
# 1. Set up everything in one command
./azure-setup.sh

# 2. Note the VM IP from the output

# 3. Set GitHub secrets automatically
gh secret set SSH_USER < <(echo "azureuser")
gh secret set SSH_HOST < <(echo "YOUR_VM_IP")
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

# 4. Push code to trigger deployment
git push origin cicd-start-demo

# 5. Access your app at http://YOUR_VM_IP
```

### Quick Cleanup After Demo

```bash
# Delete everything
./azure-teardown.sh

# Remove GitHub secrets
gh secret delete SSH_USER
gh secret delete SSH_HOST
gh secret delete SSH_PRIVATE_KEY
```

---

## 💰 Cost Management

### Estimated Costs (24/7 usage)

- **Standard_B1s:** ~$7-10/month
- **Standard_B2s:** ~$30-40/month

### Save Money

**Stop VM when not in use:**
```bash
# Stop (deallocate) the VM
az vm deallocate --resource-group recipe-cookbook-rg --name recipe-cookbook-vm

# Start it again when needed
az vm start --resource-group recipe-cookbook-rg --name recipe-cookbook-vm
```

**Auto-shutdown:**
```bash
# Set up auto-shutdown at 11 PM daily
az vm auto-shutdown \
  --resource-group recipe-cookbook-rg \
  --name recipe-cookbook-vm \
  --time 2300
```

---

## 🔧 Troubleshooting

### Issue: "Azure CLI is not installed"

**Solution:**
```bash
# macOS
brew install azure-cli

# Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Windows
# Download from: https://aka.ms/installazurecliwindows
```

### Issue: "Not logged in to Azure"

**Solution:**
```bash
az login
```

### Issue: SSH connection fails after setup

**Cause:** VM may still be initializing

**Solution:**
```bash
# Wait 1-2 minutes, then try again
ssh azureuser@YOUR_VM_IP
```

### Issue: Docker permission denied on VM

**Cause:** Need to logout and login after docker group change

**Solution:**
```bash
# Logout from VM
exit

# Login again
ssh azureuser@YOUR_VM_IP

# Now docker should work
docker ps
```

### Issue: Resource group deletion is stuck

**Check status:**
```bash
az group exists --name recipe-cookbook-rg
```

**Force delete (if needed):**
```bash
az group delete --name recipe-cookbook-rg --yes --force-deletion-types Microsoft.Compute/virtualMachines
```

---

## 📝 Customization Examples

### Different Region

Edit `azure-setup.sh`:
```bash
LOCATION="eastus"  # Change from westeurope to eastus
```

### Bigger VM

Edit `azure-setup.sh`:
```bash
VM_SIZE="Standard_B2s"  # Change from Standard_B1s
```

### Different Resource Group Name

Edit both `azure-setup.sh` and `azure-teardown.sh`:
```bash
RESOURCE_GROUP="my-custom-name-rg"
```

### Multiple VMs

Create different scripts with different names:
```bash
cp azure-setup.sh azure-setup-dev.sh
cp azure-setup.sh azure-setup-prod.sh

# Edit each script with different:
# - RESOURCE_GROUP
# - VM_NAME
# - LOCATION (optional)
```

---

## 🎯 Best Practices

1. **Always run teardown** when you're done to avoid unnecessary costs
2. **Use auto-shutdown** for demos that span multiple days
3. **Keep scripts in version control** so students can use them
4. **Document custom changes** if you modify the scripts
5. **Test setup/teardown** before class to ensure they work
6. **Have a backup plan** in case Azure is slow or has issues

---

## 📚 Additional Resources

- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure VM Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)
- [Azure Free Account](https://azure.microsoft.com/en-us/free/) - $200 credit for students
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
