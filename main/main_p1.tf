provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Priya_RG" {
  name     = var.pk_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "example" {
  name                     = "priyastorageaccountname"
  resource_group_name      = azurerm_resource_group.Priya_RG.name
  location                 = azurerm_resource_group.Priya_RG.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}

resource "azurerm_app_service_plan" "appservice" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.Priya_RG.location
  resource_group_name = azurerm_resource_group.Priya_RG.name
  kind                = "FunctionApp"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "funapp" {
  name                       = "cloudquickpocsfuncapp"
  location                   = azurerm_resource_group.Priya_RG.location
  resource_group_name        = azurerm_resource_group.Priya_RG.name
  app_service_plan_id        = azurerm_app_service_plan.appservice.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
}