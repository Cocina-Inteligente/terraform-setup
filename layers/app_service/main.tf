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

module app_service {
    source = "../../modules/app_service"

    app_name            = var.app_name
    location            = var.location
    env                 = var.env
    os_type             = var.os_type
    sku_name            = var.sku_name
    https_only          = var.https_only
    tls_version         = var.tls_version
}