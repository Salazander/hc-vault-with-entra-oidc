terraform {
    required_version = ">= 0.12"
}

module "oidc_app_registration" {
    source = "./entra-app-registration"
}

module "vault_configuration" {
    source = "./vault-auth-configuration"
    reader_group_id   = var.reader_group_id
    admin_group_id    = var.admin_group_id
    oidc_discovery_url = module.oidc_app_registration.oidc_discovery_url
    oidc_client_id    = module.oidc_app_registration.oidc_client_id
    oidc_client_secret = module.oidc_app_registration.oidc_client_secret
    oidc_issuer       = module.oidc_app_registration.oidc_issuer
}