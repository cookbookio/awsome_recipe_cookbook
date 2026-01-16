# Auto-Update GitHub Secrets When VM IP Changes

When you recreate your Azure VM with Terraform, the public IP address may change. This guide shows three different approaches to automatically sync the new IP to your GitHub Actions secrets.

## The Problem

Your GitHub Actions workflow needs to connect to your VM via SSH. It uses these secrets:
- `SSH_HOST` - The VM's public IP address
- `SSH_USER` - The username (usually "azureuser")
- `SSH_PRIVATE_KEY` - The private SSH key

When you run `terraform apply` and the VM gets a new IP address, the `SSH_HOST` secret becomes outdated, causing deployment failures.

## Solution Options

### Option 1: Simple Bash Script (Recommended)

Create a script that automatically updates GitHub secrets after Terraform creates/updates the VM.

**Create the script:**

```bash
#!/bin/bash
# update-github-secrets.sh

# Get values from Terraform outputs
SSH_HOST=$(terraform output -raw vm_public_ip)
SSH_USER=$(terraform output -raw admin_username)

# Update GitHub secrets
gh secret set SSH_HOST --body "$SSH_HOST"
gh secret set SSH_USER --body "$SSH_USER"
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

echo "GitHub secrets updated successfully!"
echo "SSH_HOST: $SSH_HOST"
echo "SSH_USER: $SSH_USER"
```

**Make it executable:**

```bash
chmod +x update-github-secrets.sh
```

**Usage:**

```bash
terraform apply
./update-github-secrets.sh
```

**Pros:**
- Simple and straightforward
- Full control over when secrets are updated
- Easy to debug if something goes wrong

**Cons:**
- Manual step after terraform apply
- Easy to forget to run it

---

### Option 2: Terraform `local-exec` Provisioner

Add a provisioner to your Terraform configuration that automatically runs after the VM is created.

**Add to your main.tf:**

```hcl
resource "null_resource" "update_github_secrets" {
  depends_on = [azurerm_linux_virtual_machine.main]

  triggers = {
    vm_ip = azurerm_public_ip.main.ip_address
  }

  provisioner "local-exec" {
    command = <<-EOT
      gh secret set SSH_HOST --body "${azurerm_public_ip.main.ip_address}"
      gh secret set SSH_USER --body "${var.admin_username}"
    EOT
  }
}
```

**Pros:**
- Fully automated - runs every time Terraform applies changes
- No separate script to remember
- IP change triggers automatic update

**Cons:**
- Mixes infrastructure provisioning with CI/CD configuration
- Requires `gh` CLI to be installed on machine running Terraform
- Less common practice (infrastructure code shouldn't modify CI/CD secrets)

---

### Option 3: Dynamic IP Lookup in GitHub Actions

Instead of storing the IP as a secret, modify your GitHub Actions workflow to query Azure directly and get the current VM IP at runtime.

**How it works:**

1. Your workflow authenticates with Azure using Azure credentials
2. It queries the Azure API to get the current public IP of your VM
3. It uses that IP for SSH connections
4. No need to update secrets when IP changes

**Prerequisites:**

You need to create an Azure Service Principal and store its credentials as a GitHub secret.

**Step 1: Create Azure Service Principal**

Run this command in your terminal:

```bash
az ad sp create-for-rbac \
  --name "github-actions-recipe-cookbook" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/recipe-cookbook-rg \
  --sdk-auth
```

This will output JSON like:

```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  "activeDirectoryEndpointUrl": "...",
  "resourceManagerEndpointUrl": "...",
  "activeDirectoryGraphResourceId": "...",
  "sqlManagementEndpointUrl": "...",
  "galleryEndpointUrl": "...",
  "managementEndpointUrl": "..."
}
```

**Step 2: Add Azure Credentials to GitHub Secrets**

```bash
# Copy the entire JSON output from above
gh secret set AZURE_CREDENTIALS --body '<paste-the-json-here>'
```

**Step 3: Update Your GitHub Actions Workflow**

Modify `.github/workflows/cicd-start-demo.yaml`:

```yaml
deploy:
  needs: build
  runs-on: ubuntu-latest
  env:
    SSH_USER: ${{ secrets.SSH_USER }}
    RESOURCE_GROUP: recipe-cookbook-rg
    VM_NAME: recipe-cookbook-vm

  steps:
    # Authenticate with Azure
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    # Query Azure for the current VM IP
    - name: Get VM Public IP
      id: get-ip
      run: |
        SSH_HOST=$(az vm show -d -g $RESOURCE_GROUP -n $VM_NAME --query publicIps -o tsv)
        echo "SSH_HOST=$SSH_HOST" >> $GITHUB_ENV
        echo "VM IP address: $SSH_HOST"

    - name: Add SSH key to runner
      run: |
        mkdir -p ~/.ssh/
        echo "$SSH_PRIVATE_KEY" > ~/.ssh/ssh_key
        chmod 600 ~/.ssh/ssh_key
      env:
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}

    - name: Create .env file
      run: |
        echo "GREETING=Hello from Github Action" >> .env
        echo "DOCKER_GITHUB_USERNAME=${{ secrets.DOCKER_GITHUB_USERNAME }}" >> .env

    # Now $SSH_HOST contains the dynamically fetched IP
    - name: Transfer .env file to server
      run: |
        scp -i ~/.ssh/ssh_key -o StrictHostKeyChecking=no .env $SSH_USER@$SSH_HOST:.env

    - name: Check Out Repository
      uses: actions/checkout@v2

    - name: Transfer Docker compose file to server
      run: |
        scp -i ~/.ssh/ssh_key -o StrictHostKeyChecking=no src/docker-compose.server.yml $SSH_USER@$SSH_HOST:docker-compose.yml

    - name: Deploy to server
      run: |
        ssh -i ~/.ssh/ssh_key -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST << "EOF"
          cd ~
          docker compose pull
          docker compose up -d
        EOF
```

**Pros:**
- Completely automated - no manual steps needed
- Always uses the current IP, even if it changes
- No need to update `SSH_HOST` secret ever again
- More robust and cloud-native approach

**Cons:**
- Requires setting up Azure Service Principal (one-time setup)
- Adds a dependency on Azure CLI in your workflow
- Slightly more complex workflow

---

## Recommendation

- **For learning/development**: Use **Option 1** (bash script) - simple and easy to understand
- **For production**: Use **Option 3** (dynamic lookup) - more robust and automated

## Current Setup

Your VM details (from Terraform output):
- IP Address: 20.251.217.150
- Username: azureuser
- Resource Group: recipe-cookbook-rg
- VM Name: recipe-cookbook-vm

You can always get the current IP with:

```bash
terraform output vm_public_ip
```
