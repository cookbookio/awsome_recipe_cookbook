#!/bin/bash

# Azure VM Docker Setup Script
# This script configures Docker permissions for CI/CD deployment

echo "=========================================="
echo "Azure VM Docker Setup for CI/CD"
echo "=========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Run: sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin"
    exit 1
fi

echo "✅ Docker is installed: $(docker --version)"

# Check if Docker Compose plugin is installed
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose plugin is not installed."
    echo "Run: sudo apt install -y docker-compose-plugin"
    exit 1
fi

echo "✅ Docker Compose is installed: $(docker compose version)"

# Add current user to docker group
echo ""
echo "Adding user '$USER' to docker group..."
sudo usermod -aG docker $USER

echo "✅ User added to docker group"

# Create app directory
echo ""
echo "Creating deployment directory..."
mkdir -p ~/app
echo "✅ Created ~/app directory"

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "⚠️  IMPORTANT: You must logout and login again for group changes to take effect!"
echo ""
echo "Run these commands:"
echo "  1. exit"
echo "  2. ssh $USER@$(hostname -I | awk '{print $1}')"
echo "  3. docker ps   # This should now work without sudo"
echo ""
echo "After re-login, verify with: docker ps"
echo "=========================================="
