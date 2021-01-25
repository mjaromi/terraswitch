# terraswitch
Tool which (1) check terraform_version in terraform.tfstate file stored on S3, (2) install the right version of terraform and make it default, (3) install suitable version of terragrunt

## prerequisites
* awscli 
* egrep 
* jq 
* tfenv 
* tgenv

## installation
```bash
$ wget -O /usr/local/bin/terraswitch https://raw.githubusercontent.com/mjaromi/terraswitch/master/terraswitch.sh
$ chmod +x /usr/local/bin/terraswitch
```

## usage
```bash
terraswitch
```

## output
```bash
download: s3://bucket_path/terraform.tfstate to ./terraform.tfstate
Terraform v0.11.14 is already installed
Switching default version to v0.11.14
Switching completed
Terragrunt v0.18.7 is already installed
[INFO] Switching to v0.18.7
[INFO] Switching completed
Terraform v0.11.14
terragrunt version v0.18.7
```