terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
}

module key_vault {
    source = "../../modules/key_vault"

    app_name           = var.app_name
    location           = var.location
    env                = var.env
}