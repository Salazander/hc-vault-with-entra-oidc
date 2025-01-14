data "azuread_client_config" "current" {}

resource "time_rotating" "password_ttl" {
     rotation_days = 30
}

resource "azuread_application" "oidc_application" {
    display_name = "hc-vault-with-entra-oidc"
    owners       = [data.azuread_client_config.current.object_id]

    password {
        display_name = "VaultSecret-1"
        start_date   = time_rotating.password_ttl.id
        end_date     = timeadd(time_rotating.password_ttl.id, "720h")
    }

    web {
        redirect_uris = [
            "http://localhost:8250/oidc/callback",
            "http://localhost:8200/ui/vault/auth/oidc/oidc/callback"
        ]
    }

    group_membership_claims = [ "All" ]
}


output "oidc_discovery_url" {
    value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/v2.0"
}

output "oidc_issuer" {
    value = "https://login.microsoftonline.com/${data.azuread_client_config.current.tenant_id}/v2.0"
}

output "oidc_client_id" {
    value = azuread_application.oidc_application.client_id
}

output "oidc_client_secret" {
    value = tolist(azuread_application.oidc_application.password).0.value
    sensitive = true
}
