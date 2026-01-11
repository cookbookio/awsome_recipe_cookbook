# Infrastructure Provisioning Guide

This repository provides **two methods** for provisioning Azure infrastructure for the Recipe Cookbook CI/CD demo: Bash scripts and Terraform. Choose the method that best fits your needs.

---

## 🔀 Two Approaches

### 1. Bash Scripts (Simple & Quick)
- [azure-setup.sh](azure-setup.sh) - Create infrastructure
- [azure-teardown.sh](azure-teardown.sh) - Delete infrastructure
- [AZURE_SCRIPTS_GUIDE.md](AZURE_SCRIPTS_GUIDE.md) - Documentation

### 2. Terraform (Infrastructure as Code)
- [terraform/](terraform/) - All Terraform files
- [terraform/README.md](terraform/README.md) - Comprehensive guide
- [terraform/QUICK_START.md](terraform/QUICK_START.md) - Quick reference

---

## 🆚 Comparison

| Feature | Bash Scripts | Terraform |
|---------|--------------|-----------|
| **Ease of Use** | ✅ Very easy | ⚠️ Moderate |
| **Learning Curve** | ✅ Low | ⚠️ Higher |
| **Prerequisites** | Azure CLI only | Azure CLI + Terraform |
| **Idempotent** | ❌ No | ✅ Yes |
| **State Tracking** | ❌ No | ✅ Yes |
| **Preview Changes** | ❌ No | ✅ Yes (`terraform plan`) |
| **Modify Infrastructure** | ❌ Hard | ✅ Easy |
| **Rollback** | ❌ Manual | ✅ Built-in |
| **Multi-cloud** | ❌ Azure only | ✅ Azure, AWS, GCP, etc. |
| **Industry Standard** | ⚠️ Good for scripting | ✅ Industry standard IaC |
| **Version Control** | ✅ Easy | ✅ Excellent |
| **Execution Time** | ~3-5 minutes | ~3-5 minutes |
| **Complexity** | ✅ Simple | ⚠️ More complex |

---

## 🎯 When to Use Each

### Use Bash Scripts When:

- ✅ Teaching CI/CD basics (not IaC)
- ✅ Students are new to DevOps
- ✅ Quick demos (< 1 hour)
- ✅ You want something simple and transparent
- ✅ Azure CLI is already familiar
- ✅ One-time setup/teardown

**Example:**
```bash
./azure-setup.sh      # Create everything
# ... run demo ...
./azure-teardown.sh   # Delete everything
```

### Use Terraform When:

- ✅ Teaching Infrastructure as Code concepts
- ✅ Students have basic DevOps knowledge
- ✅ Longer courses (multi-week)
- ✅ Need to modify infrastructure during course
- ✅ Want to demonstrate industry best practices
- ✅ Teaching multi-cloud concepts
- ✅ Need repeatable, version-controlled infrastructure

**Example:**
```bash
terraform init
terraform apply       # Create everything
# ... run demo, make changes to config ...
terraform apply       # Update infrastructure
# ... demo continues ...
terraform destroy     # Delete everything
```

---

## 📚 Teaching Scenarios

### Scenario 1: Introduction to CI/CD (Beginner)

**Recommended:** Bash Scripts

**Why:** Students focus on CI/CD pipeline concepts without learning Terraform syntax.

**Flow:**
1. Run `./azure-setup.sh`
2. Teach GitHub Actions, Docker, deployment
3. Run `./azure-teardown.sh`

**Time:** 2-4 hours

---

### Scenario 2: DevOps Fundamentals (Intermediate)

**Recommended:** Both (start with Bash, introduce Terraform)

**Why:** Show progression from scripting to IaC.

**Flow:**
1. Week 1: Use Bash scripts, teach CI/CD
2. Week 2: Introduce Terraform, explain IaC benefits
3. Week 3: Students convert Bash to Terraform (exercise)

**Time:** 3-4 weeks

---

### Scenario 3: Infrastructure as Code Course (Advanced)

**Recommended:** Terraform

**Why:** Terraform is the focus, CI/CD is secondary.

**Flow:**
1. Teach Terraform basics
2. Build infrastructure incrementally
3. Add CI/CD pipeline to deploy to Terraform-managed infrastructure
4. Explore Terraform modules, workspaces, remote state

**Time:** 4-8 weeks

---

## 🚀 Quick Start Comparison

### Bash Scripts

```bash
# Prerequisites
brew install azure-cli  # or apt install azure-cli
az login

# Setup
./azure-setup.sh

# Teardown
./azure-teardown.sh
```

### Terraform

```bash
# Prerequisites
brew install azure-cli terraform  # or apt install
az login

# Setup
cd terraform
terraform init
terraform apply

# Teardown
terraform destroy
```

---

## 💡 Best Practices

### For Bash Scripts:

1. **Review before running** - Read the script to understand what it does
2. **Customize variables** - Edit configuration at the top of scripts
3. **Keep output** - Note down VM IP and other outputs
4. **Test before class** - Run setup/teardown to ensure they work
5. **Have fallback** - Azure Portal as backup if scripts fail

