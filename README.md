# Introduction
This repository showcases the integration of HashiCorp Vault with MS Entra ID using the OIDC authentication method. The solution maps all authenticated users to a single Vault Entity and Alias, distinguishing their access rights by attaching specific access policies to different Vault Roles. Access to these roles is authorized by validating the group membership claims.

## Prerequisites
- Docker + VSCode running locally
- Azure Subscription
- Permission to register applications in your MS Entra Tenant ID

## How to get started
1. Open the .devcontainer
2. Replace the values in `variables.tfvars.tmpl` with group IDs applicable to your [MS Entra ID Tenant](https://portal.azure.com/#view/Microsoft_AAD_IAM/GroupsManagementMenuBlade/~/AllGroups) and rename the file to `variables.tfvars`. Use two distinct groups to test the `SecretsReader` and `SecretsAdministrator` roles individually.
3. Log in with your Azure credentials using 
```sh
az login
```
4. Create the infrastructure by running
```sh
cd terraform
terraform init
terraform apply -var-file="variables.tfvars"
```
5. Unset the root `VAULT_TOKEN` environment variable to login using different roles
```sh
unset VAULT_TOKEN
```
6. Login as Vault `SecretsAdministrator` using 
```sh
vault login -method=oidc role="SecretsAdministrator"
```
7. Create a new secret using 
```sh
vault kv put secret/test message="Hello World"
```
8. Retrieve the created secret using 
```sh 
vault kv get secret/test
```
9. Log in as Vault `SecretsReader` using 
```sh 
vault login -method=oidc role="SecretsReader"
```
10. List all secrets using
```sh
vault kv list secret
```
11. Try (**Error expected!**) to create a secret using 
```sh
vault kv put secret/test message="Hello World"
```

## How to clean up
To remove all created resources, use
```sh
export VAULT_TOKEN=root
cd terraform
terraform destroy -var-file="variables.tfvars"
```
