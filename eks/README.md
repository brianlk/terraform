# Build EKS cluster by terraform

Requirements: terraform, aws cli

terraform init main.tf

terraform validate main.tf

terraform plan -out=x

terraform apply x

The scripts are used to provision 2 eks in 2 regions.

The failover mechanism depends on the route 53 scripts.
