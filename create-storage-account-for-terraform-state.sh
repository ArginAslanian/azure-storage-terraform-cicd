# 1. Create a Resource Group for the Terraform State
az group create --name rg-terraform-state --location eastus

# 2. Create the Storage Account 
az storage account create --resource-group rg-terraform-state --name sttfstateaa2026 --sku Standard_LRS --encryption-services blob

# 3. Create the Blob Container inside that Storage Account
az storage container create --name tfstate --account-name sttfstateaa2026 --auth-mode login