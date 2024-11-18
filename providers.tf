terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}

  # Optional: Uncomment and configure these if you want to specify manually
  # subscription_id = "<YOUR_SUBSCRIPTION_ID>"
  # tenant_id       = "<YOUR_TENANT_ID>"
  # client_id       = "<YOUR_CLIENT_ID>"
  # client_secret   = "<YOUR_CLIENT_SECRET>"
}
terraform {
  cloud {

    organization = "Sai_Personal"

    workspaces {
      name = "infra-personal"
    }
  }
}