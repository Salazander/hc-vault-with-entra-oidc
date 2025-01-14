provider "vault" {
    address = "http://vault-server:8200"
}

resource "vault_policy" "secrets_reader_policy" {
    name   = "Secrets Reader"
    policy = <<EOT
path "secret/*" {
    capabilities = ["read", "list"]
}
EOT
}

resource "vault_policy" "secrets_admin_policy" {
    name   = "Secrets Administrator"
    policy = <<EOT
path "/secret/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

resource "vault_jwt_auth_backend" "oidc_auth" {
    description         = "OIDC Integration with MS Entra ID"
    path                = "oidc"
    type                = "oidc"
    oidc_discovery_url  = var.oidc_discovery_url
    oidc_client_id      = var.oidc_client_id
    oidc_client_secret  = var.oidc_client_secret
    bound_issuer        = var.oidc_issuer
}

resource "vault_jwt_auth_backend_role" "secrets_reader_role" {
    backend               = vault_jwt_auth_backend.oidc_auth.path
    role_name             = "SecretsReader"
    role_type             = "oidc"
    allowed_redirect_uris = ["http://localhost:8250/oidc/callback", "http://localhost:8200/ui/vault/auth/oidc/oidc/callback"]
    user_claim            = "aud"
    token_policies        = [vault_policy.secrets_reader_policy.name]
    bound_audiences       = [var.oidc_client_id]
    bound_claims          = { "groups" = var.reader_group_id }
    verbose_oidc_logging  = true
}

resource "vault_jwt_auth_backend_role" "secrets_admin_role" {
    backend               = vault_jwt_auth_backend.oidc_auth.path
    role_name             = "SecretsAdministrator"
    role_type             = "oidc"
    allowed_redirect_uris = ["http://localhost:8250/oidc/callback", "http://localhost:8200/ui/vault/auth/oidc/oidc/callback"]
    user_claim            = "aud"
    token_policies        = [vault_policy.secrets_admin_policy.name]
    bound_audiences       = [var.oidc_client_id]
    bound_claims          = { "groups" = var.admin_group_id }
    verbose_oidc_logging  = true
}

resource "vault_identity_entity" "singleton_entity" {
  name      = "TheEntity"
}

resource "vault_identity_entity_alias" "singleton_alias" {
  name            = var.oidc_client_id
  mount_accessor  = vault_jwt_auth_backend.oidc_auth.accessor
  canonical_id    = vault_identity_entity.singleton_entity.id
}