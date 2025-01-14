variable "oidc_discovery_url" {
    description = "The OIDC discovery URL"
    type        = string
}

variable "oidc_client_id" {
    description = "The OIDC client ID"
    type        = string
}

variable "oidc_client_secret" {
    description = "The OIDC client secret"
    type        = string
    sensitive   = true
}

variable "oidc_issuer" {
    description = "The issuer URL of the OIDC Identity Provider"
    type        = string
}

variable "reader_group_id" {
    description = "The Entra group ID with Reader permissions"
    type        = string
}

variable "admin_group_id" {
    description = "The Entra group ID with Admin permissions"
    type        = string
}