#!/bin/bash

# Deploy legacy files to VM
# Run this script after 'terraform apply' to copy legacy files to the VM

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${YELLOW}Deploying legacy files to VM...${NC}"

# Extract VM IP from Terraform output
cd "$SCRIPT_DIR"
VM_IP=$(terraform output -raw vm_public_ip 2>/dev/null)

if [ -z "$VM_IP" ]; then
    echo -e "${RED}Error: Could not get VM IP from Terraform output${NC}"
    echo "Make sure you've run 'terraform apply' first"
    exit 1
fi

echo -e "${GREEN}VM IP: $VM_IP${NC}"

# Get admin username from Terraform variables
ADMIN_USER=$(terraform output -raw admin_username 2>/dev/null)

if [ -z "$ADMIN_USER" ]; then
    echo -e "${YELLOW}Could not get admin username from Terraform, using default 'azureuser'${NC}"
    ADMIN_USER="azureuser"
fi

echo -e "${GREEN}Admin user: $ADMIN_USER${NC}"

# Get SSH key path from terraform.tfvars or use default
SSH_KEY_PATH=$(grep ssh_public_key_path terraform.tfvars 2>/dev/null | cut -d'"' -f2 | sed 's/\.pub$//')

if [ -z "$SSH_KEY_PATH" ]; then
    SSH_KEY_PATH="$HOME/.ssh/id_rsa"
fi

echo -e "${GREEN}SSH key: $SSH_KEY_PATH${NC}"

# Test SSH connection
echo -e "${YELLOW}Testing SSH connection...${NC}"
if ! ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$ADMIN_USER@$VM_IP" "echo 'SSH connection successful'" 2>/dev/null; then
    echo -e "${RED}Error: Cannot connect to VM via SSH${NC}"
    echo "Please check:"
    echo "  1. VM is running"
    echo "  2. SSH key is correct: $SSH_KEY_PATH"
    echo "  3. Security group allows SSH from your IP"
    exit 1
fi

# Create legacy directory structure on VM
echo -e "${YELLOW}Creating directory structure on VM...${NC}"
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$ADMIN_USER@$VM_IP" << 'ENDSSH'
mkdir -p ~/legacy/static ~/legacy/templates
ENDSSH

# Copy legacy files to VM
echo -e "${YELLOW}Copying legacy files...${NC}"

echo "  - requirements.txt"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/requirements.txt" \
    "$ADMIN_USER@$VM_IP:~/legacy/"

echo "  - app.py"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/app.py" \
    "$ADMIN_USER@$VM_IP:~/legacy/"

echo "  - api-schema.yaml"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/api-schema.yaml" \
    "$ADMIN_USER@$VM_IP:~/legacy/"

echo "  - static/style.css"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/static/style.css" \
    "$ADMIN_USER@$VM_IP:~/legacy/static/"

echo "  - templates/base.html"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/templates/base.html" \
    "$ADMIN_USER@$VM_IP:~/legacy/templates/"

echo "  - templates/home.html"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/templates/home.html" \
    "$ADMIN_USER@$VM_IP:~/legacy/templates/"

echo "  - templates/recipe_detail.html"
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no \
    "$PROJECT_ROOT/legacy/templates/recipe_detail.html" \
    "$ADMIN_USER@$VM_IP:~/legacy/templates/"

# Verify files were copied
echo -e "${YELLOW}Verifying files on VM...${NC}"
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$ADMIN_USER@$VM_IP" << 'ENDSSH'
echo "Files in ~/legacy:"
find ~/legacy -type f | sort
ENDSSH

echo -e "${GREEN}✓ Legacy files deployed successfully!${NC}"
echo -e "${GREEN}All files are now in /home/$ADMIN_USER/legacy on the VM${NC}"
