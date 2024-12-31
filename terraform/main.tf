provider "azurerm" {
  subscription_id = "6a18591d-f445-43a2-b12a-1f1f9b4e3238"
  features {}
  use_oidc = true
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  required_version = ">=1.1.0"
}

resource "azurerm_resource_group" "opa-test" {
  name     = var.resource_group_name
  location = var.location

  tags = var.common_tags
}

resource "azurerm_virtual_network" "opa" {
  name                = azurerm_resource_group.opa-test.name
  location            = azurerm_resource_group.opa-test.location
  resource_group_name = azurerm_resource_group.opa-test.name

  address_space = [var.vnet_address_space]

  tags = var.common_tags
}

resource "azurerm_subnet" "main" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.opa-test.name
  virtual_network_name = azurerm_virtual_network.opa.name
  address_prefixes     = [each.value]
}

resource "azurerm_storage_account" "opatesttf" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.opa-test.name
  location                 = azurerm_resource_group.opa-test.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
    project = "opa"
  }
}

resource "azurerm_application_security_group" "NSG" {
  name                = "NSG"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = "dev"
    project = "opa"
  }
}

# Define a map for storage accounts with unique names
locals {
  storage_accounts = {
    for i in range(1, 12) : "examplestoracct${i}" => i
  }
}

# Create multiple storage accounts using for_each
resource "azurerm_storage_account" "example" {
  for_each                 = local.storage_accounts
  name                     = each.key
  resource_group_name      = azurerm_resource_group.opa-test.name
  location                 = azurerm_resource_group.opa-test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}