### For Terraform:

1. **Use `.tfvars` files** - Don't hardcode values in `.tf` files
2. **Version control** - Commit `.tf` files, not `.tfstate` or `.tfvars`
3. **Plan before apply** - Always run `terraform plan` first
4. **Use outputs** - Extract information via `outputs.tf`
5. **Document changes** - Comment why you made specific choices
6. **Remote state (advanced)** - Use Azure Storage for team collaboration

---

## 📊 Feature Comparison

### What Both Can Do:

- ✅ Create complete Azure infrastructure
- ✅ Install Docker and Docker Compose
- ✅ Configure firewall and security
- ✅ Provide VM IP and SSH commands
- ✅ Delete all resources cleanly
- ✅ Same cost (same infrastructure)

### What Only Terraform Can Do:

- ✅ Preview changes before applying
- ✅ Track infrastructure state
- ✅ Safely update existing infrastructure
- ✅ Detect configuration drift
- ✅ Reuse modules across projects
- ✅ Manage multiple environments (dev, staging, prod)
- ✅ Work across multiple cloud providers

---

## 🎓 Learning Outcomes

### With Bash Scripts Students Learn:

- Bash scripting fundamentals
- Azure CLI commands
- Infrastructure provisioning concepts
- Automation basics
- Error handling and validation

### With Terraform Students Learn:

- Infrastructure as Code principles
- Declarative vs imperative programming
- State management
- Dependency management
- Industry-standard DevOps tools
- Cloud-agnostic thinking

---

## 💰 Cost Considerations

**Both methods create identical infrastructure, so costs are the same:**

| VM Size | Monthly (24/7) | Per Hour | Demo (4 hours) |
|---------|----------------|----------|----------------|
| Standard_B1s | ~$8 | ~$0.01 | ~$0.04 |
| Standard_B2s | ~$32 | ~$0.04 | ~$0.16 |

**Cost Saving Tips:**
- Delete infrastructure immediately after demos
- Use `Standard_B1s` for teaching (sufficient for demos)
- Set up auto-shutdown for longer courses
- Stop VMs between classes

---

## 🔧 Maintenance

### Bash Scripts:
- **Update frequency:** Rarely needed
- **Dependencies:** Azure CLI version
- **Complexity:** Easy to modify
- **Testing:** Run before each class

### Terraform:
- **Update frequency:** Provider updates every few months
- **Dependencies:** Terraform version, Azure provider version
- **Complexity:** Moderate to modify
- **Testing:** `terraform plan` shows changes

---

## 🎯 Recommendation by Course Type

| Course Type | Recommended | Alternative |
|-------------|-------------|-------------|
| **CI/CD Intro (1 day)** | Bash Scripts | - |
| **DevOps Bootcamp (1-2 weeks)** | Bash Scripts | Show Terraform as bonus |
| **Cloud Infrastructure (2-4 weeks)** | Terraform | - |
| **Full DevOps Course (4+ weeks)** | Both | Start Bash, migrate to Terraform |
| **IaC Specialist Course** | Terraform | - |

---

## 📝 Migration Path

If you start with Bash scripts and want to move to Terraform:

1. **Week 1-2:** Use Bash scripts for quick setup
2. **Week 3:** Introduce Terraform concepts
3. **Week 4:** Show both methods side-by-side
4. **Week 5+:** Use only Terraform

**Assignment Idea:** Have students recreate the Bash script functionality in Terraform.

---

## 🆘 Troubleshooting

### Both Methods:

- Login issues → `az login`
- SSH key missing → `ssh-keygen -t rsa -b 4096`
- Ports not open → Check NSG rules
- Docker permission denied → Logout and login to VM

### Bash Scripts Specific:

- Script fails midway → Manually delete resources or rerun
- Resource exists error → Delete via Portal or use `az group delete`

### Terraform Specific:

- State lock → `terraform force-unlock <ID>`
- Provider version → `terraform init -upgrade`
- State drift → `terraform refresh` then `terraform plan`

---

## 📚 Additional Resources

### For Bash Scripts:
- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [AZURE_SCRIPTS_GUIDE.md](AZURE_SCRIPTS_GUIDE.md)

### For Terraform:
- [Terraform Tutorial](https://learn.hashicorp.com/terraform)
- [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [terraform/README.md](terraform/README.md)
- [terraform/QUICK_START.md](terraform/QUICK_START.md)

---

## 🎉 Summary

**Both methods work perfectly for provisioning infrastructure for this CI/CD demo.**

- Choose **Bash scripts** for simplicity and quick demos
- Choose **Terraform** for teaching IaC and industry best practices

You can even use **both** in the same course to demonstrate different approaches!

---

## ❓ Still Not Sure?

Ask yourself:

1. **Is the course primarily about CI/CD?** → Use Bash scripts
2. **Is IaC a learning objective?** → Use Terraform
3. **How long is the course?** → < 1 week: Bash, > 2 weeks: Terraform
4. **What's the students' experience level?** → Beginner: Bash, Intermediate+: Terraform

When in doubt, **start with Bash scripts** and introduce Terraform later if needed.
