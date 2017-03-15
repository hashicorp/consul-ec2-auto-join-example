# Consul Auto-Join Example
This repository contains an example Terraform config to create a Consul cluster using the Auto-Join feature.

To run this example modify the terraform.tfvars file adding your AWS credentials and setting the region to create the cluster.

```
aws_region = "eu-west-1"

aws_access_key = "AWS_ACCESS_KEY"

aws_secret_key = "AWS_SECRET"
```

Run `terraform plan` and `terraform apply` to create the server.

For more details please see blog post ...
