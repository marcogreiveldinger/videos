## Terraform with github actions and cloudflare
This guide shows how to use terraform with github actions and cloudflare to create a dns record.
Terraform helps you to maintain your infrastructure as code and github actions helps you to automate your workflow. Cloudflare is a dns provider which helps you to manage your dns records.

[Link to the youtube video](https://youtu.be/0BNwAEwYZlA)

## Terraform 

Project structure:
```
.
├── .github
│   ├── workflows
│   │   └── terraform.yml
├── README.md
├── backend.tf
├── domain.tf
├── provider.tf
├── records.tf
└── variables.tf
```
3 things to prepare:
- Create a cloudflare account and generate an api token with the following permissions: `Zone.DNS:Edit` and `Zone.Zone:Read`
- Create a github repository
- Create a terraform cloud account and create a workspace (CLI-driven workflow) and generate an user token which you store in the github repository as a secret with the name `TF_API_TOKEN`


[_backend.tf_](backend.tf)
```
terraform {
  cloud {
    organization = "your-organisation-name"  

    workspaces {
      name = "your-workspace-name"
    }
  }
}
```
The backend configuration is used to store the terraform state in terraform cloud. It creates the connection between the terraform cloud workspace and the github repository.

[_provider.tf_](provider.tf)
```
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_key
}
```
The provider configuration is used to connect to the cloudflare api. There you need the above created api token and reference it in the variable `cloudflare_api_key` which you can find in [variables.tf](variables.tf).

Do not hard code the api token in the variable! Instead add it to the terraform cloud workspace and create a variable with the checkbox 'secret' with the name `cloudflare_api_key` and the value of the api token. This way the api token is not visible in the github repository.

[_domain_.tf_](domain.tf)
```
resource "cloudflare_zone" "domain_zone" {
  account_id = var.cloudflare_account_id
  zone       = var.cf_domain
}
```
The resource configuration is used to create a dns zone in cloudflare. There you need the above created account id and reference it in the variable `cloudflare_account_id` which you can find in [variables.tf](variables.tf). 
Do not hard code the account id in the variable! Instead add it to the terraform cloud workspace and create a variable with the checkbox 'secret' with the name `cloudflare_account_id` and the value of the api token. This way the id is not visible in the github repository.

[_records_.tf_](records.tf)
```
resource "cloudflare_record" "any_record_a" {
  zone_id = cloudflare_zone.domain_zone.id
  name    = "your-record-name"
  value   = "your-ipv4-address"
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "any_record_aaaa" {
  zone_id = cloudflare_zone.domain_zone.id
  name    = "your-record-name"
  value   = "some_ip_v6_address"
  type    = "AAAA"
  proxied = false
}
```
The resources configuration is used to create dns records in cloudflare. It references the zone_id from the resource `cloudflare_zone.domain_zone` which is created in the file [domain.tf](domain.tf).

## Deploy with github actions

[_terraform.yml_](.github/workflows/terraform.yml)
```
...
 steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}
....
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve -input=false

```
The github action is used to deploy the terraform configuration. It uses the terraform cloud workspace to store the terraform state. The terraform cloud workspace is connected to the github repository via the user token stored as a secret in the repository. The github action is triggered when a push is made to the branch `main`.

