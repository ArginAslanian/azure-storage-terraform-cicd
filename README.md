# ☁️ Enterprise Azure Storage & CI/CD Pipeline

This repository contains an Infrastructure as Code (IaC) deployment for a secure, multi-tier Azure Storage architecture. It features a fully automated, "Zero Secrets" CI/CD pipeline utilizing passwordless OIDC federation between GitHub Actions and Microsoft Entra ID.

## 🚀 Project Overview

The objective of this project is to provision real-world, enterprise-grade storage solutions while adhering to strict security and identity management best practices. The infrastructure is entirely deployed and managed via Terraform.

### 🏗️ Core Architecture
* **The Internal Vault (Premium Block Blobs):** A highly secure storage account locked behind an Azure Private Endpoint. Public internet access is explicitly disabled, and access is strictly governed by Entra ID Role-Based Access Control (RBAC).
* **The Compliance Archive (Standard/Cool Tier):** A logging and archive repository utilizing a 14-day Time-Based Immutability Policy (WORM: Write Once, Read Many) to prevent the deletion or alteration of critical infrastructure logs.
* **The IT Portal (Static Website):** A public-facing container configured to host static documentation and frontend assets for internal IT tools.
* **Dedicated Network:** A freshly provisioned Virtual Network and dedicated subnet to route private traffic securely.

### 🔐 Security & Identity Management
* **Zero Secrets Pipeline:** Uses OpenID Connect (OIDC) for GitHub Actions to authenticate to Azure without storing long-lived Client Secrets.
* **Entra ID Integration:** Custom Azure RBAC roles (`Storage Blob Data Contributor` and `Storage Blob Data Reader`) are mapped directly to Entra ID Security Groups.
* **Remote State Security:** Terraform state is stored securely in a dedicated remote Azure Blob container to prevent configuration drift and protect sensitive deployment data.

## 🛠️ Tools & Technologies Used
* **Infrastructure as Code:** Terraform (v4 Azure Provider)
* **CI/CD Automation:** GitHub Actions
* **Cloud Platform:** Microsoft Azure
* **Identity Management:** Microsoft Entra ID
* **Version Control:** Git & GitHub

## 📂 Repository Structure
* `.github/workflows/terraform.yml` - The OIDC deployment pipeline.
* `providers.tf` - Terraform provider and remote backend configuration.
* `network.tf` - Virtual Network and Private Endpoint subnet provisioning.
* `storage.tf` - Storage accounts, static website config, and WORM policies.
* `rbac.tf` - Entra ID role assignments to the storage containers.
* `variables.tf` - Variable declarations for group Object IDs and locations.
