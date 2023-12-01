locals {
  resource_type = "api-rest"
  main_resource_name = "${local.resource_type}-${var.app_name}-${var.env}-${var.location}"
  short_resource_name = replace(local.main_resource_name, "-", "")
}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "${local.main_resource_name}-rg"
  location = var.location
}

resource "azurerm_service_plan" "this" {
  name                = "webapp-asp-${local.main_resource_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = var.os_type
  sku_name            = var.sku_name
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "this" {
  name                  = "webapp-${local.main_resource_name}"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  service_plan_id       = azurerm_service_plan.this.id
  https_only            = var.https_only

  site_config { 
    minimum_tls_version = var.tls_version
  }
}