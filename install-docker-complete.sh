#!/bin/bash

# Complete Docker and Docker Compose Installation Script for Azure VM
# Run this on your Azure VM to install everything needed for CI/CD

set -e  # Exit on any error

echo "=========================================="
echo "Docker + Docker Compose Installation"
echo "=========================================="
echo ""

# Update package index
echo "📦 Updating package index..."
sudo apt update

# Install prerequisites
echo "📦 Installing prerequisites..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
echo "🔑 Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "📦 Adding Docker repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
echo "📦 Updating package index with Docker repo..."
sudo apt update

# Install Docker and Docker Compose plugin
echo "📦 Installing Docker and Docker Compose plugin..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start and enable Docker service
echo "🚀 Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group
echo "👤 Adding user '$USER' to docker group..."
sudo usermod -aG docker $USER

# Create app directory
echo "📁 Creating deployment directory..."
mkdir -p ~/app

# Verify installations
echo ""
echo "=========================================="
echo "✅ Installation Complete!"
echo "=========================================="
echo ""
docker --version
docker compose version
echo ""
echo "=========================================="
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "=========================================="
echo ""
echo "1. LOGOUT and LOGIN again for group changes to take effect:"
echo "   exit"
echo "   ssh $USER@\$(hostname -I | awk '{print \$1}')"
echo ""
echo "2. Verify Docker works without sudo:"
echo "   docker ps"
echo "   docker compose version"
echo ""
echo "3. Login to GitHub Container Registry:"
echo "   docker login ghcr.io -u YOUR_GITHUB_USERNAME"
echo "   (Use your CR_PAT token as password)"
echo ""
echo "=========================================="
