terraform {
  backend "azurerm" {
    resource_group_name  = "opa-test"
    storage_account_name = "opatesttf"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
    client_id            = "ed872b6a-648b-49c6-a0b0-64b8b66fbcf3"
    subscription_id      = "6a18591d-f445-43a2-b12a-1f1f9b4e3238"
    tenant_id            = "2317cfc5-74aa-48f9-9027-47fd5cf4b19c"
  }
}
