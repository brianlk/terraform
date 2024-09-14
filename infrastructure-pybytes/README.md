__deploy pybytes infrastructure__
---
# Core concepts
## Naming
## Tenant
Tenant is the name of the "customer" that will use the platform. Tenant is the first level of separation.

A tenant is unique in its naming
## Environment
A tenant has 1-n environments. Each environment is network isolated from the other.
Each environment has its own :
- VPC
- MongoDB cluster
## App
An app is a component of the environment. Each environment has 1-n applications.
## DNS records
Each application will receive a public and a private DNS record :

__public:__
`<app>.<environment>.<tenant>.pycom.io`

__private:__
`<app>.<environment>.<tenant>.pycom.awsprivate`

Some applications __CAN__ have aliases to their public or private records.

## Terraform guidelines
## resource naming

* resource __MUST__ respect the DRY (don't repeat yourself) principle. A ressource name __MUST__ not contain the module name, the provider name or the ressource provider name
* if the resource is unique in its module and the provider name is self explanatory, it __SHOULD__ be named `this`
* resource __MUST__ be written using snake case

## variables
* variable names __MUST__ be as accurate as possible
* when possible, variable names __MUST__ contain the provider and the ressource name
* variable names __MUST__ be written using snake case
* variable files __MUST__ follow the naming convention: `<tenant>.<environment>.tfvars`

## workspaces
* a workspace is needed to deploy apps for a specific environment in a specific tenant
* workspace __MUST__ be named: `<tenant>.<environment>`


# Deploy
## Prerequisites
* AWS [configure authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)
* Cloudflare [configure authentication](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs#argument-reference)
## Pybytes
TBD
## MWC
__Murata__

```bash
terraform workspace select mwc-murata.staging
terraform plan -var-file="murata-staging.tfvars"
terraform apply -var-file="murata-staging.tfvars"
```

__Sequans__

```bash
terraform workspace select mwc-sequans.staging
terraform plan -var-file="sequans-staging.tfvars"
terraform apply -var-file="sequans-staging.tfvars"
```

# Limitations
Some things are done manually :
* MongoDB cluster creation
* MongoDB encryption at REST configuration
