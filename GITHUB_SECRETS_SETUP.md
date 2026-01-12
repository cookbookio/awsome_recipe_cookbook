# GitHub Secrets Setup Guide

This guide covers how to set up the required GitHub secrets for the CI/CD pipeline.

## Required Secrets

Your CI/CD pipeline requires **6 secrets** to function properly:

| Secret Name | Description | Example Value |
|------------|-------------|---------------|
| `CR_PAT` | GitHub Personal Access Token with `write:packages` permission | `ghp_xxxxxxxxxxxxx` |
| `DOCKER_GITHUB_USERNAME` | Your GitHub username (lowercase) | `your-username` |
| `ENV_GREETING` | Environment variable for the app | `Hello from CI/CD!` |
| `SSH_USER` | Username for Azure VM | `azureuser` |
| `SSH_HOST` | IP address or hostname of Azure VM | `20.123.45.67` |
| `SSH_PRIVATE_KEY` | Private SSH key to access the VM | Contents of `~/.ssh/id_rsa` |

---

## Method 1: Using GitHub Web Interface

### Step-by-Step Instructions

1. Navigate to your repository on GitHub
2. Go to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret following the details below

---

### 1️⃣ CR_PAT (Container Registry Personal Access Token)

**Purpose:** Authenticate with GitHub Container Registry (GHCR)

**How to create:**
1. Go to your GitHub profile → **Settings** (not repository settings)
2. Navigate to **Developer settings** → **Personal access tokens** → **Tokens (classic)**
3. Click **Generate new token (classic)**
4. Configure the token:
   - **Note:** `GHCR Access for Recipe Cookbook`
   - **Expiration:** Choose duration (90 days or No expiration for demo)
   - **Scopes:** Select **ONLY** `write:packages` ✅
     - This automatically includes `read:packages`
5. Click **Generate token**
6. **⚠️ Copy the token immediately** (you won't see it again!)
7. Add to GitHub secrets:
   - **Name:** `CR_PAT`
   - **Value:** Paste the token (e.g., `ghp_xxxxxxxxxxxx`)

---

### 2️⃣ DOCKER_GITHUB_USERNAME

**Purpose:** Your GitHub username for GHCR authentication

**Value:** Your GitHub username in **lowercase**
- Example: If your GitHub is `JohnDoe`, use `johndoe`

**To add:**
- **Name:** `DOCKER_GITHUB_USERNAME`
- **Value:** `your-github-username` (lowercase)

---

### 3️⃣ ENV_GREETING

**Purpose:** Sample environment variable for the application

**Value:** Any greeting message you want

**To add:**
- **Name:** `ENV_GREETING`
- **Value:** `Hello from CI/CD Pipeline!` (or your custom message)

---

### 4️⃣ SSH_USER

**Purpose:** Username to login to your Azure VM

**Value:** The username you use to SSH into your Azure VM
- Common defaults: `azureuser`, `ubuntu`, or your custom username

**To add:**
- **Name:** `SSH_USER`
- **Value:** `azureuser` (or your VM username)

---

### 5️⃣ SSH_HOST

**Purpose:** IP address or hostname of your Azure VM

**How to find it:**
- In Azure Portal: Go to your VM → **Overview** → **Public IP address**
- Example: `20.123.45.67` or `myvm.eastus.cloudapp.azure.com`

**To add:**
- **Name:** `SSH_HOST`
- **Value:** `20.123.45.67` (your VM's public IP)

---

### 6️⃣ SSH_PRIVATE_KEY

**Purpose:** Private SSH key to authenticate with your Azure VM

**How to get the private key:**

**Option A: Use existing SSH key**
```bash
cat ~/.ssh/id_rsa
```

**Option B: Create new SSH key**
```bash
ssh-keygen -t rsa -b 4096 -C "cicd-pipeline@github-actions" -f ~/.ssh/azure_vm_key -N ""
cat ~/.ssh/azure_vm_key
```

Copy the **entire output** including:
```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

**⚠️ IMPORTANT:** Add the **public key** to your Azure VM:
```bash
# Display public key
cat ~/.ssh/id_rsa.pub
# OR
cat ~/.ssh/azure_vm_key.pub

# Add to Azure VM's authorized_keys
# SSH into your VM and run:
echo "your-public-key-here" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

**To add:**
- **Name:** `SSH_PRIVATE_KEY`
- **Value:** Paste the **entire private key** (including BEGIN/END lines)

---

## Method 2: Using GitHub CLI (Faster)

### Prerequisites

Ensure GitHub CLI is installed and authenticated:
```bash
gh auth login
```

### Quick Setup Script

```bash
# 1. Set GitHub username (replace with yours)
echo "your-github-username" | gh secret set DOCKER_GITHUB_USERNAME

# 2. Set greeting message
echo "Hello from CI/CD Pipeline!" | gh secret set ENV_GREETING

# 3. Set SSH user (adjust if needed)
echo "azureuser" | gh secret set SSH_USER

# 4. Set SSH host (replace with your VM IP)
echo "20.123.45.67" | gh secret set SSH_HOST

# 5. Set SSH private key
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

# 6. Set CR_PAT (generate token via web first, then run)
echo "ghp_yourTokenHere" | gh secret set CR_PAT
```

### Interactive Method (Prompted Input)

For each secret, run the command and paste the value when prompted:

```bash
# GitHub username
gh secret set DOCKER_GITHUB_USERNAME
# Paste value, then press Ctrl+D (Cmd+D on Mac)

# Greeting message
gh secret set ENV_GREETING
# Paste value, then press Ctrl+D

# SSH user
gh secret set SSH_USER
# Paste value, then press Ctrl+D

# SSH host
gh secret set SSH_HOST
# Paste value, then press Ctrl+D

# SSH private key (from file)
gh secret set SSH_PRIVATE_KEY < ~/.ssh/id_rsa

# CR_PAT (after generating via web)
gh secret set CR_PAT
# Paste token, then press Ctrl+D
```

---

## Verification

### Using Web Interface
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Verify all 6 secrets are listed (values are hidden)

### Using GitHub CLI
```bash
gh secret list
```

Expected output:
```
CR_PAT               Updated 2026-01-09
DOCKER_GITHUB_USERNAME Updated 2026-01-09
ENV_GREETING         Updated 2026-01-09
SSH_HOST             Updated 2026-01-09
SSH_PRIVATE_KEY      Updated 2026-01-09
SSH_USER             Updated 2026-01-09
```

---

## Troubleshooting

### CR_PAT Issues
- **Error:** `authentication failed`
  - **Solution:** Verify token has `write:packages` scope
  - Regenerate token if expired

### SSH Connection Issues
- **Error:** `Permission denied (publickey)`
  - **Solution:** Ensure public key is added to VM's `~/.ssh/authorized_keys`
  - Check private key format includes BEGIN/END lines

### Docker Login Issues
- **Error:** `unauthorized: authentication required`
  - **Solution:** Verify `DOCKER_GITHUB_USERNAME` is lowercase
  - Check `CR_PAT` is valid and not expired

---

## Security Notes

- Never commit secrets to your repository
- Rotate tokens and keys regularly
- Use minimal required permissions for tokens
- Consider using separate keys for CI/CD vs personal access
- For production, use shorter expiration times for tokens

---

## Next Steps

After setting up all secrets, proceed to:
1. Configure Azure VM (see AZURE_VM_SETUP.md)
2. Update workflow branch configuration
3. Test the CI/CD pipeline